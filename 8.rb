require 'csv'

t = Time.now

d = open("data.csv").read.split("\n") #.map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

ins = "LRRLRRRLRRLRRLRRRLRRLRLLRRRLRRRLRRRLRRRLRRRLRRLLRRRLLRLRRRLRRLRRRLLRRRLRLLRRLRLLRLRLLRRLRRRLRRLLRRRLRRRLRLRRRLRRRLRRRLRRRLRLRRRLLRRRLRRLRRRLRLRRRLRRLRLLLLLRRRLRRRLRRRLRRRLRRLLRLRLRRLRRLLRRRLRRRLRRRLLLRRRLRRRLRRRLRLRRRLLRLRLRRLRRLRRRLRRLRRRLRRRLRRRLRRLLRRRLRRLRRLRLLRRRR"

p d.first

arr = {}
d.each do |x|
  s = x.split(' ').first
  l = x.split('(').last.split(',').first
  r = x.split('(').last.split(', ').last.gsub(')', '')
  arr[s] = [l, r]
end

sts = arr.keys.select{|x| x[2] == 'A'}
p sts
i = 0
l = []
sts.length.times { l << 0 }
while true
  p i / 117952056440 if i % 117952056440 == 0
  p "Elapsed time: #{Time.now - t}s" if i % 117952056440 == 0
  # p sts.first if sts.first[2] == 'Z'
  ii = ins[i % ins.length]
  sts.map!{|st| ii == 'L' ? arr[st].first : arr[st].last}
  i += 1
  if sts.map{|x| x[2]}.uniq == ['Z']
    p "YES"
    p i
    return
  end
end


as = [12643, 14257, 15871, 18023, 19637, 16409]

l = 1
as.each do |x|
  l = x.lcm(l)
end
p l
