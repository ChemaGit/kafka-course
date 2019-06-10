# Case study Big data ingestion

	- It is common to have "generic" connectors or solutions to offload data from Kafka to HDFS, Amazon S3, and ElasticSearch for example
	- It is also very common to have Kafka serve a "speed layer" for real time applications, while having a "slow layer" which helps with data ingestions into stores for later analytics
	- Kafka as a fromt to Big Data Ingestion is a common pattern in Big Data to provide an "ingestion buffer" in front of some stores

# Big Data Ingestion

	- Data Producers:
		- Apps	--> 		Kafka
		- Website -->		Kafka
		- Financial Systems -->	Kafka		---> Spark,Storm, Flink, etc...	--> 	Real time analytics, Dashboards/Alerts,Apps/Consumers ----- REALTIME
		- Email -->		Kafka
		- Customer Data --> 	Kafka
		- Databases --> 	Kafka

		- Apps	--> 		Kafka
		- Website -->		Kafka
		- Financial Systems -->	Kafka		---> Kafka Connect --> Hadoop,Amazon S3,RDBMS	--> Data Scienct,Reporting,Audit,Backup/Long term Storage ----- BATCH
		- Email -->		Kafka
		- Customer Data --> 	Kafka
		- Databases --> 	Kafka

