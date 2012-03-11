module Storage
  module FileStore
    extend self
    
    def file_path
      "#{Rails.root}/lib/banned_words.yml"
    end

    def storage_exists?
      File.exists?(Storage::FileStore.file_path)
    end

    def write_to_storage(value)
      File.open(Storage::FileStore.file_path, "w+") do |file|
        YAML.dump(value, file)
      end
    end

    def empty_storage
      write_to_storage(nil)
    end

    def load_storage
      YAML.load_file(file_path) || {}
    end

    def list_contents!
      if storage_exists?
        load_storage
      else
        raise IOError, "No banned words file!"
      end
    end

    def clear_storage!
      if storage_exists?
        empty_storage
      else
        raise IOError, "No banned words file!"
      end
    end
  end
end