#-- encoding: UTF-8

# For Ruby 1.9.3, 2.0.0
rv = RUBY_VERSION.split(".")[(0..1)].join("")
require "string-scrub" if(rv >= '19' && rv < '21')

module Nomener
  module Helper

    # Internal: Clean up a given string. Quotes from http://en.wikipedia.org/wiki/Quotation_mark
    #  Needs to be fixed up for matching and non-english quotes
    #
    # name - the string to clean
    # leftleft - the left double quote to use when replacing others
    # rightright - the right double quote to use when replacing others
    # left - the single left quote to use when replacing others
    # right - the single left quote to use when replacing others
    #
    # Returns a string which is (ideally) pretty much the same as it was given.
    def self.reformat(name, leftleft = '"', rightright = '"', left = "'", right = "'")
      nomen = name.dup
      nomen.scrub! # remove illegal characters

      # translate fullwidth to typewriter
      nomen.tr!("\uFF02\uFF07", "\u0022\u0027")

      nomen.tr!("\u0022\u00AB\u201C\u201E\u2036\u300E\u301D\u301F\uFE43", leftleft) # replace left double quotes
      nomen.tr!("\u0022\u00BB\u201D\u201F\u2033\u300F\u301E\uFE44", rightright) # replace right double quotes

      nomen.tr!("\u0027\u2018\u201A\u2035\u2039\u300C\uFE41\uFF62", left) # replace left single quotes
      nomen.tr!("\u0027\u2019\u201B\u2032\u203A\u300D\uFE42\uFF62", right) # replace left single quotes

      nomen.gsub!(/[^\p{Alpha}\-&\/ \.\,\'\"#{leftleft}#{rightright}#{left}#{right}\(\)]/, " ") # what others may be in a name?
      nomen.squeeze! " "
      nomen.strip!

      nomen
    end

  end
end
