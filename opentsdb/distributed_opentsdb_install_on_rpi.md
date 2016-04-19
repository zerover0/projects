### Raspberry Pi에 OpenTSDB 설치와 분산환경 구성 안내

##### 설치 환경
* 하드웨어: Raspberry Pi 1 Model B+
* 운영체제: Raspbian Jessie Lite, 2016-03-18 release
* 사용 소프트웨어 버전
  - Oracle JDK 1.7
  - GnuPlot 4.6
  - Hadoop 2.6.4
  - ZooKeeper 3.4.8
  - HBase 1.2.1
  - OpenTSDB 2.2.0

##### 호스트 구성
* 호스트이름과 IP 주소 구성
  - server01 : 192.168.0.211
  - server01 : 192.168.0.212
  - server01 : 192.168.0.213
* 호스트별 서버 구성
  - server01 : Master 노드, Hadoop NameNode/SecondaryNameNode/DataNode, YARN ResourceManager/NodeManager, HBase Master/RegionServer, ZooKeeper, OpenTSDB
  - server02 : Slave 노드, Hadoop DataNode, YARN NodeManager, HBase RegionServer, ZooKeeper
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

2.Oracle JDK가 설치되어 있지 않다면 설치한다.
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

##### (공통) Hadoop 설치와 환경설정

* 아래 링크의 문서를 따라서 Hadoop을 설치한다.
  - Ubuntu Server 14.04에 Hadoop 설치하기
    - https://github.com/zerover0/projects/blob/master/hadoop/hadoop_install_on_ubuntu.md
  - Raspberry Pi에 Hadoop 설치하기
    - https://github.com/zerover0/projects/blob/master/hadoop/hadoop_install_on_rpi.md

##### (master) GnuPlot 설치하기

OpenTSDB Web UI 사이트에서 그래프를 그릴 때 사용된다.

1.패키지 설치 명령으로 GnuPlot을 설치한다.
```sh
$ sudo apt-get update 
$ sudo apt-get install gnuplot 
```

##### (master) ZooKeeper 설치와 환경설정

ZooKeeper는 분산 서버들 간에 조정자 역할을 해주는데, HBase가 분산 환경에서 작동할 때 필요하다.

1.ZooKeeper 홈페이지에서 3.4.8 릴리즈 파일을 다운로드한다.
  - http://zookeeper.apache.org

2.다운로드한 파일을 hadoop 홈디렉토리 아래에 있는 'app' 디렉토리에 압축을 풀고, 생성된 디렉토리의 이름을 'zookeeper'로 바꾼다.
```sh
$ tar xzf zookeeper-3.4.8.tar.gz -C ~/app/
$ mv ~/app/zookeeper-3.4.8 ~/app/zookeeper
```

3.'zoo.cfg' 샘플 파일을 복사해서 ZooKeeper 환경설정 파일을 만든다.
```sh
$ cp ~/app/zookeeper/conf/zoo_sample.cfg ~/app/zookeeper/conf/zoo.cfg
```

4.'zoo.cfg' 파일을 열어서 'dataDir' 설정을 수정한 후에 저장한다.
  - dataDir : ZooKeeper의 데이터를 저장할 로컬 디렉토리
```sh
$ vi ~/app/zookeeper/conf/zoo.cfg
dataDir=/home/hadoop/data/zookeeper
```

5.master 노드에 있는 ZooKeeper 디렉토리 전체를 slave 노드로 복사한다.
```sh
$ scp -r ~/app/zookeeper hadoop@server02:~/app/
$ scp -r ~/app/zookeeper hadoop@server03:~/app/
```

6.ZooKeeper 서버를 실행한다.
```sh
$ ~/app/zookeeper/bin/zkServer.sh start
```

7.ZooKeeper 프로세스가 작동하는지 확인한다.
```sh
$ jps
1220 QuorumPeerMain
```

8.telnet 명령으로 ZooKeeper 서버에 연결해서 'stat' 명령으로 작동 중인지 확인할 수 있다(telnet이 없다면 통과).
```sh
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
```

9.ZooKeeper 프로세스를 종료하려면, 아래 명령을 실행한다.
```sh
$ ~/app/zookeeper/bin/zkServer.sh stop
```

##### (master) HBase 설치와 환경설정

1.HBase 홈페이지에서 1.1.4 릴리즈 파일을 다운로드한다.
  - http://hbase.apache.org

2.다운로드한 파일을 hadoop 홈디렉토리 아래에 있는 'app' 디렉토리에 압축을 풀고, 생성된 디렉토리의 이름을 'hbase'로 바꾼다.
```sh
$ tar xzf hbase-1.1.4-bin.tar.gz -C ~/app/
$ mv ~/app/hbase-1.1.4 ~/app/hbase
```

4.'regionservers' 파일을 열어서 RegionServer가 실행될 호스트이름을 한줄에 하나씩 입력하고 저장한다.
```sh
$ vi ~/app/hbase/conf/regionservers
server01
server02
server03
```

5.Hadoop HDFS 설정을 참조하기 위해서 'hdfs-site.xml' 파일을 Hadoop 디렉토리에서 HBase 디렉토리로 복사한다.
```sh
$ cp ~/app/hadoop/etc/hadoop/hdfs-site.xml ~/app/hbase/conf/
```

6.'hbase-env.sh' 파일을 열어서 'LD_LIBRARY_PATH'를 추가하고, 'JAVA_HOME', 'HBASE_CLASSPATH', 'HBASE_LOG_DIR'을 찾아서 수정한 후 저장한다.
  - LD_LIBRARY_PATH : Hadoop native library 경로를 추가
  - HBASE_CLASSPATH : HADOOP_CONF_DIR을 가리키도록 설정($HADOOP_CONF_DIR/hadoop-env.sh 이용)
