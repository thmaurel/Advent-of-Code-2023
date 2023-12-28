require 'csv'

t = Time.now

d = open("data.csv").read.split("\n").map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

# p d.first

# Finding empty lines
ays = []
d.each_with_index do |l, y|
  if l.uniq == ['.']
    ays << y
  end
end

# Finding empty columns
axs = []
xmax =  d.first.length
xmax.times do |x|
  if d.map{|l| l[x]}.uniq == ['.']
    axs << x
  end
end

# Part 1 code to insert empty lines & columns
  # ays.reverse.each do |y|
  #   tmp = []
  #   xmax.times {tmp << '.'}
  #   d.insert(y, tmp)
  # end

  # axs.reverse.each do |x|
  #   d.each do |l|
  #     l.insert(x, '.')
  #   end
  # end

# Finding galaxies
nodes = []
d.each_with_index do |l, y|
  l.each_with_index do |c, x|
    nodes << [x, y] unless c == '.'
  end
end


# Computing smallest distance
# Since it's the difference of coordinates,
# you can do it ignoring the 1000000lines added
# Then just count how many empty columns / lines between the 2 galaxies
# Then add the 999999 * number of empty columns + lines

res = 0
nodes.each do |node|
  nodes.each do |anode|
    unless node == anode
      xmax = anode.first > node.first ? anode.first : node.first
      xmin = anode.first > node.first ? node.first : anode.first
      ymax = anode.last > node.last ? anode.last : node.last
      ymin = anode.last > node.last ? node.last : anode.last
      inf = 0
      (xmin..xmax - 1).to_a.each do |rg|
        inf += 1 if axs.include?(rg)
      end
      (ymin..ymax - 1).to_a.each do |rg|
        inf += 1 if ays.include?(rg)
      end
      res += (node.first - anode.first).abs + (node.last - anode.last).abs + inf * 999999
    end
  end
end

# Since it computes from A to B and from B to A, just taking half to get only one of them
p res / 2
