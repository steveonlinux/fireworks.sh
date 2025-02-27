#!/bin/bash
#TODO: get other trajectories working

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
  local color="\033[38;5;${ID}m"
  echo "$color"
}

launch_linear() {
    local x=$((RANDOM % (cols - 2) + 1)) # Random x coordinate for the launch
    local y=$((rows - 1)) # Start at the bottom of the screen
    local color="\033[37m" # White color for the firework trail
   # y_max=$(( y_max - (RANDOM % y_max) ))
    # Move the firework up the screen
    while [ $y -gt "$y_max" ]; do
        draw_frame $x $y "|" "$color" # Draw the firework trail
        sleep 0.05 # Short delay for the animation
        draw_frame $x $y " " "$color" # Clear the previous trail character
        y=$((y-1)) # Move up one row
    done

    # Once the firework reaches the top, make it explode
#    explode $x $y
    explode $x $y
}

launch_squiggle() {
    local x=$((RANDOM % (cols - 2) + 1)) # Random x coordinate for the launch
    local y=$((rows - 1)) # Start at the bottom of the screen
    local color="\033[37m" # White color for the firework trail
    local flag
    if (( RANDOM % 2 )); then
      flag=true
    else
      flag=false
    fi
   # y_max=$(( y_max - (RANDOM % y_max) ))
    # Move the firework up the screen
    while [ $y -gt "$y_max" ]; do
        flag=$([ "$flag" = true ] && echo false || echo true)
        draw_frame $x $y "*" "$color" # Draw the firework trail
        sleep 0.05 # Short delay for the animation
        draw_frame $x $y " " "$color" # Clear the previous trail character
        if [ $flag == false ]; then
          x=$((x-1))
        else
          x=$((x+1))
        fi
        y=$((y-1)) # Move up one row
    done

    # Once the firework reaches the top, make it explode
#    explode $x $y
    explode $x $y
}


launch_parabolic() {
    local x_start=$((RANDOM % (cols - 2) + 1)) # Random x starting point
    local x_end=$((RANDOM % (cols - 2) + 1))   # Random x ending point
    local y_max=$((rows / 4)) # Maximum height of the parabolic path
    local color="\033[37m"    # White color for the firework trail

    local a=$(( (y_max - rows) / ((x_end - x_start) * (x_end - x_start)) )) # Calculate a for the parabola

    # Move the firework along the parabolic path
    for ((x = x_start; x <= x_end; x++)); do
        local y=$(( a * (x - x_start) * (x - x_start) + rows ))
        draw_frame $x $y "|" "$color" # Draw the firework trail
        sleep 0.05 # Short delay for the animation
        draw_frame $x $y " " "$color" # Clear the previous trail character
    done

    # Once the firework reaches the end, make it explode
    explode $x $y
}


