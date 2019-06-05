# Consumer part 5 Performance improvement using batching

	- Right now we are doing one record at the time, and this a lot of time
	- We would like to do is something more efficient and use batching
	- BulkRequest bulkRequest = new BulkRequest();
	- bulkRequest.add(indexRequest); // we add to our bulk request (takes no time)
	- BulkResponse bulkItemResponses = client.bulk(bulkRequest, RequestOptions.DEFAULT);
	- properties.setProperty(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, "100");
	- Integer recordCount = records.count();
	- logger.info("Received " + recordCount + " records");
	- if (recordCount > 0) {
            	- BulkResponse bulkItemResponses = client.bulk(bulkRequest, RequestOptions.DEFAULT);
            	- logger.info("Committing offsets....");
            	- consumer.commitSync();
            	- logger.info("Offsets have been committed");
            	- try {
                	- Thread.sleep(1000);
            	- } catch(InterruptedException e) {
                	- e.printStackTrace();
            	- }
	- }

       	- try {
         	- String id = extractIdFromTweet(record.value());

                - // where we insert data into ElasticSearch
                - IndexRequest indexRequest = new IndexRequest("twitter","tweets",id /*this is to make our consumer idempotent*/).source(record.value(), XContentType.JSON);

                - bulkRequest.add(indexRequest); // we add to our bulk request (takes no time)
      	- } catch (NullPointerException e) {
             	- logger.warn("skipping bad data: " + record.value());
    	- }	



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

import org.elasticsearch.action.bulk.BulkRequest;

import org.elasticsearch.action.bulk.BulkResponse;

import org.elasticsearch.action.index.IndexRequest;

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

public class ElasticSearchConsumerIdempotent5 {

    public static RestHighLevelClient createClient() {

        // replace whith your own credentials
        String hostname = "jjjjjjjjjjjjjjj.bonsaisearch.net";
        String username = "xxxxxxxxxxx";
        String password = "mmmmmmmmmm";

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
        // disable auto commit of offsets
        properties.setProperty(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
        properties.setProperty(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, "100");

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

        Logger logger = LoggerFactory.getLogger(ElasticSearchConsumerIdempotent5.class.getName());
        RestHighLevelClient client = createClient();

        // poll for new data
        KafkaConsumer<String,String> consumer = createConsumer("twitter_tweets");
        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100)); // new in Kafka 2.0.0

            Integer recordCount = records.count();
            logger.info("Received " + recordCount + " records");

            BulkRequest bulkRequest = new BulkRequest();

            for(ConsumerRecord<String, String> record : records) {
                // two strategies
                // 1. Kafka generic ID:
                // String id = record.topic() + "_" + record.partition() + "_" + record.offset();

                // 2. twitter feed specific id
                try {
                    String id = extractIdFromTweet(record.value());

                    // where we insert data into ElasticSearch
                    IndexRequest indexRequest = new IndexRequest("twitter","tweets",id /*this is to make our consumer idempotent*/).source(record.value(), XContentType.JSON);

                    bulkRequest.add(indexRequest); // we add to our bulk request (takes no time)
                } catch (NullPointerException e) {
                    logger.warn("skipping bad data: " + record.value());
                }

            }

            if (recordCount > 0) {

                BulkResponse bulkItemResponses = client.bulk(bulkRequest, RequestOptions.DEFAULT);
                logger.info("Committing offsets....");
                consumer.commitSync();
                logger.info("Offsets have been committed");
                try {
                    Thread.sleep(1000);
                } catch(InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        // close the client gracefully
        // client.close();
    }

}