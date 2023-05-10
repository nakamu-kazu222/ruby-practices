# frozen_string_literal: true

require 'optparse'
require 'fileutils'

def select_options
  option = {}
  options = OptionParser.new
  options.on('-l') { |v| option[:l] = v }
  options.on('-w') { |v| option[:w] = v }
  options.on('-c') { |v| option[:c] = v }
  options.parse(ARGV)
  option
end

def acquisition_argument_filename
  argument_filename = []
  ARGV.each do |filename|
    argument_filename << filename if File.file?(filename) && File.extname(filename)
  end
  argument_filename
end

def size_count_calc(file)
  File.stat(file).size
end

def line_count_calc(file)
  File.foreach(file).count
end

def word_count_calc(file)
  word_count = 0
  File.open(file) do |files|
    files.each_line do |line|
      word_count += line.split.length
    end
  end
  word_count
end

def total_size_count_calc(file_list)
  file_list.sum { |file| size_count_calc(file) }
end

def total_line_count_calc(file_list)
  file_list.sum { |file| line_count_calc(file) }
end

def total_word_count_calc(file_list)
  file_list.sum { |file| word_count_calc(file) }
end

def word_line_size_count_in_array(acquisition_argument_filename)
  array_wc_count = []
  if acquisition_argument_filename.empty?
    standard_input_text = $stdin.read
    size_count = standard_input_text.bytesize
    line_count = standard_input_text.count("\n")
    word_count = standard_input_text.split("\n").sum { |line| line.split.length }
    array_wc_count << { line_count:, word_count:, size_count:, file: '' }

  elsif acquisition_argument_filename.count.positive?
    acquisition_argument_filename.each do |file|
      size_count = size_count_calc(file)
      line_count = line_count_calc(file)
      word_count = word_count_calc(file)
      array_wc_count << { line_count:, word_count:, size_count:, file: }
    end

    if acquisition_argument_filename.count > 1
      line_count = total_line_count_calc(acquisition_argument_filename)
      word_count = total_word_count_calc(acquisition_argument_filename)
      size_count = total_size_count_calc(acquisition_argument_filename)
      file = 'total'.ljust(10)
      array_wc_count << { line_count:, word_count:, size_count:, file: }
    end
    array_wc_count
  end
end

def array_wc_count_adjust_indentation(option, array_wc_count)
  array_wc_count.map do |data|
    line_count_indented = data[:line_count].to_s.rjust(8) if option[:l]
    word_count_indented = data[:word_count].to_s.rjust(8) if option[:w]
    size_count_indented = data[:size_count].to_s.rjust(8) if option[:c]
    if !option[:l] && !option[:w] && !option[:c]
      line_count_indented = data[:line_count].to_s.rjust(8)
      word_count_indented = data[:word_count].to_s.rjust(8)
      size_count_indented = data[:size_count].to_s.rjust(8)
    end
    file_indented = data[:file].ljust(10)
    "#{line_count_indented} #{word_count_indented} #{size_count_indented} #{file_indented}"
  end
end

def display_wc(array_wc_count)
  array_wc_count.each do |display_wc_count|
    print display_wc_count
    print "\n"
  end
end

option = select_options
acquisition_argument_filename
array_wc_count = word_line_size_count_in_array(acquisition_argument_filename)
array_wc_count = array_wc_count_adjust_indentation(option, array_wc_count)
display_wc(array_wc_count)
