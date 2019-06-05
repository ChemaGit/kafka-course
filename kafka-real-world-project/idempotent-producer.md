# IDEMPOTENT PRODUCER

	- Here's the problem: the Producer can introduce duplicate messages in Kafka due to network errors
	- In Kafka >= 0.11, you can define a "idempotent producer" which won't introduce duplicates on network error
	- Detect duplicate, don't commit twice
	- Idempotent producers are great to guarantee a stable and save pipeline!
	- They come with:
		- retries=Integer.MAX_VALUE(2^31-1=2147483647)
		- max.in.flight.requests=1 (Kafka >= 0.11 & < 1.1) or
		- max.in.flight.requests=5 (Kafka >= 1.1 - higher performance)
		- acks=all
	- Just set:
		- producerProps.put("enable.idempotence",true);