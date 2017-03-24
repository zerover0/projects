### Mobius Yellow Turtle 서버를 Raspberry Pi에 설치하기

##### Mobius Yellow Turtle 설치 환경과 사용 소프트웨어

* 운영체제 : Raspbian Jessie Lite, 2016-02-26 릴리즈 이미지
* 사용 소프트웨어 버전
  - Mobius Yellow Turtle : 1.9.6
    - **[주의] Mobius Yellow Turtle 2.0 이상 버전의 속성들이 바뀐 것이 있는데 기존 문서나 코드와 호환이 되지 않고 있기때문에 당분간 2.0으로 업그레이드는 하지 않는 것이 좋습니다.**
  - MySQL 데이터베이스 서버 : 5.5 (Raspbian Jessie 기본 패키지 버전)
  - Mosquitto MQTT 서버 : 1.4.8 (MQTT broker 3.1)
    - Mosquitto 1.3 이하 버전에서는 WebSocket이 지원되지 않아서 Mobius와 Thyme이 연동할 수 없습니다.
  - Node.js : 4.4.1

##### MySQL 데이터베이스 서버 설치

1.MySQL을 설치합니다. 
```sh
$ sudo apt-get update 
$ sudo apt-get install -y mysql-server mysql-client 
$ mysql --version
mysql  Ver 14.14 Distrib 5.5.44, for debian-linux-gnu (armv7l) using readline 6.3
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
Enter password: (MySQL root 암호)
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

1.Mosquitto 릴리즈 저장소  정보를 업데이트합니다.
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

1.Node.js release 파일을 다운로드해서 압축을 풀고 디렉토리를 이동합니다.
  - BCM2835 ARM11 기반 모델 : Raspberry Pi Model A, B, B+ and Compute Module:
```sh
$ wget https://nodejs.org/dist/v4.4.1/node-v4.4.1-linux-armv6l.tar.gz 
$ tar -xvf node-v4.4.1-linux-armv6l.tar.gz 
$ cd node-v4.4.1-linux-armv6l
```
  - BCM2836 ARM Cortex-A7 기반 : Raspberry Pi 2 Model B:
```sh
$ wget https://nodejs.org/dist/v4.4.1/node-v4.4.1-linux-armv7l.tar.gz 
$ tar -xvf node-v4.4.1-linux-armv7l.tar.gz 
$ cd node-v4.4.1-linux-armv7l
```
  - BCM2837 ARM Cortex-A53 기반 : Raspberry Pi 3 Model B:
```sh
$ wget https://nodejs.org/dist/v4.4.1/node-v4.4.1-linux-arm64.tar.gz 
$ tar -xvf node-v4.4.1-linux-arm64.tar.gz 
$ cd node-v4.4.1-linux-arm64
```

2.모든 파일을 '/usr/local/'로 복사합니다.
```sh
$ sudo cp -R * /usr/local/
```

3.npm을 써서 native addons을 사용하려면 build-essential 패키지가 필요합니다.  
```sh
$ sudo apt-get install -y build-essential 
```

4.설치된 nodejs 버전을 확인합니다.
```sh
$ node -v
```

##### Mobius Yellow Turtle 서버 설치

1.Mobius Yellow Turtle release 파일을 다운로드해서 압축을 푼 후 Mobius Yellow Turtle에 필요한 node.js 모듈을 설치합니다. 
```sh
$ unzip Mobius_Yellow_Turtle_v1.9.6.zip -d ~/mobius/ 
$ cd ~/mobius 
$ npm install 
```

2.'conf.json' 파일을 서버 구성에 맞도록 수정합니다. 특히, MySQL 데이터베이스의 root 암호를 확인해서 수정합니다.

    "dbpass": "(MySQL root 암호)", 
    
3.Mobius Yellow Turtle 서버를 실행합니다. 
```sh
$ node app.js 
CPU Count: 1
CPU Count: 1
server (10.0.1.147) running at 7579 port
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
