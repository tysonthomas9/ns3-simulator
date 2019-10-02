FROM ubuntu:16.04

LABEL Description="Docker image for NS-3 Network Simulator"

# Needed packages
RUN apt-get update && apt-get install -y \
  git \
  mercurial \
  gcc \
  g++ \
  vim \
  python \
  python-dev \
  python-setuptools \
  qt5-default \
  python-pygraphviz \
  python-kiwi \
  python-pygoocanvas \
  libgoocanvas-dev \
  ipython \
  autoconf \
  cvs \
  bzr \
  unrar \
  gdb \
  valgrind \
  uncrustify \
  flex \
  bison \
  libfl-dev \
  tcpdump \
  gsl-bin \
  libgsl2 \
  libgsl-dev \
  sqlite \
  sqlite3 \
  libsqlite3-dev \
  libxml2 \
  libxml2-dev \
  cmake \
  libc6-dev \
  libc6-dev-i386 \
  libclang-dev \
  llvm-dev \
  automake \
  libgtk2.0-0 \
  libgtk2.0-dev \
  vtun \
  lxc \
  libboost-signals-dev \
  libboost-filesystem-dev \
  make \
  autoconf \
  autoconf-archive \
  automake \
  m4 \
  libtool \
  openvpn \
  easy-rsa

# Create working directory
RUN mkdir -p /usr/ns3
WORKDIR /usr

# Fetch NS-3 source
RUN wget http://www.nsnam.org/release/ns-allinone-3.30.tar.bz2 && tar -xf ns-allinone-3.30.tar.bz2

RUN git clone https://github.com/Nat-Lab/libbgp.git /usr/ns-allinone-3.30/ns-3.30/libbgp

RUN cd /usr/ns-allinone-3.30/ns-3.30/libbgp && ./autogen.sh && ./configure && make && make install

RUN git clone https://github.com/Nat-Lab/ns3-bgp /usr/ns-allinone-3.30/ns-3.30/src/bgp

RUN git clone https://github.com/Nat-Lab/ns3-distributed-bridge /usr/ns-allinone-3.30/ns-3.30/src/distributed-bridge

ADD test.cc /usr/ns-allinone-3.30/ns-3.30/src/scratch/

# Configure and compile NS-3
# RUN cd ns-allinone-3.30 && ./build.py --enable-examples --enable-tests
RUN cd ns-allinone-3.30 && ./build.py

RUN ln -s /usr/ns-allinone-3.30/ns-3.30/ /usr/ns3/

WORKDIR /usr/ns3/

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt && \
  rm /usr/ns-allinone-3.30.tar.bz2