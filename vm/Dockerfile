FROM centos:7

ARG auth_path="login"
ARG default_user="_admin"
ARG default_pass="_admin"
ARG default_port="8700"
ENV TZ=Asia/Jakarta
ENV PATH="$PATH:/www/server/panel/pyenv/bin"

COPY ./systemctl.py /usr/bin/system
COPY ./supervisord.conf /etc/supervisord.confctl
COPY ./install.sh /root/
COPY ./start.sh /root/
RUN chmod a+x /usr/bin/systemctl && chmod +x start.sh \
    && rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
    && yum -y install initscripts curl wget nmap telnet net-tools vim git top openssh-server cmake \
    && yum-complete-transaction --cleanup-only \
    && yum clean all && rm -rf /var/cache \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_dsa_key -N '' \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key -N '' \
    && (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN chmod +x /root/install.sh && bash /root/install.sh aapanel \
    && echo "/${auth_path}" > "/www/server/panel/data/admin_path.pl" \
    && yes ${default_user} | /etc/init.d/bt 6 \
    && yes ${default_pass} | /etc/init.d/bt 5 \
    && echo ${default_port} > /www/server/panel/data/port.pl \
    && sh /www/server/panel/install/install_soft.sh 1 install nginx "1.24" \
    && sh /www/server/panel/install/install_soft.sh 1 install php "81" \
    && /www/server/panel/pyenv/bin/pip install supervisor git+https://github.com/coderanger/supervisor-stdout \
    && yum-complete-transaction --cleanup-only \
    && yum clean all && rm -rf /var/cache \
    && /www/server/panel/pyenv/bin/pip cache purge \
    && rm -rf /root/.cache && rm -rf /tmp/pip* \
    && rm -rf /www/server/backup/* \
    && yes | /usr/bin/mv -f /www/server /www/server-base \
    && echo "www:${default_pass}" | chpasswd \
    && sed -i "s/\/www:\/sbin\/nologin/\/www:\/bin\/bash/" /etc/passwd
    
VOLUME ["/www/backup"]
VOLUME ["/www/server"]
VOLUME ["/www/wwwroot"]
VOLUME ["/www/wwwlogs"]

ENTRYPOINT ["/usr/sbin/init" ]
CMD ["/root/start.sh"]
