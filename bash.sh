#kodekloud_ecommerce_site_shell_script

#!/bin/bash
#
# Automate ECommerce Application Deployment
# Author: GENCER

#######################################
# Print a message in a given color.
# Arguments:
#   Color. eg: green, red
#######################################
function print_color(){
    NC='\033[0m' # No Color

    case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
    esac

    echo -e "${COLOR} $2 ${NC)"
}

#######################################
# Check the status of a given service. If not active exit script
# Arguments:
#   Service Name. eg: firewalld, mariadb
#####################################

function check_service_status(){
    service_is_active=$(sudo systemctl is-active $1)

    if [ $service_is_active = "active" ]
    then
        echo "$1 is acitve and running"
    else
        echo "$1 is not active/running"
        exit 1
    fi
}











echo "----------------------- Veritabanı Kuruluyor------------------"

#install and configure firewalld
print_color "green" "Installing  FirewallD.. "
sudo yum install -y firewalld

print_color "green" "Installing  FirewallD.. "
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Check FirewallD Service is running
check_service_status firewalld

#####BURADA KALDIMMMMMMMMMMM

#install mariadb
sudo yum install -y mariadb-server
sudo vi /etc/my.cnf
sudo systemctl start mariadb
sudo systemctl enable mariadb

#configure firewalld
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

#configure mariadb
sudo mysql
MariaDB > CREATE DATABASE ecomdb;
MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
MariaDB > FLUSH PRIVILEGES;

#create db-load-script.sql
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF

