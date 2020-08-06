# Aperture Science Icon Displayer
This is a simple shell script that gets your current focused window id and output an ascii of your preference for it, based on portal's credit scene (Still Alive and those ascii's at bottom right). Enjoy!

# Customization
~> Change color of the output: change $COLOR variable on "asid.sh". It uses ANSI escape codes.

~> Change delay between each loop iteration: change $SLEEP variable on "asid.sh". Currently, value is on seconds (less ms = more resource consumption & "performance", more ms = less performance & less resource consumption)


/// IMPORTANT

~> Add / change ascii's for a specific application:

1- Open asid with "-s" or "--show" option (asid --show)

2- Focus a window of that application (Firefox for example, just hover over it or click it)

3- Copy the word output (in case of firefox, "Firefox" or "firefox")

4- Create a file in ascii folder with your ascii art and name it with what you copied ("firefox" for example)

5- Thats it, just quit current asid instance and open another one to see changes.

# Dependencies

~> xdotool 

~> x11-utils
