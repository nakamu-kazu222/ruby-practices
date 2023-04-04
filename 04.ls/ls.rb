# frozen_string_literal: true

# 行数指定
COLUMN_COUNT = 3

# 全ファイル名の文字数を揃える
def chara_length
  ary = Dir.glob('*')
  max_chara = ary.max_by(&:size)
  ary = ary.map { |max_chara_space| max_chara_space.ljust(max_chara.size + 6) }
  file_set(ary)
end

# ファイル名を名前順に縦に並べる
def file_set(ary)
  column_number = ary.size.quo(COLUMN_COUNT).ceil
  column_file = []
  ary.each_slice(column_number) { |file| column_file << file }
  print_ls = []
  COLUMN_COUNT.times do |i|
    if i.zero?
      column_file[i].zip(column_file[i + 1]) do |ls_file1|
        print_ls << ls_file1
      end

    elsif i < (COLUMN_COUNT - 1)
      x = 0
      y = i
      column_number.times do |column_file_count|
        next unless column_file_count < column_number

        print_ls[x] << column_file[y + 1][x]
        x += 1
      end

    else
      break
    end
    i + 1
  end
  display(print_ls)
end

def display(print_ls)
  print_ls.each do |secondary_array|
    secondary_array.each do |primary_array|
      print primary_array
    end
    print "\n"
  end
end

chara_length
