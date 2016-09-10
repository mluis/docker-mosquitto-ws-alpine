FROM alpine:3.4

MAINTAINER Miguel Luis <mkxpto@gmail.com>

RUN 	mkdir -p src && \
	cd src && \
	apk add --update build-base git openssl-dev c-ares-dev util-linux-dev libwebsockets-dev && \
	git clone https://github.com/eclipse/mosquitto.git && \
	cd mosquitto && \
	git checkout tags/v1.4.9 -b v1.4.9 && \
	sed -i.bak s/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/g config.mk && \
	sed -i.bak s/WITH_DOCS:=yes/WITH_DOCS:=no/g config.mk && \
	make && \
	find . -type f | grep Makefile | xargs grep -r -- --strip-program  | awk {'print $1'} | cut -d : -f 1 | xargs sed -i 's/--strip-program=\${CROSS_COMPILE}\${STRIP}//g' && \
	sed -i 's/set -e; for d in ${DOCDIRS}; do $(MAKE) -C $${d} install; done//g' Makefile  && \
	make install && \
	adduser -s /bin/false -D -H mosquitto && \
	cd / && \
	rm -rf src && \
	rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log
COPY mqtt/config /mqtt/config
RUN chown -R mosquitto:mosquitto /mqtt
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 9001

ADD docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]
