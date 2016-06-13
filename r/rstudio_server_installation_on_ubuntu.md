### Ubuntu Linux 서버에 RStudio Server 설치하기

1.Rstudio repository 추가
```sh
$ sudo vi /etc/apt/sources.list
deb http://healthstat.snu.ac.kr/CRAN/bin/linux/ubuntu trusty/
```
2.Rstudio repository의 public key 추가
```sh
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
```
3.R base package설치
```sh
$ sudo apt-get update
$ sudo apt-get install r-base 
```
4.Rstudio package 다운로드 후 설치
```sh
$ wget https://download2.rstudio.org/rstudio-server-0.99.902-amd64.deb
$ sudo dpkg -i rstudio-server-0.99.902-amd64.deb
```
5.R java config 업데이트 (rJava 패키지 사용을 위해서)
  - 'java.conf'에 추가하는 경로는 실제로 JRE가 설치된 디렉토리로 수정
```sh
$ sudo vi /etc/ld.so.conf.d/java.conf
/usr/lib/jvm/default-java/jre/lib/amd64
/usr/lib/jvm/default-java/jre/lib/amd64/server
$ sudo ldconfig
$ sudo R CMD javareconf
```
6.Rsutido 재실행
```sh
$ sudo rstudio-server stop
$ sudo rstudio-server start
```
7.Rstudio 서버에 웹브라우저로 연결하기 (Linux 계정 사용)
  > http://ubuntu01:8787
