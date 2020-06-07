FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:cartoon' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile






RUN  apt-get install openjdk-8-jre -y
RUN apt-get install curl -y

COPY .kube /root/.kube
COPY ca.crt /root/ca.crt
COPY client.crt /root/client.crt
COPY client.key /root/client.key


RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl 

	
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/bin/kubectl

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


