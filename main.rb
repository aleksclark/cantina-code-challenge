require "./lib/finder"
require "pp"

file_name = ARGV[0]
raise "You must provide a file name as the first command line argument" unless file_name
raise "#{file_name} is not a file" unless File.exists?(file_name) && !File.directory?(file_name)

finder = Finder.new(File.read(file_name))
ARGV.clear
puts "Type a selector at the prompt. Type !quit to exit."
while true
  print "> "
  input = gets
  input = input.chomp

  break if input == '!quit'

  begin
    nodes = finder.find_nodes(input)
    if nodes.length == 0
      puts "No nodes found!"
    else
      nodes.each do |n|
        pp n.raw
        puts "-"*80
      end
      puts "#{nodes.length} nodes found."
    end
  rescue Exception => e
    puts e
  end
end

puts "Thanks for using the NodeFinder 3000. Goodbye!"
