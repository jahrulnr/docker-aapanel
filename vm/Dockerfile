FROM centos:centos7.9.2009

ARG auth_path="login"
ARG default_user="_admin"
ARG default_pass="_admin"
ARG default_port="8700"

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum -y install curl wget nmap telnet net-tools vim git

WORKDIR /root/
COPY ./install.sh ./
COPY ./start.sh ./
RUN chmod +x install.sh start.sh
RUN bash /root/install.sh aapanel
RUN echo "/${auth_path}" > "/www/server/panel/data/admin_path.pl" && \
    yes ${default_user} | /etc/init.d/bt 6 && \
    yes ${default_pass} | /etc/init.d/bt 5 && \
    echo ${default_port} > /www/server/panel/data/port.pl

ENTRYPOINT ["/root/start.sh"]
# CMD ["/etc/init.d/bt", "3"]
