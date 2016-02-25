# @Author: Benjamin Held
# @Date:   2015-08-27 11:42:38
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-24 18:25:10

require_relative '../data/data_repository'
require_relative '../entity/person/person'
require_relative '../entity/task'
require_relative '../data/file_storage/file_reader'
require_relative '../data/file_storage/file_writer'

# This class serves as a handler between the repositories and the queries. It
# also takes care about the initialization of the repositories and the id
# generators. The handler also provides methods to save and load data from and
# to a repository.
class DataHandler
  # @return [DataRepository] the repository
  attr_reader :repository
  # @return [String] the file name
  attr_reader :filename

  # initialization
  # @param [String] filename the filename from where the data should be loaded
  #   or to where the data should be saved
  # @param [DataRepository] repository the repository for the data
  def initialize(filename, repository=DataRepository.new())
    @repository = repository
    @filename = filename
    Person::PersonIDGenerator.new(@repository.max_person_id)
    Task::TaskIDGenerator.new(@repository.max_task_id)
  end

  # method to save the content of the repository to the file specified by
  # {#filename}
  def save_repository()
    writer = FileWriter.new(filename)
    writer.write_all_persons(@repository.repository.keys)
    writer.write_all_tasks(@repository.repository)
  end

  # singleton method to read data from a file and initialize a new data handler
  # @param [String] filename the filename from where the data should be loaded
  #   or to where the data should be saved
  # @return [DataHandler] a new instance of the data handler initializes with
  #   the content of the file
  def self.load_database(filename)
    begin
      repo = FileReader.read_file(filename)
      DataHandler.new(filename, repo)
    rescue Exception => e
      raise IOError, " Error: File #{filename} does not exist.".red
    end
  end

end
