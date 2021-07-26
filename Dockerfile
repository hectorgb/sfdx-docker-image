# node > 14.6.0 is required for the SFDX-Git-Delta plugin
FROM node:latest

RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install default-jdk git findutils bash curl wget openssh-client perl jq && \
    apt clean;
    
RUN export JAVA_HOME

RUN npm install sfdx-cli --global
RUN sfdx --version

ENV SFDX_AUTOUPDATE_DISABLE=true
ENV SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
ENV SFDX_DOMAIN_RETRY=300
ENV SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_CREATE=true
ENV SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_VERSION_CREATE=true
ENV SFDX_DISABLE_SOURCE_MEMBER_POLLING=true

RUN npm install sfdc-merge-package --global
RUN smp --version

RUN npm install -g sfdc-specified-test
RUN sst --version

RUN echo y | sfdx plugins:install sfdx-git-delta
RUN sfdx plugins

RUN echo y | sfdx plugins:install texei-sfdx-plugin @salesforce/sfdx-scanner
RUN sfdx plugins
