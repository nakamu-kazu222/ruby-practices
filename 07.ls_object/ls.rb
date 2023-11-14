# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative 'option'
require_relative 'file_detail'
require_relative 'display'

options = Option.new
options.parse_options(ARGV)

file_detail = FileDetail.new
array_files = file_detail.list_files(options)
array_files = file_detail.align_file_characters(array_files)

display = Display.new
array_of_filenames = display.sort_file_vertical(array_files, options)
display.display_ls(array_of_filenames, options)
