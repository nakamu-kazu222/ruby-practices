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
end
