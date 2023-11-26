# frozen_string_literal: true

class FileFormatter
  COLUMN_COUNT = 3

  def sort_file_vertical(array_files, options)
    column_number = options.long_format? ? 1 : array_files.size.quo(COLUMN_COUNT).ceil
    column_files = array_files.each_slice(column_number).to_a
    array_of_filenames = []
    return column_files if column_files.length < 2

    array_of_filenames = column_files[0]
    column_files[1..].each { |column| array_of_filenames = array_of_filenames.zip(column).map(&:flatten) }
    array_of_filenames = array_of_filenames.map(&:compact)

    array_of_filenames = array_of_filenames.map { |lines| [lines.join("\n")] } if options.long_format?

    array_of_filenames
  end
end
