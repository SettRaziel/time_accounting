# This modules holds the classes and files that handle the communication
# between the menu or user interface and the used data storage. Depending on
# the settings the data can be stored in:
# * Plain files
# * Sqlite3 database
module DataHandler

  require 'sqlite3'
  require_relative '../data/sqlite/db_mapping'

  # This class serves as a handler between the repositories and the queries. It
  # also takes care about the initialization of the repositories and the id
  # generators. The handler also provides methods to save and load data from and
  # to a repository.
  class SqliteHandler < BaseHandler

    # initialization
    # @param [String] filename the filename from where the data should be loaded
    #   or to where the data should be saved
    def initialize(filename)
      open_database(filename)
      super(filename)
    end

    # method to persis the newly created or updated data to the database
    def persist_data
      @mapper[:person].persist_persons(@change_queue[:person])
      @mapper[:task].persist_tasks(@change_queue[:task])
      @mapper[:relation].
             generate_person_and_task_relations(@change_queue[:relation])
      nil
    end

    # method to return all stored persons
    # @return [Array] all stored persons
    def get_persons
      @mapper[:person].generate_persons
    end

    # method to return all stored tasks
    # @return [Array] all stored tasks
    def get_tasks
      @mapper[:task].generate_tasks
    end

    # method to search for a person by its id
    # @return [Person | nil] the person if found or nil
    def find_person_by_id(id)
      @mapper[:person].query_person(id)
    end

    # method to search for a person by its id
    # @return [Task] the task with the given id
    def find_task_to_id(id)
      @mapper[:task].query_task(id)
    end

    # method to search for all tasks associated
    # @param [Integer] id the id of the person
    # @return [Array] the tasks of the person with the given id
    def get_tasks_to_person(id)
      task_ids = @mapper[:relation].retrieve_tasks_for_person(id)
      tasks = Array.new()
      task_ids.each { |task_id|
        tasks << find_task_to_id(task_id)
      }
      tasks
    end

    # method to add a person to the transient storage
    # @param [Person::Person] person the person that should be added
    def add_person(person)
      @change_queue[:person] << person
      nil
    end

    # method to add a task for a person to the transient storage
    def add_task_to_person(person_id, task)
      @change_queue[:task] << task
      if (@change_queue[:relation][person_id] == nil)
        @change_queue[:relation][person_id] = Array.new()
      end
      @change_queue[:relation][person_id] << task.id
      nil
    end

    private

    # @return [SQLite3::Database] a reference to the database
    attr_reader :database
    # @return [Hash] the mapping Symbol => Mapper
    attr_reader :mapper
    # @return [Hash] a hash to map the change operations for the database
    attr_reader :change_queue

    # method to initialize the required data objects
    def prepare_data
      @mapper = { :person => DBMapping::StudentMapper.new(@database),
                  :task => DBMapping::TaskMapper.new(@database),
                  :relation => DBMapping::RelationsMapper.new(@database)}
      @change_queue = { :person => Array.new(),
                        :task => Array.new(),
                        :relation => Hash.new()}
      initialize_id_generators
      nil
    end

    # method to initialize the required id generators
    def initialize_id_generators
      Person::PersonIDGenerator.new(@mapper[:person].query_max_person_id)
      Task::TaskIDGenerator.new(@mapper[:task].query_max_task_id)
      nil
    end

    # method to create a new database at the given path
    # @ param [String] db_path the given file path
    def open_database(db_path)
      begin
        @database = SQLite3::Database.open(db_path)
        @database.results_as_hash = true
        nil
      rescue IOError || StandardError
        raise ArgumentError, "Error [DBCreator]: invalid path to database."
      end
    end

  end

end
