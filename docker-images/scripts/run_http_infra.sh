#!/bin/bash

#Kill containers if they are running
docker kill apache_static apache_reverse express_dynamic

#Remove containers created before with the same name
docker rm apache_static apache_reverse express_dynamic

#Run containers
docker run -d --name apache_static res/apache_php
docker run -d --name express_dynamic res/express_students
docker run -d -p 8080:80 --name apache_reverse res/apache_rp

