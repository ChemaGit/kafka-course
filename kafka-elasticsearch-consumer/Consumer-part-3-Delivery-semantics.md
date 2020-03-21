# Consumer part 3 Delivery semantics

## At Most Once
````text
- At most once: offsets are commited as soon as the message batch is received. 
- If the processing goes wrong, the message will be lost (it won't be read again)
````

## At least Once
````text
- At least once: offsets are committed after the message is processed.
- If the processing goes wrong, the message will be read again.
- This can result in duplicate processing of messages.
- Make sure your processing is idempotent (i.e. processing again the messages won't impact your systems)
````

## Exactly Once
````text
- Exactly once: Can be achieved for Kafka => Kafka workflows using Kafka Streams API. 
- For Kafka => Sink workflows, use an idempotent consumer.
````

## Bottom line
````text
- for most applications you should use at least once processing (we'll see in practice how to do it) and ensure your transformations / processing are idempotent
````

