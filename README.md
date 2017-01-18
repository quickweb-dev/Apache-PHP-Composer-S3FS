* Apache-PHP-Composer-S3FS Base Image

Base image for PHP applications possibly backed up by AWS storage via S3FS

Defines:

| Environment Variable | Value             | Meaning                                     |
|----------------------|-------------------|---------------------------------------------|
| ```APP_DIR```        | /var/www/html/app | Path where the application must be deployed |
| ```WORKDIR```        | /workdir          | The folder in which the startup script runs |

Environment:

* apache2
* php7.0
* libapache2-mod-php7.0
* php7.0-mysql
* php7.0-xml
* php7.0-zip
* php7.0-mbstring
* php7.0-gd

Enabled modules:

* mod-rewrite
* mod-ssl

Utilities:

* composer
* git
* s3fs

Enables apache configuration: [000-default.conf](./resources/000-default.conf)
Enables apache configuration: [000-default-ssl.conf](./resources/000-default-ssl.conf)
Startup script: [docker-entrypoint.sh](./resources/docker-entrypoint.sh)



