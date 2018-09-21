#!/bin/bash

find . -name *.ttcn -exec grep -iR --color "$1" {} \; -print | grep ttcn | tee results.txt

while read row; do
  #echo $row
  fileName=`basename $row`
  moduleName="${fileName%.*}"
  #echo $moduleName
  ttcnName=$moduleName.$fileName
  echo $ttcnName >> results2.txt
done <results.txt