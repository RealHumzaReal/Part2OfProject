#!/bin/bash

filepath="/home/gamerwolf4512/Documents/Part2OfProject/word_library"
word="XXXXX"

randomize_word() {
chosenfile= ls $filepath | shuf -n 1
echo "$chosenfile"
}



while true; do
	echo -e "\nWelcome to Wordle.\nYou have 5 attempts, guess them all wrong and you lose."
	sleep 1
	randomize_word
done