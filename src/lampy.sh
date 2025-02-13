#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Credenciais padrão
DEFAULT_USER="lampy_admin"
DEFAULT_PASS="lampy#@"

# Configuração de credenciais
MYSQL_USER=""
MYSQL_PASS=""

# Funções auxiliares 
show_progress() {
    echo -e "${YELLOW}➜ $1...${NC}"
}

show_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

show_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

check_status() {
    if [ $? -eq 0 ]; then
        show_success "$1"
    else
        show_error "$1"
    fi
}

show_log() {
    local log_file=$1
    echo -e "${YELLOW}----------------------------------------${NC}"
    echo -e "${YELLOW}Log de instalação:${NC}"
    cat $log_file
    echo -e "${YELLOW}----------------------------------------${NC}"
}

SPINNER="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
SPINNER_LENGTH=10

show_spinner() {
    local msg=$1
    local pid=$2
    local delay=0.1
    local counter=0
    local spinstr=""

    while kill -0 $pid 2>/dev/null; do
    counter=$((counter + 1))
    spinstr=${SPINNER:$(( (counter/2) % SPINNER_LENGTH )):1}
    printf "\r${YELLOW}➜ %s... %s${NC}" "$msg" "$spinstr"
    sleep $delay
    done
    printf "\r\033[K"
}

install_with_progress() {
    local msg=$1
    local cmd=$2
    local log_file=$3
    local delay=0.1
    local counter=0
    local spinstr=""
    local percent=0

    eval "$cmd" > "$log_file" 2>&1 &
    local pid=$!

    while kill -0 $pid 2>/dev/null; do
        counter=$((counter + 1))
        percent=$((counter % 100))
        spinstr=${SPINNER:$(( (counter/2) % SPINNER_LENGTH )):1}
        printf "\r%-60s" ""  
        printf "\r${YELLOW}➜ %s... %s [%3d%%]${NC}" "$msg" "$spinstr" "$percent"
        sleep $delay
    done

    wait $pid
    if [ $? -eq 0 ]; then
        printf "\r%-60s" ""  
        show_success "$msg"
    else
        echo
        show_error "Falha: $msg"
        show_log "$log_file"
        exit 1
    fi
}


show_banner() {
    clear
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}           🚀 Lampy 1.0.0                 ${NC}"
    echo -e "${BLUE}   Instalador Ambiente Web Linux           ${NC}"
    echo -e "${BLUE}               by AugSec                   ${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo
    echo -e "${CYAN}Simplificando a configuração do seu servidor!"
    echo -e "https://github.com/augsec/lampy${NC}"
    echo
}


# Função para configurar credenciais
setup_credentials() {
    echo
    echo "Configuração de credenciais do phpMyAdmin:"
    echo "-----------------------------------------"
    echo -e "${YELLOW}Você pode usar as credenciais padrão ou definir as suas.${NC}"
    echo -e "Padrão - Usuário: ${GREEN}$DEFAULT_USER${NC}"
    echo -e "Padrão - Senha: ${GREEN}$DEFAULT_PASS${NC}"
    echo
    read -p "Deseja configurar suas próprias credenciais? [s/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        read -p "Digite o usuário desejado: " MYSQL_USER
        while true; do
            read -s -p "Digite a senha desejada: " MYSQL_PASS
            echo
            read -s -p "Confirme a senha: " MYSQL_PASS_CONFIRM
            echo
            if [ "$MYSQL_PASS" = "$MYSQL_PASS_CONFIRM" ]; then
                break
            else
                echo -e "${RED}As senhas não coincidem. Tente novamente.${NC}"
            fi
        done
    else
        MYSQL_USER=$DEFAULT_USER
        MYSQL_PASS=$DEFAULT_PASS
        echo -e "${YELLOW}Usando credenciais padrão.${NC}"
    fi
}



