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

run_whit_stop_server(){
  func="${1}"
  env="${2:-test}"
  echo "Start ${func}"
  docker-compose exec php-fpm bash -c "${func}"
  if [ $? -eq 0 ]; then
    echo "End ${func}"
    run_command php-fpm "(cd tests/Application && bin/console server:stop -e ${env} )"
  else
    run_command php-fpm "(cd tests/Application && bin/console server:stop -e ${env} )"
    echo "Error in ${func}, server stop"
    exit 1;
  fi
}

assets(){
  env="${1:-dev}"
  run_command php-fpm "(cd tests/Application && bin/console c:c -e ${env} )"
  run_command php-fpm "(cd tests/Application && bin/console sylius:theme:assets:install public --symlink --relative -e ${env} )"
  run_command php-fpm "(cd tests/Application && bin/console assets:install public --symlink --relative --symlink --relative -e ${env} )"
  run_command php-fpm "(cd tests/Application && bin/console sylius:install:assets -e ${env} )"

}

func_tests(){

  env="${1:-test}"
  stopServer=${2:-0}

  if [ $? -eq 1 ]; then
      run_command php-fpm "(cd tests/Application && bin/console server:stop -e ${env} )"
  fi
  assets test ${env}

  run_command php-fpm "(cd tests/Application && bin/console server:start php-fpm:8080 -d public -e ${env} )"
  run_whit_stop_server "(vendor/bin/behat --tags='@javascript' -vvv )"
}
