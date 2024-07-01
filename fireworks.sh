#!/bin/bash

# Hide the cursor
tput civis
# Ensure cursor is visible again on exit
trap "tput cnorm; clear" EXIT

# Clear the screen at the start
clear

draw_frame() {
    local col=$1
    local row=$2
    local char=$3
    local color=$4

    # Move cursor to the position
    tput cup "$row" "$col"

    # Print the character with color
    echo -ne "${color}${char}${RESET}"
}

gen_color() {
  local ID=$(( (RANDOM % 231) + 1 ))
  color="\033[38;5;{$ID}m"
}

launch_linear() {
    local x=$((RANDOM % (cols - 2) + 1)) # Random x coordinate for the launch
    local y=$((rows - 1)) # Start at the bottom of the screen
    local color="\033[37m" # White color for the firework trail

    # Move the firework up the screen
    while [ $y -gt "$y_max" ]; do
        draw_frame $x $y "|" "$color" # Draw the firework trail
        sleep 0.05 # Short delay for the animation
        draw_frame $x $y " " "$color" # Clear the previous trail character
        y=$((y-1)) # Move up one row
    done

    # Once the firework reaches the top, make it explode
    explode $x $y
}

explode() {
  rand_num=$(( (RANDOM % 4) + 1 ))
}

main() {
  rows=$(tput lines)
  cols=$(tput cols)
  y_max=$(($rows / 4))
  x_max=$(($cols - ($cols / 4)))

  launch_linear
}

main
