# Consumer Offset Commits Strategies

	- There are two most common patterns for committing offsets in a consumer application.

	- Two strategies:
		- (easy) enable.outo.commit = true & synchronous processing of batches
		- (medium) enable.auto.commit = false & manual commit of offsets

	- First
		- enable.auto.commit = true & synchronous processing of batches
````java
			while(true) {

				List<Records> batch = consumer.poll(Duration.ofMillis(100))

				doSomethingSynchronous(batch)

			}
````
		- With auto-commit, offsets will be committed automatically for you at regular interval
		- (auto.commit.interval.ms=5000 by default) every-time you call .poll()
		- If you don't use synchronous processing, you will be in "at-most-once" behavior because offsets will be committed before your data is processed

	- Second
		- enable.auto.commit = false & synchronous processing of batches
````java
			while(true) {

				batch += consumer.poll(Duration.ofMillis(100))

				if(isReady(batch)) {					

					doSomethingSynchronous(batch)

					consumer.commitSync();
				}
			}
````
	- You control when you commit offsets and what's the condition for committing them.
	- Example: accumulating records into a buffer and then flushing the buffer to a database + committing offsets then.