module Storage
  module FileStore
    def self.file_path
      "#{Rails.root}/lib/banned_words.yml"
    end
  end
end