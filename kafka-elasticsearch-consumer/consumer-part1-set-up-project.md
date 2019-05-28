# Kafka Consumer Elasticsearch - Part 1

	- In Idea IDE -> new Module -> kafka-consumer-elasticsearch
	- We include dependencies in the pom.xml

	<dependency>
    		<groupId>org.elasticsearch.client</groupId>
    		<artifactId>elasticsearch-rest-high-level-client</artifactId>
    		<version>7.1.0</version>
	</dependency>

	<!-- https://mvnrepository.com/artifact/org.apache.kafka/kafka-clients -->
        <dependency>
            <groupId>org.apache.kafka</groupId>
            <artifactId>kafka-clients</artifactId>
            <version>2.0.0</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-simple -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>1.7.25</version>
        </dependency>

	- new package and new Java class ElasticSearchConsumer

package com.github.chema.kafka.tutorial3;

import org.apache.http.HttpHost;

import org.apache.http.auth.AuthScope;

import org.apache.http.auth.UsernamePasswordCredentials;

import org.apache.http.client.CredentialsProvider;

import org.apache.http.impl.client.BasicCredentialsProvider;

import org.apache.http.impl.nio.client.HttpAsyncClientBuilder;

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

public class ElasticSearchConsumer {

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

    public static void main(String[] args) throws IOException {

        Logger logger = LoggerFactory.getLogger(ElasticSearchConsumer.class.getName());
        RestHighLevelClient client = createClient();

        String jsonString = "{ \"foo\": \"bar\" }";

        IndexRequest indexRequest = new IndexRequest("twitter","tweets").source(jsonString, XContentType.JSON);

        IndexResponse indexResponse = client.index(indexRequest, RequestOptions.DEFAULT);
        String id = indexResponse.getId();
        logger.info(id);

        // close the client gracefully
        client.close();
    }

}

	- we create an index in the console
	- PUT /twitter
	- And run ElasticSearchConsumer
	- We get an id: oBhm_moBtS95x-ir_dUN
	- GET /twitter/tweets/oBhm_moBtS95x-ir_dUN

{
  "_index": "twitter",
  "_type": "tweets",
  "_id": "oBhm_moBtS95x-ir_dUN",
  "_version": 1,
  "found": true,
  "_source": {
    "foo": "bar"
  }
}