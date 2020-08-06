#!/bin/bash

###### DEPENDENCIES ######
#~xdotool
#~x11-utils (xprop)

# Start option to show or not window class
case $1 in
 -g|--get) xprop WM_CLASS | awk '{print $NF}' | tr '-' "_" | tr '"' " " ;; # Kind of useless piece of code
 -s|--show) show_class=true ;; # If -s or --show passed as argument, it shows ascii's AND class of the window
 -h|--help) 
 printf("\n ASIGD is a simple script that displays a icon in function of your current focused window. \n\tArguments:\n  -s \/ --show: to display focused window's WM_CLASS (necessary to implement personalized ascii art\n  -h \/--help: Displays this list. \n\n\t)")
 printf ("\n\t Sidenote: if you want to set your own ascii art, create a .txt file on ascii/. The name of that file should be the name that displays with the --show option (formatted WM_CLASS).\n Example: i want to set an ascii to gnome terminal. Then i'll open asigd --show, focus a gnome terminal and then copy those words to name the ascii. For this case, the file should be named it as 'Gnome_Terminal'");;
**) show_class=false ;; 
esac
 
COLOR='\033[0;34m' # uses ANSI escapes codes to set a code. Default: blue
SLEEP=0.2 # time between each while true loop iteration. Default: 0.2 (200 ms). Used to get better (less) resource consumption.
last_class=1010 # Any value should do it, this is to avoid a bug where current_class = last_class, so program prints every second instead of when focused window changes.


# Function get_class: get focused window id using xdotool, then xprop use it to get focused window class. Also, it removes '"-'

function get_class() 
{
	local current_id=$(xdotool getwindowfocus) # Get id process of focused window
	current_class=$(xprop -id "$current_id" WM_CLASS | awk '{print $NF}' | tr '-' "_" | tr '"' " ") # xprop use process id collected on last line to get WM_CLASS.
}

# Function compare_class: wait until current_class, given by get_class, its different to last_class, which initially is 1010 and then it becomes same as current_class and calls get_ascii_location. This function a chain if current_class is not last_class

function compare_class()
{
if [[ "$last_class" == "$current_class" ]] ; then # If focused window doesnt change, just do nothing
	sleep 0	
else 
	last_class=$current_class # Update last_class value to actual focused window value 
	get_ascii_location $current_class # Call next function with the current focused window class as a argument
#	echo $last_class $current_class

fi
}

# Function get_ascii_location: sets $current_icon by searching into ascii's directory a file with same name as WM_CLASS. In case it doesnt finds anything, sets $currenticon as default. 

function get_ascii_location() 
{
local icons_directory="./ascii/" # Where ascii's arts are located (directory)
if [ -e $icons_directory$1 ] ; then
	current_icon=$(cat $icons_directory$1) # If the focused window class name exists as a file on your ascii's directory, set current_icon as the content of that file

elif [ ! -e $icons_directory$1 ] && [ -e $icons_directory"default" ] ; then
	current_icon=$(cat $icons_directory"default") # If there is no coincident file, current_icon = content of default.txt

else
	current_icon=$(echo "why?how?") # Why? How?
fi

draw_icon
}


# Function draw_icon: Draws $currenticon when called. Also, checks for show_class state, so if you passed -s as a argument, prints WM_CLASS already formatted

function draw_icon() 
{
if [[ $show_class = false ]] ; then # Check for --show argument = false
	clear
	echo -e "$COLOR $current_icon" | head -c -1 # $COLOR - applies color to text # $current_icon - cat your ascii file  # head - to erase default new line of echo
else				# Check for --show argument = true
	clear 
	echo -e "$COLOR $current_icon\t\t$current_class" | head -c -1 # $current_class - echoes current focused window WM_CLASS formatted. You can need to use this name if you want to add an ascii 
fi
}



while :
do
	sleep $SLEEP # To get better performance. You can delete it or set it to 0 if you want, anyway gives a little delay that you could or couldn't like between every new icon refresh  
	get_class
	compare_class
done





