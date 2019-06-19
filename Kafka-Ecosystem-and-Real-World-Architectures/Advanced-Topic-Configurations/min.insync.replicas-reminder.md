# min.insync.replicas reminder

	- Acks=all must be used in conjunction with min.insync.replicas
	- min.insync.replicas can be set at the broker or topic level (override)

	- min.insync.replicas=2 implies that at least 2 brokers that are ISR(including leader) must respond that they have the data
	- That means if you use replication.factor=3, min.insync=2,acks=all, you can only tolerate 1 broker going down, otherwise the producer will receive an exception on send

	- $ kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic highly-durable --partitions 3 --replication-factor 1
	- $ kafka-configs --zookeeper quickstart.cloudera:2181 --entity-type topics --entity-name highly-durable --alter --add-config min.insync.replicas=2