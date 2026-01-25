#!/usr/bin/env bash
# ==========================================================
# Nextcloud Smart Installer
# Integrado en LXApp - www.idealored.com
# Fernando Garau - v1.2
# ==========================================================

set -euo pipefail

LOG="/var/log/nextcloud_installer_v1_2.log"
exec > >(tee -a "$LOG") 2>&1

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "ERROR: ejecuta con sudo"; exit 1; }

# ------------------------
# Helpers
# ------------------------
ask_yn() {
  local q="$1" d="${2:-y}" a
  while true; do
    read -rp "$q [y/n] (default $d): " a || true
    a="${a,,}"
    [[ -z "$a" ]] && a="$d"
    [[ "$a" == "y" || "$a" == "n" ]] && { echo "$a"; return; }
    echo "Responde y/n."
  done
}

ask_str() {
  local q="$1" d="${2:-}" a
  read -rp "$q${d:+ (default $d)}: " a || true
  echo "${a:-$d}"
}

ask_pass() {
  local p1 p2
  while true; do
    read -rsp "Contraseña: " p1; echo
    read -rsp "Repite contraseña: " p2; echo
    [[ "$p1" == "$p2" && -n "$p1" ]] && { echo "$p1"; return; }
    echo "No coinciden o está vacía. Reintenta."
  done
}

pause() { read -r -p "ENTER para continuar... " _; }

