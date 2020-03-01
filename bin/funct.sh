#!/bin/bash -e

run_command(){
  container_name=$1
  func=$2
  echo "Start ${func}"
  docker-compose exec ${container_name} bash -c "${func}"
  if [ $? -eq 0 ]; then
    echo "End ${func}"
  else
    echo $?
    echo "Error in ${func}"
    exit 1;
  fi
}
