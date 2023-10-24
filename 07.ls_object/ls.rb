# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative 'option'
require_relative 'file_permission'
require_relative 'display'

option = Option.new
options = option.parse_options

file = FilePermission.new
array_files = file.list_files(options)

display = Display.new
array_files = display.align_file_characters(array_files)
array_of_filenames = display.sort_file_vertical(array_files, options)
display.display_ls(array_of_filenames, options)
