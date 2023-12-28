require 'csv'

d = open("data.csv").read.split("\n").map{|x| x.split('')}

# d = open("data.txt").read.split("\n")

# p d.first

ns = []


def neighbours(x, y, d)
  nes = []
  nes << [x - 1, y - 1] if y > 0 && x > 0
  nes << [x, y - 1] if y > 0
  nes << [x - 1, y] if  x > 0
  nes << [x + 1, y] if x < d.first.length - 1
  nes << [x + 1, y - 1] if  y > 0 && x < d.first.length - 1
  nes << [x + 1, y + 1] if  y < d.length - 1 && x < d.first.length - 1
  nes << [x - 1, y + 1] if  y < d.length - 1 && x > 0
  nes << [x, y + 1] if  y < d.length - 1
  return nes
end

number = nil
close = nil

d.each_with_index do |l, y|
  number = 0
  close = false
  star = nil
  l.each_with_index do |c, x|
    if c.match?(/\d/)
      number = 10 * number + c.to_i
      p number
      neighbours(x, y, d).each do |nbs|
        if !d[nbs.last][nbs.first].match?(/\d/) && d[nbs.last][nbs.first] != '.'
          if d[nbs.last][nbs.first] == '*'
            close = true
            star = nbs
          end
        end
      end
    else
      ns << [number, star] if number > 0 && close
      number = 0
      close = false
    end
    if x == d.first.length - 1
      ns << [number, star] if number > 0 && close
      number = 0
      close = false
    end
  end
end

p "result"

ggs = ns.map{|x| x.last}

res = ns.select{|x| ggs.count(x.last) == 2}

done = []
total = 0
res.each do |cbs|
  n = cbs.first
  pos = cbs.last
  unless done.include?(pos)
    tt = res.select{|x| x.last == pos}.map{|x| x.first}
    p "ERROR" if tt.length > 2
    total += tt.first * tt.last
    done << pos
  end
end

p total
