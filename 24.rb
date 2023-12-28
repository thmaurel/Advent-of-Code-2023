# Part 1 worked by manually solving the equation
# Part 2 didn't, used Mathematica which made it instantly
# NSolve[{t1 >= 0,
#   t2 >= 0,
#   t3>=0,
#   211614908752320 + 15 * t1 == x + u * t1,
#   403760160726375 - 18 * t2 == x + u * t2 ,
#   144186255945915 - 7 * t3 == x + u * t3,
#   355884497165907 - 119 * t1 == y + v * t1,
#   378047702508912 - 130 * t2 == y + v * t2 ,
#   328686782113692 + 147 * t3 == y + v * t3,
#   259696313651729 + 26 * t1 == z + w * t1,
#   174017730109516 + 147 * t2 == z + w * t2 ,
#   276690520845056 -255 * t3 == z + w * t3 },
#   {x, y, z, u, v, w, t1, t2, t3}, Integers]


require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('')}#.map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

pts = []
d.each do |l|
  x, y, z = l.split(' @ ').first.split(', ').map{|x| x.to_i}
  vx, vy, vz = l.split(' @ ').last.split(', ').map{|x| x.to_i}
  pts << [[x, y, z], [vx, vy, vz]]
end

c = 0
while true
  c += 1
  t1 = pts.map do |pt|
    [pt.first[0] + c * pt.last[0], pt.first[1] + c * pt.last[1], pt.first[2] + c * pt.last[2]]
  end
  t2 = pts.map do |pt|
    [pt.first[0] + (c + 1) * pt.last[0], pt.first[1] + (c + 1) * pt.last[1], pt.first[2] + (c + 1) * pt.last[2]]
  end
  t3 = pts.map do |pt|
    [pt.first[0] + (c + 2) * pt.last[0], pt.first[1] + (c + 2) * pt.last[1], pt.first[2] + (c + 2) * pt.last[2]]
  end

  dist = {}
  t3.each_with_index do |pt3, i|
    dist[i] = []
    t2.each_with_index do |pt2, j|
      unless i == j
        dist[i] << [pt3.first - pt2.first, pt3[1] - pt2[1], pt3.last - pt2.last]
      end
    end
  end

  dist2 = {}
  t2.each_with_index do |pt2, i|
    dist2[i] = []
    t1.each_with_index do |pt1, j|
      unless i == j
        dist2[i] << [pt2.first - pt1.first, pt2[1] - pt1[1], pt2.last - pt1.last]
      end
    end
  end

  pts.length.times do |k|
    if (dist[k] & dist2[k]).any?
      p k
      return
    end
  end
end
p dist

p "done"
return

p pts.length

done = []

xmin = 200000000000000
xmax = 400000000000000

pts.each do |pt|
  pts.each do |pot|
    unless pt == pot
      a = pt.first.first
      b = pt.last.first
      c = pot.first.first
      d = pot.last.first
      a2 = pt.first[1]
      b2 = pt.last[1]
      c2 = pot.first[1]
      d2 = pot.last[1]

      y = (a * b2 - a2 * b - c * b2 + c2 * b).to_f / (b2 * d - b * d2) unless (b2 * d - b * d) == 0
      x = (c + d * y - a).to_f / b unless b.zero? || y.nil?

      if x && y && x > 0 && y > 0 && a + b * x >= xmin && a + b * x <= xmax && a2 + b2 * x >= xmin && a2 + b2 * x <= xmax
        done << [pt, pot].sort unless done.include?([pt, pot].sort)
      end
    end
  end
end
# p done
p done.length

p "Elapsed time: #{Time.now - t}s"

# 5998 too low

#  a + bx = c + dx

#  a' + b'x = c' + d'x
#  a'' + b'' x = c'' + d'' x

# a - c = (d - b)x
# a' - c' = (d' - b')x
# a'' - c'' = (d'' - b'')x






#  ab' + bb' x = cb' + db' y
# a'b + bb' x = c'b + bd' y

# ab' - a'b - cb' + c'b = y(db' - bd')


# x , y , z @ vx vy vz

# pts

# x + vx * t = ptx + ptvx * t
# y + vy * t = pty + ptvy * t
# z + vz * t = ptz + ptvz * t




# x - x2 = (vx2 - vx ) * t
# y - y2 = (vy2 - vy ) * t
# z - z2 = (vz2 - vz ) * t

# x - x2 / (vx2 - vx )= t
# y - y2 / (vy2 - vy )=  t
# z - z2 / (vz2 - vz )=  t

# x - x2 / vx2 - vx = y - y2 / vy2 - vy
# x - x2 / vx2 - vx = z - z2 / vz2 - vz

# 2x


# x - x3 / vx3 - vx = y - y3 / vy3 - vy
# x - x3 / vx3 - vx = z - z3 / vz3 - vz


# x - x4 / vx4 - vx = y - y4 / vy4 - vy
# x - x4 / vx4 - vx = z - z4 / vz4 - vz








# x - pt2x = (pt2vx - vx ) * t2
# y - pt2y = (pt2vy - vy ) * t2
# z - pt2z = (pt2vz - vz ) * t2


# x + y * t = a + b * t

# x + y * t2 = a2 + b2 * t2



# x + vx ti = xi + vxi ti
# y + vy ti = yi + vyi ti
# z + vz ti = zi + vzi ti
