require "set"

sum = 0
STDIN.each_line(chomp: true) do |line|
  unique_digits, output_displays = line.split(" | ") # separate the unique patterns from the output values
  input_values = unique_digits.split.map { |val| val.chars.to_set } # make the unique patterns Sets for easier comparison
  input_by_size = input_values.group_by { |val| val.size } # group the unique patterns by number of segments (size)
  val_by_digit = Hash(Int32, Set(Char)).new # to track which pattern is which digit
  # identify the obvious digits
  val_by_digit[1] = input_by_size[2].first # 2 segments must be a 1
  val_by_digit[7] = input_by_size[3].first # 3 segments must be a 7
  val_by_digit[4] = input_by_size[4].first # 4 segments must be a 4
  val_by_digit[8] = input_by_size[7].first # and 7 segments must be an 8
  # now it gets trickier; of the two digits that have six segments, 9 has both of 1's segments, but 6 only has one of them
  six_pos = input_by_size[6].index { |val| (val & val_by_digit[1]).size == 1 }
  if six_pos
    val_by_digit[6] = input_by_size[6][six_pos]
    input_by_size[6].delete_at(six_pos)
    # this leaves 0 and 9; 0 shares 3 segments with 4, 9 shares all 4
    zero_pos = input_by_size[6].index { |val| (val & val_by_digit[4]).size < 4 }
    if zero_pos
      val_by_digit[0] = input_by_size[6][zero_pos]
      val_by_digit[9] = input_by_size[6][1-zero_pos]
      # now we have 5-segment digits 2, 3 and 5; digit 3 has both the segments of digit 1, the others only have 1
      three_pos = input_by_size[5].index { |val| (val & val_by_digit[1]).size == 2 }
      if three_pos
        val_by_digit[3] = input_by_size[5][three_pos]
        input_by_size[5].delete_at(three_pos)
        # and finally, digit 2 shares 2 segments with 4, digit 5 has 3
        two_pos = input_by_size[5].index { |val| (val & val_by_digit[4]).size == 2 }
        if two_pos
          val_by_digit[2] = input_by_size[5][two_pos]
          val_by_digit[5] = input_by_size[5][1-two_pos]
          # now we have identified all the digits, de-obfuscate the output values
          digit_by_val = val_by_digit.invert # maps from set value to digit
          sum += output_displays.split.map { |s| s.chars.to_set }.map { |set| digit_by_val[set] }.join.to_i
        end
      end
    end
  end
end

p sum
