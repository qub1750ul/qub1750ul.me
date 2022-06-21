FROM docker.io/klakegg/hugo:0.97.2-ext-asciidoctor as hugo

WORKDIR /mnt/projectRoot
ADD . ./
RUN hugo -s src/hugo -d ../../build/hugo