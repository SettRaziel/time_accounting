# @Author: Benjamin Held
# @Date:   2016-03-25 12:13:48
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-08-09 09:30:01

module Menu

  module TimeMenu

    # singleton class to present the available query options for a given week
    # and for a given entity, identified by its id
    class WeektimeMenu < IntervaltimeMenu

      # initialization
      def initialize
        super('week')
      end

      private

      # method to retrieve all task that started, ended or took place within
      # the given week for the provided id
      # @return [Hash] a hash mapping (task_type => Array) holding the queried
      #   tasks
      def retrieve_tasks
        Query.get_weekly_data_for(@values[:id], @values[:year],
                                  @values[:time_frame])
      end

      # method to retrieve the overall worktime for an entity with the given id
      # for the given week
      # @return [Hash] a hash with the hours for each type of task
      def retrieve_worktime
        Query::WeekQuery.get_weekly_worktime(@values[:id], @values[:year],
                                             @values[:time_frame])
      end

    end

  end

end
