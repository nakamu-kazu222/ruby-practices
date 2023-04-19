# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

# 行数指定
COLUMN_COUNT = 3
PERMISSION_SYMBOL = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def file_list_depending_options(option)
  options = OptionParser.new
  options.on('-l') { |v| option[:l] = v }
  options.parse(ARGV)
  if option[:l]
    file_status_l_options
  else
    Dir.glob('*')
  end
end

def file_status_l_options
  file_list = Dir.glob('*')
  total_blocks = 0
  file_uid_size_max = 0
  file_gid_size_max = 0
  file_size_max = 0
  array_files = []
  file_list.each do |files|
    file_status = File.stat(files)
    file_blocks = file_status.blocks
    total_blocks += file_blocks
    file_uid = Etc.getpwuid(file_status.uid).name
    file_gid = Etc.getgrgid(file_status.gid).name
    file_size = file_status.size
    file_mtime = file_status.mtime
    file_update_time = format('%<month>2d %<day>2d %<hour>02d:%<min>02d', month: file_mtime.month, day: file_mtime.day, hour: file_mtime.hour,
                                                                          min: file_mtime.min).ljust(12)
    file_nlink = file_status.nlink
    permission_eight_bit = file_status.mode.to_s(8)[-3..]
    file_mode_permission = file_type(files)
    file_mode_permission += permission_eight_bit.chars.map { |bit| PERMISSION_SYMBOL[bit] }.join
    file_uid_size_max = [file_uid.size].max
    file_gid_size_max = [file_gid.size].max
    file_size_max = [file_size.to_s.size].max
    array_files << [file_mode_permission, file_nlink, file_uid, file_gid, file_size, file_update_time, files]
  end
  array_files = array_files.map do |file_status_list|
    file_mode_permission = file_status_list[0].ljust(11)
    file_nlink = file_status_list[1].to_s.rjust(2)
    file_uid = file_status_list[2].ljust(file_uid_size_max + 2)
    file_gid = file_status_list[3].ljust(file_gid_size_max + 2)
    file_size = file_status_list[4].to_s.rjust(file_size_max + 2)
    file_update_time = file_status_list[5]
    file_name = file_status_list[6]
    "#{file_mode_permission} #{file_nlink} #{file_uid} #{file_gid} #{file_size} #{file_update_time} #{file_name}"
  end
  array_files.unshift("total #{total_blocks}")
end

def file_type(file)
  if File.file?(file)
    '-'
  elsif File.symlink?(file)
    'l'
  elsif File.directory?(file)
    'd'
  elsif File.chardev?(file)
    'c'
  elsif File.blockdev?(file)
    'b'
  elsif File.socket?(file)
    's'
  elsif File.pipe?(file)
    'p'
  end
end

def align_file_characters(array_files)
  max_characters = array_files.max_by(&:size)
  array_files.map { |max_characters_space| max_characters_space.ljust(max_characters.size + 4) }
end

def sort_file_vertical(array_files, option)
  column_number = if option[:l]
                    1
                  else
                    array_files.size.quo(COLUMN_COUNT).ceil
                  end
  column_files = array_files.each_slice(column_number).to_a
  array_of_filenames = []
  return column_files if column_files.length < 2

  array_of_filenames = column_files[0]
  column_files[1..].each { |column| array_of_filenames = array_of_filenames.zip(column).map(&:flatten) }
  array_of_filenames
end

def display_ls(array_of_filenames, option)
  if option[:l]
    array_of_filenames.each { |primary_array_files| puts primary_array_files }
  else
    array_of_filenames.each do |secondary_array_files|
      secondary_array_files.each do |primary_array_files|
        print primary_array_files
      end
      print "\n"
    end
  end
end

option = {}
array_files = file_list_depending_options(option)
array_files = align_file_characters(array_files)
array_of_filenames = sort_file_vertical(array_files, option)
display_ls(array_of_filenames, option)
