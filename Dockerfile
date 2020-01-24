#Download base image ubuntu 18.04
FROM ubuntu:18.04
 
# Update Software repository
RUN dpkg --add-architecture i386 \
	&& apt-get update


COPY . /rpi3

##ENTRYPOINT ["/rpi3/build.sh"] 
