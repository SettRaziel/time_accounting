# @Author: Benjamin Held
# @Date:   2016-11-19 15:59:49
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-27 08:33:35

module DataHandler

  # This class serves as a abstract parent class to take care about the
  # initialization of the repositories and the id generator. This class also
  # provides abstract methods to save and load data from and to a repository
  # which are implemented by child classes.
  class BaseHandler

    # initialization
    # @param [String] filename the filename from where the data should be loaded
    #   or to where the data should be saved
    def initialize(filename)
      @filename = filename
    end

    # method to load the content into the repository from the path specified
    # by the filename and based on the used adapter
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def load_data
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        load_repository from its base class".red
    end

    # method to save the content of the repository to the path specified by
    # the filename and based on the used adapter
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def persist_data
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        save_repository from its base class".red
    end

    # method to return all stored persons
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def get_persons
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        get_persons from its base class".red
    end

    # method to return all stored tasks
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def get_tasks
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        get_tasks from its base class".red
    end

    # method to search for a person by its id
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def find_person_by_id(id)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        find_person_by_id from its base class".red
    end

    # method to search for a person by its id
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def find_task_to_id(id)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        find_task_to_id from its base class".red
    end

    # method to search for all tasks associated
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def get_tasks_to_person(id)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        get_tasks_to_person from its base class".red
    end

    # method to add a person to the transient storage
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def add_person(person)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        add_person from its base class".red
    end

    # method to add a task for a person to the transient storage
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def add_task_to_person(person_id, task)
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        add_task_to_person from its base class".red
    end

    private

    # @return [String] the file name
    attr_reader :filename

    # method to initialize the required id generators
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def initialize_id_generators
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        initialize_id_generators from its base class".red
    end

  end

end

require_relative 'file_handler'
