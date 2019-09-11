# Consumer part 2 Write the consumer and send to Elasticsearch

	- Insert data from Kafka into ElasticSearch using a Consumer

````java
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

public class ElasticSearchConsumer2 {

    public static RestHighLevelClient createClient() {

        // replace whith your own credentials
        String hostname = "xxxxxxxxxxxxx.bonsaisearch.net";
        String username = "xxxxxxxxxxxxx";
        String password = "xxxxxxxxxxxxx";

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

    public static void main(String[] args) throws IOException {

        Logger logger = LoggerFactory.getLogger(ElasticSearchConsumer2.class.getName());
        RestHighLevelClient client = createClient();

        // poll for new data
        KafkaConsumer<String,String> consumer = createConsumer("twitter_tweets");
        while (true) {
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100)); // new in Kafka 2.0.0

            for(ConsumerRecord<String, String> record : records) {
                // where we insert data into ElasticSearch
                IndexRequest indexRequest = new IndexRequest("twitter","tweets").source(record.value(), XContentType.JSON);
                IndexResponse indexResponse = client.index(indexRequest, RequestOptions.DEFAULT);
                String id = indexResponse.getId();
                logger.info(id);
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

	- Run the application: ElasticSearchConsumer2 

	- [main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumer2 - 6AEbA2sBNjbTEtniUQ2L
	- [main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumer2 - 6gEbA2sBNjbTEtniWg1W
	- [main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumer2 - 6wEbA2sBNjbTEtniYQ2v
	- [main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumer2 - 7AEbA2sBNjbTEtniaA1R
	- [main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumer2 - 7QEbA2sBNjbTEtnibA2H
	- [main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumer2 - 7wEbA2sBNjbTEtnicw1M
	- [main] INFO com.github.chema.kafka.tutorial3.ElasticSearchConsumer2 - 8AEbA2sBNjbTEtnieQ0D

	- we get an ID every 1 second with a complete tweet into our elasticsearch cluster
	- And now check an ID in the console of elasticsearch
		- GET /twitter/tweets/6AEbA2sBNjbTEtniUQ2L
````json
{
  "_index": "twitter",
  "_type": "tweets",
  "_id": "6AEbA2sBNjbTEtniUQ2L",
  "_version": 1,
  "found": true,
  "_source": {
    "created_at": "Tue May 21 11:14:36 +0000 2019",
    "id": 1130794014213591000,
    "id_str": "1130794014213591040",
    "text": "#WebDollar #Reward #BOUNTY",
    "source": "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>",
    "truncated": false,
    "in_reply_to_status_id": null,
    "in_reply_to_status_id_str": null,
    "in_reply_to_user_id": null,
    "in_reply_to_user_id_str": null,
    "in_reply_to_screen_name": null,
    "user": {
      "id": 1129297496348549100,
      "id_str": "1129297496348549121",
      "name": "#WebDollar #Affiliates",
      "screen_name": "WebdollarA",
      "location": null,
      "url": null,
      "description": "#WebDollar #money #POS #Bitcoin",
      "translator_type": "none",
      "protected": false,
      "verified": false,
      "followers_count": 75,
      "friends_count": 336,
      "listed_count": 0,
      "favourites_count": 190,
      "statuses_count": 131,
      "created_at": "Fri May 17 08:07:59 +0000 2019",
      "utc_offset": null,
      "time_zone": null,
      "geo_enabled": false,
      "lang": "en",
      "contributors_enabled": false,
      "is_translator": false,
      "profile_background_color": "F5F8FA",
      "profile_background_image_url": "",
      "profile_background_image_url_https": "",
      "profile_background_tile": false,
      "profile_link_color": "1DA1F2",
      "profile_sidebar_border_color": "C0DEED",
      "profile_sidebar_fill_color": "DDEEF6",
      "profile_text_color": "333333",
      "profile_use_background_image": true,
      "profile_image_url": "http://pbs.twimg.com/profile_images/1129297752528162816/Ey0Fjhq4_normal.jpg",
      "profile_image_url_https": "https://pbs.twimg.com/profile_images/1129297752528162816/Ey0Fjhq4_normal.jpg",
      "default_profile": true,
      "default_profile_image": false,
      "following": null,
      "follow_request_sent": null,
      "notifications": null
    },
    "geo": null,
    "coordinates": null,
    "place": null,
    "contributors": null,
    "quoted_status_id": 1130052399484330000,
    "quoted_status_id_str": "1130052399484329984",
    "quoted_status": {
      "created_at": "Sun May 19 10:07:42 +0000 2019",
      "id": 1130052399484330000,
      "id_str": "1130052399484329984",
      "text": "#WebDollar #money #POS #Bitcoin  #coin #phone #price #card #deposit #instamoney #instahome #instacash #instafree… https://t.co/jxWqmyuzee",
      "source": "<a href=\"https://mobile.twitter.com\" rel=\"nofollow\">Twitter Web App</a>",
      "truncated": true,
      "in_reply_to_status_id": null,
      "in_reply_to_status_id_str": null,
      "in_reply_to_user_id": null,
      "in_reply_to_user_id_str": null,
      "in_reply_to_screen_name": null,
      "user": {
        "id": 1060169399531946000,
        "id_str": "1060169399531945984",
        "name": "Ifrim Alexandru Giuliano",
        "screen_name": "GiulianoIfrim",
        "location": null,
        "url": "http://www.webdollar.io",
        "description": "#WebDollar  #money #ProofofStake  #POW #BankInterest #efficiency #TechNews #Cryptocurrency #Mining #bitcoin #btc #coin #time #eco #working #nature #friendly",
        "translator_type": "none",
        "protected": false,
        "verified": false,
        "followers_count": 4647,
        "friends_count": 4399,
        "listed_count": 1,
        "favourites_count": 4567,
        "statuses_count": 628,
        "created_at": "Wed Nov 07 13:57:36 +0000 2018",
        "utc_offset": null,
        "time_zone": null,
        "geo_enabled": false,
        "lang": "en",
        "contributors_enabled": false,
        "is_translator": false,
        "profile_background_color": "F5F8FA",
        "profile_background_image_url": "",
        "profile_background_image_url_https": "",
        "profile_background_tile": false,
        "profile_link_color": "1DA1F2",
        "profile_sidebar_border_color": "C0DEED",
        "profile_sidebar_fill_color": "DDEEF6",
        "profile_text_color": "333333",
        "profile_use_background_image": true,
        "profile_image_url": "http://pbs.twimg.com/profile_images/1111246305504968709/Q4Git5GO_normal.jpg",
        "profile_image_url_https": "https://pbs.twimg.com/profile_images/1111246305504968709/Q4Git5GO_normal.jpg",
        "profile_banner_url": "https://pbs.twimg.com/profile_banners/1060169399531945984/1554212637",
        "default_profile": true,
        "default_profile_image": false,
        "following": null,
        "follow_request_sent": null,
        "notifications": null
      },
      "geo": null,
      "coordinates": null,
      "place": null,
      "contributors": null,
      "is_quote_status": false,
      "extended_tweet": {
        "full_text": "#WebDollar #money #POS #Bitcoin  #coin #phone #price #card #deposit #instamoney #instahome #instacash #instafree #bounty #reward #instaprice #efficiency #TechNews #Cryptocurrency #Mining #eco #success #DreamBigger #millionairemindset #news #NewsZERO \n\nhttps://t.co/GrIvdhdQu9",
        "display_text_range": [
          0,
          275
        ],
        "entities": { 
          "hashtags": [
            {
              "text": "WebDollar",
              "indices": [
                0,
                10
              ]
            },
            {
              "text": "money",
              "indices": [
                11,
                17
              ]
            },
            {
              "text": "POS",
              "indices": [
                18,
                22
              ]
            },
            {
              "text": "Bitcoin",
              "indices": [
                23,
                31
              ]
            },
            {
              "text": "coin",
              "indices": [
                33,
                38
              ]
            },
            {
              "text": "phone",
              "indices": [
                39,
                45
              ]
            },
            {
              "text": "price",
              "indices": [
                46,
                52
              ]
            },
            {
              "text": "card",
              "indices": [
                53,
                58
              ]
            },
            {
              "text": "deposit",
              "indices": [
                59,
                67
              ]
            },
            {
              "text": "instamoney",
              "indices": [
                68,
                79
              ]
            },
            {
              "text": "instahome",
              "indices": [
                80,
                90
              ]
            },
            {
              "text": "instacash",
              "indices": [
                91,
                101
              ]
            },
            {
              "text": "instafree",
              "indices": [
                102,
                112
              ]
            },
            {
              "text": "bounty",
              "indices": [
                113,
                120
              ]
            },
            {
              "text": "reward",
              "indices": [
                121,
                128
              ]
            },
            {
              "text": "instaprice",
              "indices": [
                129,
                140
              ]
            },
            {
              "text": "efficiency",
              "indices": [
                141,
                152
              ]
            },
            {
              "text": "TechNews",
              "indices": [
                153,
                162
              ]
            },
            {
              "text": "Cryptocurrency",
              "indices": [
                163,
                178
              ]
            },
            {
              "text": "Mining",
              "indices": [
                179,
                186
              ]
            },
            {
              "text": "eco",
              "indices": [
                187,
                191
              ]
            },
            {
              "text": "success",
              "indices": [
                192,
                200
              ]
            },
            {
              "text": "DreamBigger",
              "indices": [
                201,
                213
              ]
            },
            {
              "text": "millionairemindset",
              "indices": [
                214,
                233
              ]
            },
            {
              "text": "news",
              "indices": [
                234,
                239
              ]
            },
            {
              "text": "NewsZERO",
              "indices": [
                240,
                249
              ]
            }
          ],
          "urls": [
            {
              "url": "https://t.co/GrIvdhdQu9",
              "expanded_url": "https://www.cryptoglobe.com/latest/2019/05/bitcoin-search-interest-hits-14-month-high-google-trends-data-shows/",
              "display_url": "cryptoglobe.com/latest/2019/05…",
              "indices": [
                252,
                275
              ]
            }
          ],
          "user_mentions": [],
          "symbols": []
        }
      },
      "quote_count": 0,
      "reply_count": 1,
      "retweet_count": 4,
      "favorite_count": 8,
      "entities": {
        "hashtags": [
          {
            "text": "WebDollar",
            "indices": [
              0,
              10
            ]
          },
          {
            "text": "money",
            "indices": [
              11,
              17
            ]
          },
          {
            "text": "POS",
            "indices": [
              18,
              22
            ]
          },
          {
            "text": "Bitcoin",
            "indices": [
              23,
              31
            ]
          },
          {
            "text": "coin",
            "indices": [
              33,
              38
            ]
          },
          {
            "text": "phone",
            "indices": [
              39,
              45
            ]
          },
          {
            "text": "price",
            "indices": [
              46,
              52
            ]
          },
          {
            "text": "card",
            "indices": [
              53,
              58
            ]
          },
          {
            "text": "deposit",
            "indices": [
              59,
              67
            ]
          },
          {
            "text": "instamoney",
            "indices": [
              68,
              79
            ]
          },
          {
            "text": "instahome",
            "indices": [
              80,
              90
            ]
          },
          {
            "text": "instacash",
            "indices": [
              91,
              101
            ]
          },
          {
            "text": "instafree",
            "indices": [
              102,
              112
            ]
          }
        ],
        "urls": [
          {
            "url": "https://t.co/jxWqmyuzee",
            "expanded_url": "https://twitter.com/i/web/status/1130052399484329984",
            "display_url": "twitter.com/i/web/status/1…",
            "indices": [
              114,
              137
            ]
          }
        ],
        "user_mentions": [],
        "symbols": []
      },
      "favorited": false,
      "retweeted": false,
      "possibly_sensitive": false,
      "filter_level": "low",
      "lang": "und"
    },
    "quoted_status_permalink": {
      "url": "https://t.co/Xo7FL4OPRr",
      "expanded": "https://twitter.com/GiulianoIfrim/status/1130052399484329984",
      "display": "twitter.com/GiulianoIfrim/…"
    },
    "is_quote_status": true,
    "quote_count": 0,
    "reply_count": 0,
    "retweet_count": 0,
    "favorite_count": 0,
    "entities": {
      "hashtags": [
        {
          "text": "WebDollar",
          "indices": [
            0,
            10
          ]
        },
        {
          "text": "Reward",
          "indices": [
            11,
            18
          ]
        },
        {
          "text": "BOUNTY",
          "indices": [
            19,
            26
          ]
        }
      ],
      "urls": [],
      "user_mentions": [],
      "symbols": []
    },
    "favorited": false,
    "retweeted": false,
    "filter_level": "low",
    "lang": "und",
    "timestamp_ms": "1558437276782"
  }
}
