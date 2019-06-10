
all:
	docker build -t kkoralsky/debian-systemd .

rebuild:
	docker pull debian:stretch
	docker build --no-cache=true -t kkoralsky/debian-systemd .

push:
	docker tag kkoralsky/debian-systemd kkoralsky/debian-systemd:stretch
	docker push kkoralsky/debian-systemd

run: all
	docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name=debian-systemd --rm kkoralsky/debian-systemd
	docker exec -it debian-systemd bash

clean:
	docker stop debian-systemd
