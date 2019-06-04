# Consumer Offset Reset Behaviour

	- A consumer is expected to read from a log continuously.
	- But if your application has a bug, your consumer can be down
	- If Kafka has a retention of 7 days, and your consumer is down for more than 7 days, the offsets are "invalid"

	- The behavior for the consumer is to then use:
		- auto.offset.reset=latest: will read from the end of the log
		- auto.offset.reset=earliest: will read from the start of the log
		- auto.offset.reset=none: will throw exception if no offset is found

	- Additionally, consumer offsets can be lost:
		- If a consumer hasn't read new data in 1 day (Kafka < 2.0)
		- If a consumer hasn't read new data in 7 days (Kafka >= 2.0)
	- This can be controlled by the broker setting offset.retention.minutes

# Replaying data for Consumers

	- To replay data for a consumer group:
		- Take all the consumers from a specific group down
		- Use kafka-consumer-groups command to set offset to what you want
		- Restart consumers

	- Bottom line:
		- Set proper data retention period & offset retention period
		- Ensure the auto offset reset behavior is the one you expect / want
		- Use replay capability in case of unexpected behaviour
