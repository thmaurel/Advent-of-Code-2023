# So basically applying some formula to compute the area
# Wasn't working on test input (too low), so adding all of the edges length sum, cuz why not ?
# Was giving correct result - 1 on input, so basically did a +1, cuz why not again ?
# Dunno why it works, but hey, I'm on holidays

require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('').map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

p d.first

h = {}

x = 0
y = 0

edges = []
d.each do |l|
  dir_n = l.split(' ').last.gsub(/[()#]/, '')[5].hex
  dir = dir_n == 0 ? 'R' : (dir_n == 1 ? 'D' : (dir_n == 2 ? 'L' : 'U'))

  size = l.split(' ').last.gsub(/[()#]/, '')[0..4].hex
  xi = x
  yi = y
  h[[x, y]] = '#'
  case dir
  when 'R' then x = x + size
  when 'L' then x = x - size
  when 'U' then y = y - size
  when 'D' then y = y + size
  end
  edges << [[xi, x], [yi, y]]
end

# p edges
p "parse fini"


xmin = edges.map{|x| x.first.min}.min
xmax = edges.map{|x| x.first.max}.max
ymin = edges.map{|x| x.last.min}.min
ymax = edges.map{|x| x.last.max}.max

p [xmin, xmax]
p [ymin, ymax]

# 71262565063800
# 71262483231402 answer too low

area = 0
edges.each_with_index do |edge, i|
  area += (edge.first.first - edge.first.last).abs +  (edge.last.last - edge.last.first).abs
  area += (edge.first.first + edge.first.last) * (edge.last.last - edge.last.first)
end

p area / 2 + 1
return

# Marchait part 1


require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('').map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

p d.first

h = {}

x = 0
y = 0
d.each do |l|
  dir_n = l.split(' ').last.gsub(/[()#]/, '')[5].hex
  dir = dir_n == 0 ? 'R' : (dir_n == 1 ? 'D' : (dir_n == 2 ? 'L' : 'U'))

  size = l.split(' ').last.gsub(/[()#]/, '')[0..4].hex

  h[[x, y]] = '#'
  size.times do |k|
    case dir
    when 'R' then x = x + 1
    when 'L' then x = x - 1
    when 'U' then y = y - 1
    when 'D' then y = y + 1
    end
    h[[x, y]] = '#'
  end
end

p "parse fini"

xmin = h.keys.map{|x| x.first}.min
xmax = h.keys.map{|x| x.first}.max
ymin = h.keys.map{|x| x.last}.min
ymax = h.keys.map{|x| x.last}.max

s = [xmin - 1, ymin - 1]

h[s] = '.'

v = {}
q = [s]
v[s] = true

def neighbours(x, y, xmin, xmax, ymin, ymax, h)
  nbs = []
  nbs << [x - 1, y] if x - 1 >= xmin - 1 && h[[x - 1, y]] != '#'
  nbs << [x + 1, y] if x + 1 <= xmax + 1 && h[[x + 1, y]] != '#'
  nbs << [x, y - 1] if y - 1 >= ymin - 1 && h[[x, y - 1]] != '#'
  nbs << [x, y + 1] if y + 1 <= ymax + 1 && h[[x, y + 1]] != '#'
  return nbs
end

p [xmin, xmax]
p [ymin, ymax]
p "Elapsed time: #{Time.now - t}s"
p "bfs start"
while !q.empty?
  f = q.first
  x = f.first
  y = f.last
  q.shift
  neighbours(x, y, xmin, xmax, ymin, ymax, h).each do |nb|
    unless v[nb]
      h[nb] = '.'
      v[nb] = true
      q << nb
    end
  end
end
p "bfs end"

p "count result"
res = 0
(ymin..ymax).to_a.each do |y|
  (xmin..xmax).to_a.each do |x|
    h[[x, y]] = '#' if h[[x, y]].nil?
    res += 1 if h[[x,y ]] == '#'
  end
end
p "res"
p res
p "Elapsed time: #{Time.now - t}s"
return

p xmin
p xmax
p ymin
p ymax
# (ymin..ymax).to_a.each do |y|
#   str = ''
#   xdeb = nil
#   xend = nil
#   (xmin..xmax).to_a.each do |x|
#     str += h[[x,y]] == '#' ? '#' : '.'
#      if h[[x,y]] == '#'
#       xend = x
#       xdeb = x unless xdeb
#      end
#   end
#   if xdeb && xend && xdeb < xend
#     (xdeb..xend).to_a.each do |x|
#       h[[x,y]] = '#'
#     end
#   end
# end

p h
p h.keys.length

p "Elapsed time: #{Time.now - t}s"
