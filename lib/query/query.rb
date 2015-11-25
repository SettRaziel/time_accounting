# @Author: Benjamin Held
# @Date:   2015-08-24 12:53:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-25 20:01:20

# this module holds the classes and methods for queries regarding the data
module Query

  # dummy class to get access to the data from methods within the module
  class << self
    # @return [DataRepository] the database with the {Task}s and {Person}s
    attr :data
  end

  # singleton method to initialize the data repository with the provided data
  # @param [DataRepository] data the created database
  def self.initialize_repository(data)
    @data = data
  end

end
