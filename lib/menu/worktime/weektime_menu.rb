# @Author: Benjamin Held
# @Date:   2016-03-25 12:13:48
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-01 16:07:26

module Menu

  module TimeMenu

    class WeektimeMenu < TimeMenu

      # main entry point to start a query on a person or task
      def self.worktime_query_menu
        @time_string = 'week'
        print_menu('Input (1-4): ')
      end

      private

      def self.retrieve_tasks
        Query.get_weekly_data_for(@values[:id], @values[:year],
                                  @values[:time_frame])
      end

      def self.retrieve_worktime
        Query::WeekQuery.get_weekly_worktime(@values[:id], @values[:year],
                                             @values[:time_frame])
      end

    end

  end

end
