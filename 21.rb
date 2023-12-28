# What happens is basically:
# All the grids are rounded by . and have straight way from source to border with .

# So you can figure out how many grids will be fully covered
# And then you need to treat the edge case
# Some paper and pen to draw it help

require 'csv'

t = Time.now

d = open("data.csv").read.split("\n").map{|x| x.split('')}#.map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

# p d.first

# The following lines determines the source coordinates
xs = nil
ys = nil

d.each_with_index do |l, y|
  l.each_with_index do |c, x|
    if c == 'S'
      xs = x
      ys =y
    end
  end
end

# The source is considered as a garden plot (thought it was useless but it does change the result for some reason)
d[ys][xs] = '.'

# BFS from the source to compute the distance to each point
s = [xs, ys]
q = [s]
dis = {}
v = {}

v[s] = true
dis[s] = 0

def nbs(x, y, d)
  nbz = []
  nbz << [x - 1, y] if d[y][x - 1] == '.' && x > 0
  nbz << [x + 1, y] if !d[y][x + 1].nil? && d[y][x + 1] == '.'
  nbz << [x, y - 1] if d[y - 1][x] == '.' && y > 0
  nbz << [x, y + 1] if d[y + 1] && d[y + 1][x] == '.'
  return nbz
end

while !q.empty?
  f = q.first

  q.shift
  nbs(f.first, f.last, d).each do |nb|
    unless v[nb]
      v[nb] = true
      q << nb
      dis[nb] = dis[f] + 1
    end
  end
end

# This gives the number of plots you can reach from the source if you walk an ODD number of times
p "Impair depuis la source"
p dis.select{|k, v| v.odd?}.length

# This gives the number of plots you can reach from the source if you walk an EVEN number of times
p "Pair depuis la source"
p dis.select{|k, v| v.even?}.length

# Shit is starting now on :/

# Computing the distance from the 4 corners
# We got 2 cases to cover, if we walk 64 steps or if we walk 195 steps
# So BFS from every single corner and storing the nb of garden plots :  [64 steps, 195 steps]

corners = [
  [0, 0],
  [d.first.length - 1, 0],
  [0, d.length - 1],
  [d.first.length - 1, d.length - 1]
]

c_val = corners.map do |s|
  q = [s]
  dis = {}
  v = {}

  v[s] = true
  dis[s] = 0

  def nbs(x, y, d)
    nbz = []
    nbz << [x - 1, y] if d[y][x - 1] == '.' && x > 0
    nbz << [x + 1, y] if d[y][x + 1] == '.' && x + 1 <= d.first.length - 1
    nbz << [x, y - 1] if d[y - 1][x] == '.' && y > 0
    nbz << [x, y + 1] if d[y+1] && d[y + 1][x] == '.' && y + 1 <= d.length - 1
    return nbz
  end

  while !q.empty?
    f = q.first

    q.shift
    nbs(f.first, f.last, d).each do |nb|
      unless v[nb]
        v[nb] = true
        q << nb
        dis[nb] = dis[f] + 1
      end
    end
  end
  {s => [dis.select{|k, v| v.even? && v <= 64}.length, dis.select{|k, v| v.odd? && v <= 195}.length]}
end

p c_val


# These are not corners but the middle of the border, just a copy paste from previous one
# We need to know how many plots covered if we walk 130 steps
corners = [
  [0, ys],
  [d.first.length - 1, ys],
  [xs, 0],
  [xs, d.length - 1]
]

vh_val = corners.map do |s|
  q = [s]
  dis = {}
  v = {}

  v[s] = true
  dis[s] = 0

  def nbs(x, y, d)
    nbz = []
    nbz << [x - 1, y] if d[y][x - 1] == '.' && x > 0
    nbz << [x + 1, y] if d[y][x + 1] == '.' && x + 1 <= d.first.length - 1
    nbz << [x, y - 1] if d[y - 1][x] == '.' && y > 0
    nbz << [x, y + 1] if d[y+1] && d[y + 1][x] == '.' && y + 1 <= d.length - 1
    return nbz
  end

  while !q.empty?
    f = q.first

    q.shift
    nbs(f.first, f.last, d).each do |nb|
      unless v[nb]
        v[nb] = true
        q << nb
        dis[nb] = dis[f] + 1
      end
    end
  end

  {s => dis.select{|k, v| v.even? && v <= 130}.length}
end

p vh_val


# Here is the computation

# We got this number of grid completly covered horizontally

nb_grids = 2 * ((26501365 / 131) - 1) + 1

i = 0
res = 0

