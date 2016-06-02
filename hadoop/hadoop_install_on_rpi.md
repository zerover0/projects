# Raspberry Pi에 Hadoop 설치와 구성 안내

### 설치 환경
* 하드웨어
  - Raspberry Pi 1 Model B+
* 운영체제
  - Raspbian Jessie Lite, 2016-03-18 release
* 사용 소프트웨어 버전
  - Oracle JDK 1.7
  - Hadoop 1.2.1
    - Hadoop 2.x는 Raspberry Pi 1에 구동하기에는 무겁다.

### 호스트 구성

* 호스트이름과 IP 주소 구성
  - rpi01 : 192.168.0.211
  - rpi02 : 192.168.0.212
  - rpi03 : 192.168.0.213
  - rpi04 : 192.168.0.214
  - rpi05 : 192.168.0.215
* 호스트별 서버 구성
  - rpi05 : Hadoop NameNode/SecondaryNameNode, MapReduce JobTracker
  - rpi01 : Hadoop DataNode, MapReduce TaskTracker
  - rpi02 : Hadoop DataNode, MapReduce TaskTracker
  - rpi03 : Hadoop DataNode, MapReduce TaskTracker
  - rpi04 : Hadoop DataNode, MapReduce TaskTracker

### (공통) 호스트에 고정 IP 주소 할당

개별 호스트에서 DHCP 대신 고정 IP 주소를 사용하도록 설정하는 방법 이외에 DHCP서버에서 호스트 MAC 주소마다 다른 고정 IP 주소를 할당하는 방법도 있는데 DHCP 서버에서 설정하는 경우는 다음 절차를 수행하지 않아도 된다.

1.DHCP로 자동 설정된 네트워크 구성 정보를 확인한다.
```sh
$ ifconfig
eth0      Link encap:Ethernet  HWaddr 08:00:27:c1:46:fd  
          inet addr:192.168.0.55  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fec1:46fd/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:936 errors:0 dropped:0 overruns:0 frame:0
          TX packets:458 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:87399 (87.3 KB)  TX bytes:64336 (64.3 KB)
```

2.DNS 서버 정보를 확인한다.
```sh
$ cat /etc/resolv.conf
nameserver 210.220.163.82
nameserver 219.250.36.130
```

3.'/etc/network/interfaces' 파일을 수정해서 고정 IP 주소를 설정한다. 다음은 'server01' 호스트에 '192.168.0.211' 주소를 설정할 때 예이다.
```
#auto eth0
#iface eth0 inet dhcp
auto eth0
iface eth0 inet static
address 192.168.0.211
gateway 192.168.0.1
netmask 255.255.255.0
network 192.168.0.0
broadcast 192.168.0.255
dns-nameservers 210.220.163.82 219.250.36.130
```

4.시스템을 재부팅한다.

### (공통) 호스트이름 변경

1.'/etc/hostname' 파일을 열어서 호스트이름을 변경하고 저장한다.

2.시스템을 재부팅한다.

### (공통) Oracle JDK 설치

Open JDK는 Oracle JDK보다 성능이 떨어지고 Hadoop 서버 프로그램들과 알 수 없는 버그를 만들기때문에 Oracle JDK를 사용한다.

