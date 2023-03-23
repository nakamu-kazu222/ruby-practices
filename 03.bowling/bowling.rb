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

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
# フレームごとの、ストライク、スペアの合計 + 9ピン以下の合計
10.times do |i|
  # ストライク
  if frames[i][0] == 10

    # ダブルストライク後の1投目も含めて合計を加算
    point += frames[i + 1][0]
    point += if frames[i + 1][0] == 10
               frames[i + 2][0]

             # ストライク後の合計を加算
             else
               frames[i + 1][1]

             end

  # スペア後の1投目を加算
  elsif frames[i].sum == 10
    point += frames[i + 1][0]

  end

  # 9ピン以下のスコアを計算
  point += frames[i].sum
  i + 1
end
puts point