# We gonna cover all the vertical lines for the FULL COVERED GRIDS ONLY
while nb_grids > 0
  # Previously computed if we walk EVEN number of times: 7734
  # Previously computed if we walk ODD number of times : 7719
  # So basically we'll add this number of grid / 2 for each
  # And we'll add it twice to have both lines on top and under the main horizontal lines

  res += 7734 * (nb_grids / 2 + 1)
  res += 7734 * (nb_grids / 2 + 1) if i > 0
  res += 7719 * (nb_grids / 2)
  res += 7719 * (nb_grids / 2) if i > 0
  nb_grids -= 2
  i += 1
end

# Then we need to cover the NOT FULLY COVERED GRIDS

# SO the 4 ones which starts from middle of line
# Meaning if you go only x + 1 / x - 1 / y + 1 / y - 1 for 26501365 steps

res += vh_val.map{|x| x.values.sum}.sum

# And then the horrible thing which require some drawing to get the grid on the edges
# Need some picture to explain tbh
c_val.each do |vv|
  res += vv.values.first.first * i + vv.values.first.last * (i - 1)
end


# Here it is:
p "RES FIN"
p res

# And here the pain i felt :'D

# 316230538405410 too low
# 632457127903011 too high
# 632421679912064 too high
# 632421649162482 wrong
# 632421649104420 wrong
# 632421649104405 wrong
# 632421652138905, 10mn 14:13
# 632421652138917 YEEEEEEEESSSSSSSSSSSSSSSSSSSSSSSSSS





# Another way


# What happens is basically:
# # All the grids are rounded by . and have straight way from source to border with .

# # So you can figure out how many grids will be fully covered
# # And then you need to treat the edge case
# # Some paper and pen to draw it help

# require 'csv'

# t = Time.now

# d = open("data.csv").read.split("\n").map{|x| x.split('')}#.map{|i| i.to_i}}
# # d = open("data.txt").read.split("\n")

# # p d.first

# # The following lines determines the source coordinates
# xs = nil
# ys = nil

# d.each_with_index do |l, y|
#   l.each_with_index do |c, x|
#     if c == 'S'
#       xs = x
#       ys =y
#     end
#   end
# end

# # The source is considered as a garden plot (thought it was useless but it does change the result for some reason)
# d[ys][xs] = '.'

# # BFS from the source to compute the distance to each point
# s = [xs, ys]
# q = [s]
# dis = {}
# v = {}

# v[s] = true
# dis[s] = 0

# def nbs(x, y, d)
#   nbz = []
#   nbz << [x - 1, y] if d[y % d.length][(x - 1) % d.first.length] == '.'
#   nbz << [x + 1, y] if d[y % d.length][(x + 1) % d.first.length] == '.'
#   nbz << [x, y - 1] if d[(y - 1) % d.length][x % d.first.length] == '.'
#   nbz << [x, y + 1] if d[(y + 1) % d.length][x % d.first.length] == '.'
#   return nbz
# end

# while !q.empty?
#   f = q.first
#   break if dis[f] > 589

#   q.shift
#   nbs(f.first, f.last, d).each do |nb|
#     unless v[nb]
#       v[nb] = true
#       q << nb
#       dis[nb] = dis[f] + 1
#     end
#   end
# end


# # f(65 + 131(2x))
# # ax2 + bx + c = 0

# # x = 0 => 3917
# # x = 1 => 96829
# # x = 2 => 313365

# # c = 3917
# # a + b = 96829 - 3917 = 92912
# # 4a + 2b = 313365 - 3917 = 309448

# # 2a + 2b = 185824
# # 4a + 2b = 309448

# # 2a = 123624

# # a = 61812
# # b = 31100
# # c = 3917

# # x = 202300
# # 61812 x2 + 31100 x + 3917 =


# xc = dis.select{|k, v| v.odd? && v <= 65}.length
# xd = dis.select{|k, v| v.odd? && v <= 327}.length
# xe = dis.select{|k, v| v.odd? && v <= 589}.length
# p 'val'
# p xc
# p xd
# p xe
# p 'done'

# # Real part 2
# s = [xs, ys]
# q = [s]
# dis = {}
# v = {}

# v[s] = true
# dis[s] = 0

# def nbs(x, y, d)
#   nbz = []
#   nbz << [x - 1, y] if d[y][x - 1] == '.' && x > 0
#   nbz << [x + 1, y] if !d[y][x + 1].nil? && d[y][x + 1] == '.'
#   nbz << [x, y - 1] if d[y - 1][x] == '.' && y > 0
#   nbz << [x, y + 1] if d[y + 1] && d[y + 1][x] == '.'
#   return nbz
# end

# while !q.empty?
#   f = q.first

#   q.shift
#   nbs(f.first, f.last, d).each do |nb|
#     unless v[nb]
#       v[nb] = true
#       q << nb
#       dis[nb] = dis[f] + 1
#     end
#   end
# end


# # f(65 + 202300x)
# # ax2 + bx + c = 0

# c = dis.select{|k, v| v.odd? && v <= 65}.length
# p c


