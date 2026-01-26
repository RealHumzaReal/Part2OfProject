#!/bin/bash

filepath="/home/gamerwolf4512/Documents/Part2OfProject/word_library" #file path to the word library.

wordle_output=""

no_color="\e[0m"
yellow="\e[1;33m"
green='\e[0;32m'

randomize_word() {
	chosenfile=$(ls $filepath | shuf -n 1) #shuffles all files in folder and takes a random one, making it the variable
	word=$(shuf -n 1 $filepath/$chosenfile) #shuffles all the words in the file and takes a random one for the wordle
} #shuffles word

guess_word_tries(){
	for (( i=1; i<6; )); do #loops for every unless i is greater then 6. i is supposed to represent the gueses
		read -p "Type word here ($i): " answer #reads users answer and i indicates what attempt there on
		check_if_word_is_in_limit
	done
} #amount of attempts

check_if_word_is_in_limit(){
	if [ ${#answer} == 5 ]; then #if the answer's length is 5, it will allow the user to continue
		check_if_word_is_in_word_library
	else #if the answer is not any of the above, it will play this message
		echo -e "What you typed in was over/under the limit\nPlease type in again!\n"
	fi
} #checks answer is in limit

check_if_word_is_in_word_library(){
	if [ -e $filepath/${answer::1}.sh ]; then #if the first letter in the word is valid, meaning it exists on the dictionary. It will allow the user to continue
		echo "it works"
		check_if_word_is_in_dictionary
	else #if the first letter is a value or symbol, it wont allow you to do anything.
		echo -e "What you typed in was a value/symbol.\nPlease type again!\n"
	fi
} #check if answer starts with a letter

check_if_word_is_in_dictionary(){
	if grep -q "$answer" $filepath/${answer::1}.sh; then #uses grep to search for specific phrase in said word library, if it doesn't exist, it'll say it's not a word.
		word_from_answer
	else
		echo "That word is not in the dictionary!"
	fi
} #checks of answer is in the dictionary

word_from_answer(){
	if [ $word == $answer ]; then
		echo -e "${green}$word${no_color}\nCongradulations you guessed the word!\nWould you like to guess again?"
	elif [ $word != $answer ]; then
		individually_check_letters
	fi
}

individually_check_letters(){
	for (( c=0; c<6; c++ )); do
		if [ $answer == "${word:c:1}" ] && [ $wordle_output != "${word:c:1}" ]; then
			wordle_output=$wordle_output${word:c:1}
			echo "$wordle_output"
		fi
	done
}

#Actual code
while true; do
	echo -e "\nWelcome to Wordle.\nYou have 5 attempts, guess them all wrong and you lose.\n"
	sleep 1
	randomize_word
	guess_word_tries
done