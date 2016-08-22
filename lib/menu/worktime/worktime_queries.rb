# @Author: Benjamin Held
# @Date:   2016-02-23 19:31:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-08-22 21:23:31

module Menu

  require_relative 'time_menu'

  # singleton class to process the queries of different worktime intervals
  class WorktimeQueries < Base

    # initialization
    def initialize
      super
      @menu_description = 'Queries for tasks done in a given time interval.'
    end

    private

    # method to define all printable menu items
    def define_menu_items
      add_menu_item('Weekly worktime.', 1)
      add_menu_item('Monthly worktime.', 2)
      add_menu_item('Custom worktime interval.', 3)
      add_menu_item('Cancel and return to previous menu.', 4)
    end

    # method to process the provided input
    # @param [String] input the provided input
    # @return [Boolean] true: if the program should continue,
    #    false: if the script should return to the previous menu
    def determine_action(input)
      case (input.to_i)
        when 1 then TimeMenu::WeektimeMenu.new.print_menu
        when 2 then TimeMenu::MonthtimeMenu.new.print_menu
        when 3 then TimeMenu::CustomtimeMenu.new.print_menu
        when 4 then return false
      else
        handle_wrong_option
      end
      return true
    end

  end

end
