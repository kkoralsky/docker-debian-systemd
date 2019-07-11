
all:
	DOCKER_CONTENT_TRUST=1 docker build -t kkoralsky/debian-systemd .

rebuild:
	docker pull debian:buster
	DOCKER_CONTENT_TRUST=1 docker build --no-cache=true -t kkoralsky/debian-systemd .

push:
	DOCKER_CONTENT_TRUST=1 docker push kkoralsky/debian-systemd:latest

run: all
	docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name=debian-systemd --rm kkoralsky/debian-systemd
	docker exec -it debian-systemd bash

clean:
	docker stop debian-systemd
