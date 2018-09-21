#!/bin/bash

for filename in *.tar.gz
do
    echo "Unpacking $filename ..."
    name=$(echo $filename | cut -f 1 -d '.')
    mkdir $name
    tar -xzvf $filename $name
done