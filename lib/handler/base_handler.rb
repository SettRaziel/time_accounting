# @Author: Benjamin Held
# @Date:   2016-11-19 15:59:49
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-11-20 18:25:40

module DataHander

  # This class serves as a abstract parent class to take care about the
  # initialization of the repositories and the id generator. This class also
  # provides abstract methods to save and load data from and to a repository
  # which are implemented by child classes.
  class BaseHandler
    # @return [DataRepository] the repository
    attr_reader :repository
    # @return [String] the file name
    attr_reader :filename

    # initialization
    # @param [String] filename the filename from where the data should be loaded
    #   or to where the data should be saved
    # @param [DataRepository] repository the repository for the data
    def initialize(filename)
      @repository=DataRepository.new()
      @filename = filename
      Person::PersonIDGenerator.new(@repository.max_person_id)
      Task::TaskIDGenerator.new(@repository.max_task_id)
    end

    # @abstract method to load the content into the repository from the path
    # specified by {#filename} and based on the used adapter
    # @raise [NotImplementedError] if the subclass does not have this method
    def load_repository
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        load_repository from its base class".red
    end

    # @abstract method to save the content of the repository to the path
    # specified by {#filename} and based on the used adapter
    # @raise [NotImplementedError] if the subclass does not have this method
    def save_repository
      fail NotImplementedError, " Error: the subclass
        #{self.name.split('::').last} needs to implement the method:
        save_repository from its base class".red
    end

  end

end
