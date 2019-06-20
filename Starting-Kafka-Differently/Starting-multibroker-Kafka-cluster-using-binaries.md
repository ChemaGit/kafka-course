# Starting a multibroker Kafka cluster using binaries

	- $ cd /opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/etc/kafka/conf.dist/
	- $ cp server.properties server0.properties
	- $ cp server.properties server1.properties
	- $ cp server.properties server2.properties
	- $ gedit server1.properties &
		- broker.id=1
		- logs.dir=/var/local/kafka/data1/
		- listeners=PLAINTEXT://:9093
	- $ gedit server1.properties &
		- broker.id=2
		- logs.dir=/var/local/kafka/data2/
		- listeners=PLAINTEXT://:9094
	- $ mkdir /var/local/kafka/data1/
	- $ mkdir /var/local/kafka/data2/

	- $ kafka-server-start /opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/etc/kafka/conf.dist/server0.properties
	- $ kafka-server-start /opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/etc/kafka/conf.dist/server1.properties
	- $ kafka-server-start /opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/etc/kafka/conf.dist/server2.properties

	- $ kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic many-reps --partitions 6 --replication-factor 3
	- $ kafka-topics --zookeeper quickstart.cloudera:2181 --describe --topic many-reps
	- $ kafka-console-producer --broker-list quickstart.cloudera:9092,quickstart.cloudera:9093,quickstart.cloudera:9094 --topic many-reps
		- >hello
		- >how are you
		- >I'm fine
		- >thank you
		- >got a Kafka cluster
		- >awesome
	- stop the producer
	- $ kafka-console-producer --broker-list quickstart.cloudera:9094 --topic many-reps
		- >trying sending messages
		- >to any partition
		- >let's see if it works
	- $ kafka-console-consumer --bootstrap-server quickstart.cloudera:9093 --topic many-reps --from-beginning
		- >hello
		- >how are you
		- >I'm fine
		- >thank you
		- >got a Kafka cluster
		- >awesome
		- >trying sending messages
		- >to any partition
		- >let's see if it works
		
	- If one broker is down, we have two brokers still and we can access to the complete cluster