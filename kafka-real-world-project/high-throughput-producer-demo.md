# High Throughput Producer Demo

	- We'll add snappy message compression in our producer
	- snappy is very helpful if your messages are text based, for example log lines or JSON documents
	- snappy has a good balance of CPUA/compression ratio
	- We'll also increase the batch.size to 32KB and introduce a small delay through linger.ms(20 ms)

	- We have to put those lines below in our code

// high throughput producer (at the expense of a bit of latency and CPU usage)

properties.setProperty(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy");

properties.setProperty(ProducerConfig.LINGER_MS_CONFIG, "20");

properties.setProperty(ProducerConfig.BATCH_SIZE_CONFIG, Integer.toString(32*1024)); // 32 KB batch size

	- $ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic twitter_tweets
	- Run the application: TwitterProducer 