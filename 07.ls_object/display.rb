# frozen_string_literal: true

class Display
  def display_ls(array_of_filenames, options)
    if options.long_format?
      array_of_filenames.each { |display_filename| puts display_filename }
    else
      array_of_filenames.each do |display_filename|
        display_filename.each do |ls_filename|
          print ls_filename
        end
        print "\n"
      end
    end
  end
end
