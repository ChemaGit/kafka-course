# ELASTICSEARCH
````text
- How elasticsearch works?
- If you are logged in your bonsai elasticsearch account, go to Interactive Console
- In the console we can run queries and it gets you information
- Query example: 
````
````json
{
  "name": "px6lx4Q",
  "cluster_name": "elasticsearch",
  "cluster_uuid": "j7eszypuS4udn1EAIPXgIA",
  "version": {
    "number": "6.5.4",
    "build_flavor": "oss",
    "build_type": "tar",
    "build_hash": "d2ef93d",
    "build_date": "2018-12-17T21:17:40.758843Z",
    "build_snapshot": false,
    "lucene_version": "7.5.0",
    "minimum_wire_compatibility_version": "5.6.0",
    "minimum_index_compatibility_version": "5.0.0"
  },
  "tagline": "You Know, for Search"
}
````
````text
- Open a new tab and see the documentation page
- https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html
- Run GET /_cat/health?v 	in the console
- We get information about how our cluster is doing.
- Run GET /_cat/nodes?v 	in the console
- Run GET /_cat/indices?v	in the console

- Create an index
- PUT /twitter
- Run GET /_cat/indices?v	in the console

- Insert documents in our index
    - PUT /twitter/tweets/1
````
````json
{
    "course": "Kafka for Beginners",
    "instructor": "Stephane Maarek",
    "module": "ElasticSearch"
}
````
````json
// And we obtain: 
{
  "_index": "twitter",
  "_type": "tweets",
  "_id": "1",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 2,
    "failed": 0
  },
  "_seq_no": 0,
  "_primary_term": 1
}
// Delete an index
// DELETE /twitter
````