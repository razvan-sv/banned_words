module Storage
  module FileStore
    extend self

    #
    # Retruns the path to where the banned words file source is/should be located.
    #
    def file_path
      "#{Rails.root}/lib/banned_words.yml"
    end

    #
    # Returns true if the banned_words.yml file exisits, false otherwise
    #
    def storage_exists?
      File.exists?(file_path)
    end

    #
    # Write new data to storage. The supplied hash value will overwrite the
    # exising data from the storage.
    #
    # ==== Parameters
    #
    # value<Hash>::
    #   Ex: {:banned_word_1 => "bw_regex_1", :banned_word_2 => "bw_regex_2"}
    #
    def write_to_storage(value = nil)
      File.open(file_path, "w+") do |file|
        YAML.dump(value, file)
      end
    end

    #
    # Returns a hash containing the banned words along with their regexes.
    # If no banned words are present the returned hash is empty.
    #
    def load_storage
      YAML.load_file(file_path) || {}
    end

    #
    # Returns an array containing the banned words.
    # If no banned words are present the returned array is empty.
    #
    def list_contents
      list = load_storage
      list.is_a?(Hash) ? list.keys.sort : [list]
    end

    #
    # Returns an array containing the banned words if the storage file exists.
    # Otherwise an error is raised.
    #
    def list_contents!
      if storage_exists?
        list_contents
      else
        raise IOError, "No banned words file!"
      end
    end

    #
    # Clear the storage.
    #
    def empty_storage
      write_to_storage
    end
    alias_method :new_storage, :empty_storage

    #
    # Clear storage file if it exists.
    # Otherwise an error is raised.
    #
    def empty_storage!
      if storage_exists?
        empty_storage
      else
        raise IOError, "No banned words file!"
      end
    end

    #
    # Creates the storage file if it's not present
    #
    def ensure_storage_file
      new_storage if !storage_exists?
    end

    #
    # Mostly used in specs
    #
    def remove_storage_file
      FileUtils.rm(file_path)
    end
  end
end