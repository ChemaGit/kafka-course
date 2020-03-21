## Kafka Streams Hands-on example
````text
- Create a new maven module called: kafka-streams-filter-tweets
- Add dependencies to pom.xml
- google: maven kafka streams ==> org.apache.kafka >> kafka-streams - maven repository
- get 2.0.0 version and add it to pom.xml
- add org.slf4j and gson dependency too
````
````xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"

         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>kafka-course</artifactId>
        <groupId>com.github.chema</groupId>
        <version>1.0</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>kafka-streams-filter-tweets</artifactId>

    <dependencies>
        <!-- https://mvnrepository.com/artifact/org.apache.kafka/kafka-streams -->
        <dependency>
            <groupId>org.apache.kafka</groupId>
            <artifactId>kafka-streams</artifactId>
            <version>2.0.0</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-simple -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>1.7.25</version>
        </dependency>

 	<!-- https://mvnrepository.com/artifact/com.google.code.gson/gson -->
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.8.5</version>
        </dependency>

    </dependencies>
    
</project>
````

````text
- we are ready to write our example
- Under src-main-java create a new package called: com.github.chema.kafka.tutorial4 
- We create a new Java class StreamsFilterTweets
````

````java
import com.google.gson.JsonParser;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.KStream;
import java.util.Properties;

public class StreamsFilterTweets {
    
    public static void main(String[] args) {
        // create properties
        Properties properties = new Properties();
        properties.setProperty(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG,"quickstart.cloudera:9092");
        properties.setProperty(StreamsConfig.APPLICATION_ID_CONFIG, "demo-kafka-streams");
        properties.setProperty(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.StringSerde.class.getName());
        properties.setProperty(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.StringSerde.class.getName());
        
        // create a topology
        StreamsBuilder streamsBuilder = new StreamsBuilder();
        
        // input topic
        KStream<String, String> inputTopic = streamsBuilder.stream("twitter_tweets");
        KStream<String, String> filteredStream = inputTopic.filter(
                // filter for tweets which has a user of over 10000 followers
                (k, jsonTweet) -> extractUserFollowersInTweet(jsonTweet) > 10000
        );
        filteredStream.to("important_tweets");
        
        // build the topology
        KafkaStreams kafkaStreams = new KafkaStreams(streamsBuilder.build(), properties);
        
        // start our streams application
        kafkaStreams.start();
    }
    
    private static JsonParser jsonParser = new JsonParser();
    
    private static Integer extractUserFollowersInTweet(String tweetJson) {
        // gson library
        try{
            return jsonParser.parse(tweetJson)
                    .getAsJsonObject()
                    .get("user")
                    .getAsJsonObject()
                    .get("followers_count")
                    .getAsInt();
        } catch (NullPointerException e) {
            return 0;
        }

    }
}
````
````text
- create a topic: 

$kafka-topics --zookeeper quickstart.cloudera:2181 --topic important_tweets --create --partitions 3 --replication-factor 1

- run the application StreamsFilterTweets 
- run TwitterProducer
- run a consumer with the created topic above: 

$ kafka-console-consumer --bootstrap-server quickstart.cloudera:9092 --topic important_tweets --from-beginning
````