# Função de remoção completa
remover_lampy() {
    echo "=========================================="
    echo "         🔥 Removendo Lampy...            "
    echo "=========================================="

    # Para os serviços
    show_progress "Parando serviços"
    systemctl stop apache2 mysql php* 2>/dev/null
    check_status "Serviços parados"

    echo "phpmyadmin phpmyadmin/dbconfig-remove boolean true" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/dbconfig-upgrade boolean true" | debconf-set-selections

    # Remove pacotes
    show_progress "Removendo pacotes"
    DEBIAN_FRONTEND=noninteractive apt-get remove --purge -y apache2* php* mysql* phpmyadmin* 2>/dev/null
    apt-get autoremove --purge -y 2>/dev/null
    check_status "Pacotes removidos"

    # Remove diretórios e configurações
    show_progress "Removendo diretórios e configurações"
    rm -rf /etc/apache2
    rm -rf /etc/mysql
    rm -rf /etc/php*
    rm -rf /var/lib/mysql*
    rm -rf /var/www/html/*
    rm -rf /var/www/sites
    rm -rf /usr/share/phpmyadmin
    rm -rf /var/lib/phpmyadmin
    check_status "Diretórios removidos"

    # Limpa entradas do hosts
    show_progress "Limpando /etc/hosts"
    sed -i '/site[1-3].local/d' /etc/hosts
    check_status "Arquivo hosts limpo"

    # Remove resíduos de configuração
    show_progress "Removendo configurações residuais"
    find /etc -name "*apache*" -exec rm -rf {} \; 2>/dev/null
    find /etc -name "*php*" -exec rm -rf {} \; 2>/dev/null
    find /etc -name "*mysql*" -exec rm -rf {} \; 2>/dev/null
    find /var/lib -name "*mysql*" -exec rm -rf {} \; 2>/dev/null
    find /var/log -name "*apache*" -exec rm -rf {} \; 2>/dev/null
    find /var/log -name "*php*" -exec rm -rf {} \; 2>/dev/null
    find /var/log -name "*mysql*" -exec rm -rf {} \; 2>/dev/null
    check_status "Configurações residuais removidas"

    # Limpa cache apt
    show_progress "Limpando cache do APT"
    apt-get clean
    apt-get autoclean
    check_status "Cache limpo"

    echo
    echo -e "${GREEN}✓ Lampy foi completamente removido do sistema!${NC}"
    echo
    exit 0
}

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
    show_error "Este script precisa ser executado como root. Por favor, execute:\n\n    sudo bash lampy.sh"
fi

# Se o script for chamado com --remove, executa a remoção
if [[ "$1" == "--remove" ]]; then
    remover_lampy
fi

# Exibe o banner
show_banner

# Confirmação do usuário
echo -e "\nEste script irá instalar:"
echo -e "${BLUE}• Apache${NC} (Servidor Web)"
echo -e "${BLUE}• PHP${NC} e extensões comuns"
echo -e "${BLUE}• MySQL${NC} (Banco de dados)"
echo -e "${BLUE}• phpMyAdmin${NC} (Gerenciador do MySQL)"
echo
echo -e "${YELLOW}Isso ocupará aproximadamente 500MB de espaço em disco.${NC}"
echo
read -p "Deseja continuar? [S/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]] && [[ ! -z $REPLY ]]; then
    echo -e "${YELLOW}Instalação cancelada pelo usuário.${NC}"
    exit 0
fi

# Configuração de credenciais
setup_credentials

# Atualiza os repositórios
show_progress "Atualizando repositórios"
apt update &>/dev/null
check_status "Atualização dos repositórios"

# Instala o Apache
install_with_progress "Instalando Apache" "apt install -y apache2" "/tmp/apache_install.log"


# Habilita o Apache para iniciar com o sistema
show_progress "Configurando Apache"
systemctl enable apache2 &>/dev/null
systemctl start apache2 &>/dev/null
check_status "Configuração do Apache"

# Instala o PHP e extensões comuns
install_with_progress "Instalando PHP e extensões" "apt install -y php php-cli php-fpm php-json php-common php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath" "/tmp/php_install.log"

# Instala o MySQL Server
install_with_progress "Instalando MySQL Server" "apt install -y mysql-server" "/tmp/mysql_install.log"

# Configura o MySQL para iniciar com o sistema e configura credenciais
show_progress "Configurando MySQL"
systemctl enable mysql &>/dev/null
systemctl start mysql &>/dev/null

# Configura o usuário MySQL
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost' WITH GRANT OPTION;"
mysql -e "FLUSH PRIVILEGES;"

check_status "Configuração do MySQL"

# Instala o phpMyAdmin
install_with_progress "Instalando phpMyAdmin" "DEBIAN_FRONTEND=noninteractive apt install -y phpmyadmin" "/tmp/phpmyadmin_install.log"


# Cria link para o phpMyAdmin
show_progress "Criando link para o phpMyAdmin"
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin &>/dev/null
check_status "Link do phpMyAdmin criado"

# Configuração para múltiplos sites
show_progress "Configurando suporte a múltiplos sites"
mkdir -p /var/www/sites
chown -R www-data:www-data /var/www/sites
check_status "Configuração de múltiplos sites"

# Função para criar VirtualHost
create_vhost() {
    local domain=$1
    local port=$2
    
    show_progress "Criando site $domain na porta $port"
    
    mkdir -p /var/www/sites/$domain
    
    cat > /etc/apache2/sites-available/$domain.conf << EOF
<VirtualHost *:$port>
    ServerAdmin webmaster@$domain
    ServerName $domain
    DocumentRoot /var/www/sites/$domain
    
    <Directory /var/www/sites/$domain>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/$domain-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain-access.log combined
</VirtualHost>
EOF
    
    a2ensite $domain.conf &>/dev/null
    
    cat > /var/www/sites/$domain/index.php << EOF
<?php
phpinfo();
EOF
    
    chown -R www-data:www-data /var/www/sites/$domain
    chmod -R 755 /var/www/sites/$domain
    
    show_success "Site $domain criado"
}

# Habilita módulos necessários do Apache
install_with_progress "Habilitando módulos Apache" "a2enmod rewrite headers ssl" "/tmp/apache_modules.log"

check_status "Módulos do Apache habilitados"

# Cria sites de exemplo
create_vhost "site1.local" 80
create_vhost "site2.local" 8080
create_vhost "site3.local" 8081

# Reinicia o Apache para aplicar as configurações
show_progress "Reiniciando Apache..."
systemctl restart apache2 &>/dev/null
check_status "Apache reiniciado"

# Configura o /etc/hosts
show_progress "Configurando /etc/hosts"
echo "127.0.0.1 site1.local" >> /etc/hosts
echo "127.0.0.1 site2.local" >> /etc/hosts
echo "127.0.0.1 site3.local" >> /etc/hosts
check_status "Configuração do /etc/hosts"

# Exibe informações finais
echo
echo -e "${GREEN}==========================================${NC}"
echo -e "${GREEN}       Instalação Concluída!! 🎉         ${NC}"
echo -e "${GREEN}==========================================${NC}"
echo
echo -e "🔐 ${BLUE}Credenciais do phpMyAdmin:${NC}"
echo -e "• Usuário: ${YELLOW}$MYSQL_USER${NC}"
echo -e "• Senha: ${YELLOW}$MYSQL_PASS${NC}"
echo
echo -e "📋 ${BLUE}Informações importantes:${NC}"
echo -e "• phpMyAdmin: ${YELLOW}http://localhost/phpmyadmin${NC}"
echo -e "• Diretório Web: ${YELLOW}/var/www/html${NC}"
echo -e "• Logs do Apache: ${YELLOW}/var/log/apache2${NC}"
echo
echo -e "🌐 ${BLUE}Sites criados:${NC}"
echo -e "• ${YELLOW}http://site1.local${NC}"
echo -e "• ${YELLOW}http://site2.local:8080${NC}"
echo -e "• ${YELLOW}http://site3.local:8081${NC}"
echo
echo -e "📝 ${BLUE}Adicione ao seu /etc/hosts:${NC}"
echo -e "${YELLOW}127.0.0.1 site1.local"
echo -e "127.0.0.1 site2.local"
echo -e "127.0.0.1 site3.local${NC}"
echo
echo -e "📚 ${BLUE}Comandos úteis:${NC}"
echo -e "• Reiniciar Apache: ${YELLOW}sudo systemctl restart apache2${NC}"
echo -e "• Logs do Apache: ${YELLOW}tail -f /var/log/apache2/error.log${NC}"
echo
echo -e "${BLUE}Precisa de ajuda? Visite: ${YELLOW}github.com/augsec/lampy${NC}"
echo