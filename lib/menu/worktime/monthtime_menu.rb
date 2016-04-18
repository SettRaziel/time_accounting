# @Author: Benjamin Held
# @Date:   2016-04-05 17:36:03
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-18 15:39:01

module Menu

  # This module holds the menu classes that are used to display the options for
  # queries based on the time interval that is presented
  module TimeMenu

    # singleton class to present the available query options for a given month
    # and for a given entity, identified by its id
    class MonthtimeMenu < TimeMenu

      # main entry point to start a query on a person or task
      def self.worktime_query_menu
        @time_string = 'month'
        print_menu('Input (1-4): ')
      end

      private

      # method to retrieve all task that started, ended or took place within
      # the given month for the provided id
      def self.retrieve_tasks
        Query.get_monthly_data_for(@values[:id], @values[:year],
                                   @values[:time_frame])
      end

      # method to retrieve the overall worktime for an entity with the given id
      # for the given month
      def self.retrieve_worktime
        Query::MonthQuery.get_monthly_worktime(@values[:id], @values[:year],
                                               @values[:time_frame])
      end

    end

  end

end
