#!/bin/bash

#Kill containers if they are running
docker kill apache_static apache_reverse express_dynamic

#Remove containers created before with the same name
docker rm apache_static apache_reverse express_dynamic

#Re building containers
docker build -t res/apache_php /home/chris/Documents/HEIG_A2_S2/RES/PatrickHttp/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/apache-php-image
docker build -t res/express_students /home/chris/Documents/HEIG_A2_S2/RES/PatrickHttp/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/express-image
docker build -t res/apache_rp /home/chris/Documents/HEIG_A2_S2/RES/PatrickHttp/Teaching-HEIGVD-RES-2018-Labo-HTTPInfra/docker-images/apache-reverse-proxy

#Run containers
docker run -d --name apache_static res/apache_php
docker run -d --name express_dynamic res/express_students
docker run -d -p 8080:80 --name apache_reverse -e STATIC_APP=172.17.0.2 -e DYNAMIC_APP=172.17.0.3:3000 res/apache_rp

