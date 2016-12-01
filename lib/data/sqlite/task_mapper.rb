# @Author: Benjamin Held
# @Date:   2016-11-29 19:43:45
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-01 18:59:57

require_relative '../../entity/task'
require_relative 'db_basic'

module DBMapping

  class TaskMapper

    def initialize(filepath)
      @db_base = Database::DBBasic.new(filepath)
    end

    def generate_tasks
      results = @db_base.query_tasks
      tasks = Array.new()
      results.each { |result|
        tasks << Task::Task.new(result['Id'], result['Start'],
                                result['End'], result['Description'])
      }
      return tasks
    end

    def persist_tasks(tasks)
      tasks.each { |task|
        @db_base.insert_task(task.id, task.start_time, task.end_time,
                             task.description)
      }
    end

    private

    attr_reader :db_base

  end

end
