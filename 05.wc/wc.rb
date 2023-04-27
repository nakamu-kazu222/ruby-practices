# frozen_string_literal: true

require 'optparse'
require 'fileutils'

def select_options_files(option)
  options = OptionParser.new
  options.on('-l') { |v| option[:l] = v }
  options.on('-w') { |v| option[:w] = v }
  options.on('-c') { |v| option[:c] = v }
  options.parse(ARGV)
  argument_filename = []
  ARGV.each do |filename|
    argument_filename << filename if File.file?(filename) && File.extname(filename)
  end
  argument_filename
end

def word_line_size_count_depending_options(option, argument_filename, standard_input_text)
  size_count = []
  size_count_sum = 0
  size_count_max = 0

  line_count = []
  line_count_sum = 0
  line_count_max = 0

  word_count = 0
  word_count_list = []
  word_count_sum = 0
  word_count_max = 0

  array_wc_count = []
  argument_filename.each do |file|
    file_status = File.stat(file)
    size_count = file_status.size
    size_count_sum += file_status.size
    size_count_max = [file_status.size.to_s.size].max

    line_count = File.foreach(file).count
    line_count_sum += File.foreach(file).count
    line_count_max = [File.foreach(file).count.to_s.size].max

    File.open(file) do |files|
      files.each_line do |line|
        word_count += line.split.length
      end

      word_count_list = word_count
      word_count_sum += word_count
      word_count_max = [word_count.to_s.size].max
      word_count = 0
    end

    array_wc_count << [line_count, word_count_list, size_count, file]
  end

  if argument_filename.count.zero?
    standard_input_text = $stdin.read
    size_count = standard_input_text.bytesize
    size_count_sum += standard_input_text.bytesize
    size_count_max = [standard_input_text.bytesize.to_s.size + 1].max

    line_count = standard_input_text.count("\n")
    line_count_sum += standard_input_text.count("\n")
    line_count_max = [standard_input_text.count("\n").to_s.size + 4].max

    standard_input_text.split("\n").each do |line|
      word_count += line.split.length
    end

    word_count_list = word_count
    word_count_sum += word_count
    word_count_max = [word_count.to_s.size + 2].max

    array_wc_count << [line_count, word_count_list, size_count, '']
  end

  array_wc_count = array_wc_count.map do |data|
    if option[:l]
      line_count_indent = data[0].to_s.rjust(line_count_max + 7)
      file_indent = data[3].ljust(10)
    end
    if option[:w]
      word_count_indent = data[1].to_s.rjust(word_count_max + 5)
      file_indent = data[3].ljust(10)
    end
    if option[:c]
      size_count_indent = data[2].to_s.rjust(size_count_max + 3)
      file_indent = data[3].ljust(10)
    end
    if !option[:l] && !option[:w] && !option[:c]
      line_count_indent = data[0].to_s.rjust(line_count_max + 3)
      word_count_indent = data[1].to_s.rjust(word_count_max + 3)
      size_count_indent = data[2].to_s.rjust(size_count_max + 3)
      file_indent = data[3].ljust(10)
    end

    "#{line_count_indent} #{word_count_indent} #{size_count_indent} #{file_indent} "
  end

  if argument_filename.count > 1
    line_count_sum_indent = line_count_sum.to_s.rjust(line_count_max + 3) if option[:l]
    word_count_sum_indent = word_count_sum.to_s.rjust(word_count_max + 3) if option[:w]
    size_count_sum_indent = size_count_sum.to_s.rjust(size_count_max + 3) if option[:c]
    if !option[:l] && !option[:w] && !option[:c]
      line_count_sum_indent = line_count_sum.to_s.rjust(line_count_max + 3)
      word_count_sum_indent = word_count_sum.to_s.rjust(word_count_max + 3)
      size_count_sum_indent = size_count_sum.to_s.rjust(size_count_max + 3)
    end
    total_title_indent = 'total'.ljust(10)
    array_wc_count.push("#{line_count_sum_indent} #{word_count_sum_indent} #{size_count_sum_indent} #{total_title_indent}")
  end
  array_wc_count
end

def display_wc(array_wc_count)
  array_wc_count.each do |display_wc_count|
    print display_wc_count
    print "\n"
  end
end

option = {}
standard_input_text = ''
argument_filename = select_options_files(option)
array_wc_count = word_line_size_count_depending_options(option, argument_filename, standard_input_text)
display_wc(array_wc_count)
