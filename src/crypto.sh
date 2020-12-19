#! /bin/bash

while getopts u:p:h flag
do
    case "${flag}" in
        u) u=${OPTARG};;
        p) p=${OPTARG};;
        h) h='-h';;
    esac

done

ruby ./main.rb $h $u $p


