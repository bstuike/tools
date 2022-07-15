#!/usr/bin/env ruby
$stdout.flush

# Text colours
RESET = "\033[0m"
YELLOW = "\033[93m"
BLUE = "\033[94m"

arguments = ARGV

# The title function displays a section header
def title(content)
  $stdout.puts(YELLOW, "+-+ +-+ +-+ +-+ +-+ +-+")
  $stdout.puts "#{content}"
  $stdout.puts("+-+ +-+ +-+ +-+ +-+ +-+" + RESET)
end

# The git_check function confirms the correct branch and syncs the repository
def git_check()
  $stdout.puts "Ensuring you're on the developmet branch..."
  $stdout.puts %x[git checkout development]
  $stdout.puts "Checking for repository updates..."
  $stdout.puts %x[git pull]
end

# The git function adds, commits, and pushes updates from the local git directory
def git()
  $stdout.puts %x[git add .]
  $stdout.puts %x[git status]
  message = input("Enter a commit message: ")
  $stdout.puts %x[git commit -m "#{message}"]
  $stdout.puts %x[git push]
end

# The deploy function executes the deploy scripts on cactuar to dev and test
def deploy()
  $stdout.puts %x[ssh -q deploy@cactuar.dmz 'deploy_wp_dev.sh']
  $stdout.puts %x[ssh -q deploy@cactuar.dmz 'deploy_wp_test.sh']
end

# The composer function uses a loop to deliver any number of require arguments
def composer(arguments)
  i = 0; until i == (arguments.length) do
    $stdout.puts %x[composer require "#{arguments[i]}"]
    i += 1
  end
end

# The input function takes a string prompt and asks the user for a string value
def input(prompt)
  ARGV.clear
  print("\n#{prompt}")
  return $stdin.gets.chomp
end

# The continue function pauses the transition to the nest screen until the enter key is pressed
def continue()
  ARGV.clear
  $stdout.puts ("\n" + RESET + "Deploying to test/dev requires" + YELLOW + " VPN " + RESET + "connection")
  print ("Confirm connection and press" + BLUE + " enter/return " + RESET + "to continue ")
  $stdin.gets.chomp
end

# Start of the program
print %x[clear], "\e[3J"
git_check()
title("|U| |p| |d| |a| |t| |e|")
composer(arguments)
title("|G| |i| |t| |H| |u| |b|")
git()
title("|D| |e| |p| |l| |o| |y|")
continue()
deploy()
