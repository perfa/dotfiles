FROM phusion/baseimage

RUN useradd -ms /bin/bash mango
RUN apt-get update && apt-get install -y git 
COPY test /

RUN /bin/bash
