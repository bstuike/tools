#!/usr/bin/env zsh
CHOICE=""

# Function: Print a title banner
title() { printf "%6s%11s%16s%26s%31s\n" "Hits" "Date" "Time" "Destination" "Origin" | tee parse.log }

# Function: Print total records found
footer() {
   # awk 'END { print "Records found: ", NR - 1 }' parse.log | tee -a parse.log
   awk 'END { printf "\n%s %s %s\n"," Records","found:",NR-1 }' parse.log | tee -a parse.log
   printf " \U24C2 %-d %-s %-s\n" 2022 Byron Stuike
}

# Function: Print a help message
# usage() { echo "usage: lop [-g get log [PATTERN] [FILE]] [-s search [STRING]] [-r range [LOW] [HIGH]] [-d duo [STRING1] [STRING2]] [-t top records [INT]]" 1>&2; }
usage() { echo "usage: lop [-g [pattern] [file]] [-s [pattern]] [-r [low] [high]] [-d [pattern 1] [pattern 2]] [-t [num]]" 1>&2; }

# Function: Exit with error
exit_bad() {
  usage
  exit 1
}

# Take arguments and assign values
while getopts ":hr:g:t:d:s:k:" opt; do
   case $opt in
      g)  # Set $WORD to specified value
         CHOICE="g"
         ;;
      t)  # Set $SEARCH to specified value
         CHOICE="t"
         ;;
      s)  # Set $WORD to specified value
         CHOICE="s"
         ;;
      r)  # Set $RANGE to specified value
         CHOICE="r"
         ;;
      d)  # Set $RANGE to specified value
         CHOICE="d"
         ;;
      h)  # Set $RANGE to specified value
         CHOICE="h"
         usage
         ;;
      :)  # If expected argument omitted
         echo "-${OPTARG} requires an argument"
         exit_bad
         ;;
      *)  # If unknown (any other) option
         exit_bad
         ;;
   esac
done

# Take action from user input
if [ "$CHOICE" = "g" ]; then
   echo " Loading and sorting log... please wait"
   grep $2 $3 | cat > master.log
   awk '{ printf "%-17s%-15s%-32s%-40s\n", substr($4,14), substr($4,2,11), substr($7,2,25), $1 }' master.log | sort | uniq -c | sort -r > hits.log
   sort -k2 hits.log > when.log
   echo " Complete"
elif [ "$CHOICE" = "t" ]; then
   title
   awk '{ printf "   %-7d%-17s%-15s%-32s%-40s\n", $1, $3, $2, $4, $5 }' hits.log | head -n $2 | tee -a parse.log
   footer
elif [ "$CHOICE" = "s" ]; then
   title
   awk ''/$2/' { printf "   %-7d%-17s%-15s%-32s%-40s\n", $1, $3, $2, $4, $5 }' hits.log | tee -a parse.log
   footer
elif [ "$CHOICE" = "d" ]; then
   title
   awk ''/$2/' && '/$3/' { printf "   %-7d%-17s%-15s%-32s%-40s\n", $1, $3, $2, $4, $5 }' hits.log | tee -a parse.log
   footer
elif [ "$CHOICE" = "r" ]; then
   title
   awk ''/$2/' , '/$3/' { printf "   %-7d%-17s%-15s%-32s%-40s\n", $1, $3, $2, $4, $5 }' when.log | tee -a parse.log
   footer
fi