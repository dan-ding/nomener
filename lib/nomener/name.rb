#-- encoding: UTF-8
require "nomener/parser"

module Nomener
  class Name < Struct.new :title, :first, :middle, :nick, :last, :suffix

    # we don't want to change what we were instantiated with
    attr_reader :original

    # Public: Create an instance!
    def initialize(nomen = '')
      @original = ""
      if nomen.kind_of?(String)
        @original = Nomener::Helper.reformat nomen
        parse
      end
    end

    # Public: Break down a string into parts of a persons name
    #   As of 0.2.5 parse no longer needs to be called after initialization, it's done automatically.
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
      f = (first || "").capitalize
      n = (nick.nil? || nick.empty?) ? "" : "\"#{nick}\""
      m = (middle || "").capitalize
      l = capit(last || "")
      t = (title || "").capitalize
      "#{t} #{f} #{n} #{m} #{l} #{suffix}".strip.gsub(/\p{Blank}+/, ' ')
    end

    # Internal: try to capitalize last names with Mac and Mc and D' and such
    #
    # last - string of the name to capitalize
    #
    # Returns a string of the capitalized name
    def capit(last)
      return "" if last.nil? || last.empty?

      fix = last.dup

      # if there are multiple last names separated by a dash
      fix = fix.split("-").map { |v|
        v.split(" ").map { |w| w.capitalize }.join " "
      }.join "-"

      # anything begining with Mac and not ending in [aciozj], except for a few
      fix.sub!(/Mac(?!
        hin|
        hlen|
        har|
        kle|
        klin|
        kie|
        hado|     # Portugese
        evicius|  # Lithuanian
        iulis|    # Lithuanian
        ias       # Lithuanian
      )([\p{Alpha}]{2,}[^aAcCiIoOzZjJ])\b/x) { |s| "Mac#{$1.capitalize}" }
      
      fix.sub! /\bMacmurdo\b/, "MacMurdo" # fix MacMurdo

      # anything beginning with Mc, Mcdonald == McDonald
      fix.sub!(/Mc(\p{Alpha}{2,})/) { |s| "Mc#{$1.capitalize}" }

      # names like D'Angelo or Van 't Hooft, no cap 't
      fix.gsub!(/('\p{Alpha})(?=\p{Alpha})/) { |s| "'#{$1[(1..-1)].capitalize}" }

      fix
    end

    # Public: Make inspect ... informative
    #
    # Returns a nicely formatted string
    def inspect
      "#<Nomener::Name #{each_pair.map { |k,v| [k,v.inspect].join('=') if (!v.nil? && !v.empty?) }.compact.join(' ')}>"
    end

    # Public: an alias for the last name
    #
    # Returns a string of the last name
    def surname
      last
    end
    alias :family :surname

    # Public: Return the first name
    #
    # Returns a string of the first name
    def given
      first
    end

    # Public: Make the name a string.
    #
    # format - a string using symboles specifying the format of the name to return
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
    def name(format = "%f %l", propercase = true)
      nomen = to_h
      nomen[:nick] = (nick.nil? || nick.empty?) ? "" : "\"#{nick}\""
      format.gsub! /\%f/, '%{first}'
      format.gsub! /\%l/, '%{last}'
      format.gsub! /\%m/, '%{middle}'
      format.gsub! /\%n/, '%{nick}'
      format.gsub! /\%s/, '%{suffix}'
      format.gsub! /\%t/, '%{title}'
      (format % nomen).strip.gsub /\p{Blank}+/, " "
    end

    # Public: Shortcut for name format
    #   can also be called by the method fullname
    #
    # Returns the full name
    def full
      name("%f %m %l")
    end
    alias :fullname :full

    # Public: See name
    #
    # Returns the name as a string
    def to_s
      name("%f %l")
    end

    # Internal: merge another Nomener::Name to this one
    #
    # other - hash to merge into self
    #
    # Returns nothing
    def merge(other)
      return self unless other.kind_of?(Hash)
      each_pair { |k, v| self[k] = other[k] }
    end

    # Public: return self as a hash. For ruby 1.9.3
    #
    # Returns a hash of the name parts
    def to_h
      Hash[self.each_pair.to_a]
    end unless method_defined?(:to_h)

  end
end