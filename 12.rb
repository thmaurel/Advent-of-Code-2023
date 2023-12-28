require 'csv'

t = Time.now

d = open("data.csv").read.split("\n")#.map{|x| x.split('')}
# d = open("data.txt").read.split("\n")

p d.first

# def transform(pa, arr, rep)
#   ind = pa.index('?')
#   if ind
#     if ind > 0
#       tmpres = pa[0..ind - 1].join('').split('.').select{|x| x != ''}.map{|x| x.length}
#       sz = tmpres.length - 2
#     end
#     if ind.zero? || tmpres.length < 2 || tmpres[0..sz] == rep[0..sz]
#       pa1 = pa.map{|x| x}
#       pa1[ind] = '.'
#       pa2 = pa.map{|x| x}
#       pa2[ind] = '#'
#       return [transform(pa1, arr, rep), transform(pa2, arr, rep)]
#     end
#   else
#     arr << pa
#   end
# end

@cache = {}
def count_pa(pat, rep_c, old_rep, rep)
  return @cache[[pat, rep_c, old_rep, rep]] if @cache[[pat, rep_c, old_rep, rep]]
  res = 0
  if old_rep == rep && (pat.length.zero? || !pat.include?('#'))
    return 1
  elsif old_rep + [rep_c] == rep && (pat.length.zero? || !pat.include?('#'))
    return 1
  elsif pat.length.zero?
    return 0
  elsif old_rep.length >= rep.length
    return 0
  end
  if pat[0] == '#'
    if rep[old_rep.length] >= rep_c + 1
      res += count_pa(pat[1..-1], rep_c + 1, old_rep, rep)
    end
  elsif pat[0] == '.'
    if rep_c.zero?
      res += count_pa(pat[1..-1], rep_c, old_rep, rep)
    else
      if rep[0..(old_rep + [rep_c]).length - 1] == old_rep + [rep_c]
        res += count_pa(pat[1..-1], 0, old_rep + [rep_c], rep)
      end
    end
  else
    if rep_c.zero?
      res += count_pa(pat[1..-1], 0, old_rep, rep)
    else
      if rep[0..(old_rep + [rep_c]).length - 1] == old_rep + [rep_c]
        res += count_pa(pat[1..-1], 0, old_rep + [rep_c], rep)
      end
    end
    if rep[old_rep.length] >= rep_c + 1
      res += count_pa(pat[1..-1], rep_c + 1, old_rep, rep)
    end
  end
  @cache[[pat, rep_c, old_rep, rep]] = res
  return res
end

res = 0
d.each_with_index do |l, i|
  # p "New line"
  # p l
  arr = []
  pa = l.split(' ').first + '?' + l.split(' ').first + '?' + l.split(' ').first + '?' + l.split(' ').first + '?' + l.split(' ').first
  trep = l.split(' ').last.split(',').map{|x| x.to_i}
  rep = trep + trep + trep + trep + trep
  pat = pa.split('')
  rep_c = 0
  old_rep = []
  res += count_pa(pat, rep_c, old_rep, rep)
  # transform(pa.split(''), arr, rep)
    # p ar.join('').split('.').select{|x| x != ''}.map{|x| x.length}
    p "Elapsed time: #{Time.now - t}s"
end

p res
p "Elapsed time: #{Time.now - t}s"
