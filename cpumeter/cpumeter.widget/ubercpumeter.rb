#!/usr/bin/ruby
# encoding: utf-8

if RUBY_VERSION.to_f > 1.9
	Encoding.default_external = Encoding::UTF_8
	Encoding.default_internal = Encoding::UTF_8
end

RED = '<span class="red">'
GREEN = '<span class="green">'
YELLOW = '<span class="yellow">'
BLUE = '<span class="blue">'
MAGENTA = '<span class="magenta">'
CYAN = '<span class="cyan">'
WHITE = '<span class="white">'
DEFAULT= '<span>'

def spacer(string)
	if string.length > 15
		string = string[0 .. 11] + "...  "
	else
		spaces = 16 - string.length
		0.upto(spaces) do
			string += " "
		end
	end
	string
end

input = %x{ps -arcwwwxo "command %cpu"|iconv -c -f utf-8 -t ascii}.split("\n")
counter, total = 0, 0

# title = ARGV[0] == "-t" ? ARGV[1] : "Top CPU processes"
# print "#{title}\n\n" unless ARGV[0] == "-t" && ARGV[1].nil?
input.delete_if {|line|
	line =~ /^top\s+(\d{1,3}\.\d)$/
}
input.each {|line|
	next if line =~ /bersicht/
	if line =~ /^(.*?)\s+(\d{1,3}\.\d)$/
		exit if counter == 5 or total == 10
		score = $2.to_i
		color = case score
		   when 0..10 then DEFAULT
		   when 11..20 then CYAN
		   when 21..30 then YELLOW
		   when 30..200 then RED
		   else RED
		end

		puts "#{color}#{spacer($1)}(#{$2})</span>"

		counter += 1 if $2.to_i < 1
		total += 1
	end
}
