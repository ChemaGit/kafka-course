## Kafka security

### The need for encryption, authentication & authorization in Kafka
````text
- Currently, any client can access your Kafka cluster (authentication)
- The clients can publish / consume any topic data (authorisation)
- All the data being sent is fully visible on the network (encryption)

- Someone could intercept data being sent
- Someone could publish bad data / stael data
- Someone could delete topics

- All these reasons push for more security and an authentication model
````

### Encryption in Kafka
````text
- Encrytion in Kafka ensures that the data exchanged between clients and brokers is secret to routers on the way
- This is similar concept to an https website

    - Kafka Client(producer/consumer) ----> U:Admin, P:supersecret ------> Kafka Brokers(Port 9092 - PLAINTEXT)
    - Kafka Client(producer/consumer) ----> aGVsbG8gd29ybGQzZWh...(Ecryted data) ------> Kafka Brokers (Port 9093 - SSL)
````

### Authentication in Kafka
````text
- Authentication in Kafka ensures that only clients that can prove their identity can connect to our Kafka Cluster
- This is similar concept to a login (username/password)

    - Kafka Client -------> Authentication data ------> Kafka Broker -------> Verify authentication
    - Kafka Client <------- Client is authenticated <------ Kafka Broker <------- Verify authentication

- Authentication in Kafka can take a few forms
- SSL Authentication: clients authenticate to Kafka using SSL certificates
- SASL Authentication:
    - PLAIN: clients authenticate using username / password (weak - easy to setup)
    - Kerberos: such as Microsoft Active Directory (strong - hard to setup)
    - SCRAM: username / password (strong - medium to setup)
````

### Authorisation in Kafka
````text
- Once a client is authenticated, Kafka can verify its identity
- It still needs to be combined with authorisation, so that Kafka knows that
    - "User alice can view topic finance"
    - "User bob cannot view topic trucks"
- ACL (Access Control Lists) have to be maintained by administration and onboard new users
````

### Putting it all together
````text
- You can mix
    - Encryption
    - Authentication
    - Authorisation

- This allows your Kafka clients to:
    - Communicate securely to Kafka
    - Clients would authenticate against Kafka
    - Kafka can authorise clients to read / write to topics
````

### State of the art of Kafka Security
````text
- Kafka Security is fairly new (0.10)
- Kafka Security improves over time and becomes more flexible /easier to setup as time goes
- Currently, it is hard to setup Kafka Security
- Best support for Kafka Security for applications is with Java
````



