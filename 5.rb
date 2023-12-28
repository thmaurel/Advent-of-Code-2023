require 'csv'

data = open("data.csv").read.split("\n") #.map{|x| x.split('')}

# To handle the input, I got manually the seeds in my code (just below), and removed any empty line from the rest
seeds = [[364807853, 408612163], [302918330, 20208251], [1499552892, 200291842], [3284226943, 16030044], [2593569946, 345762334], [3692780593, 17215731], [1207118682, 189983080], [2231594291, 72205975], [3817565407, 443061598], [2313976854, 203929368]]

# Then I initialized some useful variables
# One to follow what's the current element while parsing
current_element = nil

# And then 7 different arrays to track the different converters
seed_soil = []
soil_fert = []
fert_wat = []
wat_light = []
light_temp = []
temp_humid = []
humid_locat = []

# Reading the data, I keep track thanks to the current element to which converter array to fill
data.each do |line|
  case line
  when 'seed-to-soil map:' then current_element = 'seed'
  when 'soil-to-fertilizer map:' then current_element = 'soil'
  when 'fertilizer-to-water map:' then current_element = 'fertilizer'
  when 'water-to-light map:' then current_element = 'water'
  when 'light-to-temperature map:' then current_element = 'light'
  when 'temperature-to-humidity map:' then current_element = 'temp'
  when 'humidity-to-location map:' then current_element = 'humidity'
  else
    case current_element
    when 'seed' then seed_soil << line.split.map(&:to_i)
    when 'soil' then soil_fert << line.split.map(&:to_i)
    when 'fertilizer' then fert_wat << line.split.map(&:to_i)
    when 'water' then wat_light << line.split.map(&:to_i)
    when 'light' then light_temp << line.split.map(&:to_i)
    when 'temp' then temp_humid << line.split.map(&:to_i)
    when 'humidity' then humid_locat << line.split.map(&:to_i)
    end
  end
end

# Once I got all the converter from the input, I created a more general rule array which is :
  # 1. sorted
  # 2. including the 1:1 mapping when it wasn't covered by the input
# Ex:
# If the seeds are (15..20) and (80..110)
# And the seed converters given look like [50, 98, 2], [52, 50, 48]
# Generated converters will look like : [15, 15, 35], [52, 50, 48], [50, 98, 2], [100, 100, 11]
# This covers all the possibilities from the incoming seeds

def generate_converters(given_converters, min_element_incoming, max_element_incoming)
  sorted_given_converters = given_converters.sort_by{|x| x[1]}
  starting_element = nil
  interval = nil
  intervals_to_add = []
  last_element = nil
  sorted_given_converters.each do |rule|
    if starting_element.nil?
      intervals_to_add << [min_element_incoming,min_element_incoming,rule[1]] if rule[1] > min_element_incoming
    elsif starting_element + interval < rule[1]
      intervals_to_add << [starting_element + interval, starting_element + interval, rule[1] - starting_element - interval]
    end
    starting_element = rule[1]
    interval = rule.last
    last_element = rule[1] + rule.last
  end

  if last_element < max_element_incoming
    intervals_to_add << [last_element, last_element, max_element_incoming - last_element]
  end
  complete_rule = sorted_given_converters + intervals_to_add
  complete_rule.sort_by{|x| x[1]}
end

# Here is the method to give the max element from the output of conversion
# Therefore I add the first element (the output) and the last one (the range size)
# And take the maximal value of all the results from all the converters
def max_element(array)
  array.map { |range| range.first + range.last }.max
end

# Here is the method to give the min element from the output of conversion
# Basically just the first element of any converter
# And taking the minimal value of all of them
def min_element(array)
  array.map(&:first).min
end

# Then i'll define the maximal and minimal value from the seeds
max = max_element(seeds)
min = min_element(seeds)

# Then generate full converters from seed to soil based on min and max
seed_soil = generate_converters(seed_soil, min, max)

# Then define the maximal and minimal value from the conversion from seed to soil
max = max_element(seed_soil)
min = min_element(seed_soil)

# Then generate full converters from soil to fert
soil_fert = generate_converters(soil_fert, min, max)

# Repeat this for every converters
max = max_element(soil_fert)
min = min_element(soil_fert)

fert_wat = generate_converters(fert_wat, min, max)
max = max_element(fert_wat)
min = min_element(fert_wat)

wat_light = generate_converters(wat_light, min, max)
max = max_element(wat_light)
min = min_element(wat_light)

light_temp = generate_converters(light_temp, min, max)
max = max_element(light_temp)
min = min_element(light_temp)

temp_humid = generate_converters(temp_humid, min, max)
max = max_element(temp_humid)
min = min_element(temp_humid)

humid_locat = generate_converters(humid_locat, min, max)

# Now we got full converters covering all possible ranges for previous step outcomes
# We need to convert our seeds input to soils ranges, then ferts...
# So basically take a range, and apply on it the set of rules we defined earlier
def convert(ranges, rules)
  converted = []
  ranges.each do |range|
    start = range.first
    length = range.last
    rules.each do |rule|
      # We check if the range overlaps the converter range, else we can skip this converter
      next unless start <= rule[1] + rule.last - 1 && start + length >= rule[1]

      # We need to define the start of the overlap
      s = [start, rule[1]].max

      gap = s - rule[1]
      ns = rule[0] + gap
      e = [start+length - 1, rule[1] + rule.last - 1].min
      gap = rule[1] + rule.last - 1 - e
      ne = rule[0] + rule.last - gap
      converted << [ns, ne - ns]
    end
  end
  converted
end

# Then we can convert the seed thanks to the seed -> soil converter
soils = convert(seeds, seed_soil)
# then the soil thanks to the soid -> fert converter
ferts = convert(soils, soil_fert)
# ...
wats =  convert(ferts, fert_wat)
lights = convert(wats, wat_light)
temps = convert(lights, light_temp)
humids = convert(temps, temp_humid)
locats = convert(humids, humid_locat)

# Once we have the locations, we can just take the one with the minimal first element which is the minimal location !
p locats.map{|x| x.first}.min
