# TIMBER-ECOSYSTEM-DATABASE-MARIADB
https://sesamedisk.com/mysql-cluster-deploy-galera-with-mariadb-proxysql/
https://engmisankim.tistory.com/64

## Galera Cluster
- 클러스터 실행 후 timber-db-mariadb-1 의 --wsrep-new-cluster 옵션을 주석처리해야 재시작 이슈 없음



## ProxySQL
- 컨테이너 접속
```Bash
docker exec -it [proxysql container id] bash
```

- proxysql 접근
```Bash
 mysql -uadmin -padminpassword -h 127.0.0.1 -P6032 --prompt='ProxySQL Admin> ' 
```

- 조회
```Bash
# 기존 테이블 내용 확인
SELECT * FROM mysql_servers; 
```

- 등록
```Bash
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (1, 'timber-db-mariadb-1', 3306);
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (1, 'timber-db-mariadb-2', 3306);
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (1, 'timber-db-mariadb-3', 3306);

SELECT * FROM mysql_servers;

# 업데이트
LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;
```
