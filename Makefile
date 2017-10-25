APPLICATION_API_HOME=$(NOTASQUARE_HOME)/application
APPLICATION_API_HOST_PORT=8888
APPLICATION_API_MYSQL_HOST_PORT=3333

# DEV
dev-create-storage:
	sudo docker run --name=application-api.mysql.storage \
		-e MYSQL_ROOT_PASSWORD=123456 -d mysql

dev-clear-storage:
	-sudo docker stop application-api.mysql.storage
	-sudo docker rm application-api.mysql.storage

dev-ssh-storage:
	sudo docker exec -it application-api.mysql.storage mysql -uroot -p123456

dev-build:
	sudo docker build -f docker/Dockerfile-dev -t application-api/dev .

dev-deploy:
	sudo docker run -d --name=application-api.mysql \
		--volumes-from=application-api.mysql.storage \
		-p $(APPLICATION_API_MYSQL_HOST_PORT):3306 \

	sudo docker run -d --name=application-api.web \
		-v $(APPLICATION_API_HOME)/src/www/:/opt/www/ \
		-p $(APPLICATION_API_HOST_PORT):80 \
		--link application-api.mysql:mysql \
		application-api/dev
