# scilab6-docker-novnc
scilab 6 - Ubuntu 20.04 w/fluxbox hosted on noVNC <br>
- Corrected grhaphics error: Profile GL3bc is not available on X11GraphicsDevice <br>
- Jupyter kernal API <br>
- Jupyter lab w/scilab kernel <br>

BUILD: `docker build -t avianinc/scilab6-docker-novnc:main` <br>
RUN: `docker run -it -p 8084:8084 -p 8888:8888 -p 10100:10100 avianinc/scilab6-docker-novnc:main` <br>
PULL: `docker pull avianinc/scilab6-docker-novnc:main`

Example API calls:
- Convert radians to degrees (http://localhost:10100/convert_r2d?angle=3.14159)
- Convert degrees to radians (http://localhost:10100/convert_d2r?angle=180)
- Fetch a random number based on a seed from scilab (http://localhost:10100/scilab_random_numb?seed=5)
- Execute a modelica model of a sine wave and return the wave points (http://localhost:10100/scilab_xcos_model?Amp=1&Freq=2)
