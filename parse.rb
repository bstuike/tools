#!/usr/bin/env ruby
%x[rm -f "tmp/error.log"]
$stdout.flush

# Text colours
RESET = "\033[0m"
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
MAGENTA = "\033[95m"
CYAN = "\033[96m"
WHITE = "\033[97m"

# Background colour
GREENBG = "\033[42m"

# Author, copyright, and EOF information
END {
  $stdout.puts sprintf("\n%s %d %s", GREEN + "\u24C2", 2022, RESET + "Byron Stuike")
  print RESET, "Terminating ", RED, "Ruby ", RESET, "Program\n\n"
}

# The welcome function displays the program name and author information
def welcome()
  print %x[clear], "\e[3J"
  $stdout.puts GREENBG + WHITE, "    _     _    __   ___   _   ___  __  ___  ___    "
  $stdout.puts "   | |   / \\  / _| | o \\ / \\ | o \\/ _|| __|| o \\   "
  $stdout.puts "   | |_ ( o )( |_n |  _/| o ||   /\\_ \\|  _||   /   "
  $stdout.puts "   |___| \\_/  \\__/ |_|  |_n_||_|\\\\|__/|___||_|\\\\   "
  $stdout.puts "                                                   " + RESET
end


# The menu function displays a list of program options
def menu()
  $stdout.puts(MAGENTA, "  DISCOVER:" + RESET)
  $stdout.puts CYAN + "    l -- " + RESET + "Leaderboard"
  $stdout.puts CYAN + "    s -- " + RESET + "String Search"
  $stdout.puts CYAN + "    r -- " + RESET + "Range of Time"
  $stdout.puts CYAN + "    d -- " + RESET + "Dual Search (&&)"
  $stdout.puts CYAN, "    x -- " + RESET + "Exit Application"
end

# The title surrounds the Main Menu title with yellow stars
def title(heading)
  $stdout.puts YELLOW, "*******************"
  $stdout.puts "**  " + RESET + "#{heading}" + YELLOW + "  **"
  $stdout.puts "*******************" + RESET
end

# The header function prints a column banner to organize the data
def header()
  File.write('tmp/parse.log', sprintf("%6s%12s%17s%28s%32s\n", "Hits", "Date", "Time", "Destination", "Origin"))
  $stdout.puts sprintf("\n%6s%12s%17s%28s%32s\n", "Hits", "Date", "Time", "Destination", "Origin")
end

# The continue function pauses the transition to the nest screen until the enter key is pressed
def continue()
  print("\n" + RESET, "Press" + YELLOW + " Enter " + RESET + "to return to the hub ")
  $stdin.gets.chomp
end

# The input function takes a string prompt and asks the user for a string value
def input(prompt)
  print("\n#{prompt}")
  return $stdin.gets.chomp
end

# The present function displays the title and header rows
def present()
  welcome()
  title("The Results")
  header()
end

def problem
  unless File.readlines("error.log").grep(/directory/)
    input("Can't find the file, try again? ") == "y"
    parse(input("Where can I find the log? "), input("Enter a search pattern: "))
  end
end

# The parse function compiles the data from a log file into a human readable format
def parse(file, pattern)
  $stdout.puts "Attempting to load and sort the log... please wait"
  $stdout.puts %x[grep "#{pattern}" "#{file}" 1> tmp/master.log 2> tmp/error.log]
  problem()
  $stdout.puts %x[awk '{ printf "%-17s%-15s%-32s%-40s\\n", substr($4,14), substr($4,2,11), substr($7,2,25), $1 }' tmp/master.log | sort | uniq -c | sort -r > tmp/where.log]
  $stdout.puts %x[sort -k2 tmp/where.log > tmp/when.log]
  $stdout.puts "Complete"
end

# The start function allows the user to parse a new log, or use existing files
def start()
  welcome()
  title("Get Started")
  if input("Do you need to parse a new log? ") == "y"
    parse(input("Where can I find the log? "), input("Enter a search pattern: "))
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
      $stdout.puts %x[awk '{ printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' tmp/where.log | head -n"#{t1}" | tee -a tmp/parse.log]
      footer()
      continue()
    when "s" then
      s1 = input("Enter a search pattern: ")
      present()
      $stdout.puts %x[awk ''/"#{s1}"/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' tmp/where.log | tee -a tmp/parse.log]
      footer()
      continue()
    when "r" then
      r1 = input("Enter the lower boundary: ")
      r2 = input("Enter the upper boundary: ")
      present()
      $stdout.puts %x[awk ''/#{r1}/' , '/#{r2}/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' tmp/when.log | tee -a tmp/parse.log]
      footer()
      continue()
    when "d" then
      d1 = input("Enter the first item: ")
      d2 = input("Enter the corresponding item: ")
      present()
      $stdout.puts %x[awk ''/#{d1}/' && '/#{d2}/' { printf "   %-7d %-17s %-15s %-32s %-40s\\n", $1, $3, $2, $4, $5 }' tmp/where.log | tee -a tmp/parse.log]
      footer()
      continue()
    end
  end
end

# The footer function prints the number of records found
def footer() $stdout.puts %x[awk 'END { printf "\\n%s %s %s\\n"," Records","found:",NR-1 }' tmp/parse.log | tee -a tmp/parse.log] end

# Method to trigger the start of the program
start()
