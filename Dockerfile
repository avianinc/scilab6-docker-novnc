# noVNC access to Scilab 6.0.2 w/coselica through a web browser #

FROM ubuntu:20.04
LABEL maintainer="jdehart@avian.com" 

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV TZ=America/New_York
ENV SCREEN_RESOLUTION 1280x768
ENV SCILAB_EXECUTABLE='/tmp/scilab-6.0.2/bin/scilab-adv-cli'
#ENV SCILAB_EXECUTABLE="scilab-adv-cli"

# See --> https://groups.google.com/g/jaer-users/c/G6mZ7EXmiYQ
#ENV _JAVA_OPTIONS="-Djogl.disable.openglcore=false"
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
RUN apt-get install -y build-essential libreadline-gplv2-dev gfortran \
    libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev python3-pip unzip lsb-release software-properties-common \
    curl wget rsync mesa-utils

# Install jupyter
RUN pip install --upgrade pip 
RUN pip install jupyterlab scilab-kernel pandas matplotlib numpy requests requests jupyter_kernel_gateway ipywidgets
RUN pip cache purge

## mesa drivers to correct plot issues with scilab 6x
# See --> https://www.linuxcapable.com/install-upgrade-mesa-drivers-radeon-nvidia-on-ubuntu-20-04-lts/
RUN add-apt-repository ppa:kisak/kisak-mesa -y
RUN apt update
RUN apt upgrade -y

# House cleaning
RUN apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Install scilab and coselica toolbox
#RUN apt-get install -y scilab
WORKDIR /tmp
RUN wget https://www.scilab.org/download/6.0.2/scilab-6.0.2.bin.linux-x86_64.tar.gz \
	&& tar xf scilab-6.0.2.bin.linux-x86_64.tar.gz \
	&& /tmp/scilab-6.0.2/bin/scilab-cli -e  "atomsRepositoryAdd([\"http://atoms.scilab.org/6.0\"]); exit;" -nb \
	&& /tmp/scilab-6.0.2/bin/scilab-cli -e  "atomsInstall(\"coselica\"); exit;" -nb \
	&& rm scilab-6.0.2.bin.linux-x86_64.tar.gz

# Docker's supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set display
ENV DISPLAY :0

# Change work directory to add novnc files
WORKDIR /root/
#ADD noVNC-0.6.2 /root/novnc/
RUN git clone https://github.com/novnc/noVNC.git ./novnc  && \
    git clone https://github.com/novnc/websockify.git ./novnc/utils/websockify
#RUN ln -s /root/novnc/vnc_lite.html /root/novnc/index.html
RUN ln -s /root/novnc/vnc.html /root/novnc/index.html

# A few examples for the demo
# WORKDIR /scripts
# ADD ./octave_scr /scripts

# Pull test directory
#RUN useradd -ms /bin/bash scilab
#USER scilab
#WORKDIR /home/scilab 
RUN git clone https://github.com/avianinc/jupyter_demos
#RUN cd /root/jupyter_demos/API_Demo

# Can be configured to set octave settings
# COPY qt-settings /root/.config/octave/qt-settings

# Expose Port (Note: if you change it do it as well in surpervisord.conf)

EXPOSE 8084
EXPOSE 8889
EXPOSE 10100

CMD ["/usr/bin/supervisord"]