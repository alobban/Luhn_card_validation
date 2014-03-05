require_relative 'processing'

store = Array.new

file = ARGV[0]
File.open(file, "r") do |f|
	f.each_line do |line|
		entry = Processing.new line, store
		store = entry.output
	end
end

#p store

sorted = store.sort { |a,b| a[3] <=> b[3] }

#p sorted

sorted.each do |rec|
	if rec[2].is_a? Numeric
		p rec[3] + ": $" + rec[2].to_s
	else
		p rec[3] + ": " + rec[2].to_s
	end
end