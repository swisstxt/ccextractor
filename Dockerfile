FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libgpac-dev libglew-dev libglfw3-dev cmake gcc libcurl4-gnutls-dev tesseract-ocr libtesseract-dev libleptonica-dev clang libclang-dev pkg-config libavformat60 libavformat-dev libavcodec60 libswscale-dev libswscale7 libavutil-dev libavutil58 ffmpeg libavcodec-dev build-essential autoconf libglew-dev libglfw3-dev cmake gcc libcurl4-gnutls-dev tesseract-ocr libtesseract-dev libleptonica-dev clang libclang-dev curl tesseract-ocr-eng tesseract-ocr-deu tesseract-ocr-fra tesseract-ocr-ita

WORKDIR /rustup

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init && chmod +x rustup-init && ./rustup-init -y
WORKDIR /src

ADD . .

WORKDIR /src/linux

ENV PATH=$PATH:/root/.cargo/bin

# RUN ./autogen.sh && ./configure --enable-ffmpeg  --enable-ocr --enable-hardsubx && make -j16
ENV FFMPEG_INCLUDE_DIR=/usr/include/x86_64-linux-gnu 
ENV FFMPEG_PKG_CONFIG_PATH=/usr/lib/pkgconfig
ENV RUST_BACKTRACE=full
RUN apt-get install -y libavdevice-dev libxcb-shm0-dev libxcb-shm0
RUN ./build -hardsubx

ENV PATH=$PATH:/src/linux