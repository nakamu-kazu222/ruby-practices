# frozen_string_literal: true

require 'optparse'

# 行数指定
COLUMN_COUNT = 3

def ls_argument
  options = OptionParser.new
  option = {}
  options.on('-a') { |v| option[:a] = v }
  options.parse(ARGV)
  array_files = Dir.glob('*')
  array_files = Dir.foreach('.').sort if option[:a]
  array_files
end

def align_file_characters(array_files)
  max_characters = array_files.max_by(&:size)
  array_files.map { |max_characters_space| max_characters_space.ljust(max_characters.size + 4) }
end

def sort_file_vertical(array_files)
  column_number = array_files.size.quo(COLUMN_COUNT).ceil
  column_files = array_files.each_slice(column_number).to_a
  array_of_filenames = []
  return column_files if column_files.length < 2

  array_of_filenames = column_files[0]
  column_files[1..].each { |column| array_of_filenames = array_of_filenames.zip(column).map(&:flatten) }
  array_of_filenames
end

def display_ls(array_of_filenames)
  array_of_filenames.each do |secondary_array_files|
    secondary_array_files.each do |primary_array_files|
      print primary_array_files
    end
    print "\n"
  end
end

array_files = ls_argument
array_files = align_file_characters(array_files)
array_of_filenames = sort_file_vertical(array_files)
display_ls(array_of_filenames)
