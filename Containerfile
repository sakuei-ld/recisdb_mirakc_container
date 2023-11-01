FROM registry.fedoraproject.org/fedora-minimal:latest

# Rust のインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Rust のインストール先を PATH に追加
ENV PATH="/root/.cargo/bin:${PATH}"

# git のインストール
RUN dnf5 install -y git

# recisdb に必要なパッケージをインストール
RUN dnf5 install -y gcc gcc-c++ make cmake pcsc-lite-devel clang-devel

# 作業先を作成&移動
RUN mkdir /root/temp
WORKDIR /root/temp

# recisdb を clone
RUN git clone --recursive https://github.com/kazuki0824/recisdb-rs.git

WORKDIR /root/temp/recisdb-rs

# b25-sys/build.rs を書き換える (修正が入るまでの仮)
RUN sed -i 's/lib"/lib64"/' ./b25-sys/build.rs

# b_cas_card.c を proxy ver に。
#RUN rm ./b25-sys/externals/libaribb25/aribb25/b_cas_card.c
#COPY ./b_cas_card.c ./b25-sys/externals/libaribb25/aribb25/

RUN cargo build --release
RUN cp -a target/release/recisdb /usr/local/bin

# 作業先を移動
WORKDIR /root/temp

# mirakc-arib に必要なパッケージをインストール
RUN dnf5 install -y autoconf automake dos2unix ninja patch libtool

# mirakc-arib を clone
RUN git clone --recursive https://github.com/mirakc/mirakc-arib.git

WORKDIR /root/temp/mirakc-arib

RUN cmake -S . -B build -G Ninja -D CMAKE_BUILD_TYPE=Release
RUN ninja -C build vendor
RUN ninja -C build
RUN build/bin/mirakc-arib -h

# 作業先を移動
WORKDIR /root/temp

# mirakc を clone
RUN git clone --recursive https://github.com/mirakc/mirakc.git

WORKDIR /root/temp/mirakc
RUN cargo build --release
RUN cp -a target/release/mirakc /usr/local/bin

RUN dnf5 install -y rotatelogs

ENV RUST_LOG=info,mirakc=debug
ENV MIRAKC_DEBUG_CHILD_PROCESS=1
ENV MIRAKC_ARIB_LOG=info,filter-service=debug,filter-program=debug
ENV MIRAKC_ARIB_LOG_NO_TIMESTAMP=1
ENV MIRAKC_CONFIG=/etc/mirakc/config.yml
ENV MIRAKC_LOGS=/var/lib/mirakc/logs

ENTRYPOINT /usr/local/bin/mirakc | /usr/sbin/rotatelogs $MIRAKC_LOGS/mirakc_log.%Y%m%d 86400 540