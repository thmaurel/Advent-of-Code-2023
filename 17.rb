require 'csv'

t = Time.now

# 810 851

d = open("data.csv").read.split("\n").map{|x| x.split('').map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

p d.first

x = 0
y = 0

un = {}
dist = {}

s = [x, y]
dir = nil
straight = 0
un[[s, dir, straight]] = 0
dist[[s, dir, straight]] = 0
# v = {}

def neighbours(node, d, dir, straight)
  x = node.first
  y = node.last
  nbs = []
  if dir.nil? || (['N', 'S'].include?(dir) && straight >= 4) || (dir == 'W' && straight < 10)
    nbs << [[x - 1, y], 'W'] if x - 1 >= 0
  end
  if dir.nil? || (['N', 'S'].include?(dir) && straight >= 4) || (dir == 'E' && straight < 10)
    nbs << [[x + 1, y], 'E'] if x + 1 <= d.first.length - 1
  end
  if dir.nil? ||  (['W', 'E'].include?(dir) && straight >= 4) || (dir == 'N' && straight < 10)
    nbs << [[x, y - 1], 'N'] if y - 1 >= 0
  end
  if dir.nil? ||  (['W', 'E'].include?(dir) && straight >= 4) || (dir == 'S' && straight < 10)
    nbs << [[x, y + 1], 'S'] if y + 1 <= d.length - 1
  end
  return nbs
end


# un[[s, dir, straight]] = [0, nil]
# dist[[s, dir, straight]] = 0
res = nil
while !un.empty?
  # p straight
  tt = Time.now
  f = un.sort_by{|k, v| v}.first
  # p "sorting time: #{Time.now - tt}"
  node = f.first.first
  node_dist = f.last
  if node == [d.first.length - 1, d.length - 1]
    res = node_dist
    break
  end
  dir = f.first[1]
  # p dir
  straight = f.first[2]
  un.delete(f.first)
  # v[[node, dir]] = true
  # p "Je suis #{node}"
  # p neighbours(node, d, dir, straight)
  # if node == [2, 1]
  #   p node_dist
  #   p  neighbours(node, d, dir, straight)
  #   p straight
  #   p dir
  # end
  # next if un.select{|k, v| (k.first == node && k[1] == dir && k[2] <= straight && v )}
  neighbours(node, d, dir, straight).each do |nbc|

    nb = nbc.first
    dirr = nbc.last
    next_s = 1 if dirr != dir
    next_s = straight + 1 if dirr == dir
      w = d[nb.last][nb.first]
      if dist[[nb, dirr, next_s]].nil? || node_dist + w < dist[[nb, dirr, next_s]]
        dist[[nb, dirr, next_s]] = node_dist + w
        un[[nb, dirr, next_s]] = dist[[nb, dirr, next_s]]
      end
    # end
  end

  # min = dist.select{|k,v| (k.first == [d.first.length - 1, d.length - 1]) && k.last >= 4}.values.min
  # break if min
end

# p dist


p "res"
p res

p "Elapsed time: #{Time.now - t}s"
