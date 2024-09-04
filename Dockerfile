FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential clang cmake curl ffmpeg gcc libavcodec-dev libavcodec60 libavdevice-dev libavformat-dev libavformat60 libavutil-dev libavutil58 libclang-dev libcurl4-gnutls-dev libglew-dev libglfw3-dev libgpac-dev liblept5 libleptonica-dev liblzma-dev libswscale-dev libswscale7 libtesseract-dev libxcb-shm0 libxcb-shm0-dev pkg-config tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng tesseract-ocr-fra tesseract-ocr-ita

WORKDIR /rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init && chmod +x rustup-init && ./rustup-init -y
ENV PATH=$PATH:/root/.cargo/bin

RUN apt-get update && apt-get install -y pkg-config
RUN apt-get update && apt-get install -y liblept5 libleptonica-dev

RUN pkg-config --cflags libavcodec && \
pkg-config --cflags libavformat  && \
pkg-config --cflags libavutil  && \
pkg-config --cflags libswscale  && \
pkg-config --libs libavcodec && \
pkg-config --libs libavformat && \
pkg-config --libs libavutil && \
pkg-config --libs libswscale && \
pkg-config --libs --cflags lept

WORKDIR /src

ADD . .

WORKDIR /src/linux

# RUN ./configure --enable-hardsubx
# RUN make ENABLE_HARDSUBX=yes

# RUN ./autogen.sh && ./configure --enable-ffmpeg  --enable-ocr --enable-hardsubx && make -j16
ENV FFMPEG_INCLUDE_DIR=/usr/include/x86_64-linux-gnu 
ENV FFMPEG_PKG_CONFIG_PATH=/usr/lib/pkgconfig
ENV RUST_BACKTRACE=full
RUN apt-get install -y libavdevice-dev libxcb-shm0-dev libxcb-shm0
RUN ./build -hardsubx

# ENV PATH=$PATH:/src/linuxautoconf

