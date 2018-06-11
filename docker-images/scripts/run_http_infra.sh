#!/bin/bash

#Kill containers if they are running
docker kill apache_static apache_reverse express_dynamic

#Remove containers created before with the same name
docker rm apache_static apache_reverse express_dynamic

#Re building containers
docker build -t res/apache_php /Users/patrickneto/CloudStation/Heig-VD/RES/Labos/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/apache-php-image
docker build -t res/express_students /Users/patrickneto/CloudStation/Heig-VD/RES/Labos/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/express-image
docker build -t res/apache_rp /Users/patrickneto/CloudStation/Heig-VD/RES/Labos/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/apache-reverse-proxy

#Run containers
docker run -d --name apache_static res/apache_php
docker run -d --name express_dynamic res/express_students
docker run -d -p 8080:80 --name apache_reverse res/apache_rp

