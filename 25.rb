# Minimal cut is 3 so Just removing 3 paths between one random node and every other pt one by one and checking if there are a 4th path, if yes, same group, else, not
# Result is number of pt in same group multiplied by total pt - number of pt in same group

require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('')}#.map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

# p d.first


map = {}
edges = []

d.each do |line|
  x = line.split(':').first
  ys = line.split(': ').last.split(' ')
  ys.each do |y|
    edges << [x, y]
    if map[x]
      map[x] << y
    else
      map[x] = [y]
    end
    if map[y]
      map[y] << x
    else
      map[y] = [x]
    end
  end
end

s = edges.first.last

group = [s]

map.keys.each do |pt|
  # p pt
  # p pt
  if pt != s
    map2 = {}
    map.each do |k, v|
      map2[k] = v.map{|x| x}
    end
    4.times do |k|
      q = [s]
      v = {}
      pa = {}
      pa[s] = s
      v[s] = true
      while !q.empty?
        f = q.first
        if f == pt
          group << pt if k == 3
          # p "hey"
          tmp = f
          until tmp == s
            map2[pa[tmp]].delete(tmp)
            tmp = pa[tmp]
          end
          found = true
          break
        end
        q.shift
        # p map2[f]
        map2[f].each do |nb|
          unless v[nb]
            v[nb] = true
            pa[nb] = f
            q << nb
            # map2[f].delete(nb)
          end
        end
        # p "yo"
      end
    end
    # p group
    # return
  end
end
# p group.length
p group.length * (1488 - group.length)
