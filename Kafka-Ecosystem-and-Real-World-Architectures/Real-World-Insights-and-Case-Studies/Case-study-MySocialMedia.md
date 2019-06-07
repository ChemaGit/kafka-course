# Case study MySocialMedia

# CQRS - MySocialMedia

	- MySocialMedia is a company that allows you people to post images and others to react by using "likes" and "comments".
	- The business wants the following capabilities
		- Users should be able to post, like and comments
		- Users should see the total number of likes and comments per post in real
		- High volume of data is expected on the first day of launch
		- Users should be able to see "trending" posts
	- How would you implement this using Kafka?


#  CQRS - MySocialMedia Architecture

	- User posts	---->	Posting Service(Producer)	---> 	posts(topic)	---->	Total Likes / Comments Computation(Kafka Streams/Spark)
	- User posts	---->	Posting Service(Producer)	---> 	posts(topic)	---->	Trending posts in the past hour (Kafka Streams/Spark)
	- User likes	---->	Like Service(Producer)	---> 	likes(topic)	---->	Total Likes / Comments Computation(Kafka Streams/Spark)
	- User likes	---->	Like Service(Producer)	---> 	likes(topic)	---->	Trending posts in the past hour (Kafka Streams/Spark)
	- User comments	---->	Comments Service(Producer)	---> 	comments(topic)	---->	Total Likes / Comments Computation(Kafka Streams/Spark)
	- User comments	---->	Comments Service(Producer)	---> 	comments(topic)	---->	Trending posts in the past hour (Kafka Streams/Spark)
	- Website	<----	Refresh Feed Service(Consumer)	<--- 	posts_with_counts(topic)	<----	Total Likes / Comments Computation(Kafka Streams/Spark)
	- Website	<----	Trending Feed Service(Consumer)	<--- 	trending_posts(topic)	<----	Trending posts in the past hour (Kafka Streams/Spark)

#  CQRS - MySocialMedia Comments

	- Responsibilities are "segregated" hence we can call the model CQRS(Command Query Responsibility Segregation)
	- Posts
		- Are topics that can have multiple producers
		- Should be highly distributed if high volume > 30 partitions
		- If I were to choose a key, I would choose "user_id"
		- We probably want a high retention period of data for this topic

	- Likes, Comments
		- Are topics with multiple producers
		- Should be highly distributed as the volume of data is expected to be much greater
		- If I were to choose a key, I would choose "post_id"

	- The data itself in Kafka should be formatted as "events"
		- User_123 created a post_id 456 at 2 pm
		- User_234 liked a post_id 456 at 3 pm 
		- User_123 deleted a post_id 456 at 6 pm





