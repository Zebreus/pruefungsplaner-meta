FROM archlinux:latest
MAINTAINER Lennart E.

#RUN pacman -Syu --noconfirm && pacman -S --noconfirm reflector
#RUN reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist && pacman -Sy --noconfirm && pacman -S --noconfirm qt5-base qt5-websockets openssl

#Install qt5, git and googletest
RUN pacman -Syu --noconfirm && pacman -S --noconfirm qt5-base qt5-websockets

COPY ./built-scheduler /scheduler

EXPOSE 9094/tcp

WORKDIR /scheduler
ENTRYPOINT ["./pruefungsplaner-scheduler"]
CMD []
