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

# make_payment price type
make_payment () {

	case $2 in

		1) ## by card
			
			echo "Loading terminal, please wait..."

			sleep 5s

			echo "Overall price $1"
			read -p "Enter PIN: " PIN

			failed=0
			check=false

			while [ "$check" = false ]
			do
				if [ "$PIN" = "1234" ]
				then
					echo "Correct PIN, performing payment..."
					sleep 3s
					echo "Connecting with your bank..."
					sleep 3s
					echo "Receiving response..."
					sleep 5s
					echo "Payment successful"

					check=true
				else
					echo "Incorrect PIN - try again"
					let failed=$failed+1

					if [ "$failed" = "3" ]
					then
						echo "Too many failed attempts, goodbye!"
						exit
					fi
				fi

			done

		2) ## by cash

			sum=$1
			while [ "$sum" > "0" ]
			do
				clear

				echo "Price left to pay: $sum"

				echo "Insert coin: "
				echo "1. 1gr"
				echo "2. 2gr"
				echo "3. 5gr"
				echo "4. 10gr"
				echo "5. 20gr"
				echo "6. 50gr"
				echo "7. 1zł"
				echo "8. 2zł"
				echo "9. 5zł"
				read -p "Your choice [1-9]: " coin

				case coin in

					1)
						


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

					clear

					# Check if VIP
					VIP_flag=0
					while [ "$VIP_flag" = "0" ]
					do
						echo "Would you like normal or VIP tickets?"
						read -p "Decision: [N/VIP]" VIP_flag

						if [ "$VIP_flag" != "N" ] || [ "$VIP_flag" != "n"] || [ "$VIP_flag" != "VIP" ] || [ "$VIP_flag" != "vip" ]
						then
							echo "Zły wybór! Spróbuj ponownie."
							continue
						fi
					done

					clear

					# Maybe more than 1 ticket?
					read -p "How many of them would you like to order?: " ticket_count

					if [ "$VIP_flag" = "N" ] || [ "$VIP_flag" = "n" ]
					then
						ticket_types+=( "$ticket_choice;$ticket_count;0" )
					else
						ticket_types+=( "$ticket_choice;$ticket_count;1" )
					fi

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

				# Show overall price
				sum=0
				for i in "${ticket_types[@]}"
				do
					if [ "$(cut -d ";" -f3 <<< "$i")" = "0" ]
					then
						let sum=$sum+"$(( "$(cut -d ";" -f2 <<< "$i")" * "$(cut -d ";" -f3 <<< "${tickets[$(( $(cut -d ";" -f1 <<< $i)-1 ))]}")" ))"
					else 
						let sum=$sum+"$(( $(cut -d ";" -f2 <<< "$i") * $(cut -d ";" -f4 <<< "${tickets[$(( $(cut -d ";" -f1 <<< $i)-1 ))]}") ))"
					fi
				done

				let sum=$sum+"$(cut -d ";" -f3 <<< "${rooms[$(( $room-choice-1 ))]}")"

				echo "Overall price: $sum"
			done
			;;
	esac
done
