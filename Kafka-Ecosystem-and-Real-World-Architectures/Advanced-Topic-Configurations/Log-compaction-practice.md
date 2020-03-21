## Log compaction practice

### Log Compaction: Example
````text
- Our topic is: employee-salary
- We want to keep the most recent salary for our employees
- Segment 0
    - 0 Key=John - salary:80000
    - 1 Key=Mark - salary:90000
    - 2 Key=Lisa - salary:95000
- Segment 2
    - ...
    - 45 Key=Mark - salary:100000 
    - 46 Key=Lisa - salary:110000

- After compaction
	- New Segment
		- 0 Key=John - salary:80000  <---- Deleted because of newer key available
		- 1 Key=Mark - salary:90000
		- 2 Key=Lisa - salary:95000  <---- Deleted because of newer key available
		- ....
		- 45 Key=Mark - salary:100000 
		- 46 Key=Lisa - salary:110000
````

### 1-log-compaction.sh
````bash
#!/bin/bash
#create our topic with appropiate configs
kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic employee-salary --partitions 1 --replication-factor 1 --config cleanup.policy=compact --config min.cleanable.dirty.ratio=0.001 --config segment.ms=5000
#Describe Topic Configs
kafka-topics --zookeeper quickstart.cloudera:2181 --describe --topic employee-salary
#in a new tab, we start a consumer
kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic employee-salary --from-beginning --property print.key=true --property key.separator=,
#we start pushing data to the topic
kafka-console-producer --broker-list quickstart.cloudera:9092 --topic employee-salary --property parse.key=true --property key.separator=,
````

````bash
$ kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic employee-salary --partitions 1 --replication-factor 1 --config cleanup.policy=compact --config min.cleanable.dirty.ratio=0.001 --config segment.ms=5000
$ kafka-topics --zookeeper quickstart.cloudera:2181 --describe --topic employee-salary
$ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic employee-salary --from-beginning --property print.key=true --property key.separator=,
$ kafka-console-producer --broker-list quickstart.cloudera:9092 --topic employee-salary --property parse.key=true --property key.separator=,

>Mark,salary: 10000
>Lucy,salary: 20000
>Bob,salary: 15000
>Patrick,salary: 30000

$ cd /var/local/kafka/data/employee-salary-0
$ ll /var/local/kafka/data/employee-salary-0

# stop the producer and restart
$ kafka-console-producer --broker-list quickstart.cloudera:9092 --topic employee-salary --property parse.key=true --property key.separator=,
>Mark,salary: 10000
>Lucy,salary: 20000
>Bob,salary: 15000
>Patrick,salary: 30000
>Mark,salary: 15000
>Patrick,salary: 25000
>John,salary: 10000

# stop the consumer and restart
$ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic employee-salary --from-beginning --property print.key=true --property key.separator=,	
>Lucy,salary: 20000
>Bob,salary: 15000	
>Mark,salary: 15000
>Patrick,salary: 25000
>John,salary: 10000
>Stephane,salary: 15000
````






