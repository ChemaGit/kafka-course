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