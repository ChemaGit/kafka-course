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
        	
        	
# KAFKA TWITTER PRODUCER AND ADVANCED CONFIGURATIONS

* TWITTER SETUP

	- We have to create a twitter account: 
	- Username: @xxxxxxxx

	- Describe in your own words what you are building:
		- I intend to use this Twitter feed to get real time data streams into an application that will put data into Kafka. 
		- This data will end up in ElasticSearch at the end and this is just ofr POC purposes.
		- No commercial application will result out of this and I won't  have any users besides just myself.
		- Twitter data will not be displayed, and we will only extract tweets on low volume terms.

	- App name: Chema-Kafka for Beginners Course
	- Application description: This application will read streams of tweets in real time and put them into Kafka.
	- Website URL: https://kafka-tutoriasl.com
	- Tell us how this app will be used
		- This app is a Proof of Concept and it will enable me to test a real time data feed into my Kafka cluster 

	- Keys and tokens
	- Keys, secret keys and access tokens management.
		- Consumer API keys
		- zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz (API key)
		- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (API secret key)

	- Access token & access token secret
		- rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr(Access token)

		- yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy (Access token secret)

		- Read and write (Access level)

	- On google: github twitter java: GitHub - twitter/hbc: A Java HTTP client for consuming Twitter's 
		- and get the dependency:

  <!--twitter dependency-->
    <dependency>
      <groupId>com.twitter</groupId>
      <artifactId>hbc-core</artifactId> <!-- or hbc-twitter4j -->
      <version>2.2.0</version> <!-- or whatever the latest version is -->
    </dependency>      
    
    
# PRODUCER - WRITING A TWITTER CLIENT

	- Create a new package: com.github.chema.kafka.tutorial2
	- Into the new package we create a new class: TwitterProducer.java

	- Three steps:
		// create a twitter client
		// create a kafka producer
		// loop to send tweets to kafka

	- Look at the documentation at: https://github.com/twitter/hbc



package com.github.chema.kafka.tutorial2;

import com.google.common.collect.Lists;
import com.twitter.hbc.ClientBuilder;
import com.twitter.hbc.core.Client;
import com.twitter.hbc.core.Constants;
import com.twitter.hbc.core.Hosts;
import com.twitter.hbc.core.HttpHosts;
import com.twitter.hbc.core.endpoint.StatusesFilterEndpoint;
import com.twitter.hbc.core.processor.StringDelimitedProcessor;
import com.twitter.hbc.httpclient.auth.Authentication;
import com.twitter.hbc.httpclient.auth.OAuth1;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

public class TwitterProducer {

	// logger
    	Logger logger = LoggerFactory.getLogger(TwitterProducer.class.getName());

	String consumerKey = "xxx";
	String consumerSecret = "yyyy";
	String token = "zzzz";
	String secret = "pppp";

	public TwitterProducer() {

	}

    	public static void main(String[] args) {
        	new TwitterProducer().run();
    	}

	public void run() {

		logger.info("Setup");

		/** Set up your blocking queues: Be sure to size these properly based on expected TPS of your stream */
		BlockingQueue<String> msgQueue = new LinkedBlockingQueue<String>(1000);
        	// create a twitter client
		Client client = createTwitterClient(msgQueue); 
		// attemps to stablish a connection
        	client.connect();
        	// create a kafka producer
        
        	// loop to send tweets to kafka 
		// on a different thread, or multiple different threads....
		while (!client.isDone()) {
			String msg = null;
			try {
  				msg = msgQueue.poll(5, TimeUnit.SECONDS);
			} catch(InterruptedException e) {
				e.printStackTrace();
				client.stop();
			}
  			if(msg != null) {
				logger.info(msg);
			}
		}
		logger.info("End of application");
	}
	
	public Client createTwitterClient(BlockingQueue<String> msgQueue) {

		/** Declare the host you want to connect to, the endpoint, and authentication (basic auth or oauth) */
		Hosts hosebirdHosts = new HttpHosts(Constants.STREAM_HOST);
		StatusesFilterEndpoint hosebirdEndpoint = new StatusesFilterEndpoint();

		List<String> terms = Lists.newArrayList("bitcoin");
		hosebirdEndpoint.trackTerms(terms);

		// These secrets should be read from a config file
		Authentication hosebirdAuth = new OAuth1(consumerKey, consumerSecret, token, secret);

		ClientBuilder builder = new ClientBuilder()
  		.name("Hosebird-Client-01")                              // optional: mainly for the logs
  		.hosts(hosebirdHosts)
  		.authentication(hosebirdAuth)
  		.endpoint(hosebirdEndpoint)
  		.processor(new StringDelimitedProcessor(msgQueue)); 

		Client hosebirdClient = builder.build();
		return hosebirdClient;
	}
}      			



