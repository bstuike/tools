#!/usr/bin/env ruby

# Text colours
RESET = "\033[0m"
GREY = "\033[37m"
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
MAGENTA = "\033[95m"
CYAN = "\033[96m"
WHITE = "\033[97m"

# Background colours
REDBG = "\033[41m"
GREENBG = "\033[42m"
YELLOWBG = "\033[43m"
BLUEBG = "\033[44m"

END {
  print sprintf("\n%s %d %s %s\n", "\u24C2", 2022, "Byron", "Stuike")
  puts RED + "Terminating Ruby Program\n\n"
}

# The welcome function displays the program name and author information
def welcome()
  print "\e[2J\e[H"
	puts(GREENBG + WHITE, "                                                                      ")
	puts("    ________                                     ______  ___          ")
	puts("    ___  __ \\______ ______________________       ___   |/  /_____     ")
	puts("    __  /_/ /_  __ `/__  ___/__  ___/_  _ \\      __  /|_/ / _  _ \\    ")
	puts("    _  ____/ / /_/ / _  /    _(__  ) /  __/      _  /  / /  /  __/    ")
	puts("    /_/      \\__,_/  /_/     /____/  \\___/       /_/  /_/   \\___/     ")
	puts("                                                                      ")
	puts("                                                                      " + RESET)
	puts(CYAN, "Created by " + WHITE + "Byron Stuike (byron.stuike@gov.bc.ca)")
	puts(BLUE + "Support and Testing " + WHITE + "Byron Stuike (byron.stuike@gov.bc.ca)")
end

# The menu function displays a list of options to choose from
def menu()
	puts(MAGENTA, "  DISCOVER:" + RESET)
  puts CYAN + "    l -- " + WHITE + "Leaderboard"
  puts CYAN + "    s -- " + WHITE + "String Search"
  puts CYAN + "    r -- " + WHITE + "Range of Time"
  puts CYAN + "    d -- " + WHITE + "Dual Search (&&)"
  puts CYAN, "    h -- " + WHITE + "Help Menu"
  puts CYAN + "    x -- " + WHITE + "Exit Application"
end

# The title surrounds the Main Menu title with yellow stars
def title(heading)
  puts YELLOW, "*******************"
  puts "**  " + WHITE + "#{heading}" + YELLOW + "  **"
  puts "*******************" + RESET
end

# The continue function pauses the transition to the nest screen until the enter key is pressed
def continue()
	print("\n" + WHITE, "Press" + YELLOW + " Enter " + WHITE + "to return to the hub ")
	gets.chomp
end

# The input function takes a string prompt and asks the user for a string value.
def input(prompt)
	print("\n#{prompt}")
  return gets.chomp
end

# The parse function compiles the data in a human readable format
def present()
	welcome()
	title("The Results")
  puts sprintf("%6s %11s %16s %26s %31s\n", "Hits", "Date", "Time", "Destination", "Origin")
end

def parse(file, pattern)
  puts " Loading and sorting log... please wait"
  puts %x[grep "#{pattern}" "#{file}" | cat > master.log]
  puts %x[awk '{ printf "%-17s%-15s%-32s%-40s\\n", substr($4,14), substr($4,2,11), substr($7,2,25), $1 }' master.log | sort | uniq -c | sort -r > hits.log]
  puts %x[sort -k2 hits.log > when.log]
  puts " Complete"
end

# The information function gathers primary data from the user.
def information()
	welcome()
	title("Get Started")
	if input("Do you need to parse a new log? ") == "y"
    parse(input("Where can I find the log? "), input("Enter a search pattern: "))
		continue()
  end
end

# The start function uses a switch statement to direct the user to a chosen task
def start()
  choice = ""
	while choice != "x"
	  welcome()
	  title("Parsing Hub")
	  menu()
	  choice = input("Make a" + CYAN + " selection" + RESET + ": ")
		case choice
    when "l" then
      t1 = input("Enter the number of rows to display: ")
      present()
      puts %x[awk '{ printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' hits.log | head -n"#{t1}" | tee -a parse.log]
      continue()
    when "s" then
      s1 = input("Enter a search pattern: ")
      present()
      puts %x[awk ''/"#{s1}"/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' hits.log | tee -a parse.log]
      continue()
    when "r" then
      r1 = input("Enter the lower boundary: ")
      r2 = input("Enter the upper boundary: ")
      present()
      puts %x[awk ''/#{r1}/' , '/#{r2}/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' when.log | tee -a parse.log]
      continue()
    when "d" then
      d1 = input("Enter the first item: ")
      d2 = input("Enter the corresponding item: ")
      present()
      puts %x[awk ''/#{d1}/' && '/#{d2}/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' hits.log | tee -a parse.log]
      continue()
    when "h" then
      puts "usage: lop [[s search [STRING]] [r range [LOW] [HIGH]] [d duo [STRING1] [STRING2]] [t top records [INT]]"
      continue()
		end
	end
end

information()
start()
