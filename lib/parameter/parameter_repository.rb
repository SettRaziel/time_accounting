module Parameter

  require 'ruby_utils/parameter'

  # Parameter repository storing the valid parameter of the script.
  # {#initialize} gets the provided parameters and fills a hash which
  # grants access on the provided parameters and their arguments
  class ParameterRepository < RubyUtils::Parameter::BaseParameterRepository

      private

      # method to read further argument and process it depending on its content
      # @param [String] arg the given argument
      def process_argument(arg)
        # no additional paramaeters
        raise_invalid_parameter(arg)
        nil
      end

      # method to define the input string values that will match a given paramter symbol
      def define_mapping
        # no additional parameters
        nil
      end

    end

end
