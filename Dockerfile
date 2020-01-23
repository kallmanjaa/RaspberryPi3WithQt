#Download base image ubuntu 16.04
FROM ubuntu:18.04
 
# Update Software repository
RUN apt-get update

COPY . /rpi3

##ENTRYPOINT ["/rpi3/build.sh"] 
