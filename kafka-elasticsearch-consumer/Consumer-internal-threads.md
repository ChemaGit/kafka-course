### Controlling Consumer Liveliness
````text
- Consumers in a Group talk to a Consumer Groups Coordinator
- To detect consumers that are "down", there is a "heartbeat" mechanism and a "poll" mechanism
- To avoid issues, consumers are encouraged to process data fast and poll often
````

### Consumer Heartbeat Thread
````text
- Session.timeout.ms (default 10 seconds):
    - Heartbeats are sent periodically to the broker
    - If no hearbeat is sent during that period, the consumer is considered dead
    - Set even lower to faster consumer rebalances

- Heartbeat.interval.ms (default 3 seconds):
    - How often to send heartbeats
    - Usually set to 1/3rd of session.timeout.ms

- Take-away: This mechanism is used to detect a consumer application being down
````

### Consumer Poll Thread
````text
- max.poll.interval.ms (default 5 minutes):
    - Maximun amount of time between two .poll() calls before declaring the consumer dead
    - This is particularly relevant for Big Data frameworks like Spark in case the processing takes time

- Take-away: This mechanism is used to detect a data processing issue with the consumer
````