require 'csv'

d = open("data.csv").read.split("\n") #.map{|x| x.split('')}

# d = open("data.txt").read.split("\n")

# p d.first

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

scores = []
# For every single line of the input
d.each_with_index do |l, i|
  # Determine id of the card
  id = l.split(':').first.gsub('Card ', '')
  # Determine all the numbers
  ns = l.split(': ').last
  # Get the winning numbers
  wss = ns.split(' |').first
  ws = wss.split(' ').map{|x| x.to_i}
  # Get card numbers
  lss = ns.split('| ').last
  ls = lss.split(' ').map{|x| x.to_i}
  score = 0
  # Check all our numbers and increase score by 1 when they're winning ones
  ls.each do |ll|
    if ws.include?(ll)
      score += 1
    end
  end
  # Store scores
  scores << score
end

res = 0
tt = {}
# Iterated again cuz I couldn't make it work in the same one :'(
d.length.times do |j|
  # Every card is counted as 1
  res += 1
  # And based on the score of this card, and the number of this card we already had, increase the number of time we'll have to pick next card
  scores[j].times do |k|
    if tt[j + 1 + k]
      tt[j + 1 + k] += tt[j] + 1 if tt[j]
      tt[j + 1 + k] += 1 unless tt[j]
    else
      tt[j + 1 + k] = tt[j] + 1 if tt[j]
      tt[j + 1 + k] = 1 unless tt[j]
    end
  end
end

# Count all the added card + the one we had by default
p tt.values.sum + res
