KAFKA JAVA PROGRAMMING

CREATING A KAFKA PROJECT
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

public class ProducerDemo {
	public static void main(String[] args) {
		System.out.println("hello world!")
	}
}

JAVA PRODUCER

	- See Kafka documentation about Producer Properties

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