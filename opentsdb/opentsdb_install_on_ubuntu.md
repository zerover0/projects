### Ubuntu 14.04에 OpenTSDB 설치와 설정 안내

#### 설치 환경

<pre>
Ubuntu Linux 14.04
</pre>

#### 설치 요구사항

<pre>
JRE(Java Runtime Environment) 1.6 이상
ZooKeeper 3.4.x 이상
HBase 1.x.x 이상
GnuPlot 4.2 이상
</pre>

#### JRE(Java Runtime Environment) 설치하기

1. JRE 설치 여부 확인
<pre>
$ java -version
java version "1.8.0_05"
Java(TM) SE Runtime Environment (build 1.8.0_05-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.5-b02, mixed mode)
</pre>

2. JRE가 설치되어 있지 않다면, Ubuntu apt-get 명령으로 JRE를 설치합니다.
<pre>
$ sudo apt-get install default-jre
</pre>

#### ZooKeeper 단독운영(Standalone Operation) 모드로 설치하기

[ZooKeeper 동작여부 확인하기]<p>

1. Telnet과 같은 명령으로 동작여부 확인이 가능합니다.</br>
아래는 로컬 호스트에 ZooKeeper가 작동 중인지 확인하는 경우입니다.
<pre>
$ telnet localhost 2181
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
</pre>

2. Telnet 연결이 거부되거나 바로 끊어지지 않으면 'stat' 명령을 입력해서 ZooKeeper 서버 응답을 받을 수 있습니다.
<pre> 
stat
Zookeeper version: 3.4.6-1569965, built on 02/20/2014 09:09 GMT
Clients:
 /127.0.0.1:38470[1](queued=0,recved=124288,sent=124288)
...
</pre>

[방법1: ZooKeeper 릴리즈를 다운로드 받아서 수동으로 설치하기]</br>

1. 다음 주소에서 ZooKeeper 릴리즈 파일을 다운로드합니다.</br>
http://apache.mirror.cdnetworks.com/zookeeper/stable/
<pre>
e.g. http://apache.mirror.cdnetworks.com/zookeeper/stable/zookeeper-3.4.8.tar.gz
</pre>

2. 다운로드한 ZooKeeper 릴리즈 파일을 압축해제한 후, 새로 생성된 디렉토리의 최상위로 이동합니다.
<pre>
$ tar xzvf zookeeper-3.4.8.tar.gz
$ cd zookeeper-3.4.8
</pre>

3. ZooKeepr 서버를 실행하기 전에 환경설정 파일('conf/zoo.cfg')을 설정해야 합니다.</br>
다음은 'conf/zoo.cfg' 예제 파일입니다.
<pre>
tickTime=2000 
dataDir=/var/lib/zookeeper 
clientPort=2181 
</pre>

4. 다음 명령으로 ZooKeeper 서버를 실행합니다.
<pre>
$ bin/zkServer.sh start 
</pre>

5. ZooKeeper 서버를 실행해서 에러가 없으면, 부팅시 자동으로 실행되도록 '/etc/rc.local' 파일에 다음 내용을 추가합니다.
<pre>
/usr/local/zookeeper/bin/zkServer.sh start 
</pre>

[방법2: Ubuntu apt-get 명령으로 패키지 설치하기]</br>

1. 다음 명령을 실행하면 ZooKeeper 릴리즈와 환경설정 파일 패키지가 설치됩니다. 
<pre>
$ sudo apt-get update 
$ sudo apt-get install zookeeper zookeeperd 
</pre>

2. apt-get 명령으로 설치하면, 환경설정 파일은 '/etc/zookeeper/conf/zoo.cfg'에 설치되고, 부팅할 때 ZooKeeper 서버가 자동으로 실행되도록 설정되어 있습니다. ZooKeeper가 데이터를 쓸 때 사용하는 디렉토리는 '/var/lib/zookeeper'로 'zoo.cfg'에 설정되어 있습니다. 

#### HBase 단독운영(Standalone Operation) 모드로 설치하기

1. 다음 주소에서 HBase 릴리즈 파일을 다운로드합니다.</br>
http://apache.mirror.cdnetworks.com/hbase/stable/
<pre>
e.g. http://apache.tt.co.kr/hbase/stable/hbase-1.1.3-bin.tar.gz
</pre>

2. 다운로드한 HBase 릴리즈 파일의 압축을 푼 후, 새로 생성된 디렉토리를 '/usr/local/hbase'라는 이름으로 변경해서 이동합니다.
<pre>
$ tar xzvf hbase-1.1.3-bin.tar.gz 
$ sudo mv hbase-1.1.3 /usr/local/hbase
</pre>

3. '/usr/local/hbase/conf/hbase-env.sh' 스크립트 파일에 Java 홈 디렉토리와 로그 디렉토리를 다음과 같이 지정합니다.
<pre>
export JAVA_HOME=/usr/java/jdk1.8/
export HBASE_LOG_DIR=/tmp/hbase/logs 
</pre>

4. '/usr/local/hbase/conf/hbase-site.xml' 파일에 rootdir 설정과 ZooKeeper 데이터 디렉토리를 설정합니다.</br>
다음 설정은 로컬 파일시스템을 이용한 HBase 설정의 예입니다.
```html
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

5. 다음 명령을 실행해서 HBase 서버를 실행합니다.
<pre>
$ /usr/local/hbase/bin/start-hbase.sh
</pre>

6. HBase 서버를 실행해서 에러가 없으면, 부팅시 자동으로 실행되도록 '/etc/rc.local' 파일에 다음 내용을 추가합니다.
<pre>
/usr/local/hbase/bin/start-hbase.sh
</pre>

#### GnuPlot 설치하기

Ubuntu apt-get 명령을 실행해서 GnuPlot을 설치합니다.
<pre>
$ sudo apt-get update 
$ sudo apt-get install gnuplot 
</pre>

#### OpenTSDB 단독운영(Standalone Operation) 모드로 설치하기

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
