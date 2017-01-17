# @Author: Benjamin Held
# @Date:   2016-11-19 15:50:59
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-17 07:18:37

# This modules holds the classes and files that handle the communication
# between the menu or user interface and the used data storage. Depending on
# the settings the data can be stored in:
# * Plain files
# * Sqlite3 database
module DataHandler

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
      # write all updates and additions to the database
    end

    # method to return all stored persons
    # @return [Array] all stored persons
    def get_persons
      @mapper[:person].generate_persons
    end

    # method to return all stored tasks
    # @return [Array] all stored tasks
    def get_tasks
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        get_tasks from its base class".red
    end

    # method to search for a person by its id
    # @return [Person | nil] the person if found or nil
    def find_person_by_id(id)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        find_person_by_id from its base class".red
    end

    # method to search for a person by its id
    # @return [Task] the task with the given id
    def find_task_to_id(id)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        find_task_to_id from its base class".red
    end

    # method to search for all tasks associated
    # @return [Array] the taskss of the person with the given id
    def get_tasks_to_person(id)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        get_tasks_to_person from its base class".red
    end

    # method to add a person to the transient storage
    def add_person(person)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        add_person from its base class".red
    end

    # method to add a task for a person to the transient storage
    def add_task_to_person(person_id, task)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        add_task_to_person from its base class".red
    end

    private

    # @return [SQLite3::Database] a reference to the database
    attr_reader :database
    # @return [Hash] the mapping Symbol => Mapper
    attr_reader :mapper

    # method to initialize the required data objects
    def prepare_data
      @mapper = { :person => DBMapping::PersonMapper.new(@database),
                  :task => DBMapping::TaskMapper.new(@database),
                  :relation => DBMapping::RelationsMapper.new(@database)}
      nil
    end

    # method to initialize the required id generators
    def initialize_id_generators
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        initialize_id_generators from its base class".red
    end

    # method to create a new database at the given path
    # @ param [String] db_path the given file path
    def open_database(db_path)
      begin
        @database = SQLite3::Database.open(db_path)
        @database.results_as_hash = true
      rescue IOError || StandardError
        raise ArgumentError, "Error [DBCreator]: invalid path to database."
      end
    end

  end

end
