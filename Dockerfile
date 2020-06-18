FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# add contrib, non-free and backports repositories
ADD sources.list /etc/apt/sources.list
# pin stable repositories
# ADD preferences /etc/apt/preferences

# clean out, update and install some base utilities
RUN apt-get -y update && apt-get -y upgrade && apt-get clean && \
	apt-get -y install apt-utils lsb-release curl git cron at logrotate rsyslog \
		lsof procps	initscripts libsystemd0 libudev1 systemd sysvinit-utils udev util-linux && \
	sed -i '/imklog/{s/^/#/}' /etc/rsyslog.conf

RUN cd /lib/systemd/system/sysinit.target.wants/ && \
		ls | grep -v systemd-tmpfiles-setup.service | xargs rm -f && \
		rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
		systemctl mask -- \
			etc-hostname.mount \
			etc-hosts.mount \
			etc-resolv.conf.mount \
			swap.target \
			getty.target \
			getty-static.service \
			dev-mqueue.mount \
			cgproxy.service \
			systemd-tmpfiles-setup-dev.service \
			systemd-remount-fs.service \
			systemd-ask-password-wall.path \
			systemd-logind.service && \
		systemctl set-default multi-user.target || true

RUN sed -ri /etc/systemd/journald.conf \
			-e 's!^#?Storage=.*!Storage=volatile!'
ADD container-boot.service /etc/systemd/system/container-boot.service
RUN mkdir -p /etc/container-boot.d && \
		systemctl enable container-boot.service

# run stuff
ADD configurator.sh configurator_dumpenv.sh /root/
ADD configurator.service configurator_dumpenv.service /etc/systemd/system/
RUN chmod 700 /root/configurator.sh /root/configurator_dumpenv.sh && \
		systemctl enable configurator.service configurator_dumpenv.service

RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "1";' > /etc/apt/apt.conf.d/90keep-downloaded

VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock", "/tmp" ]
CMD ["/lib/systemd/systemd"]
