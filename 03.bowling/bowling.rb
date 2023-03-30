score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = 0

10.times do |i|
  if frames[i][0] == 10
    point += frames[i + 1][0]
    point += if frames[i + 1][0] == 10
               frames[i + 2][0]

             else
               frames[i + 1][1]

             end

  elsif frames[i].sum == 10
    point += frames[i + 1][0]

  end

  point += frames[i].sum
end
puts point
