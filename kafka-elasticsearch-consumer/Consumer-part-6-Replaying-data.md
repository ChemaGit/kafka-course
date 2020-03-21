# Consumer part 6. Replaying data
````bash
$ kafka-consumer-groups --bootstrap-server quickstart.cloudera:9092 --group kafka-demo-elasticsearch --describe
````
````text
- TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
- twitter_tweets  3          21              21              0               -               -               -
- twitter_tweets  0          22              22              0               -               -               -
- twitter_tweets  4          24              24              0               -               -               -
- twitter_tweets  5          25              25              0               -               -               -
- twitter_tweets  2          22              22              0               -               -               -
- twitter_tweets  1          24              24              0               -               -               -

- to restart our consumer and replay the data we have to do as following
````
````bash
$ kafka-consumer-groups --bootstrap-server quickstart.cloudera:9092 --group kafka-demo-elasticsearch --reset-offsets --execute --to-earliest --topic twitter_tweets		
````
````text
- TOPIC                          PARTITION  NEW-OFFSET     
- twitter_tweets                 3          10             
- twitter_tweets                 0          11             
- twitter_tweets                 4          12             
- twitter_tweets                 5          13             
- twitter_tweets                 2          11             
- twitter_tweets                 1          12
````
````bash
$ kafka-consumer-groups --bootstrap-server quickstart.cloudera:9092 --group kafka-demo-elasticsearch --describe
````
````text
- TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
- twitter_tweets  3          10              21              11              -               -               -
- twitter_tweets  0          11              22              11              -               -               -
- twitter_tweets  4          12              24              12              -               -               -
- twitter_tweets  5          13              25              12              -               -               -
- twitter_tweets  2          11              22              11              -               -               -
- twitter_tweets  1          12              24              12              -               -               -

- Now we can rerun our application and receive data again without replicating data because our consumer is idempotent
````

