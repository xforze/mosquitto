# Import paho-mqtt Client class:                                                                                                                                                                                                                
import paho.mqtt.client as mqtt
import threading
from threading import Thread
import time

f=open('rnd.list.5000')
lines=f.readlines()


n=-1

#def on_connect(client, userdata, flags, rc):
#  print("Connection returned with result code:" + str(rc))

#def on_publish(client, userdata, mid):
#  print(mid)

#def on_disconnect(client, userdata, rc):
#  global n
#  n += 1
#  if n <5000:
#    t = Thread(target=publish, args=(n,))
#    t.start()
#  else:
#    exit


def publish(n):
        print("Run: "+str(n))
        #client = mqtt.Client(client_id="mosq-bvMFqWBanjpOIXw1uG")
        client = mqtt.Client()
#        client.on_disconnect= on_disconnect
        #client.tls_set(ca_certs="ca.crt", certfile="server.crt", keyfile="server.key")
        #client.tls_insecure_set(True)
#        client.connect("10.1.6.21", 1883, 60)
        client.username_pw_set('VS-Server', 'test')
        client.connect("emqx-openshift", 80, 60)
        client.loop_start()
        ret=client.publish("mosq-bvMFqWBanjpOIXw1uG/gw/test", payload = lines[n].rstrip('\n'), qos=2)
        client.loop_stop()
        time.sleep(0.5)
        client.disconnect()
        return 0

while True:
  for i in range(10):
    n += 1
    if n <5000:
      t = Thread(target=publish, args=(n,))
      t.start()
    else:
      exit
  time.sleep(0.1)

