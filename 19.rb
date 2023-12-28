require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('').map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

# p d.first

wfw = true
WFS = {}
pts = []
d.each do |l|
  if l == ''
    wfw = false
  elsif wfw
    nm = l.split('{').first
    rules = l.split('{').last.gsub('}', '')
    WFS[nm] = rules
  else
    x = l.split('x=').last.split(',').first.to_i
    m = l.split('m=').last.split(',').first.to_i
    a = l.split('a=').last.split(',').first.to_i
    s = l.split('s=').last.split('}').first.to_i
    pts << [x, m, a ,s]
  end
end

def l_to_ind(l, xs, ms, as, ss)
  case l
  when "x" then return [xs, 0]
  when "m" then return [ms, 1]
  when "a" then return [as, 2]
  when 's' then return [ss, 3]
  end
end

xs = (1..4000).to_a
ms = (1..4000).to_a
as = (1..4000).to_a
ss = (1..4000).to_a

pro = 'in'
step = 0


def treat_step(pro, step, xs, ms, as, ss)
  return 0 if xs.empty? || ms.empty? || as.empty? || ss.empty?
  return 0 if pro == 'R'
  return (xs.max - xs.min + 1) * (ms.max - ms.min + 1) * (as.max - as.min + 1) * (ss.max - ss.min + 1) if pro == 'A'
  res = 0
  cur = WFS[pro].split(',')[step]
  if cur.include?(':')
    cnd = cur.split(':').first
    next_pro = cur.split(':').last
    itv = l_to_ind(cnd[0], xs, ms, as ,ss).first
    itv_i = l_to_ind(cnd[0], xs, ms, as ,ss).last
    if cnd[1] == '>'
      case itv_i
      when 0 then res += treat_step(next_pro, 0, itv - (0..cnd[2..-1].to_i).to_a, ms, as, ss)
      when 1 then res += treat_step(next_pro, 0, xs, itv - (0..cnd[2..-1].to_i).to_a, as, ss)
      when 2 then res += treat_step(next_pro, 0, xs, ms, itv - (0..cnd[2..-1].to_i).to_a, ss)
      when 3 then res += treat_step(next_pro, 0, xs, ms, as, itv - (0..cnd[2..-1].to_i).to_a)
      end
      case itv_i
      when 0 then res += treat_step(pro, step + 1, itv - ((cnd[2..-1].to_i + 1)..itv.max).to_a, ms, as, ss)
      when 1 then res += treat_step(pro, step + 1, xs, itv - ((cnd[2..-1].to_i + 1)..itv.max).to_a, as, ss)
      when 2 then res += treat_step(pro, step + 1, xs, ms, itv - ((cnd[2..-1].to_i + 1)..itv.max).to_a, ss)
      when 3 then res += treat_step(pro, step + 1, xs, ms, as, itv - ((cnd[2..-1].to_i + 1)..itv.max).to_a)
      end
      # contin = itv - (0..cnd[2..-1].to_i).to_a
      # next_step = itv - ((cnd[2..-1].to_i + 1)..itv.max).to_a
    elsif cnd[1] == '<'
      case itv_i
      when 0 then res += treat_step(next_pro, 0, itv - ((cnd[2..-1].to_i)..itv.max).to_a, ms, as, ss)
      when 1 then res += treat_step(next_pro, 0, xs, itv - ((cnd[2..-1].to_i)..itv.max).to_a, as, ss)
      when 2 then res += treat_step(next_pro, 0, xs, ms, itv - ((cnd[2..-1].to_i)..itv.max).to_a, ss)
      when 3 then res += treat_step(next_pro, 0, xs, ms, as, itv - ((cnd[2..-1].to_i)..itv.max).to_a)
      end
      case itv_i
      when 0 then res += treat_step(pro, step + 1, itv - (0..(cnd[2..-1].to_i - 1)).to_a, ms, as, ss)
      when 1 then res += treat_step(pro, step + 1, xs, itv - (0..(cnd[2..-1].to_i - 1)).to_a, as, ss)
      when 2 then res += treat_step(pro, step + 1, xs, ms, itv - (0..(cnd[2..-1].to_i - 1)).to_a, ss)
      when 3 then res += treat_step(pro, step + 1, xs, ms, as, itv - (0..(cnd[2..-1].to_i - 1)).to_a)
      end
    else
      p "ERROR"
    end
  elsif cur == 'A'
    res += (xs.max - xs.min + 1) * (ms.max - ms.min + 1) * (as.max - as.min + 1) * (ss.max - ss.min + 1)
  elsif cur == 'R'
    res += 0
  else
    res += treat_step(cur, 0, xs, ms, as, ss)
  end
  return res
end

p "Part 2"
p treat_step(pro, step, xs, ms, as, ss)



def l_to_ind(l)
  case l
  when "x" then return 0
  when "m" then return 1
  when "a" then return 2
  when 's' then return 3
  end
end

def check(v, op, nb)
  case op
  when "<" then return v < nb
  when ">" then return v > nb
  else
    p "ERROR"
  end
end

# PArt 1
sum = 0

pts.each do |pt|
  done = false
  process = "in"
  step = 0
  until done
    r1 = WFS[process].split(',')[step]
    if r1.include?(':')
      cnd = r1.split(':').first
      res = r1.split(':').last
      v = pt[l_to_ind(cnd[0])]
      op = cnd[1]
      nb = cnd[2..-1].to_i
      # p v
      # p op
      # p nb
      # p check(v, op ,nb)
      # return
      if check(v, op, nb)
        case res
        when 'A'
          done = true
          sum += pt.sum
        when 'R'
          done = true
        else
          process = res
          step = 0
        end
      else
        step += 1
      end
    else
      res = r1
      case res
      when 'A'
        done = true
        sum += pt.sum
      when 'R'
        done = true
      else
        process = res
        step = 0
      end
    end
  end
end

p "Part1:"
p sum


p "Elapsed time: #{Time.now - t}s"