```sh
$ vi ~/app/hbase/conf/hbase-env.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/hadoop/app/hadoop/lib/native
export JAVA_HOME=/usr/lib/jvm/default-java
export HBASE_CLASSPATH=/home/hadoop/app/hadoop/etc/hadoop
export HBASE_LOG_DIR=/home/hadoop/data/hbase/logs
export HBASE_MANAGES_ZK=false
```

7.'hbase-site.xml' 파일을 열어서 아래 내용을 추가한다.
  - hbase.rootdir : HDFS의 HBase 루트 디렉토리 URI
  - hbase.cluster.distributed : true = 분산환경에서 동작을 의미
  - hbase.zookeeper.quorum : ZooKeeper 프로세스가 실행 중인 호스트이름 목록
  - hbase.zookeeper.property.dataDir : ZooKeepr 데이터를 저장할 로컬 디렉토리
```sh
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
```

8.master 노드에 있는 HBase 디렉토리 전체를 slave 노드로 복사한다. 원격으로 slave 노드의 프로세스를 실행하려면 master 노드와 디렉토리 구조가 동일해야한다.
```sh
$ scp -r ~/app/hbase hadoop@server02:~/app/
$ scp -r ~/app/hbase hadoop@server03:~/app/
```

9.HBase 프로세스를 실행한다.
```sh
$ ~/app/hbase/bin/start-hbase.sh
```

10.HBase 프로세스가 작동하는지 확인한다.
```sh
server01:~$ jps
4607 HRegionServer
3903 NodeManager
3765 ResourceManager
3388 DataNode
843 QuorumPeerMain
3584 SecondaryNameNode
3246 NameNode
4475 HMaster
server02:~$ jps
4607 HRegionServer
3903 NodeManager
3388 DataNode
2548 HMaster
843 QuorumPeerMain
4475 HMaster
server03:~$ jps
4607 HRegionServer
3903 NodeManager
3388 DataNode
843 QuorumPeerMain
```

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

##### (master) OpenTSDB 설치와 환경설정

1.다음 주소에서 OpenTSDB의 릴리즈 파일을 다운로드한다.
  - https://github.com/OpenTSDB/opentsdb/releases

2.다운로드한 파일의 압축을 푼 후, 빌드하고 설치한다.
```sh
$ tar xzf opentsdb-2.2.0.tar.gz -C ~/
$ cd ~/opentsdb-2.2.0
$ ./build.sh
$ cd build
$ sudo make install
```

3.OpenTSDB 프로그램은 '/usr/local/share/opentsdb/' 디렉토리에 설치된다. 환경설정 파일인 'opentsdb.conf'을 열어서 필요한 옵션을 설정하고 저장한다.
  - tsd.core.auto_create_metrics : true = 레코드의 metric이 데이터베이스에 존재하지 않을 때, 자동으로 metric 추가
  - tsd.storage.fix_duplicates : true = 같은 시간에 중복된 데이터가 존재하는 경우 마지막 입력된 데이터만 쓰임
```sh
$ sudo vi /usr/local/share/opentsdb/etc/opentsdb/opentsdb.conf
tsd.core.auto_create_metrics = true
tsd.storage.fix_duplicates = true
```

4.OpenTSDB를 설치한 후, 최초로 한번 데이터베이스 테이블을 구성하는 명령을 실행한다.
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

5.TSD 데몬을 실행한다.
```sh
$ /usr/share/opentsdb/bin/tsdb tsd
(중간 생략)
2016-04-15 20:54:56,124 INFO  [main] TSDMain: Ready to serve on /0.0.0.0:4242
```
  - 만일, 아래와 같은 에러가 나면, '/tmp/opentsdb' 디렉토리를 지우고 다시 실행한다.
```
2016-04-15 20:53:44,517 INFO  [main] Config: Successfully loaded configuration file: /etc/opentsdb/opentsdb.conf
Cannot write to directory [/tmp/opentsdb]
```

6.OpenTSDB 서비스가 정상적으로 작동하는지 OpenTSDB Web UI 사이트를 통해서 확인한다.
  - 호스트 주소가 '192.168.0.3'인 경우 : http://192.168.0.3:4242

##### (master) Grafana에서 OpenTSDB lookup API 사용을 위한 설정

1.Grafana에서 템플릿을 만들 때 변수가 자동으로 나타나도록 하려면 'opentsdb.conf'에 아래 설정을 추가하여 활성화한다.
  - tsd.core.meta.enable_realtime_ts = true

2.OpenTSDB에 있는 time series 데이터의 메타데이터를 나타나도록 하려면 아래 명령을 OpenTSDB 서버가 실행 중인 호스트에서 실행한다.
```sh
$ /usr/share/opentsdb/bin/tsdb uid metasync
```

##### (공통) ZooKeeper를 부팅할 때 자동 실행하기

ZooKeepr는 다른 서버 프로그램들이 실행되기 이전에 독립적으로 실행되어야하므로 부팅할 때 자동으로 실행되도록 설정한다. 부팅할 때 실행하는 여러가지 방법 가운데, 아래는 'crontab'을 이용하는 방법이다.

1.'/etc/crontab' 파일을 열어서 파일 끝부분에 부팅할 때 실행할 서버 스크립트를 추가하고 저장한다.
```sh
$ sudo vi /etc/crontab
@reboot hadoop /home/hadoop/app/zookeeper/bin/zkServer.sh start
```
