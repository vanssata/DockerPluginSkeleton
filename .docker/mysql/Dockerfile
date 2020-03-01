FROM mariadb:10.2.14

RUN chown -R mysql:mysql /var/lib/mysql/

ADD ./.docker/mysql/config/my.cnf /etc/mysql/my.cnf

USER mysql:mysql
CMD ["mysqld"]
