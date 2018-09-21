#!/bin/bash


function arg()
{
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
verbose=0

while getopts "h?vf:" opt; do
    case "$opt" in
        h|\?)
            #show_help
            exit 0
            ;;
        v)  verbose=1
            ;;
        f)  output_file=$OPTARG
            ;;
    esac
done
}


logdir="/home/emrtsis/logs/"

if [ -z $1 ]
then
    echo "Filename missing!"
    exit 1
fi



filename=$(basename "$1")
extension="${filename##*.}"
filename="${filename%.*}"

mkdir -vp $logdir/$filename
echo $logdir/$filename/
echo $1
tar -xzvf $1 -C $logdir/$filename/
cd $logdir/$filename/
