# PRODUCER BATCHING

## Linger.ms & batch.size
````text
- By default, Kafka tries to send records as soon as possible
    - It will have up to 5 requests in flight, meaning up to 5 messages individually sent at the same time
    - After this, if more messages have to be sent while others are in flight, Kafka is smart and will start batching them while they wait to send themm all at once.

- This smart batching allows Kafka to increase throughput while maintaining very low latency.
- Batches have higher compression ration so better efficiency

- So how can we control the batching mechanism?
    - Linger.ms: Number of milliseconds a producer is willing to waint before sending a batch out. (default 0)
    - By introducing some lag(for example linger.ms=5), we increase the chances of messages being sent together in a batch
    - So at the expense of introducing a small delay, we can increase throughput, compression and efficiency of our producer.
    - If a batch is full (see batch.size) before the end of the linger.ms period, it will be sent to Kafka right away!

- batch.size: Maximum number of bytes that will be included in a batch. The default is 16KB.
- Increasing a batch size to something like 32KB or 64KB can help increasing the compression, throughput, and efficiency of requests
- Any messge that is bigger than the batch size will not be batched
- A batch is allocated per partition, so make sure that you don't set it to a number that's too high, otherwise you'll run waste memory!
- (Note: You can monitor the average batch size metric using Kafka Producer Metrics)
````