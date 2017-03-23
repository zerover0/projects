# Mobius Yellow Turtle 2.3.4를 Ubuntu 14.04에 설치하기

### Mobius Yellow Turtle 설치 환경과 사용 소프트웨어

* 운영체제 : Ubuntu 14.04.5 LTS x86 64-bit
* 사용 소프트웨어 버전
  - Mobius Yellow Turtle : 2.3.4
  - MariaDB 데이터베이스 서버 : 10.1.x (MySQL 5.7 호환)
  - Mosquitto MQTT 서버 : 1.4.x (MQTT 3.1)
    - Mosquitto 1.3 이하 버전에서는 WebSocket이 지원되지 않아서 Mobius 서버와 Thyme이 연동할 수 없습니다.
  - Node.js : 6.x.x

### MariaDB 데이터베이스 서버 설치

1.MariaDB을 설치합니다. 
```sh
$ sudo apt-get install software-properties-common
$ sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
$ sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.kaist.ac.kr/mariadb/repo/10.1/ubuntu trusty main'
$ sudo apt-get update
$ sudo apt-get install -y mariadb-server
$ mysql --version
mysql  Ver 15.1 Distrib 10.1.22-MariaDB, for debian-linux-gnu (x86_64) using readline 5.2
```

2.MariaDB 데이터베이스에 네트워크를 통해 외부 클라이언트가 접속할 수 있도록 설정합니다. 
- file: /etc/mysql/my.cnf 
```
#bind-address            = 127.0.0.1 
```

3.MariaDB 서비스를 재시작합니다.
```sh
$ sudo service mysql restart 
```

4.'mobiusdb' 데이터베이스를  생성하고, 데이터베이스에 접속 권한을 부여합니다.
```sh
$ mysql –u root –p 
Enter password: (root 암호)
MariaDB [(none)]> create database mobiusdb;
Query OK, 1 row affected (0.00 sec)
MariaDB [(none)]> grant all on *.* to 'root'@'%' identified by 'starone';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> flush privileges;
Query OK, 0 rows affected (0.00 sec)
```

5.'mobiusdb' 데이터베이스에 SQL script를 사용하여 테이블을 생성합니다. 
  - SQL script(*.sql)는 OCEAN 사이트에 Yellow Turtle 다운로드 사이트에서 다운로드할 수 있습니다. 
  - SQL script는 Mobius 버전과 호환되는 버전을 사용해야 합니다.
```sh
$ MariaDB –u root -p 
MariaDB [(none)]> use mobiusdb;
Database changed
MariaDB [mobiusdb]> source mobiusdb.sql
MariaDB [mobiusdb]> show tables;
+--------------------+
| Tables_in_mobiusdb |
+--------------------+
| acp                |
| ae                 |
| cb                 |
| cin                |
| cnt                |
| csr                |
| grp                |
| lcp                |
| lookup             |
| mms                |
| req                |
| sd                 |
| sri                |
| sub                |
| ts                 |
| tsi                |
+--------------------+
16 rows in set (0.01 sec)
```

### Mosquitto MQTT 서버 설치

1.Mosquitto 릴리즈 저장소 정보를 업데이트합니다.
```sh
$ sudo apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
$ sudo apt-get update
```

2.Mosquitto MQTT 서버와 클라이언트를 설치합니다. 
```sh
$ sudo apt-get install -y mosquitto mosquitto-clients 
$ mosquitto -h
mosquitto version 1.4.11 (build date Fri, 03 Mar 2017 15:11:39 +0000)
mosquitto is an MQTT v3.1.1/v3.1 broker.
```

3.두 개의 콘솔 창을 열어서 Mosquitto MQTT 서비스를 시험한다.
```sh
$ mosquitto_sub -h localhost -t /mytopic/1
$ mosquitto_pub -h localhost -t /mytopic/1 -m "Hello MQTT"
```

### Node.js 서버 설치

1.Node.js 릴리즈 저장소 정보를 업데이트합니다.
```sh
$ curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - 
```

2.Node.js를 설치합니다.
```sh
$ sudo apt-get install -y nodejs 
$ node -v
v6.9.1
```

3.npm을 써서 native addons을 사용하려면 build-essential 패키지가 필요합니다.  
```sh
$ sudo apt-get install -y build-essential 
```

4.설치가 성공했는지 확인하기 위해 테스트 스크립트를 실행합니다.
```sh
$ curl -sL https://deb.nodesource.com/test | bash -
```

### Mobius Yellow Turtle 설치

1.Mobius Yellow Turtle release 파일을 OCEAN 다운로드 사이트에서 다운로드해서 압축을 풉니다.
  - 다운로드 사이트 : http://iotocean.org/download/
```sh
$ unzip mobius-yt-v2.3.4.zip -d ~/mobius/ 
$ cd ~/mobius 
```

2.Mobius Yellow Turtle에 필요한 node.js 모듈 패키지들을 설치합니다. 
```sh
$ npm install 
```

2.'conf.json' 파일을 서버 구성에 맞도록 수정합니다. 특히, MariaDB 데이터베이스의 root 암호를 확인해서 수정합니다.
- file : conf.json
```
    "dbpass": "(root 암호)", 
```

