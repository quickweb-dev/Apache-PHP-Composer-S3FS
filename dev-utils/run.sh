#!/usr/bin/env bash

docker run -it --rm \
        -v "$(pwd)/sample":/var/www/html/app \
        -v "$(pwd)/sample/.env.example":/workdir/.env.example \
	--env-file ./sample/.env.example \
        --name web-server-local-build \
	--cap-add SYS_ADMIN \
        --device /dev/fuse \
	apache-php-composer-s3fs
