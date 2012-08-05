# Banned Words
Detects and masks banned words within a text

[![Build Status](https://secure.travis-ci.org/razvan-sv/banned_words.png?branch=master)](http://travis-ci.org/razvan-sv/banned_words)

## Installation

Add this line in your Gemfile:

```ruby
gem 'banned_words'
```
Then you need to run:

```ruby
rails g banned_words
```
to generate the banned_words.yml file.

## Usage

### Masking
```ruby
# Single banned word
BannedWords.create!('dog')
phrase = 'Red d-o-g'
BannedWords.mask(phrase)
> 'Red *Buzz*'

# With an array of banned words
BannedWords.create!(['fox', 'over'])
phrase = 'The quick brown fox jumps over the lazy dog'
BannedWords.mask(phrase)
> 'The quick brown *Buzz* jumps *Buzz* the lazy *Buzz*'

# Override the masking word
BannedWords.mask(phrase, "*Bad Word*")
> 'The quick brown *Bad Word* jumps *Bad Word* the lazy *Bad Word*'
```

### Detecting
```ruby
BannedWords.create!(['quick', 'jumps'])
phrase = 'The q-u#-_^i!c~k brown fox j=u m p?s over the lazy dog'
BannedWords.detect(phrase)
> ['q-u#-_^i!c~k', 'j=u m p?s']
```

### Listing
```ruby
BannedWords.list
> ['dog', 'fox', 'over']
```

### Removing
```ruby
BannedWords.remove('dog')
BannedWords.list
> ['fox', 'over']

# Another example:
BannedWords.remove(['fox', 'over'])
BannedWords.list
> []
```

## Copyright

See LICENSE for details.