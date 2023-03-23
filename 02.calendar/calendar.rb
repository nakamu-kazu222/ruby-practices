require 'date'
require 'optparse'

# 今日の年月を取得
year = Date.today.year
month = Date.today.month

# 引数の年月を取得
options = OptionParser.new
options = ARGV.getopts("","y:#{year}","m:#{month}")

year_option, month_option = options.values.map(&:to_i)

# 指定した年月の初めの日と終わりの日を取得
start_day = Date.new(year_option, month_option, 1)
end_day = Date.new(year_option, month_option, -1)

# 年月と曜日を出力
puts "#{month_option}月 #{year_option}".center(20)
puts " 日 月 火 水 木 金 土"

print space = "   " * start_day.wday

# 取得した日数を繰り返す
(start_day..end_day).each do |day|
  print day.day.to_s.rjust(2)
  if day.wday == 6
    print "\n"
  else
    print " "
  end
end