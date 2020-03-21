## Kafka Cluster SetUp - Hihg Level Architecture
````text
- You want multiple brokers in different data centers (racks) to distribute your load. You also want a cluster of at least 3 zookeeper
- In AWS:
    - us-east-1a(Zookeeper 1, Kafka Broker 1, Kafka Broker 4)
    - us-east-1b(Zookeeper 2, Kafka Broker 2, Kafka Broker 5)
    - us-east-1c(Zookeeper 3, Kafka Broker 3, Kafka Broker 6)
````

### Kafka Cluster SetUp - Gotchas
````text
- It's not easy to setup a cluster
- You want to isolate each Zookeeper & Broker on separate servers
- Monitoring needs to be implemented
- Operations have to be mastered
- You need a really good Kafka Admin

- Alternative: many differen "Kafka as a Service" offerings on the web
- No operational burdens (updates, monitoring, setup, etc....)
````

