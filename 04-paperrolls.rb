class PaperRolls
  
  attr_accessor :data, :total_rolls, :total_avail, :max_rows, :logit

  def initialize
    @data = Array.new
    @total_rolls = 0
    @total_avail = 0
    @max_rows = 0
    @logit = true
  end

  def count_avail(row_num)
    # find and count all the rolls of paper in this row
    this_row_rolls = 0
    this_row_avail = 0
    curr_row = @data[row_num]
    row_len = curr_row.length
    puts "row #{row_num}: #{curr_row}" if @logit
    for i in 0..row_len
      # add to the total rolls found
      this_row_rolls += 1 if curr_row[i] == '@'

      # count nearby rolls
      nearby_rolls = 0
      if curr_row[i] == '@'    
        # look left
        nearby_rolls += 1 if                              i > 0 &&           curr_row[i-1] == '@'
        # look left/down
        nearby_rolls += 1 if row_num < (@max_rows - 1) && i > 0 &&           @data[row_num+1][i-1] == '@'
        # look down
        nearby_rolls += 1 if row_num < (@max_rows - 1) &&                    @data[row_num+1][i] == '@'
        # look down/right
        nearby_rolls += 1 if row_num < (@max_rows - 1) && i < (row_len-1) && @data[row_num+1][i+1] == '@'
        # look right
        nearby_rolls += 1 if                              i < (row_len-1) && curr_row[i+1] == '@'
        # look up/right
        nearby_rolls += 1 if row_num > 0 &&               i < (row_len-1) && @data[row_num-1][i+1] == '@'
        # look up
        nearby_rolls += 1 if row_num > 0 &&                                  @data[row_num-1][i] == '@'
        # look up/left
        nearby_rolls += 1 if row_num > 0 &&               i > 0 &&           @data[row_num-1][i-1] == '@'

        puts "  position #{i} has #{nearby_rolls} rolls nearby" if @logit
        this_row_avail += 1 if nearby_rolls < 4
      end
    end

    puts "  row #{row_num} has #{this_row_rolls} rolls and #{this_row_avail} available"
    @total_avail += this_row_avail
    @total_rolls += this_row_rolls
    
    return this_row_avail
  end

end

rolls = PaperRolls.new

#fn = "input04-sample.txt"
fn = "input04.txt"
rolls.data = File.read(fn).split("\n")

rolls.logit = false if rolls.data.length > 10
unless rolls.data.empty?
  rolls.max_rows = rolls.data.size
  puts "#{ rolls.max_rows } rows of strings, each #{ rolls.data[0].length } long."
  (0..(rolls.max_rows-1)).select { |x| rolls.total_avail += rolls.count_avail(x) }
  
  puts "out of #{ rolls.total_rolls }, #{ rolls.total_avail} are available."
end