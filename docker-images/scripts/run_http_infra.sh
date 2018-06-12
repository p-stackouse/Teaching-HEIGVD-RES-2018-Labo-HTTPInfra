#!/bin/bash

#Kill containers if they are running
docker kill apache_static apache_static2 apache_reverse express_dynamic express_dynamic2

#Remove containers created before with the same name
docker rm apache_static apache_static2 apache_reverse express_dynamic express_dynamic2

#Re building containers
docker build -t res/apache_php /Users/patrickneto/CloudStation/Heig-VD/RES/Labos/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/apache-php-image
docker build -t res/express_students /Users/patrickneto/CloudStation/Heig-VD/RES/Labos/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/express-image
docker build -t res/apache_rp /Users/patrickneto/CloudStation/Heig-VD/RES/Labos/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/apache-reverse-proxy

#Run containers
docker run -d --name apache_static res/apache_php
docker run -d --name apache_static2 res/apache_php
docker run -d --name express_dynamic res/express_students
docker run -d --name express_dynamic2 res/express_students
docker run -d -p 8080:80 --name apache_reverse -e STATIC_APP1=172.17.0.2 -e STATIC_APP2=172.17.0.3 -e DYNAMIC_APP1=172.17.0.4:3000 -e DYNAMIC_APP2=172.17.0.5:3000 res/apache_rp

