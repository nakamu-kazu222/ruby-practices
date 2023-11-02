# frozen_string_literal: true

class Display
  COLUMN_COUNT = 3

  def align_file_characters(array_files)
    max_characters = array_files.max_by(&:size)
    array_files.map { |max_characters_space| max_characters_space.ljust(max_characters.size + 4) }
  end

  def sort_file_vertical(array_files, options)
    column_number = options.long_format? ? 1 : array_files.size.quo(COLUMN_COUNT).ceil
    column_files = array_files.each_slice(column_number).to_a
    array_of_filenames = []
    return column_files if column_files.length < 2

    array_of_filenames = column_files[0]
    column_files[1..].each { |column| array_of_filenames = array_of_filenames.zip(column).map(&:flatten) }
    array_of_filenames
  end

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
