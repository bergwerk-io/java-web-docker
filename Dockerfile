FROM ubuntu:14.04

# set locales
RUN locale-gen de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LC_CTYPE de_DE.UTF-8

# fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install dependencies
RUN apt-get update && \
 apt-get install -y git build-essential curl wget software-properties-common

# install jdk 8
RUN sudo apt-get install -y wget unzip tar

# install jdk 8
RUN wget https://s3.eu-central-1.amazonaws.com/bemer-shared-libs/jdk-8u161-linux-x64.tar.gz -O /opt/jdk.tar.gz
RUN tar xzf /opt/jdk.tar.gz && rm /opt/jdk.tar.gz && mv /jdk* /opt/jdk
ENV JAVA_HOME /opt/jdk

# install tomcat 8
RUN wget https://s3.eu-central-1.amazonaws.com/bemer-shared-libs/apache-tomcat-8.5.9.tar.gz -O /tmp/tomcat.tgz
RUN tar xzvf /tmp/tomcat.tgz -C /opt && \
  mv /opt/apache-tomcat-* /opt/tomcat && \
  rm /tmp/tomcat.tgz && \
  rm -rf /opt/tomcat/webapps/examples && \
  rm -rf /opt/tomcat/webapps/docs && \
  rm -rf /opt/tomcat/webapps/ROOT
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

# install nginx
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  chown -R www-data:www-data /var/lib/nginx
