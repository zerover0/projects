#### Ubuntu 14.04에 Node.js 설치하기

NodeSource Debian and Ubuntu binary distributions repository (이전 Chris Lea's Launchpad PPA)에서 Node.js를 다운로드할 수 있습니다. 아래 GitHub에서 저장소 관련 정보와 필요한 스크립트 파일을 받을 수 있습니다.
  - https://github.com/nodesource/distributions

1.Node.js 릴리즈 저장소 정보를 업데이트합니다.
```sh
$ curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - 
```
  - 이때, curl 프로그램이 설치되어 있지 않다면, 다음 명령으로 설치합니다.
```sh
$ sudo apt-get install curl
```

2.Node.js를 설치합니다.
```sh
$ sudo apt-get install -y nodejs 
$ node -v
v4.4.1
```

3.npm을 써서 native addons을 사용하려면 build-essential 패키지가 필요합니다.  
```sh
$ sudo apt-get install -y build-essential 
```

4.설치가 성공했는지 확인하기 위해 테스트 스크립트를 실행합니다.
```sh
$ curl -sL https://deb.nodesource.com/test | bash -
```

#### Raspbian Jessie Lite에 Node.js 설치하기

1.Node.js release 파일을 다운로드해서 압축을 풀고 디렉토리를 이동합니다.
  - BCM2835 ARM11 기반 모델 : Raspberry Pi Model A, B, B+ and Compute Module:
```sh
$ wget https://nodejs.org/dist/v4.0.0/node-v4.0.0-linux-armv6l.tar.gz 
$ tar -xvf node-v4.0.0-linux-armv6l.tar.gz 
$ cd node-v4.0.0-linux-armv6l
```
  - BCM2836 ARM Cortex-A7 기반 : Raspberry Pi 2 Model B:
```sh
$ wget https://nodejs.org/dist/v4.0.0/node-v4.0.0-linux-armv7l.tar.gz 
$ tar -xvf node-v4.0.0-linux-armv7l.tar.gz 
$ cd node-v4.0.0-linux-armv7l
```
  - BCM2837 ARM Cortex-A53 기반 : Raspberry Pi 3 Model B:
```sh
$ wget https://nodejs.org/dist/v4.0.0/node-v4.0.0-linux-arm64.tar.gz 
$ tar -xvf node-v4.0.0-linux-arm64.tar.gz 
$ cd node-v4.0.0-linux-arm64
```

2.모든 파일을 '/usr/local/'로 복사합니다.
```sh
$ sudo cp -R * /usr/local/
```

3.npm을 써서 native addons을 사용하려면 build-essential 패키지가 필요합니다.  
```sh
$ sudo apt-get install -y build-essential 
```

4.설치된 nodejs 버전을 확인합니다.
```sh
$ node -v
v4.4.1
```
