FROM debian:latest
MAINTAINER Pedro Azevedo "pedrocesar.ti@gmail.com"

RUN apt-get update
RUN apt-get install openssh-server -y
RUN apt-get install supervisor -y
RUN apt-get install openjdk-7-jdk -y
RUN apt-get install git-core -y

RUN echo "root:password" | chpasswd
RUN mkdir -p /home/jenkins
RUN useradd jenkins -d /home/jenkins
RUN chown -R jenkins:jenkins /home/jenkins
RUN echo "jenkins:jenkins" | chpasswd

RUN mkdir -p /var/run/sshd
RUN rm -rvf /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd

RUN mkdir -p /var/run/supervisord
ADD supervisord.conf /etc/supervisord.conf

EXPOSE 22
CMD ["/usr/bin/supervisord"]
