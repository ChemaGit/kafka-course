# MESSAGE COMPRESSION
````text
- Producer usually send data that is text-based, for example with JSON data
- In this case, it is important to apply compression to the producer.

- Compression is enabled at the Producer level and doesn't require any configuration change in the Brokers or in the Consumers
- "compression.type" can be 'none'(default), 'gzip', 'lz4', 'snappy'

- Compression is more effective the bigger the batch of message being sent to Kafka!
- Benchmarks here: https://blog.cloudflare.com/squeezing-the-firehose/

- Producer Batch MSG1 - MSG2 - MSG3 - ... - MSG100 ====> Compressed Messages(Compressed Producer Batch, Big decrease in size!) ===> Send to Kafka

- The compressed batch has the following advantage:
    - Much smaller producer request size (compression ratio up to 4x!)
    - Faster to transfer data over the network => less latency
    - Better throughput
    - Better disk utilisation in Kafka(stored messages on disk are smaller)
- Disavantages(very minor):
    - Producers must commit some CPU cycles to compression
    - Consumers must commit some CPU cycles to decompression
- Overall:
    - Consider testing snappy or lz4 for optimal spedd / compression ratio
````
## MESSAGE COMPRESSION RECOMMENDATIONS
````text
- Find a compression algorithm that gives you the best performance for your specific data. Test all of them!
- Always use compression in production and especially if you have high throughput
- Consider tweaking linger.ms and batch.size to have bigger batches, and therefore more compression and higher throughput
````