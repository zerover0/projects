# Caffe installation on Jetson TX1
JetPack 2.2.1 32 비트 버전을 Jetson TX1에 설치한다.
ARM 용 Linux 배포 패키지들이 아직 64 비트용 Linux와 호환성에서 문제가 있는 것으로 알려져있고, 일부는 64 비트용을 제공하지 않아서 ARM 시스템에는 32 비트용 Linux를 사용하는 것을 권장한다.
JetPack 2.2.1에는 Jetson TX1 용 CUDA toolkit 7.0, cuDNN v5가 포함되어 있다.

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

GitHub에서 최신 소스를 다운로드한다.
```sh
$ git clone https://github.com/BVLC/caffe.git caffe
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
