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
  lines=`mysql -e "show status" -s|awk -v HOSTNAME=$HOSTNAME '! / Value / { printf("%s.mysql.stats.%s %d %d\n",HOSTNAME,$1,$2,systime()) }'`
  
  for line in $lines
  do
    # Send data to Graphite  
    echo $line | nc $GRAPHITE $GRAPHITE_PORT
  done 
  IFS=$old_IFS  

  sleep 15
done
