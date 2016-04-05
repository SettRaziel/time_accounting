# @Author: Benjamin Held
# @Date:   2016-04-05 17:36:03
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-05 17:39:54

module Menu

  module TimeMenu

    class MonthtimeMenu < TimeMenu

      # main entry point to start a query on a person or task
      def self.worktime_query_menu
        @time_string = 'month'
        print_menu('Input (1-4): ')
      end

      private

      def self.retrieve_tasks
        Query.get_monthly_data_for(@values[:id], @values[:year],
                                   @values[:time_frame])
      end

      def self.retrieve_worktime
        Query::MonthQuery.get_monthly_worktime(@values[:id], @values[:year],
                                               @values[:time_frame])
      end

    end

  end

end
