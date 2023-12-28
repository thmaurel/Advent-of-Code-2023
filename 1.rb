require 'csv'

d = open("data.csv").read.split("\n")
#  .map{|x| x.to_i}

# d = open("data.txt").read.split("\n")

res = []

d = ['lkdbjd5']

d.each do |l|
  ns = []
  l.gsub!('one', 'o1e')
  l.gsub!('two', 't2o')
  l.gsub!('three', 't3e')
  l.gsub!('four', 'f4r')
  l.gsub!('five', 'f5e')
  l.gsub!('six', 's6x')
  l.gsub!('seven', 's7n')
  l.gsub!('eight', 'e8t')
  l.gsub!('nine', 'n9e')
  p l
  l.split("").each do |c|
    ns << c.to_i if c.to_i != 0
  end
  res << ns.first * 10 + ns.last
  p res
end

p res.sum
