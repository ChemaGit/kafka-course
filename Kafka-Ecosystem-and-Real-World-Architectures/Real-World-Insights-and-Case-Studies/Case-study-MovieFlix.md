# Case study MovieFlix

# Video Analytics - MovieFlix

	- MovieFlix is a company that allows you to watch TV shows and Movies on demand.
	- The business wants the following capabilities:
		- Make sure the user can resume the video where they left it off
		- Build a user profile in real time
		- Recommend the next show to the user in real time
		- Store all the data in analytics store
	- How would you implement this using Kafka?

# Video Analytics - MovieFlix Architecture

	- Video Player(while playing)	---->	Video Position Service(Producer)	---> 	show_position(topic)	---->	Recommendation Engine in Real Time(Kafka Streams)
	- Video Player(while playing)	---->	Video Position Service(Producer)	---> 	show_position(topic)	---->	Analytics consumer (Kafka Connect)
	- Video Player(while starting)	<----	Resuming Service(Consumer)		<--- 	show_position(topic)	
	- Movies and TV Shows Portal/Website <-- Recommedations Service(Consumer)	<---	recommendations(topic)	---->	Analytics consumer (Kafka Connect)	--> Analytics Store(Hadoop)
	- Movies and TV Shows Portal/Website <-- Recommedations Service(Consumer)	<---	recommendations(topic)	<----	Recommendation Engine in Real Time(Kafka Streams)

# Video Analytics - Comments

	- show_position topic:
		- is a topic that can have multiple producers
		- Should be highly distributed if high volume > 30 partitions
		- If I were to choose a key, I would choose "user_id"
	- recommendations topic:
		- The kafka streams recommendation engine may source data from the analytical store for historical training
		- May be a low volume topic
		- If I were to choose a key, I would choose "user_id"
