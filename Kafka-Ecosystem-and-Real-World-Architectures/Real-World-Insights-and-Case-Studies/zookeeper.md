## Zookeeper

### Partitions Count, Replication Factor
````text
- The two most important parameters when creating a topic.
- They impact performance and durability of the system overall
- It is best to get parameters right the first time!
    - If the Partitions Count increases during a topic lifecycle, you will break your keys ordering guarantees
    - If the Replication Factor increases during a topic lifecycle, you put more pressure on your cluster, which can lead to unexpected performance decrease
````

### Partitions Count
````text
- Each partition can handle a throughput of a few MB/s(measure it for your setup!)
- More partitions implies:
    - Better parallelism, better throughput
    - Ability to run more consumers in a group to scale
    - Ability to leverage more brokers if you have a large cluster
    - BUT more elections to perform for Zookeeper
    - BUT more files opened on Kafka

- Guidelines
    - Partitions per topic = MILLION DOLLAR QUESTION
        - (Intuition) Small cluster (< 6 brokers): 2 x #brokers
        - (Intuition) Big cluster (> 12 brokers): 1 x #brokers
        - Adjust for number of consumers you need to run in parallel at peak throughput
        - Adjust for producer throughput (increase if super-high throughput or projected increase in the next 2 year)
    - TEST! Every Kafka cluster will have different performance.
    - Don't create a topic with 1000 partitions!
````

### Replication Factor
````text
- Should be at least 2, usually 3, maximum 4
- The higher the replication factor (N):
    - Better resilience of your system (N - 1 brokers can fail)
    - BUT more replication (higher latency if acks=all)
    - BUT more disk space on your system (50% more if RF is 3 instead of 2)

- Guidelines:
    - Set it to 3 to get started (you must have at least 3 brokers for that)
    - If replication performance is an issue, get a better broker instead of less RF
    - Never set it to 1 in production
````

### Cluster Guidelines
````text
- It is pretty much accepted that a broker should not hold more than 2000 to 4000 partitions (across all topics of that broker) 
- Additionally, a Kafka cluster should have a maximum of 20000 partitions across all brokers
- The reason is that in case of brokers going down, Zookeeper needs to perform a lot of leader elections
- If you need more partitions in your cluster, add brokers instead
- If you need more than 20000 partitions in your cluster (it will take time to get there!), follow the Netflix model and create more Kafka clusters.
- Overall, you don't need a topic with 1000 partitions to achieve high throughput.
- Start at a reasonable number and test the perfomance
````