# frozen_string_literal: true

# 行数指定
COLUMN_COUNT = 3

# ファイル名の文字数を揃える
def current_directory_get_file
  Dir.glob('*')
end

# ファイル名の文字数を揃える
def align_file_characters(array_files)
  max_characters = array_files.max_by(&:size)
  array_files = array_files.map { |max_characters_space| max_characters_space.ljust(max_characters.size + 6) }
end

# ファイル名を名前順に縦に並べる
def sort_file_vertical(array_files)
  column_number = array_files.size.quo(COLUMN_COUNT).ceil
  column_files = []
  array_files.each_slice(column_number) { |file| column_files << file }
  print_ls = []
  column_files.count.times do |i|
    if i.zero?
      if column_files[i + 1].nil?
        print_ls << column_files[i]
        break
      else
        column_files[i].zip(column_files[i + 1]) do |ls_file1|
          print_ls << ls_file1
        end
      end

    elsif i < (column_files.count - 1)
      x = 0
      y = i
      column_number.times do |column_files_count|
        next unless column_files_count < column_number

        print_ls[x] << column_files[y + 1][x]
        x += 1
      end
    end
    i + 1
  end
  array_files = print_ls
end

def display_ls(print_ls)
  print_ls.each do |secondary_array_files|
    secondary_array_files.each do |primary_array_files|
      print primary_array_files
    end
    print "\n"
  end
end

array_files = current_directory_get_file
array_files = align_file_characters(array_files)
array_files = sort_file_vertical(array_files)
display_ls(array_files)
