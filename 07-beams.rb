#fn = "input07-sample.txt"
fn = "input07.txt"

# read the math problems
data = File.read(fn).split("\n").reject(&:empty?)
puts "#{data.length} lines read"

splits = 0

data.each.with_index do |row,r|
	row.each_char.with_index do |c,i|
		if row[i] == 'S'
			data[r+1][i] = '|'
		elsif row[i] == '|' && r < data.length-1
			if data[r+1][i] == '.'
				data[r+1][i] = '|'
			elsif data[r+1][i] == '^'
				splits += 1
				data[r+1][i-1] = '|'
				data[r+1][i+1] = '|'
			end
		end
	end
end

puts data
puts "total splits: #{splits}"