# Kafka Schema Registry introduction

# The need for a schema registry

	- Kafka takes bytes as an input and publishes them
	- No data verification

	- What if the producer sends bad data?
	- What if a field gets renamed?
	- What if the data format changes from one day to another?

	- The Consumers Break!!!

	- We need data to be self describable
	- We need to be able to evolve data without breaking downstream consumers.
	- We need schemas... and a schema registry!

	- What if the Kafka Brokers were verifying the messages they receive?
	- It would break what makes Kafka so good:
		- Kafka doesn't parse or even read your data (no CPU usage)
		- Kafka takes bytes as an input without even loading them into memory (that's called zero copy)
		- Kafka distributes bytes
		- As far as Kafka is concerned, it doesn't even know if your data is an integer, a string, etc

	- The Schema Registry has to be a separate components
	- Producers and Consumers need to be able to talk to it
	- The Schema Registry must be able to reject bad data
	- A common data format must be agreed upon
		- It needs to support schemas
		- It needs to support evolution
		- It needs to be lightweight
	- Enter .... the Confluent Schema Registry
	- And Apache Avro as the data format

# Pipeline without Schema Registry

	- Source Systems ----> Java Producers ----> Kafka ----> Java Consumers ----> Target Systems

# Confluent Schema Registry Purpose

	- Store and retrieve schemas for Producers / Consumers
	- Enforce Backward / Forward / Full compatibility on topics
	- Decrease the size of the payload of data sent to Kafka

		- Send schema			- Schema Registry	- Get schema

	- Producer									                    - Consumer

		- Send Avro Content		- Kafka			- Read Avro content


# Schema Registry: gotchas

	- Utilizing a schema registry has a lot of benefits
	- But it implies you need to 
		- Set it up well
		- Make sure it's highly available
		- Partially change the producer and consumer code
	- Apache Avro as a format is awesome but has a learning curve
	- The schema registry is free and open sourced, created by Confluent (creators of Kafka)
	- As it takes time to setup, we won't cover the usage in this course
