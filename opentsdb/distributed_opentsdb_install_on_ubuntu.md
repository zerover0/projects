### Ubuntu에 OpenTSDB 설치와 분산환경 구성 안내

##### 설치 환경
* 운영체제: Ubuntu 14.04, x86 64-bit
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
Hadoop, HBase, ZooKeeper, OpenTSDB 등 서버들이 모두 Java 기반으로 개발되어 있어서 실행할 때 JDK(혹은 JRE)가 필요합니다. Open JDK는 Oracle JDK보다 성능도 나쁘고 설치할 프로그램들과 여러가지 버그를 만들기때문에 Oracle JDK를 사용합니다.

1.JDK 설치 여부를 확인합니다.
```sh
$ java -version
java version "1.7.0_95"
OpenJDK Runtime Environment (IcedTea 2.6.4) (7u95-2.6.4-0ubuntu0.14.04.2)
OpenJDK 64-Bit Server VM (build 24.95-b01, mixed mode)
```

2.OpenJDK가 이미 설치되어 있다면, 제거합니다. JDK가 설치되어 있지 않다면, PPA repository를 추가하고 Oracle JDK를 설치합니다.
  - Open JDK 제거
```sh
$ sudo apt-get purge openjdk*
```
  - Oracle JDK 설치
```sh
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java7-installer
```

3.JDK 버전을 확인합니다.
```sh
$ java -version
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
```

4.편의를 위해서 Oracle JDK를 'default-java'로 링크합니다.
```sh
$ sudo ln -s /usr/lib/jvm/java-7-oracle /usr/lib/jvm/default-java
```

##### GnuPlot 설치하기
OpenTSDB에서 그래프 그릴 때 사용됩니다.

1.패키지 설치 명령으로 GnuPlot을 설치합니다.
```sh
$ sudo apt-get update 
$ sudo apt-get install gnuplot 
```

##### ZooKeeper 설치하기
ZooKeeper는 분산 서버들 간에 조정자 역할을 해주는데, HBase가 분산 환경에서 작동할 때 필요합니다.

(master) ZooKeeper 프로그램 설치와 환경설정
1.ZooKeeper 홈페이지에서 3.4.8 릴리즈 파일을 다운로드한다.
- http://zookeeper.apache.org
2.다운로드한 파일을 hadoop 홈디렉토리 아래에 있는 'app' 디렉토리에 압축을 풀고, 생성된 디렉토리의 이름을 'zookeeper'로 바꾼다.
$ tar xzf zookeeper-3.4.8.tar.gz -C ~/app/
$ mv ~/app/zookeeper-3.4.8 ~/app/zookeeper
3.'zoo.cfg' 샘플 파일을 복사해서 ZooKeeper 환경설정 파일을 만든다.
$ cp ~/app/zookeeper/conf/zoo_sample.cfg ~/app/zookeeper/conf/zoo.cfg
4.'zoo.cfg' 파일을 열어서 'dataDir' 설정을 수정한 후에 저장한다. 'dataDir'은 ZooKeeper의 데이터가 저장될 로컬 디렉토리이이다.
$ vi ~/app/zookeeper/conf/zoo.cfg
dataDir=/home/hadoop/data/zookeeper
5.master 노드에 있는 ZooKeeper 디렉토리 전체를 slave 노드로 복사한다.
$ scp -r ~/app/zookeeper hadoop@server02:~/app/
$ scp -r ~/app/zookeeper hadoop@server03:~/app/
6.ZooKeeper 서버를 실행한다.
$ ~/app/zookeeper/bin/zkServer.sh start
7.ZooKeeper 프로세스가 작동하는지 확인한다.
$ jps
1220 QuorumPeerMain
8.telnet 명령으로 ZooKeeper 서버에 연결해서 'stat' 명령으로 작동 중인지 확인하다.
$ telnet localhost 2181
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
stat
Zookeeper version: 3.4.8--1, built on 02/06/2016 03:18 GMT
Clients:
 /127.0.0.1:56211[0](queued=0,recved=1,sent=0)
Latency min/avg/max: 0/0/0
Received: 1
Sent: 0
Connections: 1
Outstanding: 0
Zxid: 0x0
Mode: standalone
Node count: 4
Connection closed by foreign host.
9.ZooKeeper 프로세스를 종료하려면, 아래 명령을 실행한다.
$ ~/app/zookeeper/bin/zkServer.sh stop