1.JDK 설치 여부를 확인하고, Open JDK가 설치되어 있다면 제거한다.
```sh
$ java -version
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

### (공통) Hadoop 관리용 계정 생성

1.'hadoop' 계정을 생성한다.
```sh
$ sudo adduser hadoop
```

2.새로 만든 계정을 'sudo' 그룹에 넣어서 'sudo' 명령을 쓸 수 있게 한다.
```sh
$ sudo adduser hadoop sudo
```

3.이후부터는 'hadoop' 계정으로 로그인해서 작업한다.

4.'hadoop' 계정으로 로그인한 후, 'app', 'data' 디렉토리를 만든다.
  - app : 프로그램 바이너리를 저장한다.
  - data : 프로그램 데이터가 저장될 공간이다.
```sh
$ mkdir ~/app ~/data
```

### (공통) '/etc/hosts' 파일에 호스트이름 등록

1.master 노드의 '/etc/hosts' 파일을 열어서 첫 줄에 있는 'localhost' 정보를 제외하고 모두 지운다. 특히, '/etc/hosts' 파일에서 '127.0.1.1'이라는 주소가 있는 줄을 지운다. 이유는 일부 서버 프로그램에서 '127.0.0.1'만 로컬호스트 주소로 인식하고 '127.0.1.1'은 로컬호스트 주소로 인식하지 못해서 문제를 일으키는 경우가 있기 때문이다.

2.'/etc/hosts' 파일에 Hadoop 클러스터에 포함된 호스트의 IP 주소와 호스트이름을 추가한다.
```
192.168.0.211   rpi01
192.168.0.212   rpi02
192.168.0.213   rpi03
192.168.0.214   rpi04
192.168.0.215   rpi05
```

### (master) SSH 인증 키 생성과 배포

여러 대의 호스트에 분산 환경으로 서버를 구성할 때, master 노드는 slave 노드의 프로세스를 원격으로 제어할 수 있어야 한다. master 노드는 SSH를 통해서 slave 노드에 연결할 수 있는데, master 노드의 인증키를 slave 노드에 배포해서 암호 확인 없이 원격 접속할 수 있도록 한다.

1.master 노드에서 인증키를 생성한다.
```sh
$ ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
```

2.master 노드에서 생성한 인증키를 slave 노드로 복사한다.
```sh
$ ssh-copy-id hadoop@localhost
$ ssh-copy-id hadoop@rpi01
$ ssh-copy-id hadoop@rpi02
$ ssh-copy-id hadoop@rpi03
$ ssh-copy-id hadoop@rpi04
```

### (master) Hadoop 프로그램 설치와 환경설정

1.Hadoop 홈페이지에서 1.2.1 릴리즈 파일을 다운로드한다.
  - http://hadoop.apache.org

2.다운로드한 파일을 hadoop 홈디렉토리 아래에 있는 'app' 디렉토리에 압축을 풀고, 생성된 디렉토리의 이름을 'hadoop'으로 바꾼다.
```sh
$ tar xzf hadoop-1.2.1-bin.tar.gz -C ~/app/
$ mv ~/app/hadoop-1.2.1 ~/app/hadoop
```

3.'hadoop-env.sh' 파일을 열어서 'JAVA_HOME'과 'HADOOP_LOG_DIR'을 수정한 후 저장한다.
  - HADOOP_DATANODE_OPTS : Raspberry Pi 1(ARMv6) 모델에서 Java Server VM을 원격으로 실행하려면 "-Dcom.sun.management.jmxremote -client" 옵션을 추가해야한다(Raspberry Pi 2,3에서는 불필요)
```sh
$ vi ~/app/hadoop/conf/hadoop-env.sh
export JAVA_HOME=/usr/lib/jvm/default-java
export HADOOP_HEAPSIZE=250
export HADOOP_LOG_DIR=/home/hadoop/data/hadoop/logs
export HADOOP_DATANODE_OPTS="-Dcom.sun.management.jmxremote $HADOOP_DATANODE_OPTS -client"
```

4.'core-site.xml' 파일을 열어서 아래 내용을 추가한다.
  - fs.default.name : HDFS 서비스 URI
  - hadoop.tmp.dir : Hadoop 시스템 임시 파일 저장 위치
```sh
$ vi ~/app/hadoop/conf/core-site.xml
<configuration>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://rpi05:9000/</value> 
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/home/hadoop/data/hadoop</value>
  </property>
</configuration>
```

5.'hdfs-site.xml' 파일을 열어서 아래 내용을 추가한다.
  - dfs.replication : HDFS에 파일이 생성될 때 복제를 몇 개 생성할 지 설정(기본값:3)
  - dfs.block.size : HDFS 파일 전송할 때 사용할 블럭크기를 지정하는데 Raspberry Pi의 메모리(512MB)를 고려한 최적값을 지정한다.
```sh
$ vi ~/app/hadoop/conf/hdfs-site.xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.block.size</name>
    <value>5242880</value>
  </property>
</configuration>
```

6.'mapred-site.xml' 파일을 열어서 아래 내용을 추가한다.
  - mapred.job.tracker : Job Tracker URI
```sh
$ vi ~/app/hadoop/conf/mapred-site.xml
<configuration>
  <property>
    <name>mapred.job.tracker</name>
    <value>rpi05:9001</value>
  </property>
</configuration>
```

7.'slaves' 파일을 열어서 데이터노드 호스트이름을 한줄에 하나씩 추가한다.
```sh
$ vi ~/app/hadoop/conf/slaves
rpi01
rpi02
rpi03
rpi04
```

8.master 노드에 있는 Hadoop 디렉토리 전체를 slave 노드로 복사한다. 원격으로 slave 노드의 프로세스를 실행하려면 master 노드와 디렉토리 구조가 동일해야한다.
```sh
$ scp -r ~/app/hadoop hadoop@rpi01:~/app/
$ scp -r ~/app/hadoop hadoop@rpi02:~/app/
$ scp -r ~/app/hadoop hadoop@rpi03:~/app/
$ scp -r ~/app/hadoop hadoop@rpi04:~/app/
```

9.HDFS를 최초로 한번 포맷한다.
```sh
$ ~/app/hadoop/bin/hadoop namenode -format
```

10.HDFS 프로세스를 실행한다. 'start-dfs.sh' 스크립트를 실행하면 master 노드 뿐만아니라 slave 노드에서도 HDFS 프로세스를 실행해준다.
```sh
$ ~/app/hadoop/bin/start-dfs.sh
```

11.MapReduce 프로세서를 실행한다. 'start-mapred.sh' 스크립트를 실행하면 master 노드 뿐만아니라 slave 노드에서도 MapReduce 프로세스를 실행해준다.'
```sh
$ ~/app/hadoop/bin/start-mapred.sh
```

12.master 노드와 slave 노드에서 실행 중인 Hadoop 프로세스를 확인한다.
```sh
rpi05:~$ jps
3011 NameNode
3345 SecondaryNameNode
3650 JobTracker
```
```sh
rpi01:~$ jps
1950 TaskTracker
1861 DataNode
```

13.Hadoop 모니터링 사이트를 열어서 동작 상태를 확인한다.
  - http://rpi05:50070
  - http://server01:50070/dfshealth.jsp

14.Hadoop 프로세스 종료 순서는 실행한 역순이다.
```sh
$ ~/app/hadoop/bin/stop-mapred.sh
$ ~/app/hadoop/bin/stop-dfs.sh
```
