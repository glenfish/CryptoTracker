#! /bin/bash
# This will get arguments for flags
# while getopts h:a:f: flag
# do
#     case "${flag}" in
#         h) help=${OPTARG};;
#         a) age=${OPTARG};;
#         f) fullname=${OPTARG};;
#     esac
# done
# echo "help: $help";
# echo "Age: $age";
# echo "Full Name: $fullname";

# This will pass just flags
i=1;
output='';
for flag in "$@" 
do
    output+=" "$flag;
    i=$((i + 1));
done
# echo $output;

# call ruby file
ruby ./main.rb$output


