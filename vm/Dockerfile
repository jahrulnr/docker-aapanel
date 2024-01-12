FROM centos:7

ARG auth_path="login"
ARG default_user="_admin"
ARG default_pass="_admin"
ARG default_port="8700"
ENV TZ=Asia/Jakarta

# enable systemctl & service command
COPY systemctl.py /usr/bin/systemctl
RUN chmod a+x /usr/bin/systemctl
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum -y install initscripts curl wget nmap telnet net-tools vim git top openssh-server cmake
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
RUN /www/server/panel/pyenv/bin/pip cache purge

RUN yes | /usr/bin/mv -f /www/server /www/server-base
ENV PATH="$PATH:/www/server/panel/pyenv/bin"
COPY ./supervisord.conf /etc/supervisord.conf

RUN echo "www:${default_pass}" | chpasswd
RUN sed -i "s/\/www:\/sbin\/nologin/\/www:\/bin\/bash/" /etc/passwd
RUN yum-complete-transaction --cleanup-only
RUN yum clean all

COPY ./start.sh ./
RUN chmod +x start.sh
VOLUME ["/www/backup"]
VOLUME ["/www/server"]
VOLUME ["/www/wwwroot"]
VOLUME ["/www/wwwlogs"]

ENTRYPOINT ["/usr/sbin/init" ]
CMD ["/root/start.sh"]
