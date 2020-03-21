## ZooKeeper

### Kafka Multi Cluster + Replication
````text
- Kafka can only operate well in a single region
- Therefore, it is very common for enterprises to have Kafka clusters across the world, with some level of replication between them

- A replication application at its core is just a consumer + a producer
- There are different tools to perform it:
    - Mirror Maker - open source tool that ships with Kafka
    - Netflix uses Flink - they wrote their own application
    - Uber uses uReplicator - addresses performance and operations issues with MM
    - Comcast has their own open source Kafka Connect Source
    - Confluent has their own Kafka Connect Source (paid)

- Overall, try these and see if it works for your use case before writing your own

- There are two designs for cluster replication:
    - Active ==> Passive
        - You want to have an aggreagation cluster (for example for analytics)
        - You want to create some form of disaster recovery strategy (it's hard)
        - Cloud Migration (from on-premise cluster to Cloud cluster)
    - Active ==> Active
        - You have a global application
        - You have a global dataset

    - Replicating doesn't preserve offsets, just data!
````