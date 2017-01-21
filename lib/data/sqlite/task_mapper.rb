# @Author: Benjamin Held
# @Date:   2016-11-29 19:43:45
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-21 19:43:19

module DBMapping

  # class to apply ER-mapping for {Task::Task} objects to a sqlite database
  class TaskMapper

    # initialization
    # @param [SQLite3::Database] database a reference of the database
    def initialize(database)
      @db_base = SqliteDatabase::DBBasic.new(database)
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
    # @param [Array] tasks the {Task::Task} that should be be persisted
    def persist_tasks(tasks)
      tasks.each { |task|
        @db_base.insert_task(task.id, task.start_time, task.end_time,
                             task.description)
      }
      nil
    end

    # method to search for a task by its id
    # @return [Task::Task | nil] the result, if found or nil
    def query_task(id)
      result = @db_base.query_task(id).next
      Task::Task.new(result['Id'], result['Start'], result['End'],
                     result['Description'])
    end

    private

    # @return [DBBasic] the basic database adapter
    attr_reader :db_base

  end

end
