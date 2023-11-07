# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'
require_relative 'option'
require_relative 'file_permission'
require_relative 'display'

options = Option.new
options.parse_options

file_permission = FilePermission.new
array_files = file_permission.list_files(options)
array_files = file_permission.align_file_characters(array_files)
array_of_filenames = file_permission.sort_file_vertical(array_files, options)

display = Display.new
display.display_ls(array_of_filenames, options)
