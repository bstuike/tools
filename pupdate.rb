#!/usr/bin/env ruby

# Text colours
RESET = "\033[0m"
YELLOW = "\033[93m"
BLUE = "\033[94m"

arguments = ARGV

# The title function displays a section header
def title(content)
  puts(YELLOW, "+-+ +-+ +-+ +-+ +-+ +-+")
  puts "#{content}"
  puts("+-+ +-+ +-+ +-+ +-+ +-+" + RESET)
end

# The git_check function confirms the correct branch and syncs the repository
def git_check()
  puts "Ensuring you're on the developmet branch..."
  puts %x[git checkout development]
  puts "Checking for repository updates..."
  puts %x[git pull]
end

# The git function adds, commits, and pushes updates from the local git directory
def git()
  puts %x[git add .]
  puts %x[git status]
  message = input("Enter a commit message: ")
  puts %x[git commit -m "#{message}"]
  puts %x[git push]
end

# The deploy function executes the deploy scripts on cactuar to dev and test
def deploy()
  puts %x[ssh -q deploy@cactuar.dmz 'deploy_wp_dev.sh']
  puts %x[ssh -q deploy@cactuar.dmz 'deploy_wp_test.sh']
end

# The input function takes a string prompt and asks the user for a string value
def input(prompt)
  ARGV.clear
	print("\n#{prompt}")
  return gets.chomp
end

# The continue function pauses the transition to the nest screen until the enter key is pressed
def continue()
  ARGV.clear
  puts ("\n" + RESET + "Deploying to test/dev requires" + YELLOW + " VPN " + RESET + "connection")
	print ("Confirm connection and press" + BLUE + " enter/return " + RESET + "to continue ")
	gets.chomp
end

# loop for compiling arguments
i = 0; until i == (arguments.length) do
  command = "#{command}" + arguments[i]
  i += 1
end

# Start of the program
print "\e[2J\e[H"
git_check()
title("|U| |p| |d| |a| |t| |e|")
puts %x[composer require "#{command}"]
title("|G| |i| |t| |H| |u| |b|")
git()
title("|D| |e| |p| |l| |o| |y|")
continue()
deploy()
