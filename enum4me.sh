#!/bin/bash

#enum4me

  echo """

d88888b d8b   db db    db .88b  d88.   j88D  .88b  d88. d88888b 
88'     888o  88 88    88 88'YbdP`88  j8~88  88'YbdP`88 88'     
88ooooo 88V8o 88 88    88 88  88  88 j8' 88  88  88  88 88ooooo 
88~~~~~ 88 V8o88 88    88 88  88  88 V88888D 88  88  88 88~~~~~ 
88.     88  V888 88b  d88 88  88  88     88  88  88  88 88.     
Y88888P VP   V8P ~Y8888P' YP  YP  YP     VP  YP  YP  YP Y88888P 

by OpLogix                                                     
                                                                

  """                                    



# Set a flag for displaying the help menu
display_help=false
amass=false

# Use getopts to parse command-line options
while getopts ":h" opt; do
  case $opt in
    h)
      display_help=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    
  esac
done

# Display the help menu if the -h option is provided
if $display_help; then
  echo "Usage: ./enum4me.sh [ip_address]"
  echo "Usage: ./enum4me.sh [url]"

  echo "Options:"
  echo "  -h  Display this help menu"

  echo "IP address input runs nmap -sV <ports> by deafult"

  echo "URL runs some curl scripts and assetfinder by default"

  exit 0
fi

# Accept input as a command-line argument
input=$1

# Check if input is an IP address
if [[ $input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "What ports do you want to check?"
  echo "1) Common ports..."
  echo "2) All Ports..."
  echo "3) Let me choose..."
  read number
  case $number in
  1)
    # do something if 1 is entered
    echo "Now scanning most common ports..."

    nmap -sV $1
    ;;
  2)
    # do something if 2 is entered
    echo "Now scanning all open ports on $input"
    echo "This might take a second..."


    nmap -p- -sV $1
    ;;
  3)
    # do something if 3 is entered
    echo "Please enter your ports...(Ex. 22,80,443)"
    read ports

    nmap -sV -p $ports $1

    ;;
  *)
    # do something if an invalid option is entered
    echo "Invalid option"
    ;;
esac
  
else
  # Test the website or IP address for software, services, and language
  software=$(curl -I $input | grep "Server" | awk '{print $2}')
  services=$(curl -I $input | grep "X-Powered-By" | awk '{print $2}')
  language=$(curl -I $input | grep "Content-Language" | awk '{print $2}')
  echo "Software: $software"
  echo "Services: $services"
  echo "Language: $language"

  echo "           "
  echo "           "

  echo "-------Running Assetfinder--------"
  echo "  "
  assetfinder $1 > $1.assetfinder.txt

  echo "Results in /$1.4me.txt"
  

fi
