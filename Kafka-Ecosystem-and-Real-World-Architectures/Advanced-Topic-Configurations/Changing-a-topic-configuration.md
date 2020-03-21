## Changing a topic configuration

### Advance Kafka - Topic Configurations

### Why should I care about topic config?
````text
- Brokers have defaults for all the topic configuration parameters
- These parameters impact performance and topic behavior

- Some topics may need different values than the defaults
    - Replication Factor
    - # of Partitions
    - Message size
    - Compression level
    - Log Cleanup Policy
    - Min Insync Replicas
    - Other configurations

- A list of configuration can be found at:
    - https://kafka.apache.org/documentation/#brokerconfigs
````

### Some examples
````bash
$ kafka-topics --zookeeper quickstart.cloudera:2181 --list
$ kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic configured-topic --partitions 3 --replication-factor 1
$ kafka-topics --zookeeper quickstart.cloudera:2181 --describe --topic configured-topic
$ kafka-configs --zookeeper quickstart.cloudera:2181 --entity-type topics --entity-name configured-topic --describe
$ kafka-configs --zookeeper quickstart.cloudera:2181 --entity-type topics --entity-name configured-topic --add-config min.insync.replicas=2 --alter
$ kafka-configs --zookeeper quickstart.cloudera:2181 --entity-type topics --entity-name configured-topic --describe
$ kafka-topics --zookeeper quickstart.cloudera:2181 --describe --topic configured-topic
$ kafka-configs --zookeeper quickstart.cloudera:2181 --entity-type topics --entity-name configured-topic --delete-config min.insync.replicas --alter
$ kafka-configs --zookeeper quickstart.cloudera:2181 --entity-type topics --entity-name configured-topic --describe
$ kafka-topics --zookeeper quickstart.cloudera:2181 --describe --topic configured-topic
````

