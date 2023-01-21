# This module holds the classes for the terminal menu, which can be used to
# run this program in a terminal window.
module Menu

  module TimeMenu

    # menu class to serve as a parent class for interval based time menus
    class IntervaltimeMenu < TimeMenu

      private

      # method to retrieve the required input values
      def get_input_values
        @values = Hash.new()
        @values[:id] = get_entry('Worktime for which ID? ').to_i
        @values[:year] = get_entry('Specify year: ').to_i
        @values[:time_frame] =
                get_entry("Specify #{@time_string} of year: ").to_i
      end

      # method to set the values for start and end time
      def set_values(times)
        @values[:start_time] = times[:actual]
        @values[:end_time] = times[:next]
      end

    end

  end

end

require_relative 'weektime_menu'
require_relative 'monthtime_menu'
