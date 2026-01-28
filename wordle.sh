#!/bin/bash

filepath="/home/gamerwolf4512/Documents/Part2OfProject/word_library" #file path to the word library.

wordle_output=""

#colors
no_color="\e[0m"
yellow="\e[1;33m"
green="\e[0;32m"

start_of_game() {
	echo -e "\nWelcome to$green Wordle.$no_color\nYou have$green 5$no_color attempts, guess them all wrong and you$yellow lose.\n $no_color"
	sleep 2
	randomize_word
	guess_word_tries
}


randomize_word() {
	chosenfile=$(ls $filepath | shuf -n 1) #shuffles all files in folder and takes a random one, making it the variable
	answer=$(shuf -n 1 $filepath/$chosenfile) #shuffles all the words in the file and takes a random one for the wordle
} #shuffles word

guess_word_tries(){
	for (( i=1; i<6; )); do #loops for every unless i is greater then 6. i is supposed to represent the gueses
		read -p "Type word here ($i): " guess #reads users guess and i indicates what attempt there on
		check_if_word_is_in_limit
		if [ $i == 6 ]; then
			echo -e "You have failed to find the word!\nThe word was $answer\nWould you like to play again? Yes(Y) No(N)"
			exit_or_continue_game
		fi
	done
} #amount of attempts

check_if_word_is_in_limit(){
	if [ ${#guess} == 5 ]; then #if the guess's length is 5, it will allow the user to continue
		check_if_word_is_in_word_library
	else #if the guess is not any of the above, it will play this message
		echo -e "What you typed in was over/under the limit\nPlease type in again!\n"
	fi
} #checks guess is in limit

check_if_word_is_in_word_library(){
	if [ -e $filepath/${guess::1}.sh ]; then #if the first letter in the word is valid, meaning it exists on the dictionary. It will allow the user to continue
		check_if_word_is_in_dictionary
	else #if the first letter is a value or symbol, it wont allow you to do anything.
		echo -e "What you typed in was a value/symbol.\nPlease type again!\n"
	fi
} #check if guess starts with a letter

check_if_word_is_in_dictionary(){
	if grep -q "$guess" $filepath/${guess::1}.sh; then #uses grep to search for specific phrase in said word library, if it doesn't exist, it'll say it's not a word.
		word_from_answer
	else
		echo "That word is not in the dictionary!"
	fi
} #checks of answer is in the dictionary

word_from_answer(){
	if [ $answer == $guess ]; then #if statement that checks if guess string is = to answer
		echo -e "${green}$answer${no_color}\nCongradulations you guessed the word!\nWould you like to guess again?\n" #if statement true then it says this line of code
		read -p "Just type Yes(Y) or No(N)" continue_playing #asks player if they want to continue playing
		exit_or_continue_game
	elif [ $answer != $guess ]; then #this if statement checks if your guess isnt equal to the answer (could just say else, but I may need to use it later, so i will leave it like this for now. Unless otherwise)
		individually_check_letters
	fi
}

individually_check_letters(){
	for (( c=0; c<5; c++ )); do #loops for 5 times (for each letter)

		guess_letter=${guess:c:1}
		answer_letter=${answer:c:1}

		if [[ $guess_letter == "$answer_letter" ]]; then #this if statement checks if the guess letter is = answer letter
			wordle_output+="$green$guess_letter$no_color" #if the statement is true, it returns with the wordle output being added with a green letter
		elif [[ $answer == *"$guess_letter"* ]]; then #this if statement checks if the letter is at least somewhere in the answer
			wordle_output+="$yellow${guess:c:1}$no_color" #if the statement is true, it returns with the wordle output being added with a yellow letter
		else #unless the statements dont follow any of the following
			wordle_output+="$guess_letter" #unless it really doesnt come true for any of the if statements it comes back with a blank letter
		fi
	done
	echo -e "$wordle_output\n" #says the output
	wordle_output="" #resets output so it doesn't remain the same for the next loop
	((i++)) #adds i so that a try has been used.
}

exit_or_continue_game(){
	case $continue_playing in
		y|Y|yes|Yes) echo -e "\nThe game will start again then!"
		((i=6))
		sleep 2
		start_of_game
		;;
		n|N|no|No) echo -e "\nYou have chosen to exit the game, goodbye!"
		exit
		;;
		*) read -p "Please re-enter your answer:" continue_playing
		exit_or_continue_game
	esac
}

start_of_game
