puts STDIN.each_line(chomp: true).map { |s| p = s[0].ord-'A'.ord; s=s[-1].ord-'Y'.ord; (p+s)%3+1 + (s+1)*3 }.sum
