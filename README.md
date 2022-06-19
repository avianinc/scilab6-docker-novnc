# scilab6-docker-novnc
scilab 6 - latest ubuntu 20.04 installation with fluxbox hosted on noVNC
Corrected grhaphics error: Profile GL3bc is not available on X11GraphicsDevice
Jupyter lab w/scilab kernel

BUILD: docker build -t avianinc/scilab6-docker-novnc:main <br>
RUN: docker run -it -p 8084:8084 -p 8888:8888 avianinc/scilab6-docker-novnc:main <br>
