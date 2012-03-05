class BannedWordsGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
 
  def copy_banned_words_yaml_file  	
    copy_file "banned_words.yml", "lib/banned_words.yml"
  end
end
