require "banned_words/storage"

module Core

  BW_REGEX = "[^a-zA-Z0-9]*"

  #
  # Create a banned word. The supplied word is transformed into a banned word
  # and stored into the storage file. The banned word is returned.
  #
  # ==== Parameters
  #
  # word<String>::
  #    Contains no more than a word.
  #    Returns nil if the word failed to be converted into a banned word.
  #
  def create!(word)

    Storage::FileStore.ensure_storage_file
    word = word.downcase.strip

    if regexed_word = word_to_regex(word)
      bw_file       = Storage::FileStore.load_storage
      bw_file[word] = regexed_word
      Storage::FileStore.write_to_storage(bw_file)
    end

    regexed_word
  end

  #
  # Masks the banned words within supplied text.
  # Returns the changed text. If no banned words are found then the initial text is returned.
  #
  # ==== Parameters
  #
  # text<String>::
  #   The text which is checked for banned words.
  # replace_with<String>::
  #   The word which replaces the banned words. It defaults to *Buzz*.
  #
  def mask(text, replace_with = "*Buzz*")
    # Don't bother verifying if the text isn't present
    return nil unless text.present?

    if banned_words = YAML.load_file(Storage::FileStore.file_path)
      bw = banned_words.values.join("|")
      text.gsub!(/#{bw}/i, replace_with)
    end

    text
  end

  #
  # List the banned words. If the storage file isn't found an error is raised.
  #
  def list
    Storage::FileStore.list_contents!
  end

  #
  # Removes all banned words. If the storage file isn't found an error is raised.
  #
  def clear
    Storage::FileStore.empty_storage!
  end

  private
  
  #
  # Transforms the word into a banned word. The BW_REGEX gets attached between every char.
  #
  def word_to_regex(word)
    # Don't bother processing if the word isn't present or has more than one word
    return nil if word.blank? || word[" "]

    regexed_word = ""
    word.chars.each_with_index do |char, i|
      regexed_word += char
      # Don't attach the regex after the last char.
      regexed_word += BW_REGEX if i < word.size - 1
    end

    regexed_word
  end

end