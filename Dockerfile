FROM centos

RUN yum install -y epel-release 
RUN yum update -y
RUN yum install -y nginx
RUN yum install -y createrepo
EXPOSE 80
#ENTRYPOINT ["/usr/sbin/nginx","-g","daemon off;"]

ADD root /

# forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /usr/src/app

COPY svcrepo.sh /usr/src/app/

COPY nginx.conf /etc/nginx/nginx.conf
COPY repo/ /usr/share/nginx/html/repo/
RUN createrepo /usr/share/nginx/html/repo
CMD ["bash","/usr/src/app/svcrepo.sh"]
