require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

# res = 0
# d.first.split(',').each do |c|
#   v = 0
#   c.split('').each do |ca|
#     v += ca.ord
#     v *= 17
#     v = v % 256
#   end
#   res += v
# end

# p res

box = {}

d.first.split(',').each do |l|
  if l.include?('=')
    lab = l.split('=').first
    nb = 0
    lab.split('').each do |ca|
      nb += ca.ord
      nb *= 17
      nb = nb % 256
    end
    if box[nb]
      ex = box[nb].find{|x| x.split(' ').first == lab}
      if ex
        ind = box[nb].index(ex)
        box[nb][ind] = l.gsub('=', ' ')
      else
        box[nb] << l.gsub('=', ' ')
      end
    else
      box[nb] = []
      box[nb] << l.gsub('=', ' ')
    end
  elsif l.include?('-')
    lab = l.split('-').first
    nb = 0
    lab.split('').each do |ca|
      nb += ca.ord
      nb *= 17
      nb = nb % 256
    end
    if box[nb]
      ex = box[nb].find{|x| x.split(' ').first == lab}
      if ex
        box[nb].delete(ex)
      end
    end
  else
    p "ERROR"
  end
end

p box

res = 0
box.each do |k, v|
  n = k + 1
  v.each_with_index do |lens, i|
    res += n * (i + 1) * lens.split(' ').last.to_i
  end
end

p res
