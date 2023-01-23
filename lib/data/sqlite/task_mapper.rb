module DBMapping

  # class to apply ER-mapping for {Task::Task} objects to a sqlite database
  class TaskMapper < Base

    # initialization
    # @param [SQLite3::Database] database a reference of the database
    def initialize(database)
      super(database)
    end

    # public method to transform database persons to entity {Task::Task}
    # @return [Array] all transformed {Task::Task} entities
    def generate_tasks
      results = @db_base.query_tasks
      tasks = Array.new()
      results.each { |result|
        tasks << create_task_from_result(result)
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
      create_task_from_result(@db_base.query_task(id).next)
    end

    # method to query the max id of the task table
    # @return [Integer] the maximal task id
    def query_max_task_id
      check_max_id(@db_base.query_max_task_id.next)
    end

    private

    # method to create a {Task::Task} from a result entry
    # @param [Hash] result an entry from the result set
    def create_task_from_result(result)
      Task::Task.new(result["Id"], Time.parse(result["Start"]),
                     Time.parse(result["End"]),
                     result["Description"])
    end

  end

end
