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
