# KAFKA JAVA PROGRAMMING

* CREATING A KAFKA PROJECT
	- Create a new project on IntelliJIdea
	- Java 8
	- We choose Maven, GroupId: com.github.chema, ArtifaId: kafka-course, version: 1.0
	- Project name: kafka-course-first
	- Project location: /home/cloudera/ideaProjects/kafkacourse

	- Search in google: kafka maven --> Maven Repository: org.apache.kafka
	- Change the pom.xml and add dependencies: kafka-dependency --> kafka-clients
	- Search in Maven repository: slf4j simple --> SLF4J Simple Binding >> 1.7.25
	- Remove the tag <scope>

	- Under main/java --> package: com.github.chema.kafka
	- New package: tutorial1
	- New class: ProducerDemo


    package com.github.chema.kafka.tutorial1;
    
    public class ProducerDemo {
    
	    public static void main(String[] args) {
	    
		    System.out.println("hello world!")		
		        
	    }   
    }

* JAVA PRODUCER

	- See Kafka documentation about Producer Properties
    
    
    package com.github.chema.kafka.tutorial1;
    
    import org.apache.kafka.clients.producer.ProducerConfig;    
    
    import org.apache.kafka.clients.producer.ProducerRecord;
    
    import org.apache.kafka.common.serialization.StringSerializer;
    
    import java.util.Properties;
    
    public class ProducerDemo {
    
	    public static void main(String[] args) {
	    
		    String bootstrapServers = "quickstart.cloudera:9092";

		    // create Producer properties
		    Properties properties = new Properties();
		    properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
		    properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
		    properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

		    // create the producer
		    KafkaProducer<String, String> producer = new KafkaProducer<~>(properties);
		
		    // create a producer record
		    ProducerRecord<String, String> record = new ProducerRecord<~>("first_topic","hello world");

		    // send data - asynchronous
		    producer.send(record);

		    // flush data
		    producer.flush()

		    // flush and close producer
		    producer.close();
	    }
    }

	- Let's start a kafka consumer
	
		$ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic first_topic --group my-third-application
		
	- Then run the ProducerDemo and see the results
	
* JAVA PRODUCER CALLBACKS
	- The producer can give us some information about its job: partition, timestamp, and if everything is going well.....


    package com.github.chema.kafka.tutorial1;
    
    import org.apache.kafka.clients.producer.ProducerConfig;
    
    import org.apache.kafka.clients.producer.ProducerRecord;
    
    import org.apache.kafka.common.serialization.StringSerializer;
    
    import org.slf4j.Logger;
    
    import org.slf4j.LoggerFactory;

    import java.util.Properties;

    public class ProducerDemoWithCallBack {
    
	    public static void main(String[] args) {

		    Logger logger = LoggerFactory.getLogger(ProducerDemoWithCallBack.class)

		    String bootstrapServers = "quickstart.cloudera:9092";

		    // create Producer properties
		    Properties properties = new Properties();
		    properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
		    properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
		    properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

		    // create the producer
		    KafkaProducer<String, String> producer = new KafkaProducer<~>(properties);
		    for(int i = 0; i < 10; i++) {
			    // create a producer record
			    ProducerRecord<String, String> record = new ProducerRecord<~>("first_topic","hello world");

			    // send data - asynchronous
			    producer.send(record, new Callback() {
				    public void onCompletion(RecorMetadata recordMetadata, Exception e) {
					    // executes every time a record is successfully sent or an exception is thrown
					    if(e == null) {
						    // the record was successfully sent
						    logger.info("Received new metadata. \n" + 
						    "Topic: " + recordMetadata.topic() + "\n" + 
						    "Partition: " + recordMetadata.partition() + "\n" +
						    "Offset: " + recordMetadata.offset() + "\n" + 
						    "Timestamp: " + recordMetadata.timestamp());
					    } else {
						    logger.error("Error while producing ", e)
					    }
				    }
			    });
		    }

		    // flush data
		    producer.flush()

		    // flush and close producer
		    producer.close();
	    }
    }

	- Let's start a kafka consumer
	
		$ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic first_topic --group my-third-application
		
	- Then run the ProducerDemoWithCallBack and see the results