3.Mobius Yellow Turtle 서버를 실행합니다. 
```sh
$ node mobius.js
select_ri_lookup /mobius-yt: 22.245ms
insert_lookup /mobius-yt: 3.989ms
insert_cb /mobius-yt: 5.804ms
""
CPU Count: 20
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 28.268ms
update_cb_poa_csi /mobius-yt: 3.470ms
""
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 27.949ms
select_ri_lookup /mobius-yt: 26.373ms
select_ri_lookup /mobius-yt: 27.667ms
select_ri_lookup /mobius-yt: 23.585ms
update_cb_poa_csi /mobius-yt: 3.275ms
update_cb_poa_csi /mobius-yt: 3.183ms
""
""
update_cb_poa_csi /mobius-yt: 3.093ms
mobius server (10.0.0.188) running at 7579 port
""
update_cb_poa_csi /mobius-yt: 2.927ms
""
select_ri_lookup /mobius-yt: 31.697ms
select_ri_lookup /mobius-yt: 28.186ms
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 42.561ms
mobius server (10.0.0.188) running at 7579 port
update_cb_poa_csi /mobius-yt: 2.177ms
""
update_cb_poa_csi /mobius-yt: 2.882ms
""
update_cb_poa_csi /mobius-yt: 2.980ms
""
select_ri_lookup /mobius-yt: 24.382ms
update_cb_poa_csi /mobius-yt: 2.491ms
""
mobius server (10.0.0.188) running at 7579 port
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 19.822ms
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 27.275ms
select_ri_lookup /mobius-yt: 18.025ms
update_cb_poa_csi /mobius-yt: 2.188ms
""
mobius server (10.0.0.188) running at 7579 port
update_cb_poa_csi /mobius-yt: 2.879ms
""
update_cb_poa_csi /mobius-yt: 2.139ms
""
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 26.918ms
select_ri_lookup /mobius-yt: 17.335ms
update_cb_poa_csi /mobius-yt: 3.195ms
""
update_cb_poa_csi /mobius-yt: 2.173ms
""
select_ri_lookup /mobius-yt: 17.198ms
update_cb_poa_csi /mobius-yt: 2.281ms
""
select_ri_lookup /mobius-yt: 17.904ms
update_cb_poa_csi /mobius-yt: 2.097ms
""
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 26.794ms
update_cb_poa_csi /mobius-yt: 2.774ms
""
mobius server (10.0.0.188) running at 7579 port
select_ri_lookup /mobius-yt: 24.464ms
update_cb_poa_csi /mobius-yt: 2.104ms
""
select_ri_lookup /mobius-yt: 15.528ms
update_cb_poa_csi /mobius-yt: 2.099ms
""
select_ri_lookup /mobius-yt: 15.257ms
update_cb_poa_csi /mobius-yt: 2.108ms
""
pxymqtt server (10.0.0.188) running at 7580 port
-----> [pxy_coap]

X-M2M-Origin: /mobius-yt
X-M2M-Origin: /mobius-yt
select_direct /mobius-yt (rkvhC-bhg): 1.824ms
select_direct /mobius-yt (Bkw2RZb3l): 1.464ms
select_resource cb /mobius-yt (Bk-DhAW-ne): 1.163ms
resource_retrieve /mobius-yt (Sklw20WW3l): 1.599ms
select_resource cb /mobius-yt (ry-vhAbZhx): 1.019ms
resource_retrieve /mobius-yt (HkeDnRbWne): 1.541ms
""
""
<----- [pxy_coap]
{"m2m:cb":{"ty":5,"ct":"20170323T090027","ri":"rJ7nAWbhe","rn":"mobius-yt","lt":"20170323T090027","et":"20270323T090027","lbl":["mobius-yt"],"cst":1,"csi":"/mobius-yt","srt":["1","2","3","4","9","10","16","17","23","24","29","30"],"poa":["http://10.0.0.188:7579"]}}
[pxy_coap] coap ready
subscribe req_topic as /oneM2M/req/+/mobius-yt/#
subscribe reg_req_topic as /oneM2M/reg_req/+/mobius-yt/#
subscribe resp_topic as /oneM2M/resp/mobius-yt/#
ts_missing agent server (10.0.0.188) running at 7582 port
X-M2M-Origin: /mobius-yt
select_direct /mobius-yt (BJK2RZZ3g): 2.603ms
search_parents_lookup /mobius-yt: 1.693ms
search_lookup (BJgK3C-W2l): 96.581ms
""
init_TS - 4004
```

### Mobius 에러 처리

1.Node.js 버전 호환 오류
```
net.js:1124 
      throw new Error('Invalid listen argument: ' + h); 
Error: Invalid listen argument: [object Object] 
    at Server.listen (net.js:1124:13) 
    at request.headers.nmtype (/home/hans/mobius/app.js:166:36) 
    at fs.js:268:14 
    at Object.oncomplete (fs.js:107:15) 
```
  - 해결책: node.js version을 확인한 후, node.js 4.0 이상으로 업그레이드합니다. 0.12.x 이하 버전에서는 에러가 납니다.

2.MariaDB root 암호 오류
```
query error: ER_ACCESS_DENIED_ERROR 
```
  - 해결책: Mobius Yellow Turtle 설치 폴더의 'conf.json' 파일에서 'dbpass' 항목에 지정된 데이터베이스 root 암호를 확인한 후, 정확한 root 암호를 저장합니다. 
