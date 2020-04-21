FROM jenkins/jenkins:lts
USER root
RUN add-apt-repository main \
    add-apt-repository universe  \
    add-apt-repository restricted \
    add-apt-repository multiverse \
    apt-get update && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    apt-get update && \
    apt-get install docker-engine -y
RUN groupadd docker \
    usermod -a -G docker jenkins \
    -s jenkins \
    chmod 664 /var/run/docker.sock \
    systemctl restart docker \
    systemctl restart jenkins.service
USER jenkins
