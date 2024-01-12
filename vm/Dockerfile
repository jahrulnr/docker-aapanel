FROM centos:centos7

ARG auth_path="login"
ARG default_user="_admin"
ARG default_pass="_admin"
ARG default_port="8700"

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum -y install curl wget nmap telnet net-tools vim git top openssh-server cmake
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_dsa_key -N ''
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key -N ''

WORKDIR /root/

COPY ./install.sh ./
RUN chmod +x install.sh
RUN bash /root/install.sh aapanel
RUN echo "/${auth_path}" > "/www/server/panel/data/admin_path.pl" && \
    yes ${default_user} | /etc/init.d/bt 6 && \
    yes ${default_pass} | /etc/init.d/bt 5 && \
    echo ${default_port} > /www/server/panel/data/port.pl
RUN /www/server/panel/pyenv/bin/pip install supervisor git+https://github.com/coderanger/supervisor-stdout

RUN sh /www/server/panel/install/install_soft.sh 1 install nginx "1.24"
RUN sh /www/server/panel/install/install_soft.sh 1 install php "81"

RUN yes | cp -rf /etc/init.d /tmp/init.d
RUN yes | cp -rf /www/server /www/server-base
RUN echo 'export PATH="$PATH:/www/server/panel/pyenv/bin"' >> ~/.bashrc
COPY ./supervisord.conf /etc/supervisord.conf

#RUN adduser --system --group root www
RUN echo "www:${default_pass}" | chpasswd
#RUN sed -i "s/::\/home\/www/:root:\/www/" /etc/passwd
RUN sed -i "s/\/www:\/sbin\/nologin/\/www:\/bin\/bash/" /etc/passwd

COPY ./start.sh ./
RUN chmod +x start.sh

RUN yum clean packages
RUN yum clean metadata
RUN yum clean headers
RUN yum clean all

VOLUME ["./data/vm/backup", "/www/backup"]
VOLUME ["./data/vm/server", "/www/server"]
VOLUME ["./data/vm/wwwroot", "/www/wwwroot"]
VOLUME ["./data/system_log", "/var/log/"]
VOLUME ["./data/vm_log", "/www/wwwlogs"]
VOLUME ["./storage", "/storage"]

CMD ["/bin/sh", "/root/start.sh"]
