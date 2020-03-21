# Producer Default Partitioner and how keys are hashed
````text
- By default, your keys are hashed using the "murmur2" algorithm.
- It is most likely preferred to not override the behavior of the partitioner, but it is possible to do so(partitioner.class)
- It's strongly recommended not modify this file if you don't know well what you are doing.
- The formula is: targetPartition = Utils.abs(Utils.murmur2(record.key())) % numPartitions;
- This means that same key will go to the same partition (we already know this), and adding partitions to a topic will completely alter the formula.
````

# Max.blocks.ms & buffer.memory
````text
- If the producer produces faster than the broker can take, re records will be buffered in memory
- buffer.memory=33554432(32MB): the size of the send buffer
- That buffer will fill up over time and fill back down when the throughput to the broker increases

- If that buffer is full (all 32MB), then the .send() method will start to block (won't return right away)
- max.block.ms=60000: the time the .send() will block until throwing an exception.
- Exceptions are basically thrown when
    - The producer has filled up its buffer
    - The broker is not accepting any new data
    - 60 seconds has elapsed

- If you hit an exception hit that usually means your brokers are down or overloaded as the can't respond to requests
````

