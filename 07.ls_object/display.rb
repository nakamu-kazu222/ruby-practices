# frozen_string_literal: true

class Display
  COLUMN_COUNT = 3

  def display_ls(array_of_filenames, long_format)
    if long_format
      display_long_format(array_of_filenames)
    else
      display_default_format(array_of_filenames)
    end
  end

  def sort_file_vertical(array_files, options)
    column_number = options.long_format? ? 1 : array_files.size.quo(COLUMN_COUNT).ceil
    column_files = array_files.each_slice(column_number).to_a
    array_of_filenames = []
    return column_files if column_files.length < 2

    array_of_filenames = column_files[0]
    column_files[1..].each { |column| array_of_filenames = array_of_filenames.zip(column).map(&:flatten) }
    display_ls(array_of_filenames, options.long_format?)
  end

  private

  def display_long_format(array_of_filenames)
    array_of_filenames.each { |display_filename| puts display_filename }
  end

  def display_default_format(array_of_filenames)
    array_of_filenames.each do |display_filename|
      display_filename.each do |ls_filename|
        print ls_filename
      end
      print "\n"
    end
  end
end
