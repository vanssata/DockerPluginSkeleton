FROM mariadb:10.2.14

RUN chown -R mysql:root /var/lib/mysql/

ADD ./.docker/mysql/config/my.cnf /etc/mysql/my.cnf

USER mysql
CMD ["mysqld"]