(master) HBase 프로그램 설치와 환경설정
1.HBase 홈페이지에서 1.1.4 릴리즈 파일을 다운로드한다.
- http://hbase.apache.org
2.다운로드한 파일을 hadoop 홈디렉토리 아래에 있는 'app' 디렉토리에 압축을 풀고, 생성된 디렉토리의 이름을 'hbase'로 바꾼다.
$ tar xzf hbase-1.1.4-bin.tar.gz -C ~/app/
$ mv ~/app/hbase-1.1.4 ~/app/hbase
4.'regionservers' 파일을 열어서 RegionServer가 실행될 호스트이름을 한줄에 하나씩 입력하고 저장한다. 아래 구성은 HBase Master인 server01에는 RegionServer가 실행되지 않고 나머지 slave 노드에 RegionServer가 실행되는 것을 가정한 예제이다.
$ vi ~/app/hbase/conf/regionservers
server01
server02
server03
5.server02를 HBase의 백업 Master로 설정하기 위해서 'backup-masters'라는 파일을 만들어서 백업 Master가 실행될 호스트이름을 추가한다.
$ vi ~/app/hbase/conf/backup-masters
server02
6.Hadoop HDFS 설정을 참조하기 위해서 'hdfs-site.xml' 파일을 Hadoop 디렉토리에서 HBase 디렉토리로 복사한다.
$ cp ~/app/hadoop/etc/hadoop/hdfs-site.xml ~/app/hbase/conf/
7.'hadoop-env.sh' 파일을 열어서 'JAVA_HOME'과 'HBASE_CLASSPATH'을 수정한 후 저장한다.
- LD_LIBRARY_PATH : Hadoop native library 경로를 추가
- HBASE_CLASSPATH : HADOOP_CONF_DIR을 가리키도록 설정
$ vi ~/app/hbase/conf/hbase-env.sh
export LD_LIBRARY_PATH=/home/hadoop/app/hadoop/lib/native
export JAVA_HOME=/usr/lib/jvm/default-java
export HBASE_CLASSPATH=/home/hadoop/app/hadoop/etc/hadoop
export HBASE_LOG_DIR=/home/hadoop/data/hbase/logs
8.'hdfs-site.xml' 파일을 열어서 아래 내용을 추가한다.
- hbase.rootdir : HDFS 서비스 URI에 HBase 파일 저장 디렉토리 이름을 추가하여 만든 HDFS의 HBase 루트 디렉토리 URI
- hbase.cluster.distributed : true로 설정하면 분산환경에서 동작을 의미
- hbase.zookeeper.quorum : ZooKeeper 프로세스가 실행 중인 호스트이름
- hbase.zookeeper.property.dataDir : ZooKeepr 데이터가 저장될 로컬 디렉토리
$ vi ~/app/hbase/conf/hbase-site.xml
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>hdfs://server01:9000/hbase</value>
  </property>
  <property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
  </property>
  <property>
    <name>hbase.zookeeper.quorum</name>
    <value>server01,server02,server03</value>
  </property>
  <property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>/home/hadoop/data/zookeeper</value>
  </property>
</configuration>
9.master 노드에 있는 HBase 디렉토리 전체를 slave 노드로 복사한다. 원격으로 slave 노드의 프로세스를 실행하려면 master 노드와 디렉토리 구조가 동일해야한다.
$ scp -r ~/app/hbase hadoop@server02:~/app/
$ scp -r ~/app/hbase hadoop@server03:~/app/
10.HBase 프로세스를 실행한다.
$ ~/app/hbase/bin/start-hbase.sh
10.HBase 프로세스가 작동하는지 확인한다.
(server01)$ jps
4607 HRegionServer
3903 NodeManager
3765 ResourceManager
3388 DataNode
843 QuorumPeerMain
3584 SecondaryNameNode
3246 NameNode
4475 HMaster
(server02)$ jps
4607 HRegionServer
3903 NodeManager
3388 DataNode
843 QuorumPeerMain
4475 HMaster
(server03)$jps
4607 HRegionServer
3903 NodeManager
3388 DataNode
843 QuorumPeerMain
11.HBase 모니터링 사이트를 열어서 동작 상태를 확인한다.
- HBase Master Web UI : http://server01:16010
- HBase backup Master Web UI : http://server02:16010
- HBase RegionServer Web UI : http://server01:16030
- HBase RegionServer Web UI : http://server02:16030
- HBase RegionServer Web UI : http://server03:16030
12.HBase 프로세스를 종료하려면, 아래 명령을 실행한다.
```sh
$ ~/app/hbase/bin/stop-hbase.sh
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
