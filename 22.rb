# Hard coded everything, no optimisation
# Got full stupid errors :'(

require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('')}#.map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

# p d.first

bricks = []
d.each do |l|
  bs = l.split('~').first.split(',').map{|x| x.to_i}
  be = l.split('~').last.split(',').map{|x| x.to_i}
  bricks << [bs, be]
end


# First creating stable_bricks after all bricks fell
# Sorting them by z to make sure they fall in correct order x)
# And creating an area hash to store all occupied spot

bricks.sort_by!{|x| x.map{|x| x.last}.min}
area = {}
stable_bricks = []

bricks.each_with_index do |brick, ind|
  fell = false
  # p brick if ind == 376
  tmp = ind
  falling_brick = brick.sort_by{|x| x.last}
  falling = true
  if brick.first.last != brick.last.last || brick.first == brick.last
    min = brick.map{|x| x.last}.min
    while falling
      if falling_brick.map{|x| x.last}.min > 1 && area[[brick.first[0], brick.first[1], falling_brick.map{|x| x.last}.min - 1]].nil?
        falling_brick = falling_brick.map{|x| [x[0], x[1], x[2] - 1]}
      else
        falling = false
        for i in (falling_brick.first.last..falling_brick.last.last)
          area[[falling_brick.first[0], falling_brick.first[1], i]] = ind
        end
      end
    end
  elsif brick.first.first != brick.last.first
    while falling
      if falling_brick.first.last == 1
        falling = false
        for i in (falling_brick.first.first..falling_brick.last.first)
          area[[i, falling_brick.first[1], falling_brick.first.last]] = ind
        end
      else
        can_fall = true
        for i in (falling_brick.first.first..falling_brick.last.first)
          can_fall = false unless area[[i, falling_brick.first[1], falling_brick.first.last - 1]].nil?
        end
        if can_fall
          falling_brick = falling_brick.map{|x| [x[0], x[1], x[2] - 1]}

        else
          falling = false
          for i in (falling_brick.first.first..falling_brick.last.first)
            area[[i, falling_brick.first[1], falling_brick.first.last]] = ind
          end
        end
      end
    end
  elsif brick.first[1] != brick.last[1]
    while falling
      if falling_brick.first.last == 1
        falling = false
        for i in (falling_brick.first[1]..falling_brick.last[1])
          area[[falling_brick.first.first, i, falling_brick.first.last]] = ind
        end
      else
        can_fall = true
        for i in (falling_brick.first[1]..falling_brick.last[1])
          can_fall = false unless area[[falling_brick.first[0], i, falling_brick.first.last - 1]].nil?
        end
        if can_fall
          falling_brick = falling_brick.map{|x| [x[0], x[1], x[2] - 1]}

        else
          falling = false
          for i in (falling_brick.first[1]..falling_brick.last[1])
            area[[falling_brick.first[0], i, falling_brick.first.last]] = ind
          end
        end
      end
    end
  end
  stable_bricks << falling_brick
end

res = []

# Then for everysingle stable brick,
# Remove it from the "area", then take every other brick and check if they can fall again
# Still sorted by z so if one fall, the next one may fall after !

stable_bricks.each do |obrick|

  new_area = {}
  area.each do |k, v|
    new_area[k] = v
  end
  if obrick.first.last != obrick.last.last || obrick.first == obrick.last
    for i in (obrick.first.last..obrick.last.last)
      new_area.delete([obrick.first.first, obrick.first[1], i])
    end
  elsif obrick.first.first != obrick.last.first
    for i in (obrick.first.first..obrick.last.first)
      new_area.delete([i, obrick.first[1], obrick.first.last])
    end
  elsif obrick.first[1] != obrick.last[1]
    for i in (obrick.first[1]..obrick.last[1])
      new_area.delete([obrick.first[0], i, obrick.first.last])
    end
  end
  c = 0
  stable_bricks.each_with_index do |brick, ind|
    unless obrick == brick
      fell = false
      tmp = ind
      falling_brick = brick.sort_by{|x| x.last}
      falling = true
      if brick.first.last != brick.last.last || brick.first == brick.last
        for i in (falling_brick.first.last..falling_brick.last.last)
          new_area[[falling_brick.first[0], falling_brick.first[1], i]] = nil
        end
        min = brick.map{|x| x.last}.min
        while falling
          if falling_brick.map{|x| x.last}.min > 1 && new_area[[brick.first[0], brick.first[1], falling_brick.map{|x| x.last}.min - 1]].nil?
            falling_brick = falling_brick.map{|x| [x[0], x[1], x[2] - 1]}
            fell = true
          else
            falling = false
            for i in (falling_brick.first.last..falling_brick.last.last)
              new_area[[falling_brick.first[0], falling_brick.first[1], i]] = ind
            end
          end
        end
      elsif brick.first.first != brick.last.first
        for i in (falling_brick.first.first..falling_brick.last.first)
          new_area[[i, falling_brick.first[1], falling_brick.first.last]] = nil
        end
        while falling
          if falling_brick.first.last == 1
            falling = false
            for i in (falling_brick.first.first..falling_brick.last.first)
              new_area[[i, falling_brick.first[1], falling_brick.first.last]] = ind
            end
          else
            can_fall = true
            for i in (falling_brick.first.first..falling_brick.last.first)
              can_fall = false unless new_area[[i, falling_brick.first[1], falling_brick.first.last - 1]].nil?
            end
            if can_fall
              falling_brick = falling_brick.map{|x| [x[0], x[1], x[2] - 1]}
              fell = true
            else
              falling = false
              for i in (falling_brick.first.first..falling_brick.last.first)
                new_area[[i, falling_brick.first[1], falling_brick.first.last]] = ind
              end
            end
          end
        end
      elsif brick.first[1] != brick.last[1]
        for i in (falling_brick.first[1]..falling_brick.last[1])
          new_area[[falling_brick.first[0], i, falling_brick.first.last]] = nil
        end
        while falling
          if falling_brick.first.last == 1
            falling = false
            for i in (falling_brick.first[1]..falling_brick.last[1])
              new_area[[falling_brick.first.first, i, falling_brick.first.last]] = ind
            end
          else
            can_fall = true
            for i in (falling_brick.first[1]..falling_brick.last[1])
              can_fall = false unless new_area[[falling_brick.first[0], i, falling_brick.first.last - 1]].nil?
            end
            if can_fall
              falling_brick = falling_brick.map{|x| [x[0], x[1], x[2] - 1]}
              fell = true
            else
              falling = false
              for i in (falling_brick.first[1]..falling_brick.last[1])
                new_area[[falling_brick.first[0], i, falling_brick.first.last]] = ind
              end
            end
          end
        end
      end
      c += 1 if fell
    end
  end

  res << c
end

p "RESULT"
p res.sum


p "Elapsed time: #{Time.now - t}s"
