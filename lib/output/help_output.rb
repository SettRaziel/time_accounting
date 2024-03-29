require "ruby_utils/string"

# Output class for help text
class HelpOutput

  # method to print the help text for the given parameter
  # @param [Symbol] parameter provided parameter
  # @raise [ArgumentError] a non existent parameter is provided
  def self.print_help_for(parameter)
    initialize_output if (@parameters == nil)
    if (@parameters[parameter])
      puts "WorkAccounting help:".light_yellow + "\n#{@parameters[parameter]}"
    elsif (parameter)
      print_help
    else
      raise ArgumentError,
            " Error: help entry for #{parameter} does not exist".red
    end
  end

  private

  # @return [Hash] hash which stores available parameters and their help text
  attr_reader :parameters

  # method to initialize the hash containing the help entries
  def self.initialize_output
    @parameters = Hash.new()
    add_single_help_entries
  end

  # method to specify and add the help entries with help text only
  def self.add_single_help_entries
    add_simple_text(:help, " -h, --help     ", "show help text")
    add_simple_text(:version,
                    " -v, --version  ",
                    "prints the current version of the project")
  end

  # method to add a (key, value) pair to the parameter hash
  # @param [Symbol] symbol the key
  # @param [String] text the value containing a formatted string
  def self.add_text(symbol, text)
    @parameters[symbol] = text
  end

  # method to add a (key, value) pair where the value contains the help text
  # @param [Symbol] symbol the key
  # @param [String] argument the string part containing the argument
  # @param [String] text the string part containing the description text
  def self.add_simple_text(symbol, argument, text)
    add_text(symbol, argument.light_blue.concat(text))
  end

  # method to print the default help text
  def self.print_help
    puts "script usage:".red + " ruby <script> "
    puts "help usage :".green + "  ruby <script> (-h | --help)"
    puts "\nWorkAccounting help:".light_yellow

    @parameters.each_value { |value|
      puts value
    }

  end

end
