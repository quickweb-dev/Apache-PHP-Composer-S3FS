#~/usr/bin/env bash

# Stop on any errors
set -e

# Figure out current dir.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check env
${DIR}/check-env.sh
${APP_DIR}/docker/check-env.php

a2ensite 000-default-ssl

# Apache gets grumpy about PID files pre-existing
rm -f /usr/local/apache2/logs/httpd.pid

# Apache gets grumpy about server-name not beeing set:
echo "ServerName ${FQDN}" > /etc/apache2/conf-available/fqdn.conf
a2enconf -q fqdn

# Change UID & GID of www-data as required
if [ "33" -ne "${WWW_DATA_USER_ID}" ] || [ "33" -ne "${WWW_DATA_GROUP_ID}" ]
then
	set +e
	usermod -u ${WWW_DATA_USER_ID} www-data    
	groupmod -g ${WWW_DATA_GROUP_ID} www-data
	find / -user 33 -exec chown -h ${WWW_DATA_USER_ID} {} \; 2>/dev/null
	find / -group 33 -exec chgrp -h ${WWW_DATA_GROUP_ID} {} \; 2>/dev/null
	set -e
fi

# Mount S3 Bucket

if [ "true" = "${USE_S3_BUCKET}" ]
then
        rm -fr /tmp/${S3_BUCKET}_cache
        mkdir -p /tmp/${S3_BUCKET}_cache
        mkdir -p ${APP_DIR}/${S3_BUCKET_MOUNTPOINT}
	export AWSACCESSKEYID=${S3_BUCKET_ACCCESSKEY}
        export AWSSECRETACCESSKEY=${S3_BUCKET_AWSSECRETACCESSKEY}
	s3fs ${S3_BUCKET} ${APP_DIR}/${S3_BUCKET_MOUNTPOINT} -o endpoint=${S3_BUCKET_ENDPOINT} -o allow_other -o use_cache=/tmp/${S3_BUCKET}_cache -o nonempty
fi

# Update the database.
if [ "true" = "${UPDATE_DB}" ]
then
	${APP_DIR}/docker/update-db.sh
fi

# Start cron in background
service cron start > /dev/null

# And start apache in the foreground
exec apachectl -DFOREGROUND -e info

