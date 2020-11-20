FROM archlinux:latest
MAINTAINER Lennart E.

#Install reflector to get the best mirrors later
RUN pacman -Syu --noconfirm && pacman -S --noconfirm reflector

#Install qt5, git and googletest
RUN reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist && pacman -Sy && pacman -S --noconfirm base-devel git gtest gmock qt qt5

