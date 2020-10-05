#!/bin/bash
# cd ..
while [ 1 ]
do
    echo "$PWD->"
    # read -a comm
    # if [ $comm == "exit" ]
    # then
    #     exec 
    # fi
    eval ${comm[@]}
    # echo $1;
    # $comm
    # $(${comm[0]} ${comm[1]}
    # exec bash
done
