## Kafka Streams Introduction
````text
- You want to do the following from the twitter_tweets topic:
    - Filter only tweets that have over 10 likes or replies
    - Count the number of tweets received for each hashtag every 1 minute

- Or combine the two to get trending topics and hashtags in real time!

- With Kafka Producer and Consumer, you can achieve that but it's very low level and not developer friendly
````

### What is Kafka Streams?
````text
- Easy data processing and transformation library within Kafka
    - Standard Java Application
    - No need to create a separate cluster
    - Highly scalable, elastic and fault tolerant
    - Exactly Once Capabilities
    - One record at a time processing (no batching)
    - Works for any application size

- And we can do:
    - Data Transformations
    - Data Enrichment
    - Fraud Detection
    - Monitoring and Alerting

- It is a serious contender to other processing frameworks such as Apache Spark, Flink, or NiFi
- Active library so prone to some changes in the future
````

### Example Tweets Filtering
````text
- We want to filter a tweets topic and put the results back to Kafka
- We basically want to chain a Consumer with a Producer
- Tweets topic --> consumer --> Application Logic --> Producer --> Filtered topic
- This is complicated and error prone, especially if you want to deal with concurrency and error scenarios
````

