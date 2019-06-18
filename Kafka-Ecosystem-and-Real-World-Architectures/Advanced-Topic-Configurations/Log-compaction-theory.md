# Log compaction theory

# Log Cleanup Policy: Compact

	- Log compaction ensures that your log contains at least the last known value for a specific key within a partition
	- Very useful if we just require a SNAPSHOT instead of full history (such as for a data table in a database)
	- The idea is that we only keep the latest "update" for a key in our log

# Log Compaction: Example

	- Our topic is: employee-salary
	- We want to keep the most recent salary for our employees
	- Segment 0
		- 0 Key=John - salary:80000
		- 1 Key=Mark - salary:90000
		- 2 Key=Lisa - salary:95000
	- Segment 2
		- ...
		- 45 Key=Mark - salary:100000 
		- 46 Key=Lisa - salary:110000

- After compaction

	- New Segment
		- 0 Key=John - salary:80000  <---- Deleted because of newer key available
		- 1 Key=Mark - salary:90000
		- 2 Key=Lisa - salary:95000  <---- Deleted because of newer key available
		- ....
		- 45 Key=Mark - salary:100000 
		- 46 Key=Lisa - salary:110000

# Log Compaction Guarantees

	- Any consumer that is reading from the tail of a log (most current data) will still see all the messages sent to the topic
	- Ordering of messages is kept, log compaction only removes some messages, but does not re-order them
	- The offset of a message is immutable (it never changes). Offsets are just skipped if a message is missing
	- Deleted records can still be seen by consumers for a period of delete.retention.ms (default is 24 hours) 

# Log Compaction Myth Busting

	- It doesn't prevent you from pushing duplicate data to Kafka
		- De-duplication is done after a segment is committed
		- Your consumers will still read tail as soon as the data arrives

	- It doesn't prevent you from reading duplicate data from Kafka
		- Same points as above

	- Log Compaction can fail from time to time
		- It is an optimization and it the compaction thread might crash
		- Make sure you assign enough memory to it and that it gets triggered
		- Restart Kafka if log compaction is broken (this is a bug and may get fixed in the future)

	- You can't trigger Log Compaction using a API call (for now...)

# Log Compaction

	- Log compaction is configured by (log.cleanup.policy=compact):
		- Segment.ms (default 7 days): Max amount of time to wait to close active segment
		- Segment.bytes (default 1G): Max size of a segment
		- Min.compaction.lag.ms (default 0): how long to wait before a message can be compacted
		- Delete.retention.ms (default 24 hours): wait before deleting data marked for compaction
		- Min.Cleanable.dirty.ratio (default 0.5): higher => less, more efficient cleaning. Lower => opposite

