# scilab6-docker-novnc
scilab 6 - latest ubuntu 20.04 installation with fluxbox hosted on noVNC
Corrected grhaphics error: Profile GL3bc is not available on X11GraphicsDevice

BUILD: docker build -t avianinc/scilab6-docker-novnc:main
RUN: docker run -it -p 8084:8084 avianinc/scilab6-docker-novnc:main