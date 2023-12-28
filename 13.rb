require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

p d

patterns = []
tmp = []

# Parsing input in an array of patterns (full variable name improvement xD)
d.each do |l|
  if l == ''
    patterns << tmp
    tmp = []
  else
    tmp << l
  end
end
patterns << tmp

sum = 0

p patterns.length

# For each pattern
patterns.each do |pat|
  # Size of the pattern
  xm = pat.first.length
  ym = pat.length
  res = nil
  # Iterating over the number of column
  xm.times do |i|
    next if i == 0
    c = 0
    # Iterating over every single element in the column
    pat.each do |l|
      # comparing left part to right part
      [i, xm - i].min.times do |k|
        # counting differences
        c += 1 if l[i - k - 1] != l[i + k]
      end
    end
    # If only one difference, we got it
    if c == 1
      res = i
      break
    end
  end
  # Iterating over the number of rows
  ym.times do |i|
    next if i == 0
    c = 0
    sym = true
    # Comparing top part to bottom
    [i, ym - i].min.times do |k|
      # Comparing every single element of the 2 rows currently compared
      xm.times do |x|
        c += 1 if pat[i - k - 1][x] != pat[i + k][x]
      end
    end
    # If only one difference, we got it
    if c == 1
      res = i * 100
      break
    end
  end
  sum += res
end

# here it is, thanks for my day x)
p sum



p "Elapsed time: #{Time.now - t}s"
