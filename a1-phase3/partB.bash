
#Kun Niu
#kun869
#11242427

#/*
#Boru sun, 
#bos226, 
#11233036



#!/bin/bash

if [ "$#" -lt 1 ] 
then
	echo "pleas enter verision number with input values";
else
	case $1 in

		A1)
			if [ "$#" == 4 ]
			then
				if ! [[ $2 =~ ^[0-9]+$ ]] 
				then
					echo "first value all numbers shoule be integer greater or equal to 0";
				elif ! [[ "$3" =~ ^[0-9]+$ ]]
				then
					echo "second value all numbers shoule be integer greater or equal to 0";
				elif ! [[ "$4" =~ ^[0-9]+$ ]]
					then
						echo "third value all numbers shoule be integer greater or equal to 0";
				else
						./PartA $2 $3 $4;
				fi;

				
			else
				echo "wrong number of arguments for A1";
			fi;;
		A2)
						if [ "$#" == 4 ]
			then
				if ! [[ $2 =~ ^[0-9]+$ ]] 
				then
					echo "first value all numbers shoule be integer greater or equal to 0";
				elif ! [[ "$3" =~ ^[0-9]+$ ]]
				then
					echo "second value all numbers shoule be integer greater or equal to 0";
				elif ! [[ "$4" =~ ^[0-9]+$ ]]
					then
						echo "third value all numbers shoule be integer greater or equal to 0";
				else
						./PartA2 $2 $3 $4;
				fi;

				
			else
				echo "wrong number of arguments for A2";
			fi;;

		A3)
			echo "upcomming in phase 2";;

		C1)
		
			if [ "$#" == 1 ]
			then
				./group-testlist;
			else
				echo "dont need arguments for C1";
			fi;;
		esac;
fi;
