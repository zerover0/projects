### Raspberry Pi에 OpenTSDB 설치와 분산환경 구성 안내

##### 설치 환경
* 하드웨어: Raspberry Pi 1 Model B+
* 운영체제: Raspbian Jessie Lite, 2016-03-18 release
* 사용 소프트웨어 버전
  - Oracle JDK 1.7
  - GnuPlot 4.6
  - Hadoop 2.6.4
  - ZooKeeper 3.4.8
  - HBase 1.1.4
  - OpenTSDB 2.2.0

##### 호스트 구성
* 호스트이름과 IP 주소 구성
  - server01 : 192.168.0.211
  - server01 : 192.168.0.212
  - server01 : 192.168.0.213
* 호스트별 서버 구성
  - server01 : Master 노드, Hadoop NameNode/SecondaryNameNode/DataNode, YARN ResourceManager/NodeManager, HBase Master/RegionServer, ZooKeeper, OpenTSDB
  - server02 : Slave 노드, Hadoop DataNode, YARN NodeManager, HBase backup Master/RegionServer, ZooKeeper
  - server03 : Slave 노드, Hadoop DataNode, YARN NodeManager, HBase RegionServer, ZooKeeper

##### JDK(Java Development Kit) 설치하기
Hadoop, HBase, ZooKeeper, OpenTSDB 등 서버들이 모두 Java 기반으로 개발되어 있어서 실행할 때 JDK(혹은 JRE)가 필요합니다. Open JDK는 Oracle JDK보다 성능이 떨어지고 설치할 프로그램들과 알 수 없는 버그를 만들기때문에 Oracle JDK를 사용한다.

1.JDK 설치 여부를 확인하고, Open JDK가 설치되어 있다면 제거한다.
```sh
java version "1.6.0_38"
OpenJDK Runtime Environment (IcedTea6 1.13.10) (6b38-1.13.10-1~deb7u1+rpi1)
OpenJDK Zero VM (build 23.25-b01, mixed mode)
$ sudo apt-get purge openjdk*
$ sudo apt-get autoremove
```

2.JDK가 설치되어 있지 않다면, Oracle JDK를 설치한다.
```sh
$ sudo apt-get update
$ sudo apt-get install oracle-java7-jdk
```

3.JDK 버전을 확인한다.
```sh
$ java -version
java version "1.7.0_60"
Java(TM) SE Runtime Environment (build 1.7.0_60-b19)
Java HotSpot(TM) Client VM (build 24.60-b09, mixed mode)
```

4.편의를 위해서 Oracle JDK 디렉토리를 'default-java'로 링크한다.
```sh
$ sudo ln -s /usr/lib/jvm/jdk-7-oracle-arm-vfp-hflt /usr/lib/jvm/default-java
```

##### GnuPlot 설치하기
OpenTSDB에서 그래프 그릴 때 사용됩니다.

1.패키지 설치 명령으로 GnuPlot을 설치합니다.
```sh
$ sudo apt-get update 
$ sudo apt-get install gnuplot 
```

##### Hadoop 설치하기

* 아래 링크의 문서를 따라서 Hadoop을 설치한다.
  - Ubuntu Server 14.04에 Hadoop 설치하기
    - https://github.com/zerover0/projects/blob/master/hadoop/hadoop_install_on_ubuntu.md
  - Raspberry Pi에 Hadoop 설치하기
    - https://github.com/zerover0/projects/blob/master/hadoop/hadoop_install_on_rpi.md

##### ZooKeeper 설치하기
ZooKeeper는 분산 서버들 간에 조정자 역할을 해주는데, HBase가 분산 환경에서 작동할 때 필요합니다.

1.Telnet으로 ZooKeeper 서버의 동작여부 확인이 가능합니다. Telnet 연결이 거부되거나 바로 끊어지지 않으면 'stat' 명령을 입력해서 ZooKeeper 서버 응답을 받을 수 있습니다.
```sh
$ telnet localhost 2181
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
stat
Zookeeper version: 3.4.6-1569965, built on 02/20/2014 09:09 GMT
Clients:
 /127.0.0.1:38470[1](queued=0,recved=124288,sent=124288)
```

2.ZooKeeper가 설치되어 있지 않다면, 패키지 설치 명령으로 ZooKeeper 릴리즈와 환경설정 파일 패키지를 설치합니다.
```sh
$ sudo apt-get update 
$ sudo apt-get install zookeeper zookeeperd 
```

3.ZooKeeper를 성공적으로 설치하면, 부팅할 때 ZooKeeper 서버는 자동으로 실행되고, 기본 환경설정 파일인 '/etc/zookeeper/conf/zoo.cfg'에 ZooKeeper 데이터 디렉토리는 '/var/lib/zookeeper'로 기본 설정됩니다. 
```
dataDir=/var/lib/zookeeper
clientPort=2181
```

##### HBase 분산환경에서 설치하기

1.다음 주소에서 HBase 릴리즈 파일을 다운로드합니다.
  - http://apache.mirror.cdnetworks.com/hbase/stable/hbase-1.1.4-bin.tar.gz

