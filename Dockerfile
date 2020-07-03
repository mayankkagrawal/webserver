FROM ubuntu:16.04
RUN apt-get update && apt-get install -y openssh-server && apt-get install openjdk-8-jre -y
RUN apt-get install sudo git jq  -y
RUN rm -rf /var/run/sshd
RUN mkdir /var/run/sshd
RUN echo 'root:redhat' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN apt-get install curl -y
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN mkdir /root/.kube
ADD kube /root/
COPY config /root/.kube/config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

