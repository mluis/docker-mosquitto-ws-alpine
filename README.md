# docker-mosquitto-ws-alpine
Automated build of the Mosquitto MQTT server with Websockets support in Alpine:3.4

RUN:
	docker run --restart=always -p 1883:1883 -p 9001:9001 -v $PWD/mqtt/config:/mqtt/config -v $PWD/mqtt/log:/mqtt/log -v $PWD/mqtt/data:/mqtt/data --name <name> <build-name>
