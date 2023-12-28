# Updated the part 1 BFS to know what was inside or not
# Everytime it gets to a neighbour, it computes his inside based on previous node
# In this code I manually transform S into the correct element based on my input
# And I randomly consider the inside at the beginning, either left or right, tried both and got result
# At the end, iterating over every element of the grid, if it's not part of the loop and inside the inside, +1
# Just need to make sure to add to the inside elements which are not directly close to the loop, that's why I added ins["add"]

# But as usual, my code is horrible x)

require 'csv'

t = Time.now

d = open("data.csv").read.split("\n").map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

# p d.first
xs = -1
ys = -1
d.each_with_index do |l, y|
  l.each_with_index do |c, x|
    xs = x if c == 'S'
    ys = y if c == 'S'
  end
end

p xs
p ys

# A remplacer en |
d[ys][xs] = '|'

q = []
v = {}
dis = {}

s = [xs, ys]
q << s
dis[s] = 0
ins = {}
ins[s] = [[s.first + 1, s.last]]
par = {}
par[s] = s

def neighbours(d, f)
  x = f.first
  y = f.last
  case d[y][x]
  when '|' then return [[x, y - 1], [x, y + 1]]
  when '-' then return [[x - 1, y], [x + 1, y]]
  when 'L' then return [[x, y - 1], [x + 1, y]]
  when 'J' then return [[x, y - 1], [x - 1, y]]
  when '7' then return [[x - 1, y], [x, y + 1]]
  when 'F' then return [[x, y + 1], [x + 1, y]]
  end
end

def inside(d, par, x, y, ins)
  pa = par[[x, y]]
  pap = d[pa.last][pa.first]
  cup = d[y][x]
  case cup
  when '|'
    case pap
    when '|'
      ins[[x, y]] = [[ins[pa].first.first, y]]
    when 'L'
      if ins[pa].nil?
        ins[[x, y]] = [[x + 1, y]]
      else
        ins[[x, y]] = [[x - 1, y]]
      end
    when 'J'
      if ins[pa].nil?
        ins[[x, y]] = [[x - 1, y]]
      else
        ins[[x, y]] = [[x + 1, y]]
      end
    when 'F'
      if ins[pa].nil?
        ins[[x, y]] = [[x + 1, y]]
      else
        ins[[x, y]] = [[x - 1, y]]
      end
    when '7'
      if ins[pa].nil?
        ins[[x, y]] = [[x - 1, y]]
      else
        ins[[x, y]] = [[x + 1, y]]
      end
    end
  when '-'
    case pap
    when '-'
      ins[[x, y]] = [[x, ins[pa].last.last]]
    when 'L'
      if ins[pa].nil?
        ins[[x, y]] = [[x, y - 1]]
      else
        ins[[x, y]] = [[x, y + 1]]
      end
    when 'J'
      if ins[pa].nil?
        ins[[x, y]] = [[x, y - 1]]
      else
        ins[[x, y]] = [[x, y + 1]]
      end
    when 'F'
      if ins[pa].nil?
        ins[[x, y]] = [[x, y + 1]]
      else
        ins[[x, y]] = [[x, y - 1]]
      end
    when '7'
      if ins[pa].nil?
        ins[[x, y]] = [[x, y + 1]]
      else
        ins[[x, y]] = [[x, y - 1]]
      end
    end
  when 'F'
    case pap
    when '|'
      if ins[pa].include?([pa.first - 1, pa.last])
        ins[[x, y]] = [[x - 1, y],[x, y - 1]]
      end
    when 'L'
      unless ins[pa].nil?
        ins[[x, y]] = [[x - 1, y],[x, y - 1]]
      end
    when 'J'
      if ins[pa].nil?
        ins[[x, y]] = [[x - 1, y],[x, y - 1]]
      end
    when '-'
      if ins[pa].include?([pa.first, pa.last - 1])
        ins[[x, y]] = [[x - 1, y],[x, y - 1]]
      end
    when '7'
      unless ins[pa].nil?
        ins[[x, y]] = [[x - 1, y],[x, y - 1]]
      end
    end
  when '7'
    case pap
    when '|'
      if ins[pa].include?([pa.first + 1, pa.last])
        ins[[x, y]] = [[x + 1, y],[x, y - 1]]
      end
    when 'L'
      if ins[pa].nil?
        ins[[x, y]] = [[x + 1, y],[x, y - 1]]
      end
    when 'J'
      unless ins[pa].nil?
        ins[[x, y]] = [[x + 1, y],[x, y - 1]]
      end
    when '-'
      if ins[pa].include?([pa.first, pa.last - 1])
        ins[[x, y]] = [[x + 1, y],[x, y - 1]]
      end
    when 'F'
      unless ins[pa].nil?
        ins[[x, y]] = [[x + 1, y],[x, y - 1]]
      end
    end
  when 'L'
    case pap
    when '|'
      if ins[pa].include?([pa.first - 1, pa.last])
        ins[[x, y]] = [[x - 1, y],[x, y + 1]]
      end
    when '7'
      if ins[pa].nil?
        ins[[x, y]] = [[x - 1, y],[x, y + 1]]
      end
    when 'J'
      unless ins[pa].nil?
        ins[[x, y]] = [[x - 1, y],[x, y + 1]]
      end
    when '-'
      if ins[pa].include?([pa.first, pa.last + 1])
        ins[[x, y]] = [[x - 1, y],[x, y + 1]]
      end
    when 'F'
      unless ins[pa].nil?
        ins[[x, y]] = [[x - 1, y],[x, y + 1]]
      end
    end
  when 'J'
    case pap
    when '|'
      if ins[pa].include?([pa.first + 1, pa.last])
        ins[[x, y]] = [[x + 1, y],[x, y + 1]]
      end
    when 'F'
      if ins[pa].nil?
        ins[[x, y]] = [[x + 1, y],[x, y + 1]]
      end
    when '-'
      if ins[pa].include?([pa.first, pa.last + 1])
        ins[[x, y]] = [[x + 1, y],[x, y + 1]]
      end
    when '7'
      unless ins[pa].nil?
        ins[[x, y]] = [[x + 1, y],[x, y + 1]]
      end
    when 'L'
      unless ins[pa].nil?
        ins[[x, y]] = [[x + 1, y],[x, y + 1]]
      end
    end
  end
end


while q.any?
  f = q.first
  q.shift
  v[f] = true

  neighbours(d, f).each do |nb|
    x = nb.first
    y = nb.last
    unless v[nb]
      q << nb
      v[nb] = true
      dis[nb] = dis[f] + 1
      par[nb] = f
      inside(d, par, x, y, ins)
    end
  end
end




p dis.values.max
p v.keys.length
ins["add"] = []
ccc = 0
d.each_with_index do |l, y|
  l.each_with_index do |c, x|
    unless v.key?([x, y])
      ins["add"] << [x + 1, y] if ins.values.flatten(1).include?([x, y]) && v[[x + 1, y]].nil?
      ins["add"] << [x, y + 1] if ins.values.flatten(1).include?([x, y]) && v[[x + 1, y]].nil?
      ccc += 1 if ins.values.flatten(1).include?([x, y])
    end
  end
end

p ccc

#  entre 205 et 602
