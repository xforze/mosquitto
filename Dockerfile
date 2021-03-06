FROM ubuntu:18.10

RUN apt update
RUN apt install -y wget build-essential libssl-dev python3 python3-pip vim curl haproxy git libssl-dev libncurses5 libncurses5-dev
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
RUN ldconfig
RUN pip3 install paho-mqtt
RUN mkdir /var/run/haproxy
RUN wget http://erlang.org/download/otp_src_21.3.tar.gz
RUN tar -xzf otp_src_21.3.tar.gz
RUN cd otp_src_21.3 && ./configure && make -j 8 && make install
RUN cd / && git clone https://github.com/emqx/emqtt-bench.git
RUN cd emqtt-bench && make
RUN cp /emqtt-bench/emqtt_bench /usr/local/bin/emqtt_bench
#CMD ["sleep","infinity"]
CMD ["emqtt_bench","pub","-c","1000","-I","1000","-u","VS-Server","-P","test","-t","mosq-bvMFqWBanjpOIXw1uG/gw/test","-s","256","-q","1","-h","emqx-openshift","-p","1883"]
