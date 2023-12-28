require 'csv'

t = Time.now

d = open("data.csv").read.split("\n").map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

p d.first

#  H
# 159 -> 68 59 73 66 67 41
# 222     68 59 73 66 67 41

2000.times do |i|
  # After a few cycles, I started printing the total load to detect cycles
  if i > 100
    res = 0

    d.each_with_index do |l, y|
      l.each_with_index do |c, x|
        res += d.length - y if c == 'O'
      end
    end
    # Manually detected the cycle in my terminal and computed the correct result
    p "#{i + 1} : #{res}"
  end

  # Rolling north
  d.length.times do
    d.each_with_index do |l, y|
      l.each_with_index do |c, x|
        if y > 0 && c == 'O' && d[y - 1][x] == '.'
          d[y][x] = '.'
          d[y - 1][x] = 'O'
        end
      end
    end
  end

  # Rolling west
  d.first.length.times do
    d.each_with_index do |l, y|
      l.each_with_index do |c, x|
        if x > 0 && c == 'O' && d[y][x - 1] == '.'
          d[y][x] = '.'
          d[y][x - 1] = 'O'
        end
      end
    end
  end

  # Rolling south
  d.length.times do
    d.each_with_index do |l, y|
      l.each_with_index do |c, x|
        if y < d.length - 1 && c == 'O' && d[y + 1][x] == '.'
          d[y][x] = '.'
          d[y + 1][x] = 'O'
        end
      end
    end
  end

  # Rolling east
  d.first.length.times do
    d.each_with_index do |l, y|
      l.each_with_index do |c, x|
        if x < d.first.length - 1 && c == 'O' && d[y][x + 1] == '.'
          d[y][x] = '.'
          d[y][x + 1] = 'O'
        end
      end
    end
  end
end
