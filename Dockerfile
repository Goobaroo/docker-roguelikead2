# syntax=docker/dockerfile:1

FROM openjdk:8u312-jre-buster

LABEL version="1.13a"
LABEL homepage.group=Minecraft
LABEL homepage.name="RAD2 - 1.13a "
LABEL homepage.icon="https://media.forgecdn.net/avatars/485/618/637786105420601729.png"
LABEL homepage.widget.type=minecraft
LABEL homepage.widget.url=udp://Roguelike-Adventures-and-Dungeons-2:25565
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