**Database Tips and Tricks**

[[_TOC_]]

# Postgresql
## DB create
### 1st method
```shell
psql -U postgres
 create user mydbuser with password 'MOTDEPASSEACHANGER';
 create database mydbname owner mydbuser;
 \q
```

### 2nd method
```shell
su - postgres
 createuser -P mydbuser
 createdb -O mydbuser mydbname
```

### 3rd method
```shell
su - postgres
 createdb mydbname
 createuser mydbuser
 psql
  alter user mydbuser with encrypted password 'MOTDEPASSEACHANGER';
  grant all privileges on database mydbname to mydbuser ;
```

----

## DB backup and restore
```shell
su - postgres
 pg_dump -U mydbuser mydbname > mydbname-mydbuser-${HOSTNAME}-$(date +%Y%m%d%H%M%S).pgsql
 psql -W -p 5432 -U mydbuser mydbname < mydbname-mydbuser-${HOSTNAME}-$(date +%Y%m%d%H%M%S).pgsql 
```

----

## psql usefull commands:
### List databases
```shell
\l
```
### Connect to database
```shell
\c mydbname
```
### Display database's tables
```shell
\dt
```



----

# MySQL
## List databases
```shell
mysql -u root -p -e 'show databases;'
```

----

## Update root password
```shell
UPDATE mysql.user SET Password=PASSWORD('MOTDEPASSEACHANGER') WHERE User='root';
FLUSH PRIVILEGES;
```

----

## DB create
```shell
mysql -uroot -p
 CREATE DATABASE mydbname CHARACTER SET utf8 COLLATE utf8_unicode_ci;
 CREATE USER 'mydbuser'@'localhost' IDENTIFIED BY 'MOTDEPASSEACHANGER';
 GRANT ALL PRIVILEGES ON mydbname.* TO 'mydbuser'@'localhost';
 FLUSH PRIVILEGES;
 exit
```

----

## DB backup and restore
```shell
mysqldump -u root -p --all-databases > alldb-${HOSTNAME}-$(date +%Y%m%d%H%M%S).sql
mysql -u root -p < alldb-${HOSTNAME}-$(date +%Y%m%d%H%M%S).sql
```


