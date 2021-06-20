FROM docker.io/klakegg/hugo:ext-asciidoctor as hugo

WORKDIR /mnt/projectRoot
ADD . ./
RUN hugo -s src/hugo -d ../../build/hugo