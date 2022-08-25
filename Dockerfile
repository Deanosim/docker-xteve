FROM ghcr.io/linuxserver/baseimage-alpine:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
ARG XTEVE_VERSION
LABEL build_version="Deanosim version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Deanosim"

RUN \
 # echo "**** install build packages ****" && \
 # apk add --no-cache --virtual=build-dependencies \
	# nodejs-npm && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	bash \
	busybox-suid \
	su-exec \
	ffmpeg \
	vlc && \
 sed -i 's/geteuid/getppid/' /usr/bin/vlc && \
 echo "**** install xteve ****" && \
 #if [ -z ${XTEVE_VERSION+x} ]; then \
#	XTEVE_VERSION=$(curl -sX GET "https://github.com/SenexCrenshaw/xTeVe/releases/latest" \
#	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
# fi && \
 curl -o \
 /tmp/xteve_linux_amd64 -L \
	"https://github.com/SenexCrenshaw/xTeVe/releases/download/v2.5.1/xteve-v2.5.1-linux-amd64.tar.gz" && \
 tar -xvf xteve-v2.5.1-linux-amd64.tar.gz
 cp \
 /tmp/xteve_linux_amd64 \
	/app/ && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# app runs on port 34400
EXPOSE 34400
