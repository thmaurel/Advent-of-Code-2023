# Careful there is a while true :'D
# Once more, two many iterations required.
# Noticed which machine rx was coming from, was a Conjunction
# So to get rw receiving a low, you need the Conjunction to have only high in memory.
# Computed manually the cycles for every single input of this Conjunction (4)
# Then the Lowest common multiple of these 4 numbers and job is done

require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('').map{|i| i.to_i}}
# d = open("data.txt").read.split("\n")

# p d

# %
class Flip
  attr_accessor :name, :state, :dests
  def initialize(name, dests)
    @name = name
    @state = false
    @dests = dests
  end

  def send_low
    @state = !@state
    return @state ? 'high' : 'low'
  end

  def send_high
    return nil
  end
end

# &
class Conj
  attr_accessor :name, :hist, :dests
  def initialize(name, dests)
    @name = name
    @hist = {}
    @dests = dests
  end

  def send_low(input)
    @hist[input] = 'low'
    return "high"
  end

  def send_high(input)
    @hist[input] = 'high'
    if @hist.values.uniq == ['high']
      return 'low'
    else
      return 'high'
    end
  end
end

class Broad
  attr_accessor :name, :dests
  def initialize(name, dests)
    @name = name
    @dests = dests
  end

  def send_low
    return 'low'
  end

  def send_high
    return 'high'
  end
end
# button => low => broadcaster
# broadcaster => same => all destination

modules = []
d.each do |l|
  if l[0] == '%'
    name = l.split(' -> ').first.gsub('%', '')
    dests = l.split(' -> ').last.split(', ')
    modules << Flip.new(name, dests)
  elsif l[0] == '&'
    name = l.split(' -> ').first.gsub('&', '')
    dests = l.split(' -> ').last.split(', ')
    modules << Conj.new(name, dests)
  else
    p l
    dests = l.split(' -> ').last.split(', ')
    modules << Broad.new('broadcaster', dests)
  end
end

modules.each do |mod|
  mod.dests.each do |dest_name|
    dest = modules.find{|x| x.name == dest_name}
    if dest.class == Conj
      dest.hist[mod.name] = 'low'
    end
  end
end


# button once
# low broadcaster

start =
p start
low = 0
high = 0

k = 0

while true
# 1000.times do  # Part 1
  k += 1
  p k if k % 10000 == 0
  ins = [['broadcaster', 'low', nil]]
  rx = 0
  while ins.any?
    f = ins.first
    rx += 1 if f.first == 'rx' && f[1] == 'low'

    # Enabled me to compute the number of button press to have bq high
    # lowest common multiple to get them all high so rx is low
    if f.first == 'bq' && f[1] == 'high'
      p "BQ IS HIGH FROM #{f[2]}"
      p k
    end
    ins.shift
    mod = modules.find{|x| x.name == f.first}
    low += 1 if f[1] == 'low'
    high += 1 if f[1] == 'high'
    if mod
      si = f[1]
      par = f.last
      unless si.nil?
        new_si = nil
        case si
        when 'low'
          if mod.class == Conj
            new_si = mod.send_low(par)
          else
            new_si = mod.send_low
          end
        when 'high'
          if mod.class == Conj
            new_si = mod.send_high(par)
          else
            new_si = mod.send_high
          end
        end
        unless new_si.nil?
          mod.dests.each do |dest_name|
            ins << [dest_name , new_si, mod.name]
          end
        end
      end
    end
  end
end

# Part 1
p high * low


p "Elapsed time: #{Time.now - t}s"
