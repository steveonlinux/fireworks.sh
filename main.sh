#!/bin/bash

source ./defs.sh

# Hide the cursor
tput civis
# Ensure cursor is visible again on exit
trap "tput cnorm; clear" EXIT

# Clear the screen at the start
clear

main() {
  time=0.1
  rows=$(tput lines)
  cols=$(tput cols)
  y_max=$(($rows / 4))
  x_max=$(($cols - ($cols / 4)))

  while [ 1 -eq 1 ]; do
    launch 2> /dev/null &
#    launch_linear 2> /dev/null &
    wait
    clear
  done
#  while :; do
#    launch_multiple 5 # Number of simultaneous fireworks
#    sleep 1 # Wait before clearing the screen and launching again
#    clear
#  done
}

main
