# Banned Words
Detects and masks banned words within a text

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
BannedWords.create!('dog')
phrase = 'Red d-o-g'
BannedWords.mask(phrase)
> 'Red *Buzz*'

# Another example:
BannedWords.create!(['fox', 'over'])
phrase = 'The quick brown fox jumps over the lazy dog'
BannedWords.mask(phrase)
> 'The quick brown *Buzz* jumps *Buzz* the lazy *Buzz*'
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