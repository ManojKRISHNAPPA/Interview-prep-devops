#!/bin/bash
read -p "enter your first number: " a
read -p "enter your second number: " b
read -p "select your option: (1.additon,2.sub,3.multiplication,4.division): " opt

case $opt in
    1)
        echo "you have selected addition"
        sum=$((a + b))
        echo " the sum of $a and $b is $sum"
        ;;

    3)
        echo "you have selected multiplication"
        multi=$((a * b))
        echo " the sum of $a and $b is $multi"
        ;;
    2)
        echo "you have selected substaratcion"
        sub=$((a - b))
        echo " the sum of $a and $b is $sub"
        ;;    
    4) 
	if [ $b -eq  0 ]; then 
	      echo "ERROR: Division is not allowed zero"	
	else
        	echo "you have selected division"
		div=$((a / b))
		#div=$(echo "scale=2"; $a / $b | bc)
        	echo " the sum of $a and $b is $div"
	fi
        ;;

    *)

    echo "invalid option"
    ;;

esac
