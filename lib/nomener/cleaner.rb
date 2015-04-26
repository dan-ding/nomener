#-- encoding: UTF-8

# For Ruby 1.9.3, 2.0.0
rv = RUBY_VERSION.split('.')[(0..1)].join('')
require 'string-scrub' if rv >= '19' && rv < '21'

module Nomener
  # Module with helper functions to clean strings
  #
  #   Currently exposes
  #   .reformat
  #   .cleanup!
  #   .dustoff
  #
  module Cleaner
    # Allowable characters in a name after quotes have been reduced
    @@allowable = nil

    # regex for stuff at the end we want to get out
    TRAILER_TRASH = /[,|\s]+$/

    # regex for name characters we aren't going to use
    DIRTY_STUFF = /[^,'\-(?:\p{Alpha}(?<\.))\p{Alpha}\p{Blank}]/

    # Internal: Clean up a given string. Quotes from http://en.wikipedia.org/wiki/Quotation_mark
    #  Needs to be fixed up for matching and non-english quotes
    #
    # name - the string to clean
    #
    # Returns a string which is (ideally) pretty much the same as it was given.
    def self.reformat(name)
      @@allowable = %r![^\p{Alpha}\-&\/\ \.\,\'\"\(\)
        #{Nomener.config.left}
        #{Nomener.config.right}
        #{Nomener.config.single}
        ] !x unless @@allowable

      # remove illegal characters, translate fullwidth down
      nomen = name.dup.scrub.tr("\uFF02\uFF07", "\u0022\u0027")

      nomen = replace_doubles(nomen)
      replace_singles(nomen)
        .gsub(/@@allowable/, ' ')
        .squeeze(' ')
        .strip
    end

    # Internal: Clean up a string where there are numerous consecutive and
    #   trailing non-name characters.
    #   Modifies given string in place.
    #
    # args - strings to clean up
    #
    # Returns nothing
    def self.cleanup!(*args)
      args.each do |dirty|
        next unless dirty.is_a?(String)

        dirty.gsub! DIRTY_STUFF, ' '
        dirty.squeeze! ' '
        # remove any trailing commas or whitespace
        dirty.gsub! TRAILER_TRASH, ''
        dirty.strip!
      end
    end

    # Internal: Replace various double quote characters with given char
    #
    # str - the string to find replacements in
    #
    # Returns the string with the quotes replaced
    def self.replace_doubles(str)
      left, right = [Nomener.config.left, Nomener.config.right]

      # replace left and right double quotes
      str.tr("\u0022\u00AB\u201C\u201E\u2036\u300E\u301D\u301F\uFE43", left)
        .tr("\u0022\u00BB\u201D\u201F\u2033\u300F\u301E\uFE44", right)
    end
    private_class_method :replace_doubles

    # Internal: Replace various single quote characters with given chars
    #
    # str - the string to find replacements in
    #
    # Returns the string with the quotes replaced
    def self.replace_singles(str)

      # replace left and right single quotes
      str.tr("\u0027\u2018\u201A\u2035\u2039\u300C\uFE41\uFF62", Nomener.config.single)
        .tr("\u0027\u2019\u201B\u2032\u203A\u300D\uFE42\uFF62", Nomener.config.single)
    end
    private_class_method :replace_singles

    # Internal: Get the quotes from a string
    #  Currently unused. To Be Removed.
    #
    # str - the string of two characters for the left and right quotes
    #
    # Returns an array of the [left, right] quotes
    def self.quotes_from(str = '""')
      left, right = str.split(/\B/)
      right = left unless right
      [left, right]
    end
    private_class_method :quotes_from
  end
end
