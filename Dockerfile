FROM ubuntu:16.04

RUN sed -i 's/archive.ubuntu.com/asia-east1.gce.archive.ubuntu.com/g' /etc/apt/sources.list && apt update && apt-get install -y lib32z1 xinetd && rm -rf /var/lib/apt/lists/ && rm -rf /root/.cache && apt-get autoclean && rm -rf /tmp/* /var/lib/apt/* /var/cache/* /var/log/*
#apt update && apt-get install -y lib32z1 xinetd && rm -rf /var/lib/apt/lists/ && rm -rf /root/.cache && apt-get autoclean && rm -rf /tmp/* /var/lib/apt/* /var/cache/* /var/log/*

COPY ./pwn.xinetd /etc/xinetd.d/pwn

COPY ./service.sh /service.sh

RUN chmod +x /service.sh

# useradd and put flag
RUN useradd -m sendflag && echo 'flag{21573db0-eb5f-49b6-90be-b605baf33422}' > /home/sendflag/flag.txt

# copy bin
COPY ./bin/sendflag /home/sendflag/sendflag
COPY ./catflag /home/sendflag/bin/sh


# chown & chmod
RUN chown -R root:sendflag /home/sendflag && chmod -R 750 /home/sendflag && chmod 740 /home/sendflag/flag.txt

# copy lib,/bin 
RUN cp -R /lib* /home/sendflag && mkdir /home/sendflag/dev && mknod /home/sendflag/dev/null c 1 3 && mknod /home/sendflag/dev/zero c 1 5 && mknod /home/sendflag/dev/random c 1 8 && mknod /home/sendflag/dev/urandom c 1 9 && chmod 666 /home/sendflag/dev/* 

CMD ["/service.sh"]
