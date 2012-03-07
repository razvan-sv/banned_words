require "banned_words/storage"

module Core

  REGEX = "[^a-zA-Z0-9]*"

  def create!(word) 
    
    ensure_yaml_file!   
    word = word.downcase.strip
    
    if regexed_word = word_to_regex(word)
      bw_file       = YAML.load_file(Storage::FileStore.file_path) || {}      
      bw_file[word] = regexed_word
      File.open(Storage::FileStore.file_path, 'w+') { |f| YAML.dump(bw_file, f) }     
    end

    regexed_word
  end

  def verify(text, replace_with = "*Buzz*")
    # Don't bother verifying if the text isn't present
    return nil unless text.present?

    if banned_words = YAML.load_file(Storage::FileStore.file_path)
      bw = banned_words.values.join("|")
      text.gsub!(/#{bw}/i, replace_with)      
    end
    
    text    
  end

  # TODO
  def list
    true
  end

  def clear
    if File.exists?(Storage::FileStore.file_path)
      File.open(Storage::FileStore.file_path, "w+") { |f| YAML.dump(nil, f) }
    end

    true
  end

  

private

  def ensure_yaml_file!   
    unless File.exists?(Storage::FileStore.file_path)
      File.open(Storage::FileStore.file_path, "w+") { |f| YAML.dump(nil, f) }
    end
  end

  def word_to_regex(word)
    # Don't bother processing if the word isn't present
    return nil if word.blank? || word[" "]
    
    regexed_word = ""
    word.chars.each_with_index do |char, i|
      regexed_word += char
      # Don't attach the regex after the last char.
      regexed_word += REGEX if i < word.size - 1
    end     

    regexed_word
  end

end