explode() {
  local rand_num=$(( (RANDOM % 6) + 1 ))

    case $rand_num in
        1)
          explode_bloom_big $1 $2
        ;;
        2)
          explode_bloom_small $1 $2
        ;;
        3)
          explode_bloom_biggest $1 $2
        ;;
        4)
          explode_starburst $1 $2
        ;;
        5)
          explode_cross $1 $2
        ;;
        6)
          explode_cross_big $1 $2
        ;;

    esac
}
explode_cross() {
    local x=$1
    local y=$2
    local color
    color=$(gen_color)

    local positions=(
        "0 -6" "0 6" "-6 0" "6 0"
        "-3 -3" "-3 3" "3 -3" "3 3"
        "-6 -6" "-6 6" "6 -6" "6 6"
    )

    local symbols=('*' 'o' '+' 'x')

    for symbol in "${symbols[@]}"; do
        for pos in "${positions[@]}"; do
            local dx=${pos% *}
            local dy=${pos#* }
            draw_frame $((x + dx)) $((y + dy)) "$symbol" "$color"
        done
        sleep $time 
    done
}
explode_cross_big() {
    local x=$1
    local y=$2
    local color=$3

    local positions=(
        "0 -8" "0 8" "-8 0" "8 0"
        "-4 -4" "-4 4" "4 -4" "4 4"
        "-8 -8" "-8 8" "8 -8" "8 8"
    )

    local symbols=('*' 'o' '+' 'x')

    for symbol in "${symbols[@]}"; do
        for pos in "${positions[@]}"; do
            local dx=${pos% *}
            local dy=${pos#* }
            draw_frame $((x + dx)) $((y + dy)) "$symbol" "$color"
        done
        sleep $time
    done
}
explode_starburst() {
    local x=$1
    local y=$2
    local color
    color=$(gen_color)

    local positions=(
        "0 -3" "0 3" "-3 0" "3 0"
        "-1 -3" "1 -3" "-1 3" "1 3"
        "-3 -1" "3 -1" "-3 1" "3 1"
        "-2 -2" "-2 2" "2 -2" "2 2"
        "-3 -3" "-3 3" "3 -3" "3 3"
    )

    local symbols=('*' 'o' '+' 'x')

    for symbol in "${symbols[@]}"; do
        for pos in "${positions[@]}"; do
            local dx=${pos% *}
            local dy=${pos#* }
            draw_frame $((x + dx)) $((y + dy)) "$symbol" "$color"
        done
        sleep $time
    done
}

# Function to animate a circular fireworks explosion
explode_bloom_big() {
    local x=$1
    local y=$2
    local color
    color=$(gen_color)

        # Define positions relative to the center for circular effect
     local positions=(
        "0 -3" "0 3" "-3 0" "3 0"
        "-1 -3" "1 -3" "-1 3" "1 3"
        "-3 -1" "3 -1" "-3 1" "3 1"
        "-2 -2" "-2 2" "2 -2" "2 2"
        "-4 0" "4 0" "0 -4" "0 4"
        "-3 -3" "-3 3" "3 -3" "3 3"
        "-2 -4" "2 -4" "-2 4" "2 4"
        "-4 -2" "4 -2" "-4 2" "4 2"
    )

    # Animation frames for the circular explosion
    local symbols=('*' 'o' '+' 'x')

    for symbol in "${symbols[@]}"; do
        for pos in "${positions[@]}"; do
            local dx=${pos% *}
            local dy=${pos#* }
            draw_frame $((x + dx)) $((y + dy)) "$symbol" "$color"
        done
        sleep $time # Short delay between frames
    done
}

explode_bloom_small() {
    local x=$1
    local y=$2
    local color
    color=$(gen_color)

        # Define positions relative to the center for circular effect
    local positions=(
        "0 -2" "0 2" "-2 0" "2 0"
        "-1 -1" "-1 1" "1 -1" "1 1"
        "-2 -2" "-2 2" "2 -2" "2 2"
        "0 -3" "0 3" "-3 0" "3 0"
        "-3 -3" "-3 3" "3 -3" "3 3"
    )

    # Animation frames for the circular explosion
    local symbols=('*' 'o' '+' 'x')

    for symbol in "${symbols[@]}"; do
        for pos in "${positions[@]}"; do
            local dx=${pos% *}
            local dy=${pos#* }
            draw_frame $((x + dx)) $((y + dy)) "$symbol" "$color"
        done
        sleep $time # Short delay between frames
    done
}

explode_bloom_biggest() {
    local x=$1
    local y=$2
    local color
    color=$(gen_color)

    local positions=(
        "0 -4" "0 4" "-4 0" "4 0"
        "-2 -3" "2 -3" "-2 3" "2 3"
        "-3 -2" "3 -2" "-3 2" "3 2"
        "-1 -4" "1 -4" "-1 4" "1 4"
        "-4 -1" "4 -1" "-4 1" "4 1"
        "-3 -3" "-3 3" "3 -3" "3 3"
        "-2 -4" "2 -4" "-2 4" "2 4"
        "-4 -2" "4 -2" "-4 2" "4 2"
    )

    local symbols=('*' 'o' '+' 'x')

    for symbol in "${symbols[@]}"; do
        for pos in "${positions[@]}"; do
            local dx=${pos% *}
            local dy=${pos#* }
            draw_frame $((x + dx)) $((y + dy)) "$symbol" "$color"
        done
        sleep $time
    done
}

# Function to launch multiple fireworks
launch_multiple() {
    local num_fireworks=$1

    for ((i = 0; i < num_fireworks; i++)); do
        (launch_linear &) # Launch each firework in the background
        sleep 0.2 # Short delay between launches to stagger them
    done

    # Wait for all background fireworks to finish
    wait
}

launch() {
  local rand_num=$(( (RANDOM % 2) + 1 ))

    case $rand_num in
        1)
          launch_linear
        ;;
        2)
          launch_squiggle
        ;;
    esac
}

