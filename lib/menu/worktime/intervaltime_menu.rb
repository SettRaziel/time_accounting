# @Author: Benjamin Held
# @Date:   2016-05-13 09:09:11
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-27 19:37:51

module Menu

  module TimeMenu

    # singleton class to serve as a parent class for interval based time menus
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
