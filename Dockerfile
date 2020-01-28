FROM ubuntu:18.10

RUN apt update
RUN apt install -y wget build-essential libssl-dev python3 python3-pip vim curl haproxy
RUN wget https://mosquitto.org/files/source/mosquitto-1.6.8.tar.gz
RUN tar -xzf mosquitto-1.6.8.tar.gz
RUN cd mosquitto-1.6.8 && make -j 8 && make install
ADD mqttp /
ADD mp /
ADD rnd.list.5000 /
ADD ca.crt /
ADD server.key /
ADD server.crt /
ADD haproxy.cfg /etc/haproxy/
ADD sub /
RUN chmod a+x /sub
RUN ldconfig
RUN pip3 install paho-mqtt
RUN mkdir /var/run/haproxy


CMD ["/usr/sbin/haproxy","-f","/etc/haproxy/haproxy.cfg","-p","/var/run/haproxy.pid"]
