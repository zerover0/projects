# Caffe installation on Jetson TK1
JetPack 2.2.1을 Jetson TK1에 설치한다.
JetPack 2.2.1에는 Jetson TK1 용 CUDA toolkit 6.5, cuDNN v2가 포함되어 있다.

### 필요 패키지 설치

```sh
$ sudo apt-get update
$ sudo apt-get install git python-dev python-numpy
$ sudo apt-get install libprotobuf-dev protobuf-compiler libleveldb-dev libsnappy-dev libatlas-base-dev libhdf5-serial-dev libgflags-dev libgoogle-glog-dev liblmdb-dev gfortran cmake
$ sudo apt-get install --no-install-recommends libboost-all-dev
$ sudo ldconfig
$ sudo reboot
```

### GitHub에서 소스 다운로드해서 빌드하기

Caffe 최근 버전에서는 cuDNN v2를 지원하지 않으므로, Jetson TK1에서 지원하는 cuDNN v2을 위한 Caffe fork로부터 소스를 다운로드한다.
```sh
$ git clone https://github.com/RadekSimkanic/caffe-for-cudnn-v2.5.48.git caffe
```

LMDB 설정에 과도한 맵 메모리 크기를 Jetson TK1에 맞게 적당하게 수정한다.
- caffe/src/caffe/util/db_lmdb.cpp:
```
const size_t LMDB_MAP_SIZE = 536870912;  // 0.5 GB
```

Makefile.config 파일에 USE_CUDNN을 설정한다.
```sh
$ cd caffe
$ cp Makefile.config.example Makefile.config
```
- Makefile.config:
```
USE_CUDNN := 1
```

CPU core가 4개 이므로 병렬 빌드를 실행해서 속도를 높인다.
```sh
$ make all -j 4
$ make test -j 4
$ make runtest -j 4
```

아래 명령을 실행해서 잘 동작하는지 확인할 수 있다.
```sh
$ build/tools/caffe time --model=models/bvlc_alexnet/deploy.prototxt --gpu=0
```

### 주의사항
Jetson TK1에 설치한 LMDB는 호환에 문제가 많으므로, Caffe 프로그램으로 트레이이닝이나 테스트를 할 때 LMDB 대신 LEVELDB를 backend로 설정해주어야 한다.
