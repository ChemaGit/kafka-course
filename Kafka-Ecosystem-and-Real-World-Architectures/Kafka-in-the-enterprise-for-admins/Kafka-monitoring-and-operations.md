## Kafka monitoring and operations
````text
- Kafka exposes metrics through JMX
- These metrics are highly important for monitoring Kakfa, and ensuring the systems are behaving correctly under load
- Common places to host Kafka metrics:
    - ELK (ElasticSearch + Kibana)
    - Datadog
    - NewRelic
    - Confluent Control Centre
    - Prometheus
    - Many others...!

- Some of the most important metrics are:
    - Under Replicated Partitions: Number of partitions are have problems with the ISR (in-sync replicas). May indicate a high load the system
    - Request Handlers: utilization of threads for IO, network, etc.... overall utilization of an Apache Kafka broker.
    - Request timing: how long it takes to reply to requests. Lower is better, as latency will be improved.

- Overall hava a look at the documentation here:
    - https://kafka.apache.org/documentation/#monitoring
    - https://docs.confluent.io/current/kafka/monitoring.html
    - https://www.datadoghq.com/blog/monitoring-kafka-performance-metrics/

- Kafka Operations team must be able to perform the following tasks:
    - Rolling Restart of Brokers
    - Updating Configurations
    - Rebalancing Partitions
    - Increasing replication factor
    - Adding a Broker
    - Replacing a Broker
    - Removing a Broker
    - Upgrading a Kafka Cluster with zero downtime
````