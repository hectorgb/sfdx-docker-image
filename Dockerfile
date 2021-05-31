# node > 14.6.0 is required for the SFDX-Git-Delta plugin
FROM node:latest

#add usefull tools
# RUN apk add --update --no-cache  \
#       git \
#       findutils \
#       bash \
#       unzip \
#       curl \
#       wget \
#       nodejs-npm \
#       java-cacerts \
#       openssh-client \
#       perl \
#       jq 


RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install default-jdk git findutils bash curl wget nodejs openssh-client perl jq && \
    apt install -y ant && \
    apt clean;

# RUN apt update && \
#     apt install ca-certificates-java && \
#     apt clean && \
#     update-ca-certificates -f;

ENV SFDX_AUTOUPDATE_DISABLE=true
ENV SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
ENV SFDX_DOMAIN_RETRY=300
ENV SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_CREATE=true
ENV SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_VERSION_CREATE=true
ENV SFDX_DISABLE_SOURCE_MEMBER_POLLING=true
# ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN export JAVA_HOME

RUN npm install sfdc-merge-package --global
RUN smp --version

# install Salesforce CLI from npm
RUN npm install sfdx-cli --global
RUN sfdx --version

# install SFDX-Git-Delta plugin - https://github.com/scolladon/sfdx-git-delta
RUN echo y | sfdx plugins:install sfdx-git-delta
RUN sfdx plugins

RUN echo y | sfdx plugins:install texei-sfdx-plugin @salesforce/sfdx-scanner
RUN sfdx plugins

# legacy way to install SFDX-Git-Delta, if you still want to use the sgd command (not needed if you use the Salesforce CLI extension)
RUN npm install sfdx-git-delta@latest --global
RUN sgd --version