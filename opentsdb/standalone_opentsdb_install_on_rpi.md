### Raspberry Pi에 OpenTSDB 설치와 단독실행형(Standalone) 구성 안내

##### 설치 환경
* 운영체제: Raspbian Jessie Lite, 2016-03-18 release
* 사용 소프트웨어 버전
  - Oracle JDK 1.7
    - [주의] Open JDK는 Oracle JDK보다 성능도 나쁘고 HBase가 여러가지 버그를 만들기때문에 Oracle JDK를 사용합니다.
  - GnuPlot 4.6
  - HBase 0.98.18
  - OpenTSDB 2.0.1

##### JDK(Java Development Kit) 설치하기
HBase, OpenTSDB 서버는 모두 Java 기반으로 개발되어 있어서 실행할 때 JDK(혹은 JRE)가 필요합니다.

1.JDK 설치 여부를 확인합니다.
```sh
$ java -version
java version "1.6.0_38"
OpenJDK Runtime Environment (IcedTea6 1.13.10) (6b38-1.13.10-1~deb7u1+rpi1)
OpenJDK Zero VM (build 23.25-b01, mixed mode)
```

2.OpenJDK가 이미 설치되어 있다면, 제거합니다. JDK가 설치되어 있지 않다면, PPA repository를 추가하고 Oracle JDK를 설치합니다.
  - Open JDK 제거
```sh
$ sudo apt-get purge openjdk*
```
  - Oracle JDK 설치
```sh
$ sudo apt-get update
$ sudo apt-get install oracle-java7-jdk
```

3.JDK 버전을 확인합니다.
```sh
$ java -version
java version "1.7.0_60"
Java(TM) SE Runtime Environment (build 1.7.0_60-b19)
Java HotSpot(TM) Client VM (build 24.60-b09, mixed mode)
```

##### GnuPlot 설치하기
OpenTSDB에서 그래프 그릴 때 사용됩니다.

1.패키지 설치 명령으로 GnuPlot을 설치합니다.
```sh
$ sudo apt-get update 
$ sudo apt-get install gnuplot 
```

##### HBase 단독실행형으로 설치하기
HBase를 단독실행형으로 설치하게 되면, HDFS 서버와 ZooKeeper 서버가 별도로 필요하지 않으며 하나의 호스트에서 실행됩니다.

1.다음 주소에서 HBase 릴리즈 파일을 다운로드합니다.
  > http://apache.mirror.cdnetworks.com/hbase/0.98.18/hbase-0.98.18-hadoop1-bin.tar.gz

2.다운로드한 HBase 릴리즈 파일의 압축을 푼 후, 새로 생성된 디렉토리를 '/usr/local/hbase'로 링크합니다.
```sh
$ tar xzvf hbase-0.98.18-hadoop1-bin.tar.gz -C ~/
$ sudo ln -s ~/hbase-0.98.18-hadoop1 /usr/local/hbase
```

3.'/usr/local/hbase/conf/hbase-env.sh' 스크립트 파일에 Java 홈 디렉토리를 다음과 같이 지정합니다.
```
export JAVA_HOME=/usr/lib/jvm/jdk-7-oracle-arm-vfp-hflt
```

4.'/usr/local/hbase/conf/hbase-site.xml' 파일에 HBase rootdir 설정과 ZooKeeper 데이터 디렉토리를 설정합니다.
다음 설정은 사용자 홈디렉토리를 데이터 디렉토리로 이용하는 HBase 설정의 예입니다.
```
<configuration> 
  <property> 
    <name>hbase.rootdir</name> 
    <value>file:///home/pi/hbase</value> 
  </property> 
  <property> 
    <name>hbase.zookeeper.property.dataDir</name> 
    <value>/home/pi/zookeeper</value> 
  </property> 
</configuration> 
```

5.다음 명령을 실행해서 HBase 서버를 실행합니다. HBase 서버를 최초 실행할 때, Raspberry Pi의 성능문제로 데이터베이스 초기화에 상당한 시간이 소요되므로 약 2분 정도 기다렸다가 이후 과정을 진행합니다.
```sh
$ /usr/local/hbase/bin/start-hbase.sh
```

6.HMaster 프로세스가 실행되었는지 확인합니다.
```sh
$ jps
1150 HMaster
```

