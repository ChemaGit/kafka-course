# Case study MyBank

	- MyBank is a company that allows real-time banking for its users.
	- It wants to deploy a brand new capability to alert users in case of large transactions.
	- The transaction data already exists in a database
	- Thresholds can be defined by the  users.
	- Alerts must be sent in real time to the users
	- How would you implement the using Kafka?

# Finance application - MyBank Architecture

	- Database of Transactions	---->	Kakfa Connect Source CDC Connector(Debezium)	---> 	bank_transactions(topic)	---->	Real time Big Transactions Detection(Kafka Streams)
	- Users set their threshold in Apps	---->	App Threshold Service(Producer)	---> 	user_settings(topic)	---->	Real time Big Transactions Detection(Kafka Streams)
	- Users see notifications in their apps	<----	Notification Service(Consumer)	<---	user_alerts(topic)	<----	Real time Big Transactions Detection(Kafka Streams)

# Finance application - MyBank Comments

	- Bank Transactions topics:
		- Kafka Connect Source is a great way to expose data from existing databases!
		- There are a tons of CDC(change data capture) connectors for technologies such as PostgreSQL, Oracle, MySQL, SQLServer, MongoDB etc....
	- Kafka Streams application:
		- When a user changes their settings, alerts won't be triggered for past transactions
	- User thresholds topics:
		- It is better to send events to the topic(User 123 enabled threshold at $1000 at 12 pm on July 12th 2018)
		- Than sending the state of the user:(User 123: threshold $1000)