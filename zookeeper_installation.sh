#!bin/bash
sudo apt-get update && \
      sudo apt-get -y install wget ca-certificates zip net-tools vim nano tar netcat

# java
sudo apt-get -y install default-jdk

# Disable RAM Swap
sudo sysctl vm.swappiness=1

# Add hosts entries (mocking DNS) - put relevant IPs here
echo "172.31.9.1 kafka1
172.31.9.1 zookeeper1
172.31.19.230 kafka2
172.31.19.230 zookeeper2
172.31.35.20 kafka3
172.31.35.20 zookeeper3" | sudo tee --append /etc/hosts

# download Zookeeper and Kafka. Recommended is latest Kafka (0.10.2.1) and Scala 2.12
wget http://apache.mirror.digitalpacific.com.au/kafka/0.10.2.1/kafka_2.12-0.10.2.1.tgz
tar -xvzf kafka_2.12-0.10.2.1.tgz
rm kafka_2.12-0.10.2.1.tgz
mv kafka_2.12-0.10.2.1 /home/ubuntu/kafka

echo '#!/bin/bash
#/etc/init.d/zookeeper
DAEMON_PATH=/home/ubuntu/kafka/bin
DAEMON_NAME=zookeeper

# See how we were called.
case "$1" in
  start)
        # Start daemon.
        pid=`ps ax | grep -i "org.apache.zookeeper" | grep -v grep | awk "{print $1}"`
        if [ -n "$pid" ]
          then
            echo "Zookeeper is already running";
        else
          echo "Starting $DAEMON_NAME";
          $DAEMON_PATH/zookeeper-server-start.sh -daemon /home/ubuntu/kafka/config/zookeeper.properties
        fi
        ;;
  stop)
        echo "Shutting down $DAEMON_NAME";
        $DAEMON_PATH/zookeeper-server-stop.sh
        ;;
  restart)
        $0 stop
        sleep 2
        $0 start
        ;;
  status)
        pid=`ps ax | grep -i "org.apache.zookeeper" | grep -v grep | awk "{print $1}"`
        if [ -n "$pid" ]
          then
          echo "Zookeeper is Running as PID: $pid"
        else
          echo "Zookeeper is not Running"
        fi
        ;;
  *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit 0' | sudo tee --append /etc/init.d/zookeeper

sudo chmod +x /etc/init.d/zookeeper
sudo chown root:root /etc/init.d/zookeeper
sudo update-rc.d zookeeper defaults
sudo service zookeeper start
