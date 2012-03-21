# Banned Words

## Installation

Add this line in your Gemfile:

  gem "banned_words"

## Usage

```ruby
BannedWords.create!("dog")
phrase = "The quick brown fox jumps over the lazy dog"
BannedWords.mask(phrase)
=> "The quick brown fox jumps over the lazy \*Buzz\*"

#Another example:
phrase = "Red d-o-g"
BannedWords.mask(phrase)
=> "Red \*Buzz\*"
```