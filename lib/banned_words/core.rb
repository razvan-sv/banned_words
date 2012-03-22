require "banned_words/storage"

module Core

  BW_REGEX = "[^a-zA-Z0-9]*"

  #
  # Create banned words. The supplied words are transformed into a banned words
  # and stored into the storage file. An array of banned words is returned.
  #
  # ==== Parameters
  #
  # words<String> or <Array>::
  #    Contains a word or an array of words. The words should not contain spaces.
  #
  def create!(words)

    Storage::FileStore.ensure_storage_file
    words = [words] unless words.is_a? Array
    regexed_words = []

    if words.present?
      bw_file       = Storage::FileStore.load_storage
      words.each do |word|
        if regexed_word = word_to_regex(word)
          bw_file[word] = regexed_word
          regexed_words << regexed_word
        end
      end
      Storage::FileStore.write_to_storage(bw_file)
    end

    regexed_words
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

  #
  # Removes the supplied banned words from the list.
  #
  # ==== Parameters
  #
  # words<String> or <Array>::
  #    Contains a word or an array of words.
  #
  def remove(words)
    words = [words] unless words.is_a? Array

    if (bw_list = Storage::FileStore.load_storage).present?
      new_bw = bw_list.reject { |name, regexed_name| words.include?(name) }
      Storage::FileStore.write_to_storage(new_bw) if new_bw != bw_list
    end
  end

  ## TODO
  #def verify(text)
  #
  #end

  private

  #
  # Transforms the word into a banned word. The BW_REGEX gets attached between every char.
  #
  def word_to_regex(word)
    # Don't bother processing if the word isn't present or has more than one word
    return nil if word.blank? || word[" "]

    regexed_word = ""
    word = word.downcase.strip
    word.chars.each_with_index do |char, i|
      regexed_word += char
      # Don't attach the regex after the last char.
      regexed_word += BW_REGEX if i < word.size - 1
    end

    regexed_word
  end

end