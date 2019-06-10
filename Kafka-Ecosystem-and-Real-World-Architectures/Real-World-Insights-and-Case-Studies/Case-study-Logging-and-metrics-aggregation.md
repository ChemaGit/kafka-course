# Case study Logging and metrics aggregation

# Logging and metrics aggregation

	- Application 1	---->	Log forwarders	---> 	application_logs(topic)	---->	Kafka Connect Sink --> 	Splunk
	- Application 2	---->	Log forwarders	---> 	application_logs(topic)	---->	Kafka Connect Sink --> 	Splunk
	- Application 3	---->	Log forwarders	---> 	application_logs(topic)	---->	Kafka Connect Sink --> 	Splunk
	- Application 1	---->	Metric collectors	---> 	application_metrics(topic)	---->	Kafka Connect Sink --> 	Splunk
	- Application 2	---->	Metric collectors	---> 	application_metrics(topic)	---->	Kafka Connect Sink --> 	Splunk
	- Application 3	---->	Metric collectors	---> 	application_metrics(topic)	---->	Kafka Connect Sink --> 	Splunk