FROM openjdk:8-slim
# Jenkins slave piece.
ARG user=jenkins
ARG group=jenkins
ARG uid=10000
ARG gid=10000

ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}

LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="3.23"

ARG VERSION=3.26
ARG AGENT_WORKDIR=/home/${user}/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar
RUN chmod 755 /usr/share/jenkins
RUN chmod 644 /usr/share/jenkins/slave.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod +x /usr/local/bin/jenkins-slave

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

#Chrome and Nodejs piece.
RUN apt-get update && apt-get install -y wget curl build-essential git
# left over command.
# curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get update

RUN apt-get install -y nodejs google-chrome-stable
RUN mkdir /tests
RUN npm i -g yarn

USER ${user}
ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
