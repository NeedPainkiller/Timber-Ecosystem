FROM mariadb:11.3.2-jammy

COPY my.cnf /etc/mysql/my.cnf

CMD ["mysqld", "--ignore-db-dir=lost+found"]
