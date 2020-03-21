## Log cleanup policies
````text
- Many Kafka clusters make data expire, according to a policy
- That concept is called log cleanup.

- Policy 1: log.cleanup.policy=delete (Kafka default for all user topics)
    - Delete based on age of data (default is a week)
    - Delete based on max size of log (default is -1 == infinite)

- Policy 2: log.cleanup.policy=compact (Kafka default for topic __consumer_offsets)
    - $ kafka-topics --zookeeper quickstart.cloudera:2181 --describe --topic __consumer_offsets
    - Delete based on keys of your messages
    - Will delete old duplicate keys after the active segment is committed
    - Infinite time and space retention
````

### Log Cleanup: Why and When?
````text
- Deleting data from Kafka allows you to:
    - Control the size of the data on the disk, delete obsolete data
    - Overall: Limit maintenace work on the Kafka Cluster

- How often does log cleanup happen?
    - Log cleanup happens on your partition segments!
    - Smaller / More segments means that log cleanup will happen more often!
    - Log cleanup shouldn't happen too often => takes CPU and RAM resources
    - The cleaner checks for work every 15 seconds (log.cleaner.backoff.ms)
````
