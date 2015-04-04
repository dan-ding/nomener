require "nomener/parser"

module Nomener
  class Name < Struct.new :title, :first, :middle, :nick, :last, :suffix

    @original = ""

    # Public: Create an instance!
    def initialize(name = '')
      @original = name
    end

    # Public: get the name we were instantiated with
    #
    # Returns a string we were instantiated with
    def original
      @original
    end

    # Public: Break down a string into parts of a persons name
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
      n = ("\"#{nick}\"" || "")
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

      # if there are multiple last names separated by spaces
      fix = fix.split(" ").map { |v| v.capitalize || v }.join " "

      # if there are multiple last names separated by a dash
      fix = fix.split("-").map { |v| v.capitalize || v }.join "-"

      # anything begining with Mac and not ending in [aciozj]
      if m = fix.match(/Mac([\p{Alpha}]{2,}[^aciozj])/i)
        unless m[1].match(%r!^
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
        !x)
          fix.sub!(/Mac#{m[1]}/, "Mac#{m[1].capitalize}")
        end
      elsif m = fix.match(/Mc([\p{Alpha}]{2,})/i) # anything beginning with Mc
        fix.sub!(/Mc#{m[1]}/, "Mc#{m[1].capitalize}")
      elsif fix.match(/Macmurdo/i) # exception of MacMurdo
        fix = "MacMurdo"
      elsif fix.match(/'\p{Alpha}/) # names like D'Angelo or Van 't Hooft
        fix.gsub!(/('\p{Alpha})/) { |s| (s[2] != 't') ? s.upcase : s } #no cap 't
      end

      fix
    end

    # Public: Make inspect ... informative
    #
    # Returns a nicely formatted string
    def inspect
      "#<Nomener::Name #{each_pair.map { |k,v| [k,v.inspect].join('=') if v }.compact.join(' ')}>"
    end

    # Public: Make the full name as a string.
    #
    # Returns the full name same case as the original
    def full
      n = (nick.nil? || nick.empty?) ? "" : "\"#{nick}\""
      "#{title} #{first} #{n} #{middle} #{last} #{suffix}".gsub(/\p{Blank}+/, ' ').strip
    end

    # Public: See full
    def to_s
      full
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

  end
end