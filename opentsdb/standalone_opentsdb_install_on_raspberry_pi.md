### Raspberry Pi에 OpenTSDB 설치와 단독실행형(Standalone) 구성 안내

##### 설치 환경
* 운영체제: Raspbian Jessie Lite, 2016-02-26 release
* 사용 소프트웨어 버전
  - JDK 1.7 (Raspberry Pi 기본 패키지 버전)
  - GnuPlot 4.6 (Raspberry Pi 기본 패키지 버전)
  - HBase 1.1
  - OpenTSDB 2.2

##### JDK(Java Development Kit) 설치하기
HBase, OpenTSDB 서버는 모두 Java 기반으로 개발되어 있어서 실행할 때 JDK(혹은 JRE)가 필요합니다.

1.JDK 설치 여부를 확인합니다.
```sh
$ java -version
java version "1.7.0_95"
OpenJDK Runtime Environment (IcedTea 2.6.4) (7u95-2.6.4-0ubuntu0.14.04.2)
OpenJDK 64-Bit Server VM (build 24.95-b01, mixed mode)
```

2.JDK가 설치되어 있지 않다면, 패키지 설치 명령으로 기본 JDK를 설치합니다.
```sh
$ sudo apt-get update
$ sudo apt-get install default-jdk
```

##### GnuPlot 설치하기
OpenTSDB에서 그래프 그릴 때 사용됩니다.

1.패키지 설치 명령으로 GnuPlot을 설치합니다.
```sh
$ sudo apt-get update 
$ sudo apt-get install gnuplot 
```

##### HBase 단독실행형으로 설치하기

1.다음 주소에서 HBase 릴리즈 파일을 다운로드합니다.
  - http://apache.mirror.cdnetworks.com/hbase/stable/hbase-1.1.4-bin.tar.gz

2.다운로드한 HBase 릴리즈 파일의 압축을 푼 후, 새로 생성된 디렉토리를 '/usr/local/hbase'로 링크합니다.
```sh
$ tar xzvf hbase-1.1.4-bin.tar.gz -C ~/
$ sudo ln -s ~/hbase-1.1.4 /usr/local/hbase
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

#### OpenTSDB 설치하기

1. 다음 주소에서 OpenTSDB의 Debian package 릴리즈 파일(*.deb)을 다운로드합니다.</br>
https://github.com/OpenTSDB/opentsdb/releases</br>
참고로, opentsdb-xxx.tar.gz 파일에는 RedHat 기반의 구성 파일이 들어 있어서 Ubuntu(Debian 기반 리눅스)에는 필요한 환경설정 파일을 자동으로 설치할 수 없으므로, Debian package(opentsdb-x.x.x_all.deb) 파일을 다운로드하거나 GitHub에서 소스를 다운로드해서 Debian target으로 소스를 빌드해야 합니다.</br>
GitHub에서 소스를 받아서 Debian package 빌드하는 방법:
<pre>
$ git clone git://github.com/OpenTSDB/opentsdb.git 
$ cd opentsdb 
$ ./build.sh debian 
$ cd build/opentsdb-x.x.x/
</pre>

2. Debian package(*.deb) 파일을 설치합니다.
<pre>
$ sudo dpkg -i opentsdb-x.x.x_all.deb
</pre>

3. Debian package를 설치하면 OpenTSDB 패키지는 '/usr/share/opentsdb/' 디렉토리에 설치되고, 환경설정파일은 '/etc/opentsdb/opentsdb.conf'에 있고, 부팅시에 자동으로 OpenTSDB 서버가 실행되도록 설정됩니다.

4. OpenTSDB를 설치한 후 최초로 한번 데이터베이스 테이블을 구성하는 명령을 실행해야 합니다.
<pre>
$ export HBASE_HOME=/usr/local/hbase 
$ export COMPRESSION=NONE 
$ cd /usr/share/opentsdb/tools/
$ ./create_table.sh
</pre>

5. 추가로 필요한 환경설정을 '/etc/opentsdb/opentsdb.conf'에 지정합니다.</br>
추가하려는 데이터의 metric이 데이터베이스에 존재하지 않을 때, 자동으로 metric을 추가해주는 옵션:
<pre>
tsd.core.auto_create_metrics = true
</pre>
