# frozen_string_literal: true

class Option
  def initialize
    @options = {}
  end

  def parse_options
    OptionParser.new do |opts|
      opts.on('-l') { @options[:l] = true }
      opts.on('-a') { @options[:a] = true }
      opts.on('-r') { @options[:r] = true }
    end.parse(ARGV)

    @options
  end

  def show_all_files?
    @options[:a] || false
  end

  def reverse_order?
    @options[:r] || false
  end

  def long_format?
    @options[:l] || false
  end
end
