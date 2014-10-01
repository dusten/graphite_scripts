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
  lines=`echo "stats" | nc localhost 11211 | awk -v HOSTNAME=$HOSTNAME '/STAT/ && ! /pid|version|pointer| time/ {printf ("%s.memcache.stats.%s %d %d\n",HOSTNAME,$2,$3,systime())}'`
  
  for line in $lines
  do
    # Send data to Graphite  
    echo $line | nc $GRAPHITE $GRAPHITE_PORT
  done 
  IFS=$old_IFS  

  sleep 15
done