# # This gives the number of plots you can reach from the source if you walk an ODD number of times
# p "Impair depuis la source"
# p dis.select{|k, v| v.odd?}.length

# # This gives the number of plots you can reach from the source if you walk an EVEN number of times
# p "Pair depuis la source"
# p dis.select{|k, v| v.even?}.length

# # Shit is starting now on :/

# # Computing the distance from the 4 corners
# # We got 2 cases to cover, if we walk 64 steps or if we walk 195 steps
# # So BFS from every single corner and storing the nb of garden plots :  [64 steps, 195 steps]

# corners = [
#   [0, 0],
#   [d.first.length - 1, 0],
#   [0, d.length - 1],
#   [d.first.length - 1, d.length - 1]
# ]

# c_val = corners.map do |s|
#   q = [s]
#   dis = {}
#   v = {}

#   v[s] = true
#   dis[s] = 0

#   def nbs(x, y, d)
#     nbz = []
#     nbz << [x - 1, y] if d[y][x - 1] == '.' && x > 0
#     nbz << [x + 1, y] if d[y][x + 1] == '.' && x + 1 <= d.first.length - 1
#     nbz << [x, y - 1] if d[y - 1][x] == '.' && y > 0
#     nbz << [x, y + 1] if d[y+1] && d[y + 1][x] == '.' && y + 1 <= d.length - 1
#     return nbz
#   end

#   while !q.empty?
#     f = q.first

#     q.shift
#     nbs(f.first, f.last, d).each do |nb|
#       unless v[nb]
#         v[nb] = true
#         q << nb
#         dis[nb] = dis[f] + 1
#       end
#     end
#   end
#   {s => [dis.select{|k, v| v.even? && v <= 64}.length, dis.select{|k, v| v.odd? && v <= 195}.length]}
# end

# p c_val


# # These are not corners but the middle of the border, just a copy paste from previous one
# # We need to know how many plots covered if we walk 130 steps
# corners = [
#   [0, ys],
#   [d.first.length - 1, ys],
#   [xs, 0],
#   [xs, d.length - 1]
# ]

# vh_val = corners.map do |s|
#   q = [s]
#   dis = {}
#   v = {}

#   v[s] = true
#   dis[s] = 0

#   def nbs(x, y, d)
#     nbz = []
#     nbz << [x - 1, y] if d[y][x - 1] == '.' && x > 0
#     nbz << [x + 1, y] if d[y][x + 1] == '.' && x + 1 <= d.first.length - 1
#     nbz << [x, y - 1] if d[y - 1][x] == '.' && y > 0
#     nbz << [x, y + 1] if d[y+1] && d[y + 1][x] == '.' && y + 1 <= d.length - 1
#     return nbz
#   end

#   while !q.empty?
#     f = q.first

#     q.shift
#     nbs(f.first, f.last, d).each do |nb|
#       unless v[nb]
#         v[nb] = true
#         q << nb
#         dis[nb] = dis[f] + 1
#       end
#     end
#   end

#   {s => dis.select{|k, v| v.even? && v <= 130}.length}
# end

# p vh_val


# # Here is the computation

# # We got this number of grid completly covered horizontally

# nb_grids = 2 * ((26501365 / 131) - 1) + 1

# i = 0
# res = 0

# # We gonna cover all the vertical lines for the FULL COVERED GRIDS ONLY
# while nb_grids > 0
#   # Previously computed if we walk EVEN number of times: 7734
#   # Previously computed if we walk ODD number of times : 7719
#   # So basically we'll add this number of grid / 2 for each
#   # And we'll add it twice to have both lines on top and under the main horizontal lines

#   res += 7734 * (nb_grids / 2 + 1)
#   res += 7734 * (nb_grids / 2 + 1) if i > 0
#   res += 7719 * (nb_grids / 2)
#   res += 7719 * (nb_grids / 2) if i > 0
#   nb_grids -= 2
#   i += 1
# end

# # Then we need to cover the NOT FULLY COVERED GRIDS

# # SO the 4 ones which starts from middle of line
# # Meaning if you go only x + 1 / x - 1 / y + 1 / y - 1 for 26501365 steps

# res += vh_val.map{|x| x.values.sum}.sum

# # And then the horrible thing which require some drawing to get the grid on the edges
# # Need some picture to explain tbh
# c_val.each do |vv|
#   res += vv.values.first.first * i + vv.values.first.last * (i - 1)
# end


# # Here it is:
# p "RES FIN"
# p res

# # And here the pain i felt :'D

# # 316230538405410 too low
# # 632457127903011 too high
# # 632421679912064 too high
# # 632421649162482 wrong
# # 632421649104420 wrong
# # 632421649104405 wrong
# # 632421652138905, 10mn 14:13
# # 632421652138917 YEEEEEEEESSSSSSSSSSSSSSSSSSSSSSSSSS
# # 632421652138917
