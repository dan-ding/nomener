# Nomener
[![Gem Version](https://badge.fury.io/rb/nomener.svg)](http://badge.fury.io/rb/nomener)

Nomener assists with parsing peoples names that they give themselves (or other people). Nomener is a fork of [People](https://github.com/dan-ding/people) as it uses some code contributed there. It's currently geared towards western style name formatting, however other cultural name formatting is (or would like to be supported).Currently it attempts to parse names through pattern matching without using dictionary/library/data files (except for name decorations and suffixes, see usage). It may not be possible to do without such in all languages.

If you didn't know, parsing names can be much more difficult than it seems it should be.

## Requirements

Requires Ruby 2.1 or higher (or equivalent).
To use with 1.9 or 2.0 you'll need to install either [https://github.com/hsbt/string-scrub](string-scrub) or [https://github.com/jrochkind/scrub_rb](scrub_rb).

## Installation

Add this line to your application's Gemfile:

    gem 'nomener'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nomener

## Basic Usage

Use Nomener directly:
```ruby
name = Nomener.parse "Joe Smith" # <Nomener::Name first="Joe" last="Smith">
```

Create a new instance:
```ruby
name = Nomener::Name.new "Joe Smith" # <Nomener::Name >
name.parse                           # <Nomener::Name first="Joe" last="Smith">
name.first                           # Joe
name.name                            # Joe Smith
"Hi #{name}!"                        # Hi Joe Smith!
```

## TODO
* optionally use web service api data to assist (and create the web service!)
* fantasy prefixes/suffixes
* multiple names from one string
* specifying formats to parse by
* many other things
* better non-english support

## References
* [http://en.wikipedia.org/wiki/Personal_name](http://en.wikipedia.org/wiki/Personal_name)
* [http://en.wikipedia.org/wiki/Surname](http://en.wikipedia.org/wiki/Surname)
* [http://en.wikipedia.org/wiki/Title](http://en.wikipedia.org/wiki/Title)
* [http://www.w3.org/International/questions/qa-personal-names](http://www.w3.org/International/questions/qa-personal-names)
* [http://heraldry.sca.org/titles.html](http://heraldry.sca.org/titles.html)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nomener/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Ensure adequate tests (rspec) on your branch
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Other similar projects (and inspiration)
* [People](https://github.com/dan-ding/people) [Original](https://github.com/mericson/people)
* [Namae](https://github.com/berkmancenter/namae) (Racc based token)
* [Nameable](https://github.com/chorn/nameable)
* [Person-name](https://github.com/matthijsgroen/person-name)

