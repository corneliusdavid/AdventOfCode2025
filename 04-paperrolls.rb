class PaperRolls
  
  attr_accessor :data, :total_avail, :max_rows, :logit

  def initialize
    @data = Array.new
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
    puts curr_row if @logit

    for i in 0..row_len
      # add to the total rolls found
      this_row_rolls += 1 if curr_row[i] == '@'

      # count nearby rolls
      nearby_rolls = 0
      if curr_row[i] == '@' || curr_row[i] == 'X'    
        # look left
        nearby_rolls += 1 if                              i > 0 &&           curr_row[i-1].match(/[@X]/)
        # look left/down
        nearby_rolls += 1 if row_num < (@max_rows - 1) && i > 0 &&           @data[row_num+1][i-1].match(/[@X]/)
        # look down
        nearby_rolls += 1 if row_num < (@max_rows - 1) &&                    @data[row_num+1][i].match(/[@X]/)
        # look down/right
        nearby_rolls += 1 if row_num < (@max_rows - 1) && i < (row_len-1) && @data[row_num+1][i+1].match(/[@X]/)
        # look right
        nearby_rolls += 1 if                              i < (row_len-1) && curr_row[i+1].match(/[@X]/)
        # look up/right
        nearby_rolls += 1 if row_num > 0 &&               i < (row_len-1) && @data[row_num-1][i+1].match(/[@X]/)
        # look up
        nearby_rolls += 1 if row_num > 0 &&                                  @data[row_num-1][i].match(/[@X]/)
        # look up/left
        nearby_rolls += 1 if row_num > 0 &&               i > 0 &&           @data[row_num-1][i-1].match(/[@X]/)

        if nearby_rolls < 4
          this_row_avail += 1
          # mark this as being removed
          curr_row[i] = 'X'
        end
      end
    end

    # puts "  row #{row_num} has #{this_row_rolls} rolls and #{this_row_avail} available to be removed"
    
    return this_row_avail
  end

  def count_all_removable
    rolls_removable = 0
    (0..(@max_rows-1)).select { |x| rolls_removable += count_avail(x)  }
    puts "#{ rolls_removable } can be removed."
    return rolls_removable
  end

  def remove_rolls(row_num)
    curr_row = @data[row_num]
    curr_row.each_char.with_index { |c,x| @data[row_num][x] = '.' if c == 'X' }
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

  # count the initial number of rolls that can be removed
  rolls_avail = rolls.count_all_removable
  until rolls_avail == 0 do
    rolls.total_avail += rolls_avail

    # remove the pending rolls from all rows
    (0..(rolls.max_rows-1)).select { |x| rolls.remove_rolls(x) }

    # count the number of rolls that can be removed for this pass
    rolls_avail = rolls.count_all_removable
  end
  
  puts "#{rolls.total_avail} can be removed."
end