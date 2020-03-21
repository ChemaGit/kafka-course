# PRODUCER RETRIES
````text
- In case of transient failures, developers are expected to handle exceptions, otherwise the data will be lost.
- Example of transient failure:
    - NotEnoughReplicasException
- There is a "retries" setting
    - defaults to 0
    - You can increase to a high number, ex Integer.MAX_VALUE

- In case of retries, by default there is a chance that messages will be sent out of order (if a batch has failed to be sent).
- If you rely on key-based ordering, that can be an issue.
- For this, you can set the setting while controls how many produce requests can be made in parallel: max.in.flight.requests.per.connection
    - Default: 5
    - Set it to 1 if you need to ensure ordering (may impact throughput)
- In Kafka >= 1.0.0, there is a better solution!
````