# Consumer part 3 Idempotence
````text
- Our consumer is actually "at least once"
- We are going to do a idempotence consumer
- We need to tell ElasticSearch what id to use
- this is to make our consumer idempotent
    - two strategies
        - 1 Kafka generic ID: String id = record.topic() + "_" + record.partition() + "_" + record.offset();
        - 2 twitter feed specific id: String id = extractIdFromTweet(record.value());
        - we look for gson library: google --> java maven gson --> and get the maven dependency
````
````xml
<!-- https://mvnrepository.com/artifact/com.google.code.gson/gson -->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.8.5</version>
</dependency>
````
````java
private static JsonParser jsonParser = new JsonParser();
private static String extractIdFromTweet(String tweetJson) {
	// gson library	
	return jsonParser.parse(tweetJson).getAsJsonObject().get("id_str").getAsString();
}
String id = extractIdFromTweet(record.value());
IndexRequest indexRequest = new IndexRequest("twitter","tweets",id /*this is to make our consumer idempotent*/).source(record.value(), XContentType.JSON);
````

## The complete class
````java
import com.google.gson.JsonParser;
import org.apache.http.HttpHost;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.nio.client.HttpAsyncClientBuilder;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.common.xcontent.XContentType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;
import java.time.Duration;
import java.util.Arrays;
import java.util.Properties;

public class ElasticSearchConsumerIdempotent {

    public static RestHighLevelClient createClient() {

        // replace whith your own credentials
        String hostname = "kafka-course-490018884.eu-west-1.bonsaisearch.net";
        String username = "56ebmep3kq";
        String password = "dbd7ofd83s";

        // don't if you run a local ES
        final CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        credentialsProvider.setCredentials(AuthScope.ANY, new UsernamePasswordCredentials(username,password));

        RestClientBuilder builder = RestClient.builder(
                new HttpHost(hostname,443,"https"))
                .setHttpClientConfigCallback(new RestClientBuilder.HttpClientConfigCallback() {
                    @Override
                    public HttpAsyncClientBuilder customizeHttpClient(HttpAsyncClientBuilder httpClientBuider) {
                        return httpClientBuider.setDefaultCredentialsProvider(credentialsProvider);
                    }
                });
        RestHighLevelClient client = new RestHighLevelClient(builder);
        return client;
    }

    public static KafkaConsumer<String,String> createConsumer(String topic) {

        // servers
        String bootstrapServers = "quickstart.cloudera:9092";
        // by change the groupId you basically reset the application
        String groupId = "kafka-demo-elasticsearch";

        // create consumer configs
        Properties properties = new Properties();
        properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

        // create consumer
        KafkaConsumer<String, String> consumer = new KafkaConsumer<String, String>(properties);
        consumer.subscribe(Arrays.asList(topic));

        return consumer;
    }

    private static JsonParser jsonParser = new JsonParser();

    private static String extractIdFromTweet(String tweetJson) {
        // gson library
        return jsonParser.parse(tweetJson).getAsJsonObject().get("id_str").getAsString();
    }

    public static void main(String[] args) throws IOException {

        Logger logger = LoggerFactory.getLogger(ElasticSearchConsumerIdempotent.class.getName());
        RestHighLevelClient client = createClient();

        // poll for new data
        KafkaConsumer<String,String> consumer = createConsumer("twitter_tweets");
        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100)); // new in Kafka 2.0.0

            for(ConsumerRecord<String, String> record : records) {
                // two strategies
                // 1. Kafka generic ID:
                // String id = record.topic() + "_" + record.partition() + "_" + record.offset();
                
                // 2. twitter feed specific id
                String id = extractIdFromTweet(record.value());

                // where we insert data into ElasticSearch
                IndexRequest indexRequest = new IndexRequest("twitter","tweets",id /*this is to make our consumer idempotent*/).source(record.value(), XContentType.JSON);
                // this is to make our consumer idempotent
                IndexResponse indexResponse = client.index(indexRequest, RequestOptions.DEFAULT);
                logger.info(indexResponse.getId());
                try {
                    Thread.sleep(1000); // Introduce a small delay
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
        // close the client gracefully
        // client.close();
    }
}
````
````text
- Run the code and see the IDs

[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071572317298688
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071578768093184
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071588259848192
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071597709627392
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071600440127489
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071607247417344
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071611622068224
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071616567226368
[main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumerIdempotent - 1134071621856169984

- Check the console in bonsai elasticsearch: GET /twitter/tweets/1134071572317298688
````

