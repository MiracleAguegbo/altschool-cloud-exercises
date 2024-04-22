## Cloud Engineering Second Semester Examination Project

Cloud Engineering Second Semester Cloud Engineering Second Semester Examination Project IN PROGRESS (Deploy LAMP Stack)

Objective: Automate the provisioning of two Ubuntu-based servers, named “Master” and “Slave”, using Vagrant. On the Master node, create a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack. This script should clone a PHP application from GitHub, install all necessary packages, and configure Apache web server and MySQL. Ensure the bash script is reusable and readable. Using an Ansible playbook: Execute the bash script on the Slave node and verify that the PHP application is accessible through the VM’s IP address (take screenshot of this as evidence) Create a cron job to check the server’s uptime every 12 am.

Requirements

Submit the bash script and Ansible playbook to (publicly accessible) GitHub repository. Document the steps with screenshots in md files, including proof of the application’s accessibility (screenshots taken where necessary) Use either the VM’s IP address or a domain name as the URL.

## solution

I started by automating the provisioning of two Ubuntu-based servers, named “Master” and “Slave”, using Vagrant, which involved configuring my Vagrantfile.

![vagrantfile](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/second-semester-project/images/vagrantfile.png)

After setting it up, I used "vagrant up," "vagrant ssh master," and "vagrant ssh slave" to start both nodes.

![vagrantfile](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/second-semester-project/images/slave%20and%20master.png)

## Bash script

I've broken down the task of automating the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack into smaller functions, each serving a specific purpose. Together, these functions seamlessly deploy the entire LAMP stack when executed sequentially.

Step 1: I cloned the Laravel application repository from GitHub and ensured appropriate ownership permissions are set.

```
#Function to clone Laravel application from GitHub

clone_repository() {
    cd /var/www/

    sudo git clone https://github.com/laravel/laravel.git

    sudo chown -R $USER:$USER /var/www/laravel
    
    }
```
Step 2:  I updated the repository and installed necessary packages such as Apache2, PHP 8.2, Git, and other essential dependencies.

```
# Function to install Packages
install_packages() {
    sudo apt update -y
    sudo apt install apache2 -y
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update -y
    sudo apt install php8.2 php8.2-curl php8.2-dom php8.2-mbstring
    php8.2-xml php8.2-mysql zip unzip git -y
    sudo a2enmod rewrite
}
```

Step 3: I installed Composer to manage PHP dependencies, installed Laravel dependencies, and created the .env file for configuration.

```
# Function to install Composer
install_composer() {
    cd /usr/local/bin
    sudo curl -sS https://getcomposer.org/installer | sudo php -q
    sudo mv composer.phar composer

    cd laravel/
    composer install --no-interaction --optimize-autoloader --no-dev
    composer update --no-interaction

    sudo cp .env.example .env
    sudo chown -R www-data storage
    sudo chown -R www-data bootstrap/cache
}
```
Step 4:  I configured Apache to serve the Laravel project, setting up a virtual host and restarting the Apache service as needed.

```
# Function to configure Apache
configure_apache() {
    sudo tee /etc/apache2/sites-available/laravel.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/laravel/public

    <Directory /var/www/laravel>
        AllowOverride All
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/laravel-error.log
    CustomLog \${APACHE_LOG_DIR}/laravel-access.log combined
</VirtualHost>
EOF

    sudo a2ensite laravel.conf
    sudo a2dissite 000-default.conf
    sudo systemctl restart apache2
}

```
Step 5: I created a function to install MySQL, create a new database, and grant privileges to a user, all while configuring the .env file to reflect MySQL settings. Additionally, the function will execute the Artisan commands for Laravel setup and restarted Apache.

```
# Function to configure MySQL
configure_mysql() {
    sudo apt install mysql-server mysql-client -y

    sudo systemctl start mysql

    sudo mysql -uroot -e "CREATE DATABASE Exam;"
    sudo mysql -uroot -e "CREATE USER 'rac'@'localhost' IDENTIFIED BY 'vagrant';"
    sudo mysql -uroot -e "GRANT ALL PRIVILEGES ON Project.* TO 'rac'@'localhost';"

    sudo sed -i "23 s/^#//g" /var/www/laravel/.env
    sudo sed -i "24 s/^#//g" /var/www/laravel/.env
    sudo sed -i "25 s/^#//g" /var/www/laravel/.env
    sudo sed -i "26 s/^#//g" /var/www/laravel/.env
    sudo sed -i "27 s/^#//g" /var/www/laravel/.env
    sudo sed -i '22 s/=sqlite/=mysql/' /var/www/laravel/.env
    sudo sed -i '23 s/=127.0.0.1/=localhost/' /var/www/laravel/.env
    sudo sed -i '24 s/=3306/=3306/' /var/www/laravel/.env
    sudo sed -i '25 s/=laravel/=Exam/' /var/www/laravel/.env
    sudo sed -i '26 s/=root/=rac/' /var/www/laravel/.env
    sudo sed -i '27 s/=/=vagrant/' /var/www/laravel/.env

    cd /var/www/laravel
    sudo php artisan key:generate
    sudo php artisan storage:link
    sudo php artisan migrate
    sudo php artisan db:seed
    sudo systemctl restart apache2
}
```

Step 6: I created a function that calls other functions and also gives an output saying "LAMP stack deployment completed successfully."

```
#Deploy Function

deploy_function() {
install_packages
clone_repository
install_composer
configure_apache
configure_mysql
echo "LAMP stack deployment completed successfully."
}

deploy_function
```