require 'csv'

t = Time.now

d = open("data.csv").read.split("\n").map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

p d.first

# Recursive method to do the propagation
def prop(x, y, dir, v, d)

  return if v[[x, y]] && v[[x, y]].include?(dir)

  if v[[x, y]].nil?
    v[[x, y]] = [dir]
  else
    v[[x, y]] << dir
  end

  case d[y][x]
  when '.'
    case dir
    when 'E'
      prop(x + 1, y, dir, v ,d) if x < d.first.length - 1
    when 'W'
      prop(x - 1, y, dir, v ,d) if x > 0
    when 'N'
      prop(x, y - 1, dir, v ,d) if y > 0
    when 'S'
      prop(x, y + 1, dir, v ,d) if y < d.length - 1
    end
  when '-'
    case dir
    when 'E'
      prop(x + 1, y, dir, v ,d) if x < d.first.length - 1
    when 'W'
      prop(x - 1, y, dir, v ,d) if x > 0
    when 'N'
      prop(x + 1, y, 'E', v ,d) if x < d.first.length - 1
      prop(x - 1, y, 'W', v ,d) if x > 0
    when 'S'
      prop(x + 1, y, 'E', v ,d) if x < d.first.length - 1
      prop(x - 1, y, 'W', v ,d) if x > 0
    end
  when '|'
    case dir
    when 'N'
      prop(x, y - 1, dir, v ,d) if y > 0
    when 'S'
      prop(x, y + 1, dir, v ,d) if y < d.length - 1
    when 'E'
      prop(x, y - 1, 'N', v ,d) if y > 0
      prop(x, y + 1, 'S', v ,d) if y < d.length - 1
    when 'W'
      prop(x, y - 1, 'N', v ,d) if y > 0
      prop(x, y + 1, 'S', v ,d) if y < d.length - 1
    end
  when '/'
    case dir
    when 'N'
      prop(x + 1, y, 'E', v ,d) if x < d.first.length - 1
    when 'S'
      prop(x - 1, y, 'W', v ,d) if x > 0
    when 'E'
      prop(x, y - 1, 'N', v ,d) if y > 0
    when 'W'
      prop(x, y + 1, 'S', v ,d) if y < d.length - 1
    end
  when "\\"
    case dir
    when 'N'
      prop(x - 1, y, 'W', v ,d) if x > 0
    when 'S'
      prop(x + 1, y, 'E', v ,d) if x < d.first.length - 1
    when 'E'
      prop(x, y + 1, 'S', v ,d) if y < d.length - 1
    when 'W'
      prop(x, y - 1, 'N', v ,d) if y > 0
    end
  end
end

# # Part 1
# x = 0
# y = 0
# dir = "E"
# v = {}

# prop(x, y, dir, v, d)

# p v.keys.length


# Part 2 is the same than part 1 but I take as the source point every possible point and store the result

xmax = d.first.length - 1
ymax = d.length - 1

res = []
xmax.times do |x|
  y = 0
  dir = "S"
  v = {}
  prop(x, y, dir, v, d)
  res << v.keys.length

  y = ymax
  dir = "N"
  v = {}
  prop(x, y, dir, v, d)
  res << v.keys.length

end

ymax.times do |y|
  x = 0
  dir = "E"
  v = {}
  prop(x, y, dir, v, d)
  res << v.keys.length

  x = xmax
  dir = "W"
  v = {}
  prop(x, y, dir, v, d)
  res << v.keys.length
end

p res.max
