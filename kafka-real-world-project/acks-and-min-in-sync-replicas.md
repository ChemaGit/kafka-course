# ACKS AND MIN IN SYNC REPLICAS

	- Producers Acks Deep Dive

		- acks = 0 (no acks)
			- No response is requested
			- If the broker goes offline or an exception happens, we won't know an will lose data.
			- Useful for data where it's okay to potencially lose messages:
				- Metrics collection
				- Log collection

		- acks = 1 (leader acks)
			- Leader response is requested, but replication is not a guarantee (happens in the background)
			- If an ack is not received, the producer may retry
			- If the leader broker goes offline but replicas haven't replicated the data yet, we have a data loss.

		- acks = all (replicas acks)
			- Leader + Replicas ack requested
			- Added latency and safety
			- No data loss if enough replicas
			- Necessary setting if you don't want to lose data

		- Acks=all must be used in conjunction with min.insync.replicas
		- min.insync.replicas can be set at the broker or topic level (override).

		- min.insync.replicas=2 implies that at least 2 brokers that are ISR (including leader) must respond that they have the data.
		- That means if you use replication.factor=3, min.insync=2,acks=all, you can only tolerate 1 broker going down, otherwise the producer will receive an exception on send.