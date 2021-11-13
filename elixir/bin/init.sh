#!/usr/bin/sh

echo "#### ADVENT OF CODE ####"
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# if year / day is not specified
if [ -z $1 ] || [ -z $1 ];
then
  echo "Args Error."
  echo "Usage:"
  echo "init.sh <year> <day>"
else
  echo "Generating Files..."
  echo "YEAR: $1"
  echo "DAY:  $2"
  mkdir -p $1
  cd "$SCRIPT_DIR/../$1/"
  mix new "day$(printf "%02d\n" $2)" > /dev/null
  cd "day$(printf "%02d\n" $2)"
  rm -rf test
  mkdir -p lib/mix/tasks/
  sed "s/01/$(printf "%02d" $2)/" "$SCRIPT_DIR/solve_task_template.ex" > lib/mix/tasks/solve.ex
  echo "Generated Files - Year $1 Day$(printf "%02d\n" $2)"
fi

