require 'optparse'
require_relative 'option'
require_relative 'file_detail'
require_relative 'file_formatter'

class LsCommand
  def initialize(args)
    @options = Option.new
    @options.parse_options(args)
  end

  def main
    file_detail = FileDetail.new(show_all_files: @options.show_all_files?, reverse_order: @options.reverse_order?)
    target_files = file_detail.l_option_formats_file(long_format: @options.long_format?)

    file_formatter = FileFormatter.new
    file_formatter.sort_file_vertical(target_files, @options).each do |formatted_line|
      formatted_line.each do |ls_filename|
        print ls_filename
      end
      print "\n"
    end
  end
end
