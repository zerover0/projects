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

