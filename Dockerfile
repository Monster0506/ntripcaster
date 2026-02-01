FROM ubuntu:22.04 AS builder

COPY ntripcaster /ntripcaster

WORKDIR /ntripcaster

RUN apt-get update && apt-get install build-essential --assume-yes

RUN ./configure

RUN make install

RUN cp /usr/local/ntripcaster/conf/ntripcaster.conf.dist /usr/local/ntripcaster/conf/ntripcaster.conf && \
    cp /usr/local/ntripcaster/conf/sourcetable.dat.dist /usr/local/ntripcaster/conf/sourcetable.dat && \
    sed -i '/^port 80$/d' /usr/local/ntripcaster/conf/ntripcaster.conf

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/ntripcaster/ /usr/local/ntripcaster/
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080 2101
WORKDIR /usr/local/ntripcaster

CMD ["/start.sh"]
