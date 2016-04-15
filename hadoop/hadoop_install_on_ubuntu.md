### Ubuntu에 Hadoop 설치와 구성 안내

##### 설치 환경
* 운영체제
  - Ubuntu 14.04, x86 64-bit
* 사용 소프트웨어 버전
  - JDK 1.7
  - Hadoop 2.7

##### 호스트 구성
* 호스트이름과 IP 주소 구성
  - tinyos-34599-00 - 192.168.0.200
  - tinyos-34599-00 - 192.168.0.201
  - tinyos-34599-00 - 192.168.0.202
* 호스트별 서버 구성
  - tinyos-34599-00 : Hadoop NameNode
  - tinyos-34599-01 : Hadoop DataNode
  - tinyos-34599-02 : Hadoop DataNode

##### 하둡 관리자용 계정 생성
하둡과 관련 프로그램을 실행하고 관리할 계정을 만듭니다. 기존 계정을 사용해도 상관없지만, 하둡 클러스터에 속한 모든 호스트에 동일한 아이디가 있어야 합니다.

1.'hadoop' 계정을 만듭니다.
```sh
$ sudo adduser hadoop
```

2.만일, 'hadoop' 계정을 만들 때 암호를 입력하지 않았다면, 암호를 생성합니다.
```sh
$ sudo passwd hadoop
```

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
master 호스트는 RSA key 기반 인증으로 SSH를 통해서 slave 호스트에 연결하는데, master 호스트의 키를 slave 호스트에 배포해서 암호 확인없이 master에서 slave로 원격 접속할 수 있도록 만들면 편리합니다. 
IP 주소보다는 호스트이름을 사용하는 것이 편리하므로 '/etc/hosts' 파일을 이용해서 호스트이름을 등록합니다. 
DNS 서버에 호스트이름을 직접 등록해서 쓸 수도 있지만, 클러스터에 속한 컴퓨터들끼리만 이름을 공유하면 되므로 굳이 DNS에 등록할 필요는 없습니다.

1.master 호스트에서 '/etc/hosts' 파일에 하둡 클러스터에 포함된 호스트의 호스트이름과 IP주소 목록을 추가합니다.
```sh
hadoop@tinyos-34599-00:~ $ sudo vi /etc/hosts
192.168.0.200   tinyos-34599-00
192.168.0.201   tinyos-34599-01
192.168.0.202   tinyos-34599-02
```

2.master 호스트에서 RSA 키를 생성한 후, 생성된 키를 slave 호스트로 복사합니다. 이때, master 호스트 로그인 아이디('hadoop')가 slave 호스트에도 동일하게 있어야 합니다. slave 호스트에 'hadoop' 계정이 없다면 생성한 후 키를 복사합니다.
```sh
hadoop@tinyos-34599-00:~ $ ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
hadoop@tinyos-34599-00:~ $ ssh-copy-id hadoop@tinyos-34599-01
hadoop@tinyos-34599-00:~ $ ssh-copy-id hadoop@tinyos-34599-02
```

3.
