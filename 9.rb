require 'csv'

t = Time.now

d = open("data.csv").read.split("\n").map{|x| x.split(' ').map{|x| x.to_i}}
# d = open("data.txt").read.split("\n")

p d.first
res = 0
d.each do |l|
  zz = false # true if we got to zeroes array
  tmp = l # current array of difference
  sts = [] # will contain all the arrays of differences
  until zz
    ar = tmp[1..-1] # removing first element to compute difference
    sts << tmp # storing array of difference
    tmp = ar.each_with_index.map{|x, i| x - tmp[i]} # creating array of difference
    zz = true if ar.uniq == [0] # check if array is zeroes only
  end
  v = 0 # computing result by removing itself to first element of every step array
  sts.reverse.each do |st|
    v = st.first - v
  end
  res += v # computing result
end

p res
