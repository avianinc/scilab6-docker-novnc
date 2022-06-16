# noVNC access to Scilab 5.2.2 + Coselica through a web browser#

FROM ubuntu:20.04
LABEL maintainer="jdehart@avian.com" 

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TZ=America/New_York
ENV SCREEN_RESOLUTION 1280x720
ENV _JAVA_OPTIONS="-Djogl.disable.openglcore=false"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Base install
RUN apt-get update && apt-get -y install \
	xvfb \
	x11vnc \
	supervisor \
	fluxbox \
	net-tools \
	git-core \
	git \
    procps \
	nano

# Extras
RUN apt-get install -y build-essential libreadline-gplv2-dev \
    libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev python3-pip unzip lsb-release software-properties-common \
    curl wget rsync mesa-utils

# Install scilab and coselica toolbox
RUN apt-get install -y scilab
#RUN scilab-cli -e  "atomsInstall(\"coselica\"); exit;" -nb

# House cleaning
RUN apt-get autoclean

# Docker's supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set display
ENV DISPLAY :0

# Change work directory to add novnc files
WORKDIR /root/
#ADD noVNC-0.6.2 /root/novnc/
RUN git clone https://github.com/novnc/noVNC.git ./novnc  && \
    git clone https://github.com/novnc/websockify.git ./novnc/utils/websockify
RUN ln -s /root/novnc/vnc_lite.html /root/novnc/index.html
#RUN ln -s /root/novnc/vnc.html /root/novnc/index.html

## mesa drivers to correct plot issues with scilab 6x
RUN add-apt-repository ppa:kisak/kisak-turtle -y
RUN apt update
RUN apt upgrade -y

# A few examples for the demo
# WORKDIR /scripts
# ADD ./octave_scr /scripts

# Can be configured to set octave settings
# COPY qt-settings /root/.config/octave/qt-settings

# Expose Port (Note: if you change it do it as well in surpervisord.conf)
EXPOSE 8084

CMD ["/usr/bin/supervisord"]