2.다운로드한 HBase 릴리즈 파일의 압축을 푼 후, 새로 생성된 디렉토리를 '/usr/local/hbase'라는 이름으로 변경해서 이동합니다.
```sh
$ tar xzvf hbase-1.1.3-bin.tar.gz 
$ sudo mv hbase-1.1.3 /usr/local/hbase
```

3.'/usr/local/hbase/conf/hbase-env.sh' 스크립트 파일에 Java 홈 디렉토리와 로그 디렉토리를 다음과 같이 지정합니다.
```sh
export JAVA_HOME=/usr/java/jdk1.8/
export HBASE_LOG_DIR=/tmp/hbase/logs 
```

4.'/usr/local/hbase/conf/hbase-site.xml' 파일에 rootdir 설정과 ZooKeeper 데이터 디렉토리를 설정합니다.</br>
다음 설정은 로컬 파일시스템을 이용한 HBase 설정의 예입니다.
```
<configuration> 
  <property> 
    <name>hbase.rootdir</name> 
    <value>file:///usr/local/hbase</value> 
  </property> 
  <property> 
    <name>hbase.zookeeper.property.dataDir</name> 
    <value>/var/lib/zookeeper</value> 
  </property> 
</configuration> 
```
5.다음 명령을 실행해서 HBase 서버를 실행합니다.
```sh
$ /usr/local/hbase/bin/start-hbase.sh
```

6.HBase 서버를 실행해서 에러가 없으면, 부팅시 자동으로 실행되도록 '/etc/rc.local' 파일에 다음 내용을 추가합니다.
```sh
$sudo vi /etc/rc.local
/usr/local/hbase/bin/start-hbase.sh
```

##### OpenTSDB 설치하기

1.다음 주소에서 OpenTSDB의 릴리즈 파일을 다운로드합니다.
  - https://github.com/OpenTSDB/opentsdb/releases

2.다운로드한 파일의 압축을 푼 후, 빌드하고 설치합니다.
```sh
$ tar xzf opentsdb-2.2.0.tar.gz -C ~/
$ cd ~/opentsdb-2.2.0
$ ./build.sh
$ cd build
$ sudo make install
```

3.OpenTSDB 프로그램은 '/usr/local/share/opentsdb/' 디렉토리에 설치됩니다. 환경설정 파일인 'opentsdb.conf'을 열어서 필요한 옵션을 설정하고 저장합니다.
  - tsd.core.auto_create_metrics : true = 레코드의 metric이 데이터베이스에 존재하지 않을 때, 자동으로 metric 추가
```sh
$ sudo vi /usr/local/share/opentsdb/etc/opentsdb/opentsdb.conf
tsd.core.auto_create_metrics = true
```

4.OpenTSDB를 설치한 후, 최초로 한번 데이터베이스 테이블을 구성하는 명령을 실행해야 합니다.
```sh
$ export JAVA_HOME=/usr/lib/jvm/default-java
$ export HBASE_HOME=/usr/local/hbase 
$ export COMPRESSION=NONE 
$ /usr/share/opentsdb/tools/create_table.sh
2016-04-15 11:24:19,339 WARN  [main] util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 1.1.4, r14c0e77956f9bb4c6edf0378474264843e4a82c3, Wed Mar 16 21:18:26 PDT 2016

create 'tsdb-uid',
  {NAME => 'id', COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
  {NAME => 'name', COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
0 row(s) in 2.3620 seconds

Hbase::Table - tsdb-uid

create 'tsdb',
  {NAME => 't', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
0 row(s) in 1.3680 seconds

Hbase::Table - tsdb
  
create 'tsdb-tree',
  {NAME => 't', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
0 row(s) in 1.3270 seconds

Hbase::Table - tsdb-tree
  
create 'tsdb-meta',
  {NAME => 'name', COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
0 row(s) in 1.3340 seconds

Hbase::Table - tsdb-meta
```

5.TSD 데몬을 실행해서 문제가 없는지 확인합니다.
```sh
$ /usr/share/opentsdb/bin/tsdb tsd
(중간 생략)
2016-04-15 20:54:56,124 INFO  [main] TSDMain: Ready to serve on /0.0.0.0:4242
```
  - 만일, 아래와 같은 에러가 나면, '/tmp/opentsdb' 디렉토리를 지우고 다시 실행합니다.
```
2016-04-15 20:53:44,517 INFO  [main] Config: Successfully loaded configuration file: /etc/opentsdb/opentsdb.conf
Cannot write to directory [/tmp/opentsdb]
```

6.OpenTSDB 서비스가 정상적으로 작동하는지 OpenTSDB 관리페이지를 통해서 확인합니다.
  - 호스트 주소가 '192.168.0.3'인 경우 : http://192.168.0.3:4242

##### Grafana에서 OpenTSDB lookup API 사용을 위한 설정

1.Grafana에서 템플릿을 만들 때 변수가 자동으로 나타나도록 하려면 'opentsdb.conf'에 아래 설정을 추가하여 활성화해야 합니다.
  - tsd.core.meta.enable_realtime_ts = true

2.OpenTSDB에 있는 time series 데이터의 메타데이터를 나타나도록 하려면 아래 명령을 OpenTSDB 서버가 실행 중인 곳에서 실행합니다.
```sh
$ /usr/share/opentsdb/bin/tsdb uid metasync
```
