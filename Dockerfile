FROM ubuntu:21.10

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y  pkg-config libavformat58 libavformat-dev libavcodec58 libswscale-dev libswscale5 libavutil-dev libavutil56 ffmpeg libavcodec-dev build-essential autoconf libglew-dev libglfw3-dev cmake gcc libcurl4-gnutls-dev tesseract-ocr libtesseract-dev libleptonica-dev clang libclang-dev curl tesseract-ocr-eng tesseract-ocr-deu tesseract-ocr-fra tesseract-ocr-ita

WORKDIR /rustup

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init && chmod +x rustup-init && ./rustup-init -y
WORKDIR /src

ADD . .

WORKDIR /src/linux

ENV PATH=$PATH:/root/.cargo/bin

RUN ./autogen.sh && ./configure --enable-ffmpeg  --enable-ocr --enable-hardsubx && make -j16

ENV PATH=$PATH:/src/linux