# Caffe installation on Ubuntu 14.04

### 필요 패키지 설치

패키지 설치 후에 시스템을 부팅하는 것이 좋다.
```sh
$ sudo apt-get update
$ sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev python-dev libgflags-dev libgoogle-glog-dev liblmdb-dev
$ sudo apt-get install --no-install-recommends libboost-all-dev
$ sudo ldconfig
$ sudo reboot
```

### Anaconda2를 설치해서 사용하는 경우

Anaconda2 설치 디렉토리 아래에 있는 library 경로를 LD_LIBRARY_PATH에 추가한다.
- ~/.bashrc:
```
export LD_LIBRARY_PATH=$HOME/anaconda2/lib:$LD_LIBRARY_PATH
```

### GitHub에서 소스 다운로드해서 빌드하기

GitHub에서 최신 소스를 다운로드한다.
```sh
$ git clone https://github.com/BVLC/caffe.git
```

Makefile.config 파일에 cuDNN과 Anaconda 등을 설정한다.
```sh
$ cd caffe
$ cp Makefile.config.example Makefile.config
```
- 수정파일: Makefile.config
  - cuDNN 설정:
```
USE_CUDNN := 1
```
- 수정파일: Makefile.config
  - Anaconda 경로 설정:
```
# PYTHON_INCLUDE := /usr/include/python2.7 \
#                 /usr/lib/python2.7/dist-packages/numpy/core/include
ANACONDA_HOME := $(HOME)/anaconda
PYTHON_INCLUDE := $(ANACONDA_HOME)/include \
           $(ANACONDA_HOME)/include/python2.7 \
           $(ANACONDA_HOME)/lib/python2.7/site-packages/numpy/core/include \
# PYTHON_LIB := /usr/lib
PYTHON_LIB := $(ANACONDA_HOME)/lib
```

CPU core 개수에 따라 병렬 빌드를 실행해서 속도를 높인다.
```sh
$ make all -j 4
$ make test -j 4
$ make runtest -j 4
```
