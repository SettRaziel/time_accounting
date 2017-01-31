# @Author: Benjamin Held
# @Date:   2017-01-29 09:22:11
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-31 17:48:50

module Menu

  # menu class to select the storage adapter that should be used
  class AdapterMenu < Base

    # initialization
    def initialize(filename)
      super
      @menu_description = "\nSelect database adapter:"
      @filename = filename
    end

    private

    # @return [String] the storage path
    attr_reader :filename

    # method to define all printable menu items
    def define_menu_items
      add_menu_item('File storage.', 1)
      add_menu_item('Sqlite3.', 2)
    end

    # method to process the provided input
    # @param [String] input the provided input
    # @return [Boolean] true: if the program should continue,
    #    false: if the script should exit
    def determine_action(input)
      case (input.to_i)
        when 1 then set_data_handler(DataHandler::FileHandler.new(@filename))
        when 2 then set_data_handler(DataHandler::SqliteHandler.new(@filename))
      else
        handle_wrong_option
      end
      false
    end

    # method to set the selected data handler
    # @param[DataHandler::BaseHandler] data_handler the select storage handler
    def set_data_handler(data_handler)
      Menu.initialize_datahandler(data_handler)
      nil
    end

  end

end
