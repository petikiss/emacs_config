#!/bin/bash

if [ $# -eq 0 ]
then
echo "Usage: $0 <string>"
exit
fi


echo find . \( -name *.cc -o -name *.h -o -name *.hh -o -name *.delos\) -exec grep -I --color "$1" {} \; -print
find . \( -name *.cc -o -name *.h -o -name *.hh -o -name *.delos\) -exec grep -I --color "$1" {} \; -print
