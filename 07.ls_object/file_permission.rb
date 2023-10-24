# frozen_string_literal: true

class FilePermission
  PERMISSION_SYMBOL = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize
    @file_list = Dir.glob('*')
  end

  def list_files(options)
    @file_list = Dir.foreach('.').sort if options[:a]
    @file_list = @file_list.reverse if options[:r]
    @file_list = file_status_l_options if options[:l]
    @file_list
  end

  private

  def collect_file_info(file_status, files)
    {
      mode: file_status.mode.to_s(8)[-3..],
      nlink: file_status.nlink,
      uid: Etc.getpwuid(file_status.uid).name,
      gid: Etc.getgrgid(file_status.gid).name,
      size: file_status.size,
      mtime: file_status.mtime,
      name: files
    }
  end

  def format_file_info(file_info, uid_size_max, gid_size_max, size_max)
    mode = file_info[:mode]
    nlink = file_info[:nlink].to_s.rjust(2)
    uid = file_info[:uid].ljust(uid_size_max + 2)
    gid = file_info[:gid].ljust(gid_size_max + 2)
    size = file_info[:size].to_s.rjust(size_max + 3)
    mtime = format('%<month>2d %<day>2d %<hour>02d:%<min>02d', month: file_info[:mtime].month, day: file_info[:mtime].day, hour: file_info[:mtime].hour,
                                                               min: file_info[:mtime].min).ljust(12)
    name = file_info[:name]

    "#{file_type(name)}#{mode.chars.map { |bit| PERMISSION_SYMBOL[bit] }.join} #{nlink} #{uid} #{gid} #{size} #{mtime} #{name}"
  end

  def file_status_l_options
    total_blocks = 0
    file_uid_size_max = 0
    file_gid_size_max = 0
    file_size_max = 0
    array_files = []

    @file_list.each do |files|
      file_status = File.stat(files)
      file_blocks = file_status.blocks
      total_blocks += file_blocks

      file_info = collect_file_info(file_status, files)
      file_info = format_file_info(file_info, file_uid_size_max, file_gid_size_max, file_size_max)

      array_files << file_info
    end

    array_files.unshift("total #{total_blocks}")
  end

  def file_type(file)
    return '-' if File.file?(file)
    return 'l' if File.symlink?(file)
    return 'd' if File.directory?(file)
    return 'c' if File.chardev?(file)
    return 'b' if File.blockdev?(file)
    return 's' if File.socket?(file)
    return 'p' if File.pipe?(file)

    '-'
  end
end
