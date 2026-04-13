# syntax=docker/dockerfile:1

FROM rockylinux:8.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG OPENSSH_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN \
  echo "**** install runtime packages ****" && \
  yum makecache --refresh && \
  yum install -y \
    logrotate \
    nano \
    iproute \
    sudo && \
  echo "**** install openssh-server ****" && \
  yum install -y openssh-server 

 # if [ -z ${OPENSSH_RELEASE+x} ]; then \
 #   OPENSSH_RELEASE=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.23/main/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp && \
 #   awk '/^P:openssh-server-pam$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
 # fi && \
 # yum install \
 #   openssh-client==${OPENSSH_RELEASE} \
 #   openssh-server-pam==${OPENSSH_RELEASE} \
 #   openssh-sftp-server==${OPENSSH_RELEASE} && \
 # printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
RUN \
  echo "**** setup openssh environment ****" && \
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
#  useradd abc && usermod --shell /bin/bash abc && \
  rm -rf /tmp/* $HOME/.cache

# add local files
COPY ./root /

EXPOSE 2222

VOLUME /config
