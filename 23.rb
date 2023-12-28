# takes a long time, but at least get a result
# not like the normal DFS for part 1 : stack level too deep :/
# Prob some conditions on the last node before destination or so could help, but no time

require 'csv'

t = Time.now

d = open("data.csv").read.split("\n").map{|x| x.split('')}#.map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

# p d.first

# 4 things we'll need
# The source s
# The destination dest
# The crossings place, where you have to choose where you go : crois
# a map saying for every crossing, which other crossing you can reach directly (without going through another crossing) and the distance


s = [1, 0]
dest = [d.first.length - 2, d.length - 1]
crois = [s, dest]
map = {}

# Small methods to check where you can go from x, y
def nbs(x, y, d)
  nbz = []
  nbz << [x + 1, y] if ['.', '^', 'v', '<', '>'].include?(d[y][x + 1])
  nbz << [x - 1, y] if ['.', '^', 'v', '<', '>'].include?(d[y][x - 1]) && x > 0
  nbz << [x, y + 1] if d[y + 1] && ['.', '^', 'v', '<', '>'].include?(d[y + 1][x])
  nbz << [x, y - 1] if y > 0 && ['.', '^', 'v', '<', '>'].include?(d[y - 1][x])
  return nbz
end

# First we get the crossings
d.each_with_index do |l, y|
  l.each_with_index do |c, x|
    crois << [x, y] if c == '.' && nbs(x, y, d).length > 2
  end
end


# For every crossing, we're doing a BFS to get the distance to all other accessible crossings
crois.each_with_index do |s, ind|
  map[s] = []
  q = [s]
  v= {}
  v[s] = true

  dist = {}
  dist[s] = 0

  while !q.empty?
    f = q.first
    q.shift
    x = f.first
    y = f.last
    nbs(x, y, d).each do |nb|
      if crois.include?(nb)
        map[s] << [nb, dist[f] + 1] unless s == nb
      elsif !v[nb]
        v[nb] = true
        q << nb
        dist[nb] = dist[f] + 1
      end
    end
  end
end

# Then we're doing a DFS on a new graph of crossings only, distances stored in map

@res = []
def dfs(pt, v, d, cur_dis, dest, map)
  @res << cur_dis if pt == dest
  u = {}
  v.each do |k, v|
    u[k] = v
  end
  u[pt] = true
  map[pt].each do |info|
    nb = info.first
    unless u[nb]
      dis = info.last
      dfs(nb, u, d, cur_dis + dis, dest, map)
    end
  end
end

v = {}
dfs(s, v, d, 0, dest, map)

p "result is"
p @res.max

p "Elapsed time: #{Time.now - t}s"

# 5998 too low
