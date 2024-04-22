#!/bin/bash

# Custom error function for displaying error messages and exiting
function error() {
    echo "Error occurred: $1"
    exit 1
}

# Function to install necessary packages
function install_packages() {
    echo "Installing required packages..."
    sudo apt update
    sudo dpkg -l | grep php | tee packages.txt
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update || error "Failed to update apt"
    sudo apt install mysql-server apache2 php8.2 php8.2-cli php8.2-{bz2,curl,mbstring,intl} php8.2-curl php8.2-dom php8.2-mbstring php8.2-xml php8.2-mysql zip unzip -y || error "Failed to install packages"
    curl -k -sS https://getcomposer.org/installer -o /tmp/composer-setup.php || error "Failed to download composer setup"
    sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer || error "Failed to install composer"
}

# Main function
function main() {
    # Check if all required arguments are provided
    if [ $# -ne 7 ]; then
        error "Not all required arguments provided"
    fi

    # Install necessary packages
    install_packages

    # Clone app from provided GitHub repository
    echo "Cloning PHP application from GitHub..."
    git clone "$1" "$2" || error "Failed to clone repository"

    # Configuring Apache web server
    echo "Configuring Apache web server..."

    # Copy application files to Apache directory
    sudo mv "$2" /var/www/ || error "Failed to copy files to Apache directory"
    sudo chmod -R 775 "/var/www/$2" || error "Failed to change permissions of files"
    sudo systemctl restart apache2 || error "Failed to restart Apache"

    # Configure MySQL database
    echo "Configuring MySQL database..."
    sudo mysql -e "CREATE DATABASE IF NOT EXISTS $3;" || error "Failed to create database"
    sudo mysql -e "CREATE USER '$4'@'%' IDENTIFIED WITH mysql_native_password BY '$5';" || error "Failed to create user"
    sudo mysql -e "GRANT ALL ON $3.* TO '$4'@'%';" || error "Failed to grant privileges"
    sudo mysql -e "FLUSH PRIVILEGES;" || error "Failed to flush privileges"

    # Create and edit .env file
    echo "Editing .env file..."
    sudo bash -c "cat > /var/www/$2/.env" <<EOF
# Environment Configuration

APP_NAME="$6"
APP_ENV="$7"
APP_KEY=
APP_DEBUG=false
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE="$3"
DB_USERNAME="$4"
DB_PASSWORD="$5"

# Other configurations...

EOF

    # Generate app key and migrate database
    echo "Generating App key and migrating database..."
    sudo chown $USER:$USER /var/www/$2/.env
    cd "/var/www/$2"
    composer install || error "Failed to install Composer dependencies"
    php artisan key:generate || error "Failed to generate App key"
    php artisan optimize || error "Failed to optimize app"
    php artisan migrate || error "Failed to migrate database"

    # Create Apache config file
    echo "Creating Apache config file..."
    cat << EOF | sudo tee /etc/apache2/sites-available/laravel.conf >/dev/null
# Apache Configuration for Laravel

<VirtualHost *:80>
    ServerName $8
    ServerAlias $8
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/$2/public
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

EOF

    # Enable Apache site
    echo "Enabling Apache site..."
    sudo chown -R www-data:www-data "/var/www/$2" || error "Failed to change ownership of files"
    sudo ln -s /etc/apache2/sites-available/laravel.conf /etc/apache2/sites-enabled/ || error "Failed to enable site"
    sudo a2ensite laravel.conf || error "Failed to enable site"
    sudo systemctl reload apache2 || error "Failed to reload Apache"

    echo "LAMP stack deployment completed successfully!"
}

# Call main function with arguments
main "$@"
