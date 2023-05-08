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
  file_status = File.stat(file)
  file_status.size
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
  file_list.sum { |file| File.stat(file).size }
end

def total_line_count_calc(file_list)
  file_list.sum { |file| File.foreach(file).count }
end

def total_word_count_calc(file_list)
  file_list.sum { |file| word_count_calc(file) }
end

def word_line_size_count_depending_options(option, argument_filename)
  array_wc_count = []
  argument_filename.each do |file|
    size_count = size_count_calc(file)
    line_count = line_count_calc(file)
    word_count = word_count_calc(file)
    array_wc_count << { line_count:, word_count:, size_count:, file: }
  end

  if argument_filename.empty?
    standard_input_text = $stdin.read
    size_count = standard_input_text.bytesize
    line_count = standard_input_text.count("\n")
    word_count = standard_input_text.split("\n").sum { |line| line.split.length }
    array_wc_count << { line_count:, word_count:, size_count:, file: '' }
  end

  array_wc_count = array_wc_count.map do |data|
    if option[:l]
      line_count_indented = data[:line_count].to_s.rjust(8)
      file_indented = data[:file].ljust(10)
    end

    if option[:w]
      word_count_indented = data[:word_count].to_s.rjust(8)
      file_indented = data[:file].ljust(10)
    end

    if option[:c]
      size_count_indented = data[:size_count].to_s.rjust(8)
      file_indented = data[:file].ljust(10)
    end

    if !option[:l] && !option[:w] && !option[:c]
      line_count_indented = data[:line_count].to_s.rjust(8)
      word_count_indented = data[:word_count].to_s.rjust(8)
      size_count_indented = data[:size_count].to_s.rjust(8)
      file_indented = data[:file].ljust(10)
    end

    "#{line_count_indented} #{word_count_indented} #{size_count_indented} #{file_indented}"
  end

  if argument_filename.count > 1
    total_line_count = total_line_count_calc(argument_filename)
    total_word_count = total_word_count_calc(argument_filename)
    total_size_count = total_size_count_calc(argument_filename)

    line_count_indented = total_line_count.to_s.rjust(8) if option[:l]

    word_count_indented = total_word_count.to_s.rjust(8) if option[:w]

    size_count_indented = total_size_count.to_s.rjust(8) if option[:c]

    if !option[:l] && !option[:w] && !option[:c]
      line_count_indented = total_line_count.to_s.rjust(8)
      word_count_indented = total_word_count.to_s.rjust(8)
      size_count_indented = total_size_count.to_s.rjust(8)
    end

    total_title_indented = 'total'.ljust(10)
    array_wc_count << ("#{line_count_indented} #{word_count_indented} #{size_count_indented} #{total_title_indented}")
  end
  array_wc_count
end

def display_wc(array_wc_count)
  array_wc_count.each do |display_wc_count|
    print display_wc_count
    print "\n"
  end
end

option = select_options
argument_filename = acquisition_argument_filename
array_wc_count = word_line_size_count_depending_options(option, argument_filename)
display_wc(array_wc_count)
