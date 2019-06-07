# Case study GetTaxi

# IOT Example - GetTaxi

	- GetTaxi is a company that allows people to match with taxi drivers on demand, right-away.
	- The business wants the following capabilities:
		- The user should match with a close by driver
		- The pricing should "surge" if the number of drivers are low or the number of users is high
		- All the position data before and during the ride should be stored in an analytics store so that the cost can be computed accurately
	- How would you implement this using Kafka?

# IOT Example - GetTaxi Architecture

	- User Application	---->	Video Position Service(Producer)	---> 	user_position(topic)	---->	Surge Pricing computation model(Kafka Streams/Spark)
	- User Application	---->	Video Position Service(Producer)	---> 	user_position(topic)	---->	Analytics consumer(Kafka Connect)
	- Taxi Driver Application	---->	Taxi Position Service(Producer)	---> 	taxi_position(topic)	---->	Surge Pricing computation model(Kafka Streams/Spark)
	- Taxi Driver Application	---->	Taxi Position Service(Producer)	---> 	taxi_position(topic)	---->	Analytics consumer(Kafka Connect)
	- User Application	<----	Taxi Cost Service(Consumer)		<--- 	surge_pricing(topic)	<----	Surge Pricing computation model(Kafka Streams/Spark)
	- User Application	<----	Taxi Cost Service(Consumer)		<--- 	surge_pricing(topic)	---->	Analytics consumer(Kafka Connect)	--->	Analytics Store(Amazon S3)

# IOT Example - GetTaxi Comments

	- taxi_position, user_position topics:
		- Are topics that can have multiple producers
		- Should be highly distributed if high volume > 30 partitions
		- If I were to choose a key, I would choose "user_id", "taxi_id"
		- Data is ephemeral and probably doesn't need to be kept for a long time

	- surge_pricing topic:
		- The computation of Surge pricing comes from the Kafka Streams application
		- Surge pricing may be regional and therefore that topic may be high volume
		- Other topics such as "weather" or "events" etc can be included in the Kafka Streams application






