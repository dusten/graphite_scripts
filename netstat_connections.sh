#!/bin/bash

# Set this hostname
HOSTNAME=`hostname --short`

# Set Graphite host
GRAPHITE=graphite
GRAPHITE_PORT=2003
 
# Loop forever
while :
do
  old_IFS=$IFS
  IFS=$'\n'
  lines=`netstat -tan | awk 'NR>2 { print $6 }' | sort | uniq -c | awk -v HOSTNAME=$HOSTNAME '{printf ("%s.netstat.connections.%s %d %d\n",HOSTNAME,$2,$1,systime())}'`
  for line in $lines
  do
    # Send data to Graphite  
    echo $line | nc $GRAPHITE $GRAPHITE_PORT
  done 
  IFS=$old_IFS  

  sleep 15
done
