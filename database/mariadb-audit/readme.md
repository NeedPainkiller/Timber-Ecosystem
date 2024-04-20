# TIMBER-ECOSYSTEM-DATABASE-MARIADB-AUDIT

## MARIADB-AUDIT
- 감사로그 저장을 위한 Achive 엔진 Mariadb

### Dockerfile
```Dockerfile
FROM mariadb:11.3.2-jammy

COPY my.cnf /etc/mysql/my.cnf

CMD ["mysqld", "--ignore-db-dir=lost+found"]
```

### my.cnf
```my.cnt
[mysqld]
default_storage_engine=ARCHIVE
```

### 빌드 
```bash
docker build -t mariadb-audit .
```

### archive 엔진 설치
```Bash
# docker exec 로 접속 한 뒤 아래 명령어 실행
## root 로 접속
mariadb -uroot -p

## archive 엔진 설치
INSTALL SONAME 'ha_archive';
show engines \G

## 테이블 생성
CREATE TABLE audit_log
(
    `_ID`                 bigint AUTO_INCREMENT                                    NOT NULL,
    TENANT_PK             bigint                                      DEFAULT NULL NULL,
    VISIBLE_YN            int                                         DEFAULT 1    NOT NULL,
    HTTP_STATUS           int                                         DEFAULT 0    NULL,
    HTTP_METHOD           tinyint unsigned                                     DEFAULT 0    NULL,
    AGENT_OS              nvarchar(64)   DEFAULT NULL NULL,
    AGENT_OS_VERSION      nvarchar(16)   DEFAULT NULL NULL,
    AGENT_BROWSER         nvarchar(64)   DEFAULT NULL NULL,
    AGENT_BROWSER_VERSION nvarchar(16)   DEFAULT NULL NULL,
    AGENT_DEVICE          nvarchar(128)  DEFAULT NULL NULL,
    REQUEST_URI           nvarchar(256)  DEFAULT NULL NULL,
    REQUEST_IP            numeric(20, 0)                              DEFAULT 0    NULL,
    REQUEST_CONTENT_TYPE  nvarchar(1024) DEFAULT NULL NULL,
    REQUEST_PAYLOAD       longtext  DEFAULT NULL NULL,
    RESPONSE_CONTENT_TYPE nvarchar(32)   DEFAULT NULL NULL,
    RESPONSE_PAYLOAD      longtext  DEFAULT NULL NULL,
    CREATED_DATE          DATETIME                                             NOT NULL,
    USER_PK               bigint                                      DEFAULT NULL NULL,
    USER_ID               nvarchar(128)  DEFAULT NULL NULL,
    USER_EMAIL            nvarchar(128)  DEFAULT NULL NULL,
    USER_NAME             nvarchar(64)   DEFAULT NULL NULL,
    TEAM_PK               bigint                                      DEFAULT NULL NULL,
    TEAM_NAME             nvarchar(128)               NULL,
    MENU_UID              bigint                                      DEFAULT NULL NULL,
    MENU_NAME             nvarchar(128)               NULL,
    API_UID               bigint                                      DEFAULT NULL NULL,
    API_NAME              nvarchar(256)  DEFAULT NULL NULL,
    ERROR_DATA            longtext  DEFAULT NULL NULL,
    CONSTRAINT PK_audit_log__ID PRIMARY KEY (`_ID`)
) ENGINE=Archive DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


# DB 내 테이블 엔진 홛인
SELECT TABLE_NAME,        ENGINE FROM   information_schema.TABLES WHERE  TABLE_SCHEMA = 'timber-audit';
+------------+---------+
| TABLE_NAME | ENGINE  |
+------------+---------+
| audit_log  | ARCHIVE |
+------------+---------+
1 row in set (0.001 sec)

```
