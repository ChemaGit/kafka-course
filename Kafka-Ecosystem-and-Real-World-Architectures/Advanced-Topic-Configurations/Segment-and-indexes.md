# Segment and indexes

# Partitions and Segments

	- Topics are made of partitions (we already know that)
	- Partitions are made of .... segments (files)!

	- Only one segment is ACTIVE (the one data is being written to)
	- Two segments settings:
		- log.segment.bytes: the max size of a single segment in bytes
		- log.segment.ms: the time Kafka will wait before committing the segment if not full

# Segment and indexes

	- Segments come with two indexes(files):
		- An offset to position index: allows Kafka where to read to find a message
		- A timestamp to offset index: allows Kafka to find messages with a timestamp
	- Therefore, Kafka knows where to find data in a constant time!


	- $ ls -ltr /var/local/kafka/data
	- $ cd /var/local/kafka/data
	- $ ll flume-kafka-retail-0

# Segments: Why should I care?

	- A smaller log.segment.bytes (size, default: 1GB) means:
		- More segments per partitions
		- Log Compaction happens more often
		- BUT Kafka has to keep more files opened (Error: Too many open files)
	- Ask yourself: how fast will I have new segments based on throughput?

	- A smaller log.segment.ms (time, default 1 week) means:
		- You set a max frequency for log compaction (more frequent triggers)
		- Maybe you want daily compaction instead of weekly?
	- Ask yourself: how often do I need log compaction to happen?


