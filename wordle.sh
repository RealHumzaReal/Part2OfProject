#!/bin/bash

filepath="/home/gamerwolf4512/Documents/Part2OfProject/word_library" #file path to the word library.
attempts=0

randomize_word() {
	chosenfile=$(ls $filepath | shuf -n 1) #shuffles all files in folder and takes a random one, making it the variable
	word=$(shuf -n 1 $filepath/$chosenfile) #shuffles all the words in the file and takes a random one for the wordle
} #shuffles word




while true; do
	echo -e "\nWelcome to Wordle.\nYou have 5 attempts, guess them all wrong and you lose."
	sleep 1
	randomize_word
	read -p "1st guess:" $guess1
done