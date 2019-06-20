# Kafka advertised host setting

# Understanding communications between Client and with Kafka

	- Advertised listeners is the most important setting of Kafka
	- Example: Kafka Client --> Kafka Broker 1
		- Hey I'd like to connect to you using public IP: 34.56.78.90
		- Sure, but first, you need to use my advertised hostname
		- Here is my advertised host: 127.31.9.1. You have to use it
		- Okay, I'm trying to use: 172.31.9.1 now.
		- If the Kafka client is on the same private network, OKAY
		- If the Kafka client is not on the same network, can't find IP

# But what if I put localhost? It works on my machine!

	- Advertised listeners is the most important setting of Kafka
	- Example: Kafka Client --> Kafka Broker 1
		- Hey I'd like to connect to you using public IP: 34.56.78.90
		- Sure, but first, you need to use my advertised hostname
		- Here is my advertised host: localhost. You have to use it
		- Okay, I'm trying to use: localhost now.
		- If the Kafka client is on the machine, OKAY
		- If the Kafka client is not on the same machine or you have 2 or more broker, NOT OKAY

# What if I use the public IP?

	- Advertised listeners is the most important setting of Kafka
	- Example: Kafka Client --> Kafka Broker 1
		- Hey I'd like to connect to you using public IP: 34.56.78.90
		- Sure, but first, you need to use my advertised hostname
		- Here is my advertised host: 34.56.78.90. You have to use it
		- Okay, I'm trying to use: 34.56.78.90 now. All good!
		
# What if I use the public IP.... But after a reboot Kafka public IP changed!

	- Assume the IP of your server has changed:
		- FROM 34.56.78.90 => TO 34.56.78.12
		- Hey I'd like to connect to you using public IP: 34.56.78.12
		- Sure, but first, you need to use my advertised hostname
		- Here is my advertised host: 34.56.78.90. You have to use it
		- Okay, I'm trying to use: 34.56.78.90 now.
		- Can't connect, no network route to the kafka server. nothing

# So what do I set for advertised.listeners?

	- If your clients are on your private network, set either:
		- the internal private IP
		- the internal private DNS hostname
	- Your clients should be able to resolve the internal IP or hostname

	- If your clients are on a public network, set either:
		- The external public IP
		- The external public DNS hostname pointing to the public IP
	- Your clients must be able to resolve the public DNS

