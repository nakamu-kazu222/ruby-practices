# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative 'option'
require_relative 'file_detail'
require_relative 'display'

options = Option.new
options.parse_options(ARGV)

file_detail = FileDetail.new(show_all_files: options.show_all_files?, reverse_order: options.reverse_order?)
array_files = file_detail.l_option_formats_file(long_format: options.long_format?)

display = Display.new
display.sort_file_vertical(array_files, options)
