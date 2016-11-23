# @Author: Benjamin Held
# @Date:   2016-11-19 15:50:14
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-11-23 18:23:07

module DataHander

  # This class serves as a handler between the repositories and the queries. It
  # also takes care about the initialization of the repositories and the id
  # generators. The handler also provides methods to save and load data from and
  # to a repository.
  class FileHandler

    # initialization
    # @param [String] filename the filename from where the data should be loaded
    #   or to where the data should be saved
    def initialize(filename)
      super(filename)
    end

    # method to load the content into the repository from the path
    # specified by the filename and based on the used adapter
    # @raise [IOError] if an error occurs during the loading process
    def load_repository
      begin
        @repository = FileReader.read_file(filename)
        nil
      rescue StandardError => e
        raise IOError,
              " An Error occurred while loading the database: #{e.message}".red
      end
    end

    # method to save the content of the repository to the path
    # specified by the filename and based on the used adapter
    def save_repository
      writer = FileWriter.new(filename)
      writer.write_all_persons(@repository.repository.keys)
      writer.write_all_tasks(@repository.repository)
      nil
    end

  end

end
