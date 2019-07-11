# docker-debian-systemd

Debian container running systemd in unpriviledged mode

start like this:
```
docker run -dv /sys/fs/cgroup:/sys/fs/cgroup:ro --name=debian-systemd kkoralsky/debian-systemd
docker exec -it debian-systemd bash
```

Or use supplied makefile.


## Basing containers on this

Docker environment variables are imported into systemd when the container starts up - see configurator_dumpenv.sh

If you need to change a configuration file based on docker environment variables, check out configurator.sh. It too runs when the container first starts up.


## Gotchas

* backports are enabled and pinned to be used.
* cron, rsyslogd and atd are running, reconfigure or disable as required
