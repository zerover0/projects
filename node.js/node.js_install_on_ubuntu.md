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
