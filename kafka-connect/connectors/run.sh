#!/usr/bin/env bash
# run the twitter connector
# connect-standalone connect-standalone.properties twitter.properties
# OR (linux / mac OSX)
/opt/cloudera/parcels/KAFKA-4.0.0-1.4.0.0.p0.1/lib/kafka/bin/connect-standalone.sh connect-standalone.properties twitter.properties
# OR (Windows)
# connect-standalone.bat connect-standalone.properties twitter.properties