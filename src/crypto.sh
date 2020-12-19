#! /bin/bash


# This will pass just flags
# i=1;
# output='';
# for flag in "$@" 
# do
#     output+=" "$flag;
#     i=$((i + 1));
# done
# echo $output;

# call ruby file
# ruby ./main.rb$output

# This will get arguments for flags
out='';
while getopts u:p:h flag
do
    case "${flag}" in
        u) u=${OPTARG};;
        p) p=${OPTARG};;
        h) h='-h';;
    esac

done
# echo "$u";
# echo "$p";
# echo "$h";
# echo $h $u $p
ruby ./main.rb $h $u $p


