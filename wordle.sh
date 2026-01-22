#!/bin/bash

filepath="/home/gamerwolf4512/Documents/Part2OfProject/word_library" #file path to the word library.
attempts=0

randomize_word() {
	chosenfile=$(ls $filepath | shuf -n 1) #shuffles all files in folder and takes a random one, making it the variable
	word=$(shuf -n 1 $filepath/$chosenfile) #shuffles all the words in the file and takes a random one for the wordle
} #shuffles word

guess_word_tries(){
	for (( i=1; i<6; )); do
		read -p "Type word here: $i " answer
		check_if_word_is_in_limit
	done
}

check_if_word_is_in_limit(){
	if [ ${#answer} == 5 ]; then
		check_if_word_is_in_limit
	else
		echo -e "What you typed in was over/under the limit\nPlease type in again!\n"
	fi
}

check_if_word_is_in_dictionary(){
	echo "Test"
}

while true; do
	echo -e "\nWelcome to Wordle.\nYou have 5 attempts, guess them all wrong and you lose.\n"
	sleep 1
	randomize_word
	guess_word_tries
done