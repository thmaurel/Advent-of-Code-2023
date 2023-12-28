require 'csv'

t = Time.now

d = open("data.csv").read.split("\n") #.map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

# p d.first
fives = []
fours = []
fulls = []
threes = []
twop = []
onep = []
high = []

# Sorting combinations in different arrays
d.each do |l|
  h = l.split(' ').first.split('')
  b = l.split(' ').last.to_i
  if h.uniq.length == 1 || (h.uniq.length == 2 && h.uniq.include?('J'))
    fives << l
  elsif h.count(h.sort[3]) == 4 || (h.select{|x| x != 'J'}.uniq.length == 2 && h.select{|x| x != 'J'}.map{|x| h.count(x)}.include?(1))
    fours << l
  elsif h.uniq.length == 2 && [3,2].include?(h.count(h.sort.first)) || (h.select{|x| x != 'J'}.uniq.length == 2)
    fulls << l
  elsif h.uniq.length == 3 && h.count(h.sort[2]) == 3 || h.map{|x| h.count(x) + h.count('J')}.include?(3)
    threes << l
  elsif h.uniq.length == 3 && h.map{|x| h.count(x)}.sort == [1, 2, 2, 2, 2] || h.select{|x| x != 'J'}.uniq.length == 3
    twop << l
  elsif h.uniq.length == 4 || h.select{|x| x != 'J'}.uniq.length == 4
    onep << l
  elsif h.uniq.length == 5 && h.select{|x| x != 'J'}.uniq.length == 5
    high << l
  else
    p "ERROR"
    p l
    p h.map{|x| h.count(x)}.sort
  end
end


# Sorting all arrays to make the best hand first
vs = {'J' => 1, 'A' => 14, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8, '9' => 9, 'T' => 10, 'Q' => 12, 'K' => 13 }

fives.sort_by! do |l|
  h = l.split(' ').first
  vs[h[4]] + 100 * vs[h[3]] + 10000 * vs[h[2]] + 1000000 * vs[h[1]] + 100000000 * vs[h[0]]
end

fours.sort_by! do |l|
  h = l.split(' ').first
  vs[h[4]] + 100 * vs[h[3]] + 10000 * vs[h[2]] + 1000000 * vs[h[1]] + 100000000 * vs[h[0]]
end

fulls.sort_by! do |l|
  h = l.split(' ').first
  vs[h[4]] + 100 * vs[h[3]] + 10000 * vs[h[2]] + 1000000 * vs[h[1]] + 100000000 * vs[h[0]]
end

threes.sort_by! do |l|
  h = l.split(' ').first
  vs[h[4]] + 100 * vs[h[3]] + 10000 * vs[h[2]] + 1000000 * vs[h[1]] + 100000000 * vs[h[0]]
end

twop.sort_by! do |l|
  h = l.split(' ').first
  vs[h[4]] + 100 * vs[h[3]] + 10000 * vs[h[2]] + 1000000 * vs[h[1]] + 100000000 * vs[h[0]]
end

onep.sort_by! do |l|
  h = l.split(' ').first
  vs[h[4]] + 100 * vs[h[3]] + 10000 * vs[h[2]] + 1000000 * vs[h[1]] + 100000000 * vs[h[0]]
end

high.sort_by! do |l|
  h = l.split(' ').first
  vs[h[4]] + 100 * vs[h[3]] + 10000 * vs[h[2]] + 1000000 * vs[h[1]] + 100000000 * vs[h[0]]
end


fives.reverse!
fours.reverse!
fulls.reverse!
threes.reverse!
twop.reverse!
onep.reverse!
high.reverse!


# Computing score from the best hand to the worst one
res = 0
rank = d.length

fives.each do |f|
  res += f.split(' ').last.to_i * rank
  rank -= 1
end

fours.each do |f|
  res += f.split(' ').last.to_i * rank
  rank -= 1
end
fulls.each do |f|
  res += f.split(' ').last.to_i * rank
  rank -= 1
end
threes.each do |f|
  res += f.split(' ').last.to_i * rank
  rank -= 1
end
twop.each do |f|
  res += f.split(' ').last.to_i * rank
  rank -= 1
end
onep.each do |f|
  res += f.split(' ').last.to_i * rank
  rank -= 1
end
high.each do |f|
  res += f.split(' ').last.to_i * rank
  rank -= 1
end

p res
