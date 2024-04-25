To install Nagios on Ubuntu server, you can follow these steps:

https://medium.com/@murat.bilal/installing-nagios-on-ubuntu-22-04-614516063a0

1. Update the package list:
```sql
sudo apt-get update
```
2. Install the required dependencies:
```arduino
sudo apt-get install build-essential wget unzip apache2 php libapache2-mod-php php-gd libcgi-pm-perl libapache2-mod-cgid
```
3. Download the latest version of Nagios Core from the official website:
```bash
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
```
Note: Replace "4.4.6" with the latest version number.
4. Extract the downloaded file:
```
tar -xvf nagios-4.4.6.tar.gz
```
5. Change to the Nagios directory:
```bash
cd nagios-4.4.6/
```
6. Run the configure script:
```bash
./configure --with-httpd-conf=/etc/apache2/sites-enabled/
```
7. Compile and install Nagios:
```go
make all
sudo make install
```
8. Install the Nagios plugins:
```bash
sudo apt-get install nagios-plugins nagios-plugins-standard nagios-plugins-basic nagios-plugins-extra
```
9. Install the Nagios web interface:
```csharp
sudo apt-get install nagios-cgi-bin
```
10. Create a Nagios user and group:
```arduino
sudo useradd -m -s /bin/bash nagios
sudo usermod -a -G nagios www-data
```
11. Configure the Nagios service:
```arduino
sudo systemctl enable nagios
sudo systemctl start nagios
```
12. Configure the Apache web server:
```lua
sudo ln -s /etc/nagios4/cgi.load /etc/apache2/mods-enabled/
sudo ln -s /etc/nagios4/nagios.conf /etc/apache2/sites-enabled/
sudo a2enmod cgi
sudo systemctl restart apache2
```
To init Nagios, you can use the following command:
```sql
sudo systemctl start nagios
```
This will start the Nagios service. You can then access the Nagios web interface by opening a web browser and navigating to `http://your_server_ip/nagios`.

That's it! Nagios is now installed and running on your Ubuntu server. You can configure Nagios to monitor your PostgreSQL database by adding the appropriate plugins and configuration files. The Nagios documentation provides detailed instructions on how to do this.