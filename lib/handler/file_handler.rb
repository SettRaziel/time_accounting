require_relative "../data/file_storage/data_repository"
require_relative "../data/file_storage/file_reader"
require_relative "../data/file_storage/file_writer"

module DataHandler

  # This class serves as a handler between the repositories and the queries. It
  # also takes care about the initialization of the repositories and the id
  # generators. The handler also provides methods to save and load data from and
  # to a repository.
  class FileHandler < BaseHandler

    # initialization
    # @param [String] filename the filename from where the data should be loaded
    #   or to where the data should be saved
    def initialize(filename)
      @repository=DataRepository.new()
      super(filename)
    end

    # method to save the content of the repository to the path
    # specified by the filename and based on the used adapter
    def persist_data
      writer = FileWriter.new(filename)
      writer.write_all_persons(@repository.get_persons)
      writer.write_all_tasks(@repository.return_output_mapping)
      nil
    end

    # method to return all stored persons
    # @return [Array] all stored persons
    def get_persons
      @repository.get_persons
    end

    # method to return all stored tasks
    # @return [Array] all stored tasks
    def get_tasks
      @repository.get_tasks
    end

    # method to search for a person by its id
    # @param [Integer] id the provided person id
    # @return [Person | nil] the person if found or nil
    def find_person_by_id(id)
      @repository.find_person_by_id(id)
    end

    # method to search for a person by its id
    # @param [Integer] id the provided task id
    # @return [Task] the task with the given id
    def find_task_to_id(id)
      @repository.find_task_to_id(id)
    end

    # method to search for all tasks associated
    # @param [Integer] id the provided person id
    # @return [Array] the tasks of the person with the given id
    def get_tasks_to_person(id)
      @repository.get_tasks_to_person(id)
    end

    # method to add a person to the transient storage
    # @param [Person] person the person that be added
    def add_person(person)
      @repository.add_person(person)
      nil
    end

    # method to add a task for a person to the transient storage
    # @param [Integer] person_id the provided person id
    # @param [Task] task the task that should be added
    def add_task_to_person(person_id, task)
      @repository.add_task_to_person(person_id, task)
      nil
    end

    private

    # @return [DataRepository] the repository
    attr_reader :repository

    # method to load the content into the repository from the path
    # specified by the filename and based on the used adapter
    # @raise [IOError] if an error occurs during the loading process
    def prepare_data
      begin
        @repository = FileReader.read_file(filename)
        initialize_id_generators
        nil
      rescue StandardError => e
        raise IOError,
              " An Error occurred while loading the database: #{e.message}".red
      end
    end

    # method to initialize the required id generators
    def initialize_id_generators
      Person::PersonIDGenerator.new(@repository.max_person_id)
      Task::TaskIDGenerator.new(@repository.max_task_id)
      nil
    end

  end

end
