FROM alpine:edge
MAINTAINER Lennart E.

RUN apk update && apk add build-base git gtest gmock qt5-qtbase-dev qt5-qtwebsockets-dev qt5-qtsvg-dev qt5-qtquickcontrols2-dev qt5-qttools-dev openssl
ENV PATH="/usr/lib/qt5/bin/:${PATH}"
