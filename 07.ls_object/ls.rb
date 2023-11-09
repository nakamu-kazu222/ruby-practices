# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative 'option'
require_relative 'file'
require_relative 'display'

options = Option.new
options.parse_options(ARGV)

file = File.new
array_files = file.list_files(options)
array_files = file.align_file_characters(array_files)
array_of_filenames = file.sort_file_vertical(array_files, options)

display = Display.new
display.display_ls(array_of_filenames, options)
