#!/bin/bash

# generate descriptor for dockerfile

function join_by { local IFS="$1"; shift; echo "$*"; }

dockerFile=$1
images=($(sed -n -e 's/^FROM\s*\(.*\):\([0-9]*\.[0-9]*.[0-9]*\)\s*[aA][sS]\s\s*\(\w*\)/\3;\(\2\)/p' $dockerFile))

str=$(join_by "/" "${images[@]}")
str=${str//\//" / "}
str=${str//;/ }

echo $str
