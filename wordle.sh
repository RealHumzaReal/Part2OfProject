#!/bin/bash

filepath="/home/gamerwolf4512/Documents/Part2OfProject/word_library" #file path to the word library.

wordle_output=""

#colors
no_color="\e[0m"
yellow="\e[1;33m"
green="\e[0;32m"

#prompts the user of the beggining of wordle.
start_of_game() {
	echo -e "\nWelcome to$green Wordle.$no_color\nYou have$green 5$no_color attempts, guess them all wrong and you$yellow lose.\n $no_color"
	sleep 2
	randomize_word
	guess_word_tries
}

#function shuffles files first then shuffles the words within the file using grep.
randomize_word() {
	chosenfile=$(ls $filepath | shuf -n 1) 
	answer=$(shuf -n 1 $filepath/$chosenfile) 
}

#uses a for loop with the index representing wordle guesses, asks for user input before going to the check if word is in limit function. If the index is equal to 6 it then tells the player they lost and asks if they would like to continue.
guess_word_tries(){
	for (( i=1; i<6; )); do 
		read -p "Type word here ($i): " guess 
		check_if_word_is_in_limit
		if [ $i == 6 ]; then 
			echo -e "You have failed to find the word!\nThe word was $answer\nWould you like to play again? Yes(Y) No(N)"
			exit_or_continue_game
		fi
	done
}

#checks if the words length is 5 letters long, if it isn't it asks for user to try again
check_if_word_is_in_limit(){
	if [ ${#guess} == 5 ]; then 
		((i--))
		check_if_word_is_in_word_library
	else 
		echo -e "What you typed in was over/under the limit\nPlease type in again!\n"
	fi
}

#checks if the first letter within word matches with a file in the directory, if not it asks the user to try again, however this also consists of capitals too.
check_if_word_is_in_word_library(){
	if [ -e $filepath/${guess::1}.sh ]; then
		check_if_word_is_in_dictionary
	else 
		echo -e "What you typed in was a value/symbol.\nPlease type again!\n"
	fi
}

#uses grep in an if statement for one last time to check if a word is in said letters dictionary, if not it wouldn't count as a word.
check_if_word_is_in_dictionary(){
	if grep -q "$guess" $filepath/${guess::1}.sh; then 
		word_from_answer
	else
		echo "That word is not in the dictionary!"
	fi
}

#uses an if statement to see if the guess is the same or not as the answer, if so the player wins, if not then it checks through the next function what letters match or not
word_from_answer(){
	if [ $answer == $guess ]; then
		echo -e "${green}$answer${no_color}\nCongradulations you guessed the word!\nWould you like to guess again?\n" 
		read -p "Just type Yes(Y) or No(N)" continue_playing 
		exit_or_continue_game
	elif [ $answer != $guess ]; then
		individually_check_letters
	fi
}

#does a for loop for 5 times, indicating each letter in the 5 lettered word, it works perfectly for the green letters however with the yellow letters it wont since it can consist the l in 'allys' as 2 yellows even if the word is later. Being a huge problem that I have yet to figure out how to fix. It then makes the text blank if none are true, before giving the output to the user, and finally adding i as a guess used.
individually_check_letters(){
	for (( c=0; c<5; c++ )); do 
		guess_letter=${guess:c:1}
		answer_letter=${answer:c:1}
		if [[ $guess_letter == "$answer_letter" ]]; then 
			wordle_output+="$green$guess_letter$no_color" 
		elif [[ $answer == *"$guess_letter"* ]]; then 
			wordle_output+="$yellow$guess_letter$no_color"
		else 
			wordle_output+="$guess_letter"
		fi
	done
	echo -e "$wordle_output\n" 
	wordle_output=""
	((i++)) 
}

#case statement that takes user input to see if player wants to continue playing or not, if so it makes i=6 so for loop from earlier resets and starts at the beggining again. If not it just exits out the code entirely and if none of the above it forces the player to re say answer however I think I just accidently made an infite case statement looking back
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
		;;
	esac
}

start_of_game
