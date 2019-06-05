# Kafka Connect introduction

	- Do you feel you're not the first person in the world to write a way to get data out of Twitter?
	- Do you feel like you're not the first person in the world to send data from Kafka to PostgreSQL / ElasticSearch / MongoDB?
	- Additionally, the bugs you'll have, won't someone have fixed them already?
	- Kafka Connect is all about code & connectors re-use!

# Kafka Connect API A brief history

	- (2013) Kafka 0.8.x:
		- Topic replication, Log compaction
		- Simplified producer client API
	- (Nov 2015) Kafka 0.9.x:
		- Simplified high level consumer APIs, without Zookeeper dependency
		- Added security (Encryption and Authentication)
		- Kafka Connects APIs
	- (May 2016): Kafka 0.10.0:
		- Kafka Streams APIs
	- (end 2016 - March 2017) Kafka 0.10.1, 0.10.2:
		- Improved Connect API, Single Message Transform API

# Why Kafka Connect and Streams

	- Four Common Kafka Use Cases:

		- Source => Kafka	Produer API		Kafka Connect Source
		- Kafka => Kafka	Consumer,Producer API	Kafka Streams
		- Kafka => Sink		Consumer API		Kafka Connect Sink
		- Kafka => App		Consumer API

	- Programmers always want to import data from the same sources:
		- Databases, JDBC, Couchbase, GoldenGate, SAP HANA, Blockchain, Cassandra, DynamoDB, FTP, IOT, MongoDB, MQTT, RethinkDB, Salesforce, Solr, SQS, Twitter, etc....
		- Programmers always want to store data in the same sinks:
			- S3, ElasticSearch, HDFS, JDBC, SAP HANA, DocumentDB, Cassandra, DynamoDB, HBase, MongoDB, Redis, Solr, Splunk, Twitter
		- It is tough to achieve Fault Tolerance, Idempotence, Distribution, Ordering
		- Other programmers may already have done a very good job!

# Kafka Connect - High level

	- Source Connectors to get data from Common Data Sources
	- Sink Connectors to publish that data in Common Data Stores
	- Make it easy for non-experienced dev to quickly get their data reliably into Kafka
	- Part of your ETL pipeline
	- Scaling made easy from small pipelines to company-wide pipelines
	- Re-usable code!