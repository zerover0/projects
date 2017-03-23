### Mobius Yellow Turtle 1.9.6 Ubuntu 14.04에 설치하기

##### Mobius Yellow Turtle 설치 환경과 사용 소프트웨어

* 운영체제 : Ubuntu 14.04.5 LTS x86 64-bit
* 사용 소프트웨어 버전
  - Mobius Yellow Turtle : 1.9.6
    - **[주의] Mobius Yellow Turtle 2.0 이상 버전의 속성들이 바뀐 것이 있는데 기존 문서나 코드와 호환이 되지 않고 있기때문에 당분간 2.0으로 업그레이드는 하지 않는 것이 좋습니다.**
  - MySQL 데이터베이스 서버 : 5.5 (Ubuntu 기본 패키지 버전)
  - Mosquitto MQTT 서버 : 1.4.x (MQTT 3.1)
    - Mosquitto 1.3 이하 버전에서는 WebSocket이 지원되지 않아서 Mobius 서버와 Thyme이 연동할 수 없습니다.
  - Node.js : 4.x.x

##### MySQL 데이터베이스 서버 설치

1.MySQL을 설치합니다. 
```sh
$ sudo apt-get update 
$ sudo apt-get install -y mysql-server mysql-client 
$ mysql --version
mysql  Ver 14.14 Distrib 5.5.47, for debian-linux-gnu (x86_64) using readline 6.3
```

2.MySQL 데이터베이스에 네트워크를 통해 외부 클라이언트가 접속할 수 있도록 설정합니다. 
```sh
$ sudo vi /etc/mysql/my.cnf 
#bind-address            = 127.0.0.1 
$ sudo service mysql restart 
```

3.'mobiusdb' 데이터베이스를  생성하고, 데이터베이스에 접속 권한을 부여합니다.
```sh
$ mysql –u root –p 
Enter password: tinyos 
mysql> create database mobiusdb; 
mysql> grant all on *.* to 'root'@'%' identified by 'tinyos'; 
mysql> flush privileges; 
```

4.'mobiusdb' 데이터베이스에 SQL script를 사용하여 테이블을 생성합니다. 
  - SQL script('Dump*.sql)는 OCEAN 사이트에 Yellow Turtle download 페이지에서 다운로드할 수 있습니다. 
  - SQL script는 Mobius 버전과 호환되는 버전을 사용해야 합니다.
```sh
$ mysql –u root -p 
mysql> use mobiusdb; 
mysql> source ./Dump20151113.sql; 
mysql> show tables; 
+--------------------+
| Tables_in_mobiusdb |
+--------------------+
| lv0                |
| lv1                |
| lv2                |
| lv3                |
| lv4                |
| lv5                |
| lv6                |
| lv7                |
| lv8                |
| lv9                |
+--------------------+
10 rows in set (0.01 sec)
```

##### Mosquitto MQTT 서버 설치

1.Mosquitto 릴리즈 저장소 정ㅂ를 업데이트합니다.
```sh
$ wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
$ sudo apt-key add mosquitto-repo.gpg.key
$ cd /etc/apt/sources.list.d/
$ sudo wget http://repo.mosquitto.org/debian/mosquitto-jessie.list
$ sudo apt-get update
```

2.Mosquitto MQTT 서버와 클라이언트를 설치합니다. 
```sh
$ sudo apt-get install -y mosquitto mosquitto-clients 
$ mosquitto -h
mosquitto version 1.4.8 (build date Sun, 14 Feb 2016 15:06:55 +0000)
mosquitto is an MQTT v3.1 broker.
```

##### Node.js 서버 설치

1.Node.js 릴리즈 저장소 정보를 업데이트합니다.
```sh
$ curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - 
```
  - 이때, curl 프로그램이 설치되어 있지 않다면, 다음 명령으로 설치합니다.
```sh
$ sudo apt-get install curl
```

2.Node.js를 설치합니다.
```sh
$ sudo apt-get install -y nodejs 
$ node -v
v4.4.1
```

3.npm을 써서 native addons을 사용하려면 build-essential 패키지가 필요합니다.  
```sh
$ sudo apt-get install -y build-essential 
```

4.설치가 성공했는지 확인하기 위해 테스트 스크립트를 실행합니다.
```sh
$ curl -sL https://deb.nodesource.com/test | bash -
```

##### Mobius Yellow Turtle 서버 설치

1.Mobius Yellow Turtle release 파일을 다운로드해서 압축을 푼 후 Mobius Yellow Turtle에 필요한 node.js 모듈을 설치합니다. 
```sh
$ unzip Mobius_Yellow_Turtle_v1.9.6.zip -d ~/mobius/ 
$ cd ~/mobius 
$ npm install 
```

2.'conf.json' 파일을 서버 구성에 맞도록 수정합니다. 특히, MySQL 데이터베이스의 root 암호를 확인해서 수정합니다.

    "dbpass": "tinyos", 

3.Mobius Yellow Turtle 서버를 실행합니다. 
```sh
$ node app.js 
CPU Count: 2
CPU Count: 2
CPU Count: 2
server (49.254.13.34) running at 7579 port
server (49.254.13.34) running at 7579 port
```

##### Mobius 에러 처리

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

2.MySQL root 암호 오류
```
query error: ER_ACCESS_DENIED_ERROR 
```
  - 해결책: Mobius Yellow Turtle 설치 폴더의 'conf.json' 파일에서 'dbpass' 항목에 지정된 데이터베이스 root 암호를 확인한 후, 정확한 root 암호를 저장합니다. 
