#!/bin/bash

# This function will wait until the specified port on the specified machine is available
# Parameters: $1 = the IP; $2 = the port; $3 = the name of the service

set -e

wait_port() {
  while ! netcat -w 5 "$1" "$2"; do
    echo "Waiting for $3 ..."
    sleep 3
  done
}

# Start cassandra container
echo "Starting cassandra container"

if [ -n "$1" ]
then
  SYSTEM_MEMORY=$1
else 
  SYSTEM_MEMORY=8
fi

if [ -n "$2" ]
then 
  ENDPOINT=$2
else 
  ENDPOINT=localhost
fi

sudo docker run -tid --privileged --name cassandra_container -e SYSTEM_MEMORY=$SYSTEM_MEMORY -e ENDPOINT=$ENDPOINT --network host cassandra-webtier

wait_port $ENDPOINT 9042 cassandra
echo "Cassandra is up and running!"
