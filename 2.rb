require 'csv'

d = open("data.csv").read.split("\n")
#  .map{|x| x.to_i}

# d = open("data.txt").read.split("\n")


# only 12 red cubes, 13 green cubes, and 14 blue cubes
# p d.first

res = []

d.each do |g|
  id = g.split(':').first.gsub('Game ', '').to_i
  rs = g.split(': ').last.split('; ')
  # possible = true
  mr = nil
  mb = nil
  mg = nil
  rs.each do |r|
    r.split(', ').each do |c|
      # if c.include?('red') && c.split(' ').first.to_i > 12
      #   possible = false
      # elsif c.include?('blue') && c.split(' ').first.to_i > 14
      #   possible = false
      # elsif c.include?('green') && c.split(' ').first.to_i > 13
      #   possible = false
      # end
      nbb = c.split(' ').first.to_i
      if c.include?('red')
        mr = nbb if mr.nil? || nbb > mr
      elsif c.include?('blue')
        mb = nbb if mb.nil? || nbb > mb
      elsif c.include?('green')
        mg = nbb if mg.nil? || nbb > mg
      end
    end
  end
  pw = mr * mg * mb
  res << pw
end

p res.sum