7.HBase shell을 이용해 HBase에 연결되는지 확인합니다. 이때, native-hadoop 라이브러리를 로드할 수 없다는 경고가 나오는데 하둡을 별도로 설치하기 않았기때문에 나오는 메시지므로 무시합니다. 시스템 성능에 따라서 몇분 정도 걸리므로 메시지가 나올 때까지 계속 기다립니다.
```sh
$ /usr/local/hbase/bin/hbase shell
tinyos@server01:~$ /usr/local/hbase/bin/hbase shell
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.98.18-hadoop1, rc26c554ab3a8deecf890873bf6b1b4c90fa001dc, Fri Mar 18 19:01:04 PDT 2016

%N(%m):%03n:%i> 
```

8.HBase 동작에 문제가 없다고 확인되면, 부팅할 때 자동으로 실행되도록 '/etc/rc.local'에 추가합니다. 추가할 때 'exit 0' 라인 이전에 추가해야 합니다.
```sh
$ sudo vi /etc/rc.local
/usr/local/hbase/bin/start-hbase.sh
exit 0
```

##### OpenTSDB 설치하기

1.다음 주소에서 OpenTSDB의 Debian 패키지 릴리즈 파일(*.deb)을 다운로드합니다.
  > https://github.com/OpenTSDB/opentsdb/releases

  - 참고로, opentsdb-xxx.tar.gz 파일에는 RedHat 기반의 구성 파일이 들어 있어서 Debian 기반 리눅스(Ubuntu, Raspbian)에는 필요한 환경설정 파일을 자동으로 설치할 수 없습니다. Debian 기반 리눅스에 설치할 때는 Debian 패키지(opentsdb-x.x.x_all.deb) 파일을 다운로드하거나 GitHub에서 소스를 다운로드해서 Debian target으로 소스를 빌드해서 Debian 패키지 파일을 생성합니다.
  - GitHub에서 소스를 받아서 Debian package 빌드하는 절차:
```sh
$ git clone git://github.com/OpenTSDB/opentsdb.git 
$ cd opentsdb 
$ ./build.sh debian 
```

2.다운로드한 Debian package(*.deb) 파일을 설치합니다. 소스를 빌드한 경우, deb 패키지 파일이 'build/opentsdb-2.x.x/' 디렉토리 아래에 만들어집니다.
```sh
$ sudo dpkg -i opentsdb-2.0.1_all.deb
```

3.Debian package를 설치하면 OpenTSDB 패키지는 '/usr/share/opentsdb/' 디렉토리에 설치되고, 환경설정파일은 '/etc/opentsdb/opentsdb.conf'에 있고, 부팅시에 자동으로 OpenTSDB 서버가 실행됩니다.

4.OpenTSDB를 설치한 후, 최초로 한번 데이터베이스 테이블을 구성하는 명령을 실행해야 합니다. 시스템 성능에 따라서 몇분 정도 걸리므로 메시지가 나올 때까지 계속 기다립니다.
```sh
$ export JAVA_HOME=/usr/lib/jvm/jdk-7-oracle-arm-vfp-hflt
$ export HBASE_HOME=/usr/local/hbase 
$ export COMPRESSION=NONE 
$ cd /usr/share/opentsdb/tools/
$ ./create_table.sh
Type "exit<RETURN>" to leave the HBase Shell
Version 0.98.18-hadoop1, rc26c554ab3a8deecf890873bf6b1b4c90fa001dc, Fri Mar 18 19:01:04 PDT 2016

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

5.추가로 필요한 환경설정을 '/etc/opentsdb/opentsdb.conf'에 지정합니다. 
  - 레코드의 metric이 데이터베이스에 존재하지 않을 때, 자동으로 metric을 추가해주는 옵션:
    - tsd.core.auto_create_metrics = true

6.시스템을 리부팅한 후, OpenTSDB가 정상저으로 작동하는지 OpenTSDB 관리페이지를 통해서 확인합니다. 아래는 '192.168.0.3' 주소를 갖는 호스트에 OpenTSDB를 설치한 경우의 관리페이지 주소입니다.
  > http://192.168.0.3:4242

##### Grafana에서 OpenTSDB lookup API 사용을 위한 설정

1.Grafana에서 템플릿을 만들 때 변수가 자동으로 나타나도록 하려면 'opentsdb.conf'에 아래 설정을 활성화해야 합니다.
  - tsd.core.meta.enable_realtime_ts = true

2.OpenTSDB에 있는 time series 데이터의 메타데이터를 나타나도록 하려면 아래 명령을 OpenTSDB 서버가 실행 중인 곳에서 실행합니다.
```sh
$ /usr/share/opentsdb/bin/tsdb uid metasync
```