# PRODUCER PART 2: WRITING THE KAFKA PRODUCER

	- We have to create the kafka producer

	KafkaProducer<String, String> producer = createKafkaProducer();

	public KafkaProducer<String, String> createKafkaProducer() {
		String bootstrapServers = "quickstart.cloudera:9092";

		// create Producer properties
		Properties properties = new Properties();
		properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
		properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
		properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

		// create the producer
		KafkaProducer<String, String> producer = new KafkaProducer<String, String>(properties);
		return producer;
	}


	public void run() {

		logger.info("Setup");

		/** Set up your blocking queues: Be sure to size these properly based on expected TPS of your stream */
		BlockingQueue<String> msgQueue = new LinkedBlockingQueue<String>(1000);
        	// create a twitter client
		Client client = createTwitterClient(msgQueue); 
		// attemps to stablish a connection
        	client.connect();
        	// create a kafka producer
		KafkaProducer<String, String> producer = createKafkaProducer();
        
        	// loop to send tweets to kafka 
		// on a different thread, or multiple different threads....
		while (!client.isDone()) {
			String msg = null;
			try {
  				msg = msgQueue.poll(5, TimeUnit.SECONDS);
			} catch(InterruptedException e) {
				e.printStackTrace();
				client.stop();
			}
  			if(msg != null) {
				logger.info(msg);
				producer.send(new ProducerRecord<>("twitter_tweets",null,msg), new Callback() {
					@Override
					public void onCompletion(RecordMetadata recordMetadata, Exception e) {
						if(e != null) {
							logger.error("Something bad happened", e);
						}
					}
				});
			}
		}
		logger.info("End of application");
	}

	- kafka-topics --zookeeper quickstart.cloudera:2181 --create --topic twitter_tweets --partitions 6 --replication-factor 1 
	- kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic twitter_tweets --from-beginning

package com.github.chema.kafka.tutorial2;

import com.google.common.collect.Lists;
import com.twitter.hbc.ClientBuilder;
import com.twitter.hbc.core.Client;
import com.twitter.hbc.core.Constants;
import com.twitter.hbc.core.Hosts;
import com.twitter.hbc.core.HttpHosts;
import com.twitter.hbc.core.endpoint.StatusesFilterEndpoint;
import com.twitter.hbc.core.processor.StringDelimitedProcessor;
import com.twitter.hbc.httpclient.auth.Authentication;
import com.twitter.hbc.httpclient.auth.OAuth1;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.List;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

public class TwitterProducer {

	// logger
    	Logger logger = LoggerFactory.getLogger(TwitterProducer.class.getName());

	String consumerKey = "xxx";
	String consumerSecret = "yyyy";
	String token = "zzzz";
	String secret = "pppp";
	List<String> terms = Lists.newArrayList("kafka");

	public TwitterProducer() {

	}

    	public static void main(String[] args) {
        	new TwitterProducer().run();
    	}

	public void run() {

		logger.info("Setup");

		/** Set up your blocking queues: Be sure to size these properly based on expected TPS of your stream */
		BlockingQueue<String> msgQueue = new LinkedBlockingQueue<String>(1000);
        	// create a twitter client
		Client client = createTwitterClient(msgQueue); 
		// attemps to stablish a connection
        	client.connect();
        	// create a kafka producer
		KafkaProducer<String, String> producer = createKafkaProducer();

		// add a shutdown hook
		Runtime.getRuntime().addShutdownHook(new Thread(() -> {
			logger.info("stopping application...");
			logger.info("shutting down client from twitter....");
			client.stop();
			logger.info("closing producer...");
			producer.close();
			logger.info("done!");
		}));
        
        	// loop to send tweets to kafka 
		// on a different thread, or multiple different threads....
		while (!client.isDone()) {
			String msg = null;
			try {
  				msg = msgQueue.poll(5, TimeUnit.SECONDS);
			} catch(InterruptedException e) {
				e.printStackTrace();
				client.stop();
			}
  			if(msg != null) {
				logger.info(msg);
				producer.send(new ProducerRecord<>("twitter_tweets",null,msg), new Callback() {
					@Override
					public void onCompletion(RecordMetadata recordMetadata, Exception e) {
						if(e != null) {
							logger.error("Something bad happened", e);
						}
					}
				});
			}
		}
		logger.info("End of application");
	}
	
	public Client createTwitterClient(BlockingQueue<String> msgQueue) {

		/** Declare the host you want to connect to, the endpoint, and authentication (basic auth or oauth) */
		Hosts hosebirdHosts = new HttpHosts(Constants.STREAM_HOST);
		StatusesFilterEndpoint hosebirdEndpoint = new StatusesFilterEndpoint();
		
		hosebirdEndpoint.trackTerms(terms);

		// These secrets should be read from a config file
		Authentication hosebirdAuth = new OAuth1(consumerKey, consumerSecret, token, secret);

		ClientBuilder builder = new ClientBuilder()
  		.name("Hosebird-Client-01")                              // optional: mainly for the logs
  		.hosts(hosebirdHosts)
  		.authentication(hosebirdAuth)
  		.endpoint(hosebirdEndpoint)
  		.processor(new StringDelimitedProcessor(msgQueue)); 

		Client hosebirdClient = builder.build();
		return hosebirdClient;
	}

	public KafkaProducer<String, String> createKafkaProducer() {
		String bootstrapServers = "quickstart.cloudera:9092";

		// create Producer properties
		Properties properties = new Properties();
		properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
		properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
		properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

		// create the producer
		KafkaProducer<String, String> producer = new KafkaProducer<String, String>(properties);
		return producer;
	}

}				                                