#!/bin/bash

# Skrypt Kino 
# Bartosz Kubacki
# 7.12.2018
# All rights reserved

# Declare variables
declare -a movies
declare -a rooms
declare -a tickets

# Functions responsible for loading data from files
load_files () {

	# Load movies
	let i=0
	while IFS=$'\n' read -r data_line
	do
		movies[i]="${data_line}"
		((++i))
	done < ~/Desktop/Kolokwium_8.12/res/movies.txt

	# Load rooms
	let i=0
	while IFS=$'\n' read -r data_line
	do
		rooms[i]="${data_line}"
		((++i))
	done < ~/Desktop/Kolokwium_8.12/res/rooms.txt

	# Load tickets
	let i=0
	while IFS=$'\n' read -r data_line
	do
		tickets[i]="${data_line}"
		((++i))
	done < ~/Desktop/Kolokwium_8.12/res/tickets.txt
	
}

# Load all necessary files
load_files

# Show welcome page
echo "$(cat ~/Desktop/Kolokwium_8.12/res/welcome.txt)"

echo

while true; do

	echo "Choose one of below available options:"
	echo "1. Buy a ticket"
	echo "2. Room reservation"
	echo "3. Buffet"
	echo "4. Exit"
	read -p "Your choice [1-4]: " main_choice
	clear

	case $main_choice in

		1)
			while true; do
				echo "Choose which movie you would like to watch:"
				# List all available movies
				let counter=1
				for i in "${movies[@]}"
				do
					echo "$counter. $(cut -d ";" -f2 <<< "$i")"
					((counter++))
				done
				echo "Enter 'q' to exit or 'r' to return to main menu"

				read -p "Your choice [1-4 q r]: " movie_choice
				clear

				if [ "$movie_choice" = 'q' ] 
				then
					exit
				elif [ "$movie_choice" = 'r' ] 
				then
					break
				fi

				declare -a ticket_types
				while true; do
					echo "Choose ticket type:"
					# List all available ticket types
					let counter=1
					for i in "${tickets[@]}"
					do
						echo "$counter. $(cut -d ";" -f2 <<< "$i") Price: $(cut -d ";" -f3 <<< "$i")zł VIP: $(cut -d ";" -f4 <<< "$i")zł"
						((counter++))
					done
					echo "Enter 'q' to exit or 'r' to return"

					read -p "Your choice [1-4 q r]: " ticket_choice
					clear

					if [ "$ticket_choice" = 'q' ] 
					then
						exit
					elif [ "$ticket_choice" = 'r' ] 
					then
						break
					fi	

					# Check if VIP
					VIP_flag=0
					while [ "$VIP_flag" = "0"]
					do
						echo "Would you like normal or VIP tickets?"
						read -p "Decision: [N/VIP]" VIP_flag

						if [ "$VIP_flag" != "N" ] || [ "$VIP_flag" != "n"] || [ "$VIP_flag" != "VIP" ] || [ "$VIP_flag" != "vip" ]
						then
							

					clear

					# Maybe more than 1 ticket?
					read -p "How many of them would you like to order?: " ticket_count

					ticket_types+=( "$ticket_choice;$ticket_count" )

					echo "Would you like to choose more ticket types?"
					read -p "Decision [Y/N]: " check

					if [ "$check" = "N" ] || [ "$check" = "n" ]
					then
						clear
						break
					elif [ "$check" = "Y" ] || [ "$check" = "y" ]
					then
						clear
						continue
					else
						clear
						echo "What the fuck?"
					fi

				done

				echo "Choose appropriate room:"
				#List all available rooms
				let counter=1
				for i in "${rooms[@]}"
				do
					echo "$counter. $(cut -d ";" -f2 <<< "$i") Capacity: $(cut -d ";" -f2 <<< "$i") Screen size: $(cut -d ";" -f4 <<< "$i") Additional price: $(cut -d ";" -f3 <<< "$i")"
					((counter++))
				done
				echo "Enter 'q' to exit or 'r' to return to main menu"

				read -p "Your choice [1-4 q r]: " room_choice
				clear

				if [ "$room_choice" = 'q' ] 
				then
					exit
				elif [ "$room_choice" = 'r' ] 
				then
					break
				fi	

				# Show overall calculation of price
				echo "Your order details:"
				echo "1. Movie: $(cut -d ";" -f2 <<< "${movies[$movie_choice]}")"
				echo "2. Tickets:"

				# Show all tickets
				let counter=1
				for i in "${ticket_types[@]}"
				do
					temp="$(cut -d ";" -f1 <<< "$i")"
					echo " 2.$counter. Type: $(cut -d ";" -f2 <<< "${tickets[$(( $temp-1 ))]}") | Amount: $(cut -d ";" -f2 <<< "$i")"
				done

				echo "3. Room:"
				echo " 3.1 Screen size: $(cut -d ";" -f4 <<< "${rooms[$(( $room_choice-1 ))]}")"
				echo " 3.2 Capacity: $(cut -d ";" -f2 <<< "${rooms[$(( $room_choice-1 ))]}")"
				echo " 3.3 Additional price: $(cut -d ";" -f3 <<< "${rooms[$(( $room_shoice-1 ))]}")"

			done
			;;
	esac
done