get_public_ip() { curl -fsS https://api.ipify.org 2>/dev/null || echo "unknown"; }
is_ip() { [[ "$1" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; }
resolve_domain() { getent ahostsv4 "$1" 2>/dev/null | awk '{print $1; exit}' || true; }

need_pkg() {
  local pkg="$1"
  dpkg -s "$pkg" >/dev/null 2>&1 || { apt-get update -y; apt-get install -y "$pkg"; }
}

# ------------------------
# Paths / State
# ------------------------
NC_DIR="/var/www/nextcloud"
NC_OCC="$NC_DIR/occ"
NC_NGINX_SITE="/etc/nginx/sites-available/nextcloud.conf"
NC_NGINX_ENABLED="/etc/nginx/sites-enabled/nextcloud.conf"
NC_DATA_DEFAULT="/srv/nextcloud-data"
STATE_DIR="/etc/nextcloud-installer"
STATE_FILE="$STATE_DIR/state.env"
NC_MENU="/usr/local/bin/nc-menu"

# ------------------------
# System Info
# ------------------------
print_info() {
  clear || true
  echo "=============================="
  echo " Nextcloud Smart Installer"
  echo " app.idealored.com"
  echo " Fernando Garau - v1.2"
  echo "=============================="
  echo
  if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    echo "Sistema: ${PRETTY_NAME:-unknown}"
  fi
  echo "Kernel : $(uname -r)"
  echo "CPU    : $(lscpu 2>/dev/null | awk -F: '/Model name/{print $2; exit}' || true)"
  echo "RAM    : $(free -h | awk 'NR==2{print $2}')"
  echo "Discos :"
  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | sed 's/^/  /'
  echo
  echo "IP pública detectada: $(get_public_ip)"
  echo
}

# ------------------------
# Post-install menu generator (nc-menu)
# ------------------------
install_or_update_nc_menu() {
  mkdir -p "$STATE_DIR"
  chmod 700 "$STATE_DIR"

  cat > "$NC_MENU" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

NC_DIR="/var/www/nextcloud"
NC_OCC="$NC_DIR/occ"
NC_NGINX_SITE="/etc/nginx/sites-available/nextcloud.conf"
NC_NGINX_ENABLED="/etc/nginx/sites-enabled/nextcloud.conf"
STATE="/etc/nextcloud-installer/state.env"

[[ ${EUID:-$(id -u)} -eq 0 ]] || { echo "ERROR: ejecuta con sudo"; exit 1; }
[[ -f "$STATE" ]] || { echo "ERROR: no existe $STATE. ¿Instalaste con el script?"; exit 1; }
# shellcheck disable=SC1090
. "$STATE"

need_pkg() {
  local pkg="$1"
  dpkg -s "$pkg" >/dev/null 2>&1 || { apt-get update -y; apt-get install -y "$pkg"; }
}

occ() {
  [[ -f "$NC_OCC" ]] || { echo "ERROR: no encuentro occ en $NC_OCC"; exit 1; }
  sudo -u www-data php "$NC_OCC" "$@"
}

pause() { read -r -p "ENTER para continuar... " _; }

header() {
  clear || true
  echo "======================================"
  echo " Nextcloud Post-Install Menu (v1.2)"
  echo " app.idealored.com (Fernando Garau)"
  echo "======================================"
  echo "Target : ${TARGET}"
  echo "Mode   : ${MODE}"
  echo "DB     : ${DB_ENGINE} (${DB_NAME})"
  echo "Data   : ${DATA_DIR}"
  echo "Redis  : ${USE_REDIS}"
  echo "SSL    : ${USE_SSL}"
  echo "======================================"
  echo
}

show_status() {
  header
  echo "Servicios (resumen):"
  systemctl --no-pager --full status nginx 2>/dev/null | sed -n '1,12p' || true
  systemctl --no-pager --full status php*-fpm 2>/dev/null | sed -n '1,12p' || true
  if [[ "$DB_ENGINE" == "postgres" ]]; then
    systemctl --no-pager --full status postgresql 2>/dev/null | sed -n '1,12p' || true
  else
    systemctl --no-pager --full status mariadb 2>/dev/null | sed -n '1,12p' || true
  fi
  if [[ "$USE_REDIS" == "y" ]]; then
    systemctl --no-pager --full status redis-server 2>/dev/null | sed -n '1,12p' || true
  fi
  echo
  echo "Nextcloud:"
  occ status || true
  pause
}

enable_ufw() {
  header
  need_pkg ufw
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow OpenSSH
  ufw allow 80/tcp
  ufw allow 443/tcp
  ufw --force enable
  ufw status verbose || true
  pause
}

add_trusted_domain() {
  header
  read -r -p "Añadir trusted domain (dominio o IP): " td
  [[ -n "$td" ]] || { echo "Vacío."; pause; return; }
  local i
  i="$(occ config:system:get trusted_domains 2>/dev/null | wc -l | tr -d ' ')"
  occ config:system:set trusted_domains "$i" --value="$td"
  echo "Añadido trusted_domains[$i] = $td"
  pause
}

migrate_ip_to_domain_no_ssl() {
  header
  echo "Esto cambia TARGET a un dominio (SIN SSL todavía)."
  echo "Luego podrás activar SSL con Certbot desde el menú."
  echo
  read -r -p "Nuevo dominio (ej: cloud.tudominio.com): " dom
  [[ -n "$dom" ]] || { echo "Vacío."; pause; return; }

  if [[ -f "$NC_NGINX_SITE" ]]; then
    sed -i "s/^  *server_name .*/  server_name ${dom};/g" "$NC_NGINX_SITE" || true
    ln -sf "$NC_NGINX_SITE" "$NC_NGINX_ENABLED"
    nginx -t
    systemctl reload nginx
  else
    echo "Aviso: no existe $NC_NGINX_SITE, no toco Nginx."
  fi

  occ config:system:set trusted_domains 0 --value="$dom" || true
  occ config:system:set overwrite.cli.url --value="http://${dom}" || true

  sed -i "s/^TARGET=.*/TARGET=\"${dom}\"/" "$STATE"
  sed -i 's/^USE_SSL=.*/USE_SSL="n"/' "$STATE"

  echo "OK. TARGET actualizado a $dom (sin SSL)."
  pause
}

enable_ssl_certbot() {
  header
  echo "Activar SSL Let's Encrypt (Certbot + Nginx). Requisitos:"
  echo " - DNS del dominio apuntando a este servidor"
  echo " - Puertos 80/443 accesibles"
  echo
  read -r -p "Dominio (ej: cloud.tudominio.com): " dom
  read -r -p "Email Let's Encrypt: " email
  [[ -n "$dom" && -n "$email" ]] || { echo "Faltan datos."; pause; return; }

  need_pkg certbot
  need_pkg python3-certbot-nginx

  if [[ -f "$NC_NGINX_SITE" ]]; then
    if ! grep -q "server_name ${dom};" "$NC_NGINX_SITE"; then
      sed -i "s/^  *server_name .*/  server_name ${dom};/g" "$NC_NGINX_SITE" || true
      ln -sf "$NC_NGINX_SITE" "$NC_NGINX_ENABLED"
      nginx -t
      systemctl reload nginx
    fi
  else
    echo "ERROR: no existe $NC_NGINX_SITE. No puedo activar SSL automáticamente."
    pause
    return
  fi

  certbot --non-interactive --agree-tos -m "$email" --nginx -d "$dom" --redirect

  occ config:system:set trusted_domains 0 --value="$dom" || true
  occ config:system:set overwrite.cli.url --value="https://${dom}" || true

  sed -i 's/^USE_SSL=.*/USE_SSL="y"/' "$STATE"
  sed -i "s/^TARGET=.*/TARGET=\"${dom}\"/" "$STATE"

  echo "OK. SSL activado. URL: https://$dom"
  pause
}

maintenance_on() { header; occ maintenance:mode --on; pause; }
maintenance_off() { header; occ maintenance:mode --off; pause; }

repair_validate_stack() {
  header
  echo "Validación/Reparación básica del stack (best-effort)..."
  echo "- nginx -t y reload"
  echo "- restart php-fpm"
  echo "- asegurar socket php-fpm symlink"
  echo "- reiniciar redis si aplica"
  echo
  local fpm_sock
  fpm_sock="$(ls /run/php/php*-fpm.sock 2>/dev/null | head -n1 || true)"
  if [[ -n "$fpm_sock" ]]; then
    ln -sf "$fpm_sock" /run/php/php-fpm.sock
  fi

  nginx -t && systemctl reload nginx || true
  systemctl restart php*-fpm 2>/dev/null || true

  if [[ "$USE_REDIS" == "y" ]]; then
    systemctl restart redis-server || true
  fi

  echo
  echo "Hecho. Revisa estado (opción 1) si algo sigue mal."
  pause
}

backup_nextcloud() {
  header
  local ts dest
  ts="$(date +%F_%H%M%S)"
  dest="/root/nextcloud-backup-${ts}"
  mkdir -p "$dest"

  echo "Creando backup en: $dest"
  tar -C /var/www -czf "$dest/nextcloud_www.tgz" nextcloud

  if [[ -d "$DATA_DIR" ]]; then
    tar -C "$(dirname "$DATA_DIR")" -czf "$dest/nextcloud_data.tgz" "$(basename "$DATA_DIR")"
  else
    echo "Aviso: no existe DATA_DIR: $DATA_DIR"
  fi

  echo "DB dump..."
  if [[ "$DB_ENGINE" == "postgres" ]]; then
    need_pkg postgresql-client
    PGPASSWORD="$DB_PASS" pg_dump -U "$DB_USER" -h localhost "$DB_NAME" > "$dest/db.sql" || true
  else
    need_pkg mariadb-client
    mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$dest/db.sql" || true
  fi

  echo "Backup completado: $dest"
  pause
}

run_occ_custom() {
  header
  echo "Escribe el comando occ SIN 'occ' (ej: app:list)"
  read -r -p "occ " cmdline
  [[ -n "$cmdline" ]] || { echo "Vacío."; pause; return; }
  # shellcheck disable=SC2086
  occ $cmdline
  pause
}

view_logs() {
  header
  echo "Nginx error (80 líneas):"
  tail -n 80 /var/log/nginx/error.log 2>/dev/null || true
  echo
  echo "Nextcloud log (si existe en DATA_DIR):"
  if [[ -f "${DATA_DIR}/nextcloud.log" ]]; then
    tail -n 120 "${DATA_DIR}/nextcloud.log" || true
  else
    echo "No localizo ${DATA_DIR}/nextcloud.log"
  fi
  pause
}

main_menu() {
  while true; do
    header
    echo "1) Ver estado (servicios + occ status)"
    echo "2) Activar/Configurar Firewall UFW (SSH/80/443)"
    echo "3) Añadir trusted domain (dominio o IP)"
    echo "4) Migrar IP -> Dominio (sin SSL)"
    echo "5) Activar SSL (Certbot + Nginx) cuando tengas dominio"
    echo "6) Maintenance mode ON"
    echo "7) Maintenance mode OFF"
    echo "8) Reparar/Validar stack (nginx/php/redis)"
    echo "9) Backup (DB + config + data)"
    echo "10) Ejecutar comando occ (custom)"
    echo "11) Ver logs (nginx + nextcloud)"
    echo "0) Salir"
    echo
    read -r -p "Opción: " op
    case "$op" in
      1) show_status ;;
      2) enable_ufw ;;
      3) add_trusted_domain ;;
      4) migrate_ip_to_domain_no_ssl ;;
      5) enable_ssl_certbot ;;
      6) maintenance_on ;;
      7) maintenance_off ;;
      8) repair_validate_stack ;;
      9) backup_nextcloud ;;
      10) run_occ_custom ;;
      11) view_logs ;;
      0) exit 0 ;;
      *) echo "Opción inválida"; pause ;;
    esac
  done
}

