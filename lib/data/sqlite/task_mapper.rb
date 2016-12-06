# @Author: Benjamin Held
# @Date:   2016-11-29 19:43:45
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-06 19:51:28

require_relative '../../entity/task'
require_relative 'db_basic'

module DBMapping

  # class to apply ER-mapping for {Task::Task} objects to a sqlite database
  class TaskMapper

    # initialization
    # @param [String] filepath the path to the database
    def initialize(filepath)
      @db_base = SqliteDatabase::DBBasic.new(filepath)
    end

    # public method to transform database persons to entity {Task::Task}
    # @return [Array] all transformed {Task::Task} entities
    def generate_tasks
      results = @db_base.query_tasks
      tasks = Array.new()
      results.each { |result|
        tasks << Task::Task.new(result['Id'], result['Start'],
                                result['End'], result['Description'])
      }
      return tasks
    end

    # method to persist a list of {Task::Task}s to the database
    # @param [Array] persons the {Task::Task} that should be be persisted
    def persist_tasks(tasks)
      tasks.each { |task|
        @db_base.insert_task(task.id, task.start_time, task.end_time,
                             task.description)
      }
      nil
    end

    private

    # @return [DBBasic] the basic database adapter
    attr_reader :db_base

  end

end
