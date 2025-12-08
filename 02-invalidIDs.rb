class InvalidIDs
  
  attr_accessor :invalid_other_total, :invalid_half_total, :invalid_other_count, :invalid_half_count, :logit

  def initialize
    @invalid_half_total = 0
    @invalid_half_count = 0
    @invalid_other_total = 0
    @invalid_other_count = 0
    @invalid_list = []
    @logit = true
  end

  def check_id_half(id)
    if id.length.even?
      half_len = id.length / 2
      if id[0, half_len] == id[half_len, half_len]
        # has this id already been added?
        return false if @invalid_list.index(id)

        # add this id to the list
        @invalid_list.push(id)
        @invalid_half_total += id.to_i
        @invalid_half_count += 1
        puts "  #{id}: #{id[0, half_len]}/#{id[half_len, half_len]}. invalids (half) found: #{@invalid_half_count}" if @logit
      end
    end
  end

  def check_id_allsame(id)
    # look at each char, exit if they're not all the same
    first_c = id[0] 
    id.each_char { |c| return false if c != first_c } 

    # this id has already been added
    return false if @invalid_list.index(id)           

    # found one with all same digits
    @invalid_list.push(id)
    @invalid_other_count += 1
    @invalid_other_total += id.to_i
    puts "  #{id}: all same digits; #{@invalid_other_count}" if @logit
  end 

  def check_id_other(id)
    case id.length
    when 6
      # check 3 pairs
      return false unless id[0,2] == id[2,2] && id[2,2] == id[4,2]
    when 8
      # check 4 pairs
      return false unless id[0,2] == id[2,2] && id[2,2] == id[4,2] && id[4,2] == id[6,2]
    when 9
      # check 3 triplets
      return false unless id[0,3] == id[3,3] && id[3,3] == id[6,3]
    when 10
      # check 5 pairs
      return false unless id[0,2] == id[2,2] && id[2,2] == id[4,2] && id[4,2] == id[6,2] && id[6,2] == id[8,2]
    else
      return false
    end

    # has this id already been added to the list?
    return false if @invalid_list.index(id)

    # add this id to the list
    @invalid_list.push(id)
    @invalid_other_count += 1
    @invalid_other_total += id.to_i
    puts "  #{id}: other id match; #{@invalid_other_count}" if @logit
  end

  def check_range(id_range)
    # split the id range into two numbers
    range = id_range.split('-')
    start = range[0].to_i
    stop  = range[1].to_i
    puts "#{id_range}: [#{start}..#{stop}]" if @logit

    # check all the ids in the range
    for i in start..stop
      check_id_half(i.to_s)
      check_id_other(i.to_s)      
      check_id_allsame(i.to_s) if i > 99
    end
  end
end

invalids = InvalidIDs.new
#data = File.read("input02-sample.txt").split(",")
data = File.read("input02.txt").split(",")
invalids.logit = false if data.length > 20
unless data.empty?
  data.each { |x| invalids.check_range(x) }
  puts "the total of the invalid (half) IDs is: #{ invalids.invalid_half_total }."
  puts "the total of the invalid (all) IDs is: #{ invalids.invalid_other_total + invalids.invalid_half_total }."
end
