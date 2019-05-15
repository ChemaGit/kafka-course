* KAFKA REAL WORLD PROJECT

* Project Goal

							  
	- TWITTER ==>>PRODUCER==>>  0 0  ==>>CONSUMER==>>ELASTIC SEARCH
							  
									                                
									                                
* Real-World Exercise:

	- Before jumping to the next section for the solution, here are some pointers for some exercises:

* Twitter Producer

	- The Twitter Producer gets data from Twitter based on some keywords and put them in a Kafka topic of your choice

    		- Twitter Java Client: https://github.com/twitter/hbc

    		- Twitter API Credentials: https://developer.twitter.com/

* ElasticSearch Consumer

	- The ElasticSearch Consumer gets data from your twitter topic and inserts it into ElasticSearch

    		- ElasticSearch Java Client: https://www.elastic.co/guide/en/elasticsearch/client/java-rest/6.4/java-rest-high.html

    		- ElasticSearch setup:

        	- https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html

        	- OR https://bonsai.io/									                                