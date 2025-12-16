#fn = "input07-sample.txt"
fn = "input07.txt"

# read the math problems
data = File.read(fn).split("\n").reject(&:empty?)
puts "#{data.length} lines read"

# part 1

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


# part 2
split_points = []
# for memorizing paths already traversed
$ski_paths = Array.new(data.length) { Array.new(data.length)}
for i in 0..(data.length-1)
	for j in 0..(data.length-1)
		$ski_paths[i][j] = 0
	end
end
$last_found_col = 0

def ski(data, row, col)
	if data[row][col].match(/[.|]/)
		# ski staight down hill
		data[row][col] = '|'
	elsif data[row][col] == '^'
		if $ski_paths[row][col] > 0
			return $ski_paths[row][col]
		else
			# ski down both the left and right sides of the split
			result = col > 0 ? ski(data,row,col-1) : 0
			result += ski(data,row,col+1) if col < data[row].length-1
			$ski_paths[row][col] = result
			return result
		end
	end

  if row < data.length-1	  
    # keep skiing
		return ski(data,row+1, col)
	else
		# at the bottom of the hill
		if col > $last_found_col
			$last_found_col = col
		  # puts "end of path found at col:#{col}" 
		end
    return 1
	end
end

paths = 0

data.each.with_index do |row, r|
	row.each_char.with_index do |c,i|
		if c == 'S'
			puts "total paths = #{ski(data,r+1,i)}"
			break
		end
	end
end

# puts
# $ski_paths.each.with_index do |ary,i|
# 	puts "#{i}. #{ ary.each { |c| c}.join(",") }"
# end