main_menu
EOF
  chmod 755 "$NC_MENU"
}

write_state() {
  mkdir -p "$STATE_DIR"
  chmod 700 "$STATE_DIR"
  cat > "$STATE_FILE" <<EOF
# Nextcloud Installer State (v1.2)
MODE="${MODE}"
DB_ENGINE="${DB_ENGINE}"
DB_NAME="${DB_NAME}"
DB_USER="${DB_USER}"
DB_PASS="${DB_PASS}"
ADMIN_USER="${ADMIN_USER}"
TARGET="${TARGET}"
DATA_DIR="${DATA_DIR}"
USE_REDIS="${USE_REDIS}"
USE_SSL="${USE_SSL}"
EOF
  chmod 600 "$STATE_FILE"
}

launch_nc_menu() {
  if [[ -x "$NC_MENU" ]]; then
    "$NC_MENU"
  else
    echo "ERROR: no existe $NC_MENU"
    exit 1
  fi
}

# ------------------------
# Installer (Normal prod)
# ------------------------
install_normal() {
  print_info

  PUBIP="$(get_public_ip)"
  TARGET="$(ask_str "Dominio o IP para Nextcloud (si no tienes dominio, deja vacío)" "")"
  [[ -z "$TARGET" ]] && TARGET="$PUBIP"

  USE_SSL="n"
  if is_ip "$TARGET"; then
    echo "Modo IP ($TARGET). Let's Encrypt no aplica aún."
  else
    RESOLVED="$(resolve_domain "$TARGET")"
    if [[ -n "$RESOLVED" && "$PUBIP" != "unknown" && "$RESOLVED" != "$PUBIP" ]]; then
      echo "AVISO: DNS resuelve a $RESOLVED pero IP pública detectada es $PUBIP."
      echo "Let's Encrypt puede fallar hasta que el DNS apunte correctamente."
    fi
    USE_SSL="$(ask_yn "¿Usar SSL Let's Encrypt (Certbot) ahora?" "n")"
  fi
  echo

  if [[ "$(ask_yn "¿Configurar Firewall UFW (SSH/80/443)?" "y")" == "y" ]]; then
    need_pkg ufw
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow OpenSSH
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw --force enable
  fi

  MODE="normal"

  DB_ENGINE="mariadb"
  if [[ "$(ask_yn "¿Usar PostgreSQL en vez de MariaDB?" "n")" == "y" ]]; then
    DB_ENGINE="postgres"
  fi

  DB_NAME="$(ask_str "Nombre base de datos" "nextcloud")"
  DB_USER="$(ask_str "Usuario BD" "ncuser")"
  echo "Contraseña BD:"
  DB_PASS="$(ask_pass)"

  ADMIN_USER="$(ask_str "Usuario admin Nextcloud" "admin")"
  echo "Contraseña admin Nextcloud:"
  ADMIN_PASS="$(ask_pass)"

  DATA_DIR="$(ask_str "Directorio de datos" "$NC_DATA_DEFAULT")"
  USE_REDIS="$(ask_yn "¿Activar Redis por socket (recomendado)?" "y")"

  echo
  echo "Instalando paquetes base..."
  apt-get update -y
  apt-get install -y nginx unzip curl jq \
    php-fpm php-cli php-gd php-curl php-zip php-xml php-mbstring php-intl php-bcmath php-gmp php-imagick php-apcu php-opcache

  # DB
  if [[ "$DB_ENGINE" == "postgres" ]]; then
    apt-get install -y postgresql postgresql-contrib php-pgsql
    systemctl enable --now postgresql
    sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE ${DB_NAME};"
    sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'" | grep -q 1 || sudo -u postgres psql -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};"
    DB_TYPE="pgsql"
    DB_HOST="localhost"
  else
    apt-get install -y mariadb-server php-mysql
    systemctl enable --now mariadb
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
    mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost'; FLUSH PRIVILEGES;"
    DB_TYPE="mysql"
    DB_HOST="localhost"
  fi

  # Redis socket
  if [[ "$USE_REDIS" == "y" ]]; then
    apt-get install -y redis-server
    conf="/etc/redis/redis.conf"
    sed -i "s|^# unixsocket .*|unixsocket /run/redis/redis-server.sock|g" "$conf" || true
    grep -q "^unixsocket /run/redis/redis-server.sock" "$conf" || echo "unixsocket /run/redis/redis-server.sock" >> "$conf"
    sed -i "s|^# unixsocketperm .*|unixsocketperm 770|g" "$conf" || true
    grep -q "^unixsocketperm 770" "$conf" || echo "unixsocketperm 770" >> "$conf"
    usermod -aG redis www-data || true
    systemctl enable --now redis-server
    systemctl restart redis-server
  fi

  # PHP tuning
  PHP_INI="$(php -i 2>/dev/null | awk -F'=> ' '/Loaded Configuration File/{print $2; exit}' || true)"
  if [[ -n "$PHP_INI" && -f "$PHP_INI" ]]; then
    perl -0777 -i -pe "s/;?memory_limit\s*=.*/memory_limit = 512M/gm" "$PHP_INI"
    perl -0777 -i -pe "s/;?upload_max_filesize\s*=.*/upload_max_filesize = 2048M/gm" "$PHP_INI"
    perl -0777 -i -pe "s/;?post_max_size\s*=.*/post_max_size = 2048M/gm" "$PHP_INI"
    perl -0777 -i -pe "s/;?max_execution_time\s*=.*/max_execution_time = 360/gm" "$PHP_INI"
    perl -0777 -i -pe "s/;?max_input_time\s*=.*/max_input_time = 360/gm" "$PHP_INI"
  fi
  cat > /etc/php/*/fpm/conf.d/10-opcache-nextcloud.ini <<'EOF'
opcache.enable=1
opcache.enable_cli=1
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.memory_consumption=256
opcache.save_comments=1
opcache.revalidate_freq=1
EOF
  systemctl restart php*-fpm || true

  # Nextcloud download
  mkdir -p /var/www
  cd /var/www
  if [[ ! -d "$NC_DIR" ]]; then
    curl -fsSL -o nc.zip https://download.nextcloud.com/server/releases/latest.zip
    unzip -q nc.zip
    rm -f nc.zip
  else
    echo "Aviso: $NC_DIR ya existe. No lo borro."
  fi
  chown -R www-data:www-data "$NC_DIR"

  mkdir -p "$DATA_DIR"
  chown -R www-data:www-data "$DATA_DIR"
  chmod 750 "$DATA_DIR"

  # Nginx
  FPM_SOCK="$(ls /run/php/php*-fpm.sock 2>/dev/null | head -n1 || true)"
  [[ -n "$FPM_SOCK" ]] || { echo "ERROR: no encuentro socket PHP-FPM en /run/php"; exit 1; }
  ln -sf "$FPM_SOCK" /run/php/php-fpm.sock

  cat > "$NC_NGINX_SITE" <<EOF
server {
  listen 80;
  server_name ${TARGET};

  root ${NC_DIR};
  index index.php index.html /index.php\$request_uri;

  client_max_body_size 2G;
  fastcgi_buffers 64 4K;

  add_header Referrer-Policy "no-referrer" always;
  add_header X-Content-Type-Options "nosniff" always;
  add_header X-Frame-Options "SAMEORIGIN" always;
  add_header X-Permitted-Cross-Domain-Policies "none" always;
  add_header X-Robots-Tag "noindex, nofollow" always;
  add_header X-XSS-Protection "1; mode=block" always;

  location = /robots.txt { allow all; log_not_found off; access_log off; }

  location ^~ /.well-known {
    location = /.well-known/carddav { return 301 /remote.php/dav/; }
    location = /.well-known/caldav { return 301 /remote.php/dav/; }
    try_files \$uri \$uri/ =404;
  }

  location / { rewrite ^ /index.php\$request_uri; }

  location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ { deny all; }
  location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) { deny all; }

  location ~ \.php(?:\$|/) {
    fastcgi_split_path_info ^(.+?\.php)(/.*)\$;
    set \$path_info \$fastcgi_path_info;
    try_files \$fastcgi_script_name =404;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    fastcgi_param PATH_INFO \$path_info;
    fastcgi_param HTTPS off;
    fastcgi_pass unix:/run/php/php-fpm.sock;
    fastcgi_intercept_errors on;
    fastcgi_request_buffering off;
  }

  location ~ \.(?:css|js|svg|gif|png|jpg|ico|wasm|map)\$ {
    try_files \$uri /index.php\$request_uri;
    expires 6M;
    access_log off;
  }
}
EOF

  ln -sf "$NC_NGINX_SITE" "$NC_NGINX_ENABLED"
  rm -f /etc/nginx/sites-enabled/default || true
  nginx -t
  systemctl enable --now nginx
  systemctl reload nginx

  # Nextcloud install
  [[ -f "$NC_OCC" ]] || { echo "ERROR: no encuentro occ en $NC_OCC"; exit 1; }

  sudo -u www-data php "$NC_OCC" maintenance:install \
    --database "$DB_TYPE" --database-name "$DB_NAME" --database-user "$DB_USER" --database-pass "$DB_PASS" --database-host "$DB_HOST" \
    --admin-user "$ADMIN_USER" --admin-pass "$ADMIN_PASS" \
    --data-dir "$DATA_DIR" || true

  sudo -u www-data php "$NC_OCC" config:system:set trusted_domains 0 --value="$TARGET" || true
  sudo -u www-data php "$NC_OCC" config:system:set overwrite.cli.url --value="http://${TARGET}" || true

  if [[ "$USE_REDIS" == "y" ]]; then
    sudo -u www-data php "$NC_OCC" config:system:set memcache.local --value='\OC\Memcache\APCu' || true
    sudo -u www-data php "$NC_OCC" config:system:set memcache.locking --value='\OC\Memcache\Redis' || true
    sudo -u www-data php "$NC_OCC" config:system:set redis host --value='/run/redis/redis-server.sock' || true
    sudo -u www-data php "$NC_OCC" config:system:set redis port --value=0 --type=integer || true
  fi

  # Cron
  sudo -u www-data php "$NC_OCC" background:cron || true
  cat > /etc/cron.d/nextcloud <<EOF
*/5 * * * * www-data php -f ${NC_DIR}/cron.php
EOF

  # SSL now? (only if domain)
  if [[ "$USE_SSL" == "y" ]] && ! is_ip "$TARGET"; then
    need_pkg certbot
    need_pkg python3-certbot-nginx
    LE_EMAIL="admin@${TARGET#*.}"
    certbot --non-interactive --agree-tos -m "$LE_EMAIL" --nginx -d "$TARGET" --redirect || true
    systemctl reload nginx || true
    sudo -u www-data php "$NC_OCC" config:system:set overwrite.cli.url --value="https://${TARGET}" || true
    USE_SSL="y"
  else
    USE_SSL="n"
  fi

  # Persist state + install menu
  install_or_update_nc_menu
  write_state

  echo
  echo "===================================="
  echo " INSTALACIÓN FINALIZADA (v1.2)"
  echo " Target: $TARGET"
  echo " URL   : http${USE_SSL:+s}://$TARGET"
  echo " Log   : $LOG"
  echo " Menú  : sudo nc-menu"
  echo "===================================="
  echo

  if [[ "$(ask_yn "¿Abrir ahora el menú post-instalación (nc-menu)?" "y")" == "y" ]]; then
    launch_nc_menu
  fi
}

# ------------------------
# Main Menu (Installer)
# ------------------------
main_menu() {
  while true; do
    print_info
    echo "MENÚ PRINCIPAL (v1.2)"
    echo "1) Instalar Nextcloud (modo normal - producción)"
    echo "2) Post-instalación (abrir nc-menu)"
    echo "3) Reinstalar/Actualizar nc-menu (por si falta)"
    echo "0) Salir"
    echo
    read -r -p "Opción: " op
    case "$op" in
      1) install_normal; return ;;
      2)
        if [[ -f "$STATE_FILE" ]]; then
          install_or_update_nc_menu
          launch_nc_menu
        else
          echo "No detecto instalación previa ($STATE_FILE no existe)."
          pause
        fi
        ;;
      3)
        install_or_update_nc_menu
        echo "OK. Menú instalado/actualizado: sudo nc-menu"
        pause
        ;;
      0) exit 0 ;;
      *) echo "Opción inválida"; pause ;;
    esac
  done
}

# Ensure menu exists if state exists
if [[ -f "$STATE_FILE" ]]; then
  install_or_update_nc_menu
fi

main_menu
