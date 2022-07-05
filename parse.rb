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

# Author, copyright, and EOF information
END {
  puts sprintf("\n%s %d %s %s", GREEN + "\u24C2", 2022, RESET + "Byron", "Stuike")
  print RESET, "Terminating ", RED, "Ruby ", RESET, "Program\n\n"
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
	puts(CYAN, "Created by " + RESET + "Byron Stuike (byron.stuike@gov.bc.ca)")
	puts(BLUE + "Support and Testing " + RESET + "Byron Stuike (byron.stuike@gov.bc.ca)")
end

# The menu function displays a list of program options
def menu()
	puts(MAGENTA, "  DISCOVER:" + RESET)
  puts CYAN + "    l -- " + RESET + "Leaderboard"
  puts CYAN + "    s -- " + RESET + "String Search"
  puts CYAN + "    r -- " + RESET + "Range of Time"
  puts CYAN + "    d -- " + RESET + "Dual Search (&&)"
  puts CYAN, "    h -- " + RESET + "Help Menu"
  puts CYAN + "    x -- " + RESET + "Exit Application"
end

# The title surrounds the Main Menu title with yellow stars
def title(heading)
  puts YELLOW, "*******************"
  puts "**  " + RESET + "#{heading}" + YELLOW + "  **"
  puts "*******************" + RESET
end

# The header function prints a column banner to organize the data
def header()
  File.write('parse.log', sprintf("%6s%12s%17s%28s%32s\n", "Hits", "Date", "Time", "Destination", "Origin"))
  puts sprintf("\n%6s%12s%17s%28s%32s\n", "Hits", "Date", "Time", "Destination", "Origin")
end

# The continue function pauses the transition to the nest screen until the enter key is pressed
def continue()
	print("\n" + RESET, "Press" + YELLOW + " Enter " + RESET + "to return to the hub ")
	gets.chomp
end

# The input function takes a string prompt and asks the user for a string value
def input(prompt)
	print("\n#{prompt}")
  return gets.chomp
end

# The present function displays the title and header rows
def present()
	welcome()
	title("The Results")
  header()
end

# The parse function compiles the data from a log file into a human readable format
def parse(file, pattern)
  puts " Loading and sorting log... please wait"
  puts %x[grep "#{pattern}" "#{file}" | cat > master.log]
  puts %x[awk '{ printf "%-17s%-15s%-32s%-40s\\n", substr($4,14), substr($4,2,11), substr($7,2,25), $1 }' master.log | sort | uniq -c | sort -r > where.log]
  puts %x[sort -k2 where.log > when.log]
  puts " Complete"
end

# The start function allows the user to parse a new log, or use existing files
def start()
	welcome()
	title("Get Started")
	if input("Do you need to parse a new log? ") == "y"
    parse(input("Where can I find the log? "), input("Enter a search pattern: "))
		continue()
    work()
  else
    work()
  end
end

# The work function uses a switch statement to direct the user to a chosen task
def work()
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
      puts %x[awk '{ printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' where.log | head -n"#{t1}" | tee -a parse.log]
      footer()
      continue()
    when "s" then
      s1 = input("Enter a search pattern: ")
      present()
      puts %x[awk ''/"#{s1}"/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' where.log | tee -a parse.log]
      footer()
      continue()
    when "r" then
      r1 = input("Enter the lower boundary: ")
      r2 = input("Enter the upper boundary: ")
      present()
      puts %x[awk ''/#{r1}/' , '/#{r2}/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' when.log | tee -a parse.log]
      footer()
      continue()
    when "d" then
      d1 = input("Enter the first item: ")
      d2 = input("Enter the corresponding item: ")
      present()
      puts %x[awk ''/#{d1}/' && '/#{d2}/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' where.log | tee -a parse.log]
      footer()
      continue()
    when "h" then
      puts "usage: lop [[s search [STRING]] [r range [LOW] [HIGH]] [d duo [STRING1] [STRING2]] [t top records [INT]]"
      continue()
		end
	end
end

# The footer function prints the number of records found
def footer() puts %x[awk 'END { printf "\\n%s %s %s\\n"," Records","found:",NR-1 }' parse.log | tee -a parse.log] end

# Methods to trigger the start of the program
start()
