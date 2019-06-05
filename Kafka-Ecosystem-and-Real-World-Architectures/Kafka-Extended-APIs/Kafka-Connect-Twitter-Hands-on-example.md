# Kafka Connect Twitter Hands-on example
	
	- Google: Kafka Connect Confluent --> https://www.confluent.io/hub/
	- We are going to use Twitter (Source)
	- https://github.com/jcustenborder/kafka-connect-twitter
	- tab releases and choose kafka-connect-twitter-0.2.26.tar.gz --> download
	- we create a folder in our project "kafka-connect --> connectors --> kafka-connect-twitter" and put the jar files in there
	- $ cd /opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/lib/kafka/bin/
	- $ ./connect-standalone.sh --> USAGE: ./connect-standalone.sh [-daemon] connect-standalone.properties
	- add this line: plugin.path=/home/cloudera/IdeaProjects/kafkacourse/kafka-connect/connectors
	- $ sudo find -name connect-standalone.properties --> /opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/etc/kafka/conf.dist/connect-standalone.properties
	- copy connect-standalone.properties in our project directory kafka-connects/connectors
	- $ sudo cp connect-standalone.properties /home/cloudera/IdeaProjects/kafkacourse/kafka-connect/connectors/
	- edit twitter.properties under connectors directory

name=TwitterSourceDemo

tasks.max=1

connector.class=com.github.jcustenborder.kafka.connect.twitter.TwitterSourceConnector

#Set these required values

process.deletes=false

filter.keywords=bitcoin

kafka.status.topic=twitter_status_connect

kafka.delete.topic=twitter_deletes_connect

twitter.oauth.consumerKey=xxx our own credentials

twitter.oauth.consumerSecret=xxx

twitter.oauth.accessToken=xxx

twitter.oauth.accessTokenSecret=xxx

	- $ kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic twitter_status_connect --partitions 3 --replication-factor 1
	- $ kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic twitter_deletes_connect --partitions 3 --replication-factor 1
	- $ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic twitter_status_connect --from-beginning
	- $ cd /home/cloudera/IdeaProjects/kafkacourse/kafka-connect/connectors
	- edit run.sh under connectors directory

#!/usr/bin/env bash
#run the twitter connector
#connect-standalone connect-standalone.properties twitter.properties
#OR (linux / mac OSX)
/opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/lib/kafka/bin/connect-standalone.sh connect-standalone.properties twitter.properties
#OR (Windows)
#connect-standalone.bat connect-standalone.properties twitter.properties

	- Run the consumer: $ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic twitter_status_connect --from-beginning
	- Run the producer run.sh from our directory project /home/cloudera/IdeaProjects/kafkacourse/kafka-connect/connectors/
	- or from command shell
	- $ ./opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/lib/kafka/bin/connect-standalone.sh /home/cloudera/flume_demo/kafkaconnectdemo/connect-standalone.properties /home/cloudera/flume_demo/kafkaconnectdemo/connect-file-source.properties