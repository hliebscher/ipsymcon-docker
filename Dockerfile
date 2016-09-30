# -----------------------------------------------------------------------------
# tommi2day/symcon
#
# VERSION=testing; docker build -f Dockerfile -t tommi2day/symcon:$VERSION --build-arg VERSION=$VERSION.
#
# Based on Dockerfile from Dieter Poessling (https://www.symcon.de/forum/threads/26294-IP-Symcon-via-Docker-Engine?p=259037#post259037)
# -----------------------------------------------------------------------------

FROM ubuntu:16.04


# Skip install dialogues
ENV DEBIAN_FRONTEND noninteractive
# Set Home-Directory
ENV HOME /root

ARG VERSION

RUN \
    apt-get update && apt-get -y upgrade && apt-get -y install wget
    
RUN \
    if [ -z "$VERSION" ]; then VERSION="stable"; fi && \
    wget -qO - http://apt.ip-symcon.de/symcon.key | apt-key add - && \
    echo "deb [arch=amd64] http://apt.ip-symcon.de/ $VERSION ubuntu" >> /etc/apt/sources.list && \
    apt-get update && apt-get -y install symcon 

#default configurarition
COPY .symcon /root/
RUN \
    cp -r /usr/share/symcon /usr/share/symcon.org &&\
    cp -r /root /root.org
    
#Clean-Up    
RUN \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
    
#Setup locale
#Change to your location
RUN \
    locale-gen de_DE.UTF-8 &&\
    locale-gen en_US.UTF-8 &&\
    dpkg-reconfigure locales

#Setup timezone
#Change for your timezone
RUN echo "Europe/Berlin" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

COPY ["docker_entrypoint.sh","set_password.sh","/usr/bin/"]
RUN \
    chmod 700 /usr/bin/docker_entrypoint.sh /usr/bin/set_password.sh && chmod 644 /root/.symcon

VOLUME \
    /root \
    /var/log/symcon \
    /var/lib/symcon

EXPOSE  3777 82
WORKDIR /root
ENTRYPOINT ["/usr/bin/docker_entrypoint.sh"]

