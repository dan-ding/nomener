#-- encoding: UTF-8
require 'nomener/parser'

module Nomener
  # name class for general purposes
  class Name < Struct.new :title, :first, :middle, :nick, :last, :suffix
    # we don't want to change what we were instantiated with
    attr_reader :original

    # Public: Create an instance!
    def initialize(nomen = '')
      return @original = '' unless nomen.is_a?(String)
      @original = Cleaner.reformat nomen
      parse
    end

    # Public: Break down a string into parts of a persons name
    #   As of 0.2.5 parse no longer needs to be called after initialization,
    #   it's done automatically. Recalling it doesn't hurt though.
    #
    # name - A string of name to parse
    #
    # Returns self populated with name or empty
    def parse
      parsed = Parser.parse(@original.dup)
      merge(parsed) unless parsed.nil?
      self
    end

    # Public: make the name proper case-like, suffix and nickname ignored
    #
    # Returns a string of the full name in a proper (western) case
    def properlike
      [capit(title),
        capit(first),
        (nick.to_s.empty? ? '' : "#{Nomener.config.left}#{nick}#{Nomener.config.right}"),
        capit(middle),
        capit(last),
        suffix
      ].join(' ').strip.squeeze ' '
    end

    # Internal: try to capitalize names including tough ones like Mac and Mc and D' and such
    #
    # nomen - string of the name to capitalize
    #
    # Returns a string of the capitalized name
    def capit(nomen)
      # if there are multiple names separated by a dash
      fix = nomen.to_s.dup.split('-').map do |outer|
        outer.split(' ').map(&:capitalize).join ' '
      end.join '-'

      # anything begining with Mac and not ending in [aciozj], except for a few
      fix.sub!(/Mac(?!
        hin|hlen|
        har|
        kle|
        klin|
        kie|
        hado|     # Portugese
        evicius|  # Lithuanian
        iulis|    # Lithuanian
        ias       # Lithuanian
      )([\p{Alpha}]{2,}[^aAcCiIoOzZjJ])\b/x) { "Mac#{$1.capitalize}" }

      fix.sub!(/\bMacmurdo\b/, 'MacMurdo') # fix MacMurdo

      # anything beginning with Mc, Mcdonald == McDonald
      fix.sub!(/Mc(\p{Alpha}{2,})/) { |s| "Mc#{s[2..-1].capitalize}" }

      # names like D'Angelo or Van 't Hooft, no cap 't
      fix.gsub!(/('\p{Alpha})(?=\p{Alpha})/) { |s| "'#{s[(1..-1)].capitalize}" }

      fix
    end

    # Public: Make inspect ... informative
    #
    # Returns a nicely formatted string
    def inspect
      "#<Nomener::Name #{
        each_pair.map { |k, v| [k, v.inspect].join('=') unless v.to_s.empty? }
        .compact
        .join(' ') }>"
    end

    # Public: an alias for the last name
    #
    # Returns a string of the last name
    def surname
      last
    end
    alias_method :family, :surname

    # Public: Return the first name
    #
    # Returns a string of the first name
    def given
      first
    end

    # Public: Make the name a string.
    #
    # format - a string using symbols for the format of the name to return
    #   defaults to "%f %l"
    #     %f -> first name
    #     %l -> last/surname/family name
    #     %m -> middle name
    #     %n -> nick name
    #     %m -> middle name
    #     %s -> suffix
    #     %t -> title/prefix
    #
    # propercase - boolean on whether to (try to) fix the case of the name
    #   defaults to true
    #
    # Returns the name as a string
    def name(format = '%f %l', _propercase = true)
      nomen = to_h
      nomen[:nick] = (nick.nil? || nick.empty?) ? '' : "\"#{nick}\""

      format = format.gsub(/%[flmnst]/,
        '%f' => '%{first}', '%l' => '%{last}', '%m' => '%{middle}',
        '%n' => '%{nick}', '%s' => '%{suffix}', '%t' => '%{title}'
      )
      (format % nomen).strip.squeeze ' '
    end

    # Public: Shortcut for name format
    #   can also be called by the method fullname
    #
    # Returns the full name
    def full
      name Nomener.config.format
    end
    alias_method :fullname, :full

    # Public: See name
    #
    # Returns the name as a string
    def to_s
      name '%f %l'
    end

    # Internal: merge another Nomener::Name to this one
    #
    # other - hash to merge into self
    #
    # Returns nothing
    def merge(other)
      return self unless other.is_a?(Hash)
      each_pair { |k, _| self[k] = other[k] }
    end

    # Public: return self as a hash. For ruby 1.9.3
    #
    # Returns a hash of the name parts
    def to_h
      Hash[each_pair.to_a]
    end unless method_defined?(:to_h)
  end
end
