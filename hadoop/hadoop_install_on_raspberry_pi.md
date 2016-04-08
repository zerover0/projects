### Raspberry Pi에 Hadoop 설치와 구성 안내

##### 설치 환경
* 운영체제: Raspbian Jessie Lite, 2016-02-26 release
* 사용 소프트웨어 버전
  - JDK 1.7 (Raspberry Pi 기본 패키지 버전)
  - Hadoop 2.7

##### 호스트 구성
* 호스트이름과 IP 주소 구성
  - tinyos-34599-01 - 10.0.1.64
  - tinyos-34599-02 - 10.0.1.116
  - tinyos-34599-03 - 10.0.1.147
* 호스트별 서버 구성
  - tinyos-34599-01 : Hadoop NameNode
  - tinyos-34599-02 : Hadoop DataNode
  - tinyos-34599-03 : Hadoop DataNode

##### JDK(Java Development Kit) 설치하기
Hadoop은 모두 Java 기반으로 개발되어 있어서 실행할 때 JDK(혹은 JRE)가 필요합니다.

1.JDK 설치 여부를 확인합니다.
```sh
$ java -version
java version "1.7.0_95"
OpenJDK Runtime Environment (IcedTea 2.6.4) (7u95-2.6.4-1~deb8u1+rpi1)
OpenJDK Zero VM (build 24.95-b01, mixed mode)
```

2.JDK가 설치되어 있지 않다면, 패키지 설치 명령으로 기본 JDK를 설치합니다.
```sh
$ sudo apt-get update
$ sudo apt-get install default-jdk
```

##### 호스트이름 등록과 RSA 키 배포하기
여러 대의 호스트에 분산 환경으로 구축할 때, master 호스트의 서버는 slave 호스트의 서버를 원격으로 제어할 수 있어야합니다. 
master 호스트는 RSA key 기반 인증으로 SSH를 통해서 slave 호스트에 연결하는데, master 호스트의 키를 slave 호스트에 배포해서 암호 확인없이 master에서 slave로 원격 접속할 수 있도록 만듭니다. 
IP 주소보다는 호스트이름을 사용하는 것이 편리하므로 '/etc/hosts' 파일을 이용해서 호스트이름을 등록합니다. 
DNS 서버에 호스트이름을 직접 등록해서 쓸 수도 있지만, 클러스터에 속한 컴퓨터들끼리만 이름을 공유하면 되므로 굳이 DNS에 등록할 필요는 없습니다.

1.master 호스트에서 '/etc/hosts' 파일에 클러스터에 포함된 호스트들의 호스트이름과 IP주소 목록을 추가합니다.
```sh
pi@tinyos-34599-01:~ $ sudo vi /etc/hosts
10.0.1.64  tinyos-34599-01
10.0.1.116 tinyos-34599-02
10.0.1.147 tinyos-34599-03
```

2.master 호스트에서 RSA 키를 생성한 후, 생성된 키를 slave 호스트로 복사합니다. 이때, master에 로그인 아이디('pi')와 slave의 아이디('pi')가 동일해야 합니다.
```sh
pi@tinyos-34599-01:~ $ ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
pi@tinyos-34599-01:~ $ ssh-copy-id pi@tinyos-34599-02
pi@tinyos-34599-01:~ $ ssh-copy-id pi@tinyos-34599-03
```

3.master 호스트에서 slave 호스트로 아이디와 암호 입력없이 로그인할 수 있는지 확인합니다.
```sh
pi@tinyos-34599-01:~ $ ssh tinyos-34599-02
(암호 입력없이 tinyos-34599-02 호스트에 연결됩니다.)
pi@tinyos-34599-02:~ $ exit
pi@tinyos-34599-01:~ $ ssh tinyos-34599-03
(암호 입력없이 tinyos-34599-03 호스트에 연결됩니다.)
pi@tinyos-34599-03:~ $ exit
```

