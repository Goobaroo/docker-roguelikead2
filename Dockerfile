# syntax=docker/dockerfile:1

FROM openjdk:8u312-jre-buster

LABEL version="1.13a"

RUN apt-get update && apt-get install -y curl unzip && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

ENV MOTD " Server"

CMD ["/launch.sh"]