* JAVA PRODUCER WITH KEYS


    //ProducerDemoKeys   
    package com.github.chema.kafka.tutorial1;
    
    import org.apache.kafka.clients.producer.*;
    
    import org.apache.kafka.common.serialization.StringSerializer;
    
    import org.slf4j.Logger;
    
    import org.slf4j.LoggerFactory;
    
    import java.util.Properties;
    
    import java.util.concurrent.ExecutionException;


    public class ProducerDemoKeys {
    
        public static void main(String[] args) throws  InterruptedException, ExecutionException {
            final Logger logger;
            logger = LoggerFactory.getLogger(ProducerDemoKeys.class);
            String bootstrapServers = "quickstart.cloudera:9092";
            // create Producer properties
            Properties properties = new Properties();
            properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
            properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
            properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
            // create the producer
            KafkaProducer<String, String> producer = new KafkaProducer<String,String>(properties);
            for(int i = 0; i < 10; i++) {
                // create a producer record

                String topic = "kafka_demo";
                String value = "Hello World" + Integer.toString(i);
                String key = "id_" + Integer.toString(i);

                ProducerRecord<String, String> record = new ProducerRecord<String,String>(topic,key,value);

                logger.info("Key: " + key); // log the key
                // id_0 is going to partition 1
                // id_1 is going to partition 0
                // id_2 is going to partition 2
                // id_3 is going to partition 0
                // id_4 is going to partition 2
                // id_5 is going to partition 2
                // id_6 is going to partition 0
                // id_7 is going to partition 2
                // id_8 is going to partition 1
                // id_9 is going to partition 2
                // the same key is always going to go to the same partition in each code execution for a fix number of partitions

                // send data - asynchronous
                producer.send(record, new Callback() {
                    public void onCompletion(RecordMetadata recordMetadata, Exception e) {
                        // executes every time a record is successfully sent or an exception is thrown
                        if(e == null) {
                            // the record was successfully sent
                            logger.info("Received new metadata. \n" +
                                "Topic: " + recordMetadata.topic() + "\n" +
                                "Partition: " + recordMetadata.partition() + "\n" +
                                "Offset: " + recordMetadata.offset() + "\n" +
                                "Timestamp: " + recordMetadata.timestamp());
                        } else {
                            logger.error("Error while producing ", e);
                        }
                    }
                }).get(); // block the .send() to make it synchronous - don't do this in production!
            }

            // flush data
            producer.flush();

            // flush and close producer
            producer.close();
        }
    }


    - Let's start a kafka consumer
    
        $ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic kafka_demo --group my-third-application
        
    - Then run the ProducerDemoKeys and see the results	
    
    
    * JAVA CONSUMER
    	- See Kafka documentation about Consumer Properties
    
    
    	package com.github.chema.kafka.tutorial1;
    
    	import org.apache.kafka.clients.consumer.*;
    
     	import org.apache.kafka.common.serialization.StringSerializer;
    
    	import org.slf4j.Logger;
    
    	import org.slf4j.LoggerFactory;
    
    	import java.time.Duration;
    
    	import java.util.Arrays;
    
    	import java.util.Properties;
    
    	public class ConsumerDemo {
    
    		public static void main(String[] args) {
    			// logger
    			Logger logger = LoggerFactory.getLogger(ConsumerDemo.class.getName());
    			// servers
    			String bootstrapServers = "quickstart.cloudera:9092";
    			String groupId = "my-fourth-application";
    			String topic = "kafka_demo";
    
    			// create consumer configs
    			Properties properties = new Properties();
    			properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
    			properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
    			properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
    			properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
    			properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
    
    			// create consumer
    			KafkaConsumer<String, String> consumer = new KafkaConsumer<String, String>(properties);
    
    			// subscribe consumer to our topic(s)
    			consumer.subscribe(Array.asList(topic));
    
    			// poll for new data
    			while (true) {
    				ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100)); // new in Kafka 2.0.0
    
    				for(ConsumerRecord<String, String> record : records) {
    					logger.info("Key: " + record.key() + ", Value: " + record.value());
    					logger.info("Partition: " + record.partition() + ", Offset: " + record.offset());
    				}
    			}
    		}
    	}
    
    
    	- Run the ConsumerDemo and the ProducerDemo
    	
    	
* JAVA CONSUMER INSIDE CONSUMER GROUP


	    package com.github.chema.kafka.tutorial1;

	    import org.apache.kafka.clients.consumer.*;

 	    import org.apache.kafka.common.serialization.StringSerializer;

	    import org.slf4j.Logger;

	    import org.slf4j.LoggerFactory;

	    import java.time.Duration;

	    import java.util.Arrays;

	    import java.util.Properties;

	    public class ConsumerDemoGroups {

		public static void main(String[] args) {
			// logger
			Logger logger = LoggerFactory.getLogger(ConsumerDemo.class.getName());
			// servers
			String bootstrapServers = "quickstart.cloudera:9092";
			// by change the groupId you basically reset the application
			String groupId = "my-fifth-application";
			String topic = "kafka_demo";

			// create consumer configs
			Properties properties = new Properties();
			properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
			properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
			properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
			properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
			properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

			// create consumer
			KafkaConsumer<String, String> consumer = new KafkaConsumer<String, String>(properties);

			// subscribe consumer to our topic(s)
			consumer.subscribe(Arrays.asList(topic));

			// poll for new data
			while (true) {
				ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100)); // new in Kafka 2.0.0

				for(ConsumerRecord<String, String> record : records) {
					logger.info("Key: " + record.key() + ", Value: " + record.value());
					logger.info("Partition: " + record.partition() + ", Offset: " + record.offset());
				}
			}
		}
	}


	- When we have add or remove consumers the group is rebalancing, this means that partitions are distribute between consumers and if we see the logs:
	- Attemp to heartbeat failed since group is rebalancing
	- Revoking previously assigned partitions
	- (Re-) joining group
	- Setting newly assigned partitions

	- Run the consumer, and the producer. 
	- Now Run another consumer without stop the first one and run the producer again  
	
	
* JAVA CONSUMER WITH THREADS
    
    
    	package com.github.chema.kafka.tutorial1;
    
    	import org.apache.kafka.clients.consumer.*;
    	
    	import org.apache.kafka.common.errors.WakeupException;
    
     	import org.apache.kafka.common.serialization.StringDeserializer;
    
    	import org.slf4j.Logger;
    
    	import org.slf4j.LoggerFactory;
    
    	import java.time.Duration;
    
    	import java.util.Arrays;
    
    	import java.util.Properties;
    	
    	import java.util.concurrent.CountDownLatch;
    
    	public class ConsumerDemoWithThread {
    
    		public static void main(String[] args) {			
    			new ConsumerDemoWithThread().run();
    		}
    
    		private ConsumerDemoWithThread() {
    		}
    
    		private void run() {
    			// logger
    			Logger logger = LoggerFactory.getLogger(ConsumerDemoWithThread.class.getName());
    			// servers
    			String bootstrapServers = "quickstart.cloudera:9092";
    			String groupId = "my-sixth-application";
    			String topic = "kafka_demo";
    
    			// latch for dealing with multiple threads
    			CountDownLatch latch = new CountDownLatch(1);
    
    			// create the consumer runnable
    			logger.info("Creating the consumer thread.");
    			Runnable myConsumerRunnable = new ConsumerRunnable(bootstrapServers,groupId,topic,latch);
    
    			// start the thread
    			Thread myThread = new Thread(myConsumerRunnable);
    			myThread.start();
    			
    			// add a shutdown hook
    			Runtime.getRuntime().addShutdownHook(new Thread( () -> {
    				logger.info("Caught shutdown hook");
    				((ConsumerRunnable) myConsumerRunnable).shutdown();
    				try {
    					latch.await();
    				} catch(InterruptedException e) {
    					e.printStackTrace();
    				}
    				logger.info("Application has exited");
    			}));
    
    			try {
    				latch.await();
    			} catch(InterruptedException e) {
    				logger.error("Application got interrupted", e);
    			} finally {
    				logger.info("Application is closing");
    			}
    		}
    
    		public class ConsumerRunnable implements Runnable {
    
    			private CountDownLatch latch;
    			private KafkaConsumer<String, String> consumer;
    			// logger			
    			private Logger logger = LoggerFactory.getLogger(ConsumerRunnable.class.getName());
    
    			public ConsumerRunnable(String bootstrapServers, String groupId, String topic, CountDownLatch latch) {
    				this.latch = latch;
    
    				// create consumer configs
    				Properties properties = new Properties();
    				properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
    				properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
    				properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
    				properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
    				properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
    
    				// create consumer
    				consumer = new KafkaConsumer<String, String>(properties);
    
    				// subscribe consumer to our topic(s)
    				consumer.subscribe(Arrays.asList(topic));
    			}
    
    			@Override
    			public void run() {
    
    				// poll for new data
    				try {
    					while (true) {
    						ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100)); // new in Kafka 2.0.0
    
    						for(ConsumerRecord<String, String> record : records) {
    							logger.info("Key: " + record.key() + ", Value: " + record.value());
    							logger.info("Partition: " + record.partition() + ", Offset: " + record.offset());
    						}
    					}
    				} catch(WakeupException e) {
    					logger.info("Received shutdown signal!");					
    				} finally {
    					consumer.close();
    					// tell our main code we're done with the consumer
    					latch.countDown();
    				}
    
    			}
    
    			public void shutdown() {
    				// the wakeup() method is a special method to interrup consumer.poll()
    				// it will throw the exception WakeUpException
    				consumer.wakeup();
    			}
    
    		}
    	}  	