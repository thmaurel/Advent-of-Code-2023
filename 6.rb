require 'csv'

t = Time.now

d = open("data.csv").read.split("\n") #.map{|x| x.split('')}
# d = open("data.txt").read.split("\n")
# def neighbours(x, y, d)
#   nes = []
#   nes << [x - 1, y - 1] if y > 0 && x > 0
#   nes << [x, y - 1] if y > 0
#   nes << [x - 1, y] if  x > 0
#   nes << [x + 1, y] if x < d.first.length - 1
#   nes << [x + 1, y - 1] if  y > 0 && x < d.first.length - 1
#   nes << [x + 1, y + 1] if  y < d.length - 1 && x < d.first.length - 1
#   nes << [x - 1, y + 1] if  y < d.length - 1 && x > 0
#   nes << [x, y + 1] if  y < d.length - 1
#   return nes
# end

# Time:        42686985
# Distance:   284100511221341

races = [42686985, 284100511221341]


ns = []
races.first.times do |i|
  speed = i + 1
  time_left = races.first - i - 1
  distance = time_left * speed
  ns << distance if distance > races.last
end
p ns.length
p "Elapsed time: #{Time.now - t}s"
