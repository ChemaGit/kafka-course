# Consumer Poll Behaviour
````text
- Kafka Consumers have a "poll" model, while many other messaging bus in enterprises have a "push" model.
- This allows consumers to control where in the log they want to consume, how fast, and gives them the ability to replay events.

    .poll(Duration timeout)------------->   Broker

Consumer

    Return data inmediately if possible <----- Broker
    Return empty after "timeout"

- Fetch.min.bytes(default 1):
    - Controls how much data you want to pull at least on each request
    - Helps improving throughput and decreasing request number
    - At cost of latency

- Max.poll.records(default 500):
    - Controls how many records to receive per poll request
    - Increase if your messages are very small and have a lot of available RAM
    - Good to monitor how many records are polled per request

- Max.partitions.fetch.bytes(default 1MB):
    - Maximum data returned by the broker per partition
    - If you read from 100 partitions, you'll need a lot of memory (RAM)

- Fetch.max.bytes(default 50MB):
    - Maximum data returned for each fetch request (covers multiple partitions)
    - The consumer performs multiple fetches in parallel

- Change these settings only if your consumer maxes out on throughput already
````

