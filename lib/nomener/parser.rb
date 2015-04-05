require "nomener/name"
require "nomener/titles"
require "nomener/suffixes"
require "nomener/compounders"

module Nomener
  class Parser
    include Nomener::Titles
    include Nomener::Suffixes
    include Nomener::Compounders

    # Public: parse a string into name parts
    #
    # name - a string to get the name from
    # format - a hash of options to parse name (default {:order => :fl, :spacelimit => 0})
    #   :order - format the name. defaults to "last first" of the available
    #     :fl - presumes the name is in the format of "first last"
    #     :lf - presumes the name is in the format of "last first"
    #     :lcf - presumes the name is in the format of "last, first"
    #   :spacelimit - the number of spaces to consider in the first name
    #
    # Returns a Nomener::Name object hopefully a parsed name of the string or nil
    def self.parse(name, format = {:order => :fl, :spacelimit => 0})
      begin
        self.parse!(name, format)
      rescue
        nil
      end
    end

    # Public: parse a string into name parts
    #
    # name - string to parse a name from
    # format - has of options to parse name. See parse()
    #
    # Returns a hash of name parts or nil
    # Raises ArgumentError if 'name' is not a string or is empty
    def self.parse!(name, format = {:order => :fl, :spacelimit => 1})
      raise ArgumentError, 'Name to parse not provided' unless (name.kind_of?(String) && !name.empty?)

      name.scrub! #remove illegal characters
      name.gsub!(/[^\p{Alpha}\-\'\.&\/ \,\"]/, "") #what others are in a name
      name.gsub!(/\p{Blank}+/, " ") #compress whitespace
      name.strip! #trim space

      title = self.parse_title(name)
      suffix = self.parse_suffix(name)
      nick = self.parse_nick(name)
      last = self.parse_last(name, format[:order])
      first, middle = self.parse_first(name, format[:spacelimit])

      {
        :title => title,
        :suffix => suffix,
        :nick => nick,
        :first => first,
        :last => last,
        :middle => middle
      }
    end

    # Internal: pull off a title if we can
    #
    # nm - string of the name to parse
    #
    # Returns string of the title found or and empty string
    def self.parse_title(nm)
      title = ""
      if m = TITLES.match(nm)
        title = m[1].strip
        nm.sub!(title, "").strip!
        title.gsub!('.', '')
      end
      title
    end

    # Internal: pull off what suffixes we can
    #
    # nm - string of the name to parse
    #
    # Returns string of the suffixes found or and empty string
    def self.parse_suffix(nm)
      suffixes = []
      suffixes = nm.scan(SUFFIXES).flatten
      suffixes.each { |s|
        nm.gsub!(/#{s}/, "").strip!
        s.strip!
      }
      suffixes.join " "
    end

    # Internal: parse nickname out of string. presuming it's in quotes
    #
    # nm - string of the name to parse
    #
    # Returns string of the nickname found or and empty string
    def self.parse_nick(nm)
      nicks = []
      nicks = nm.scan(/([\(\"][\p{Alpha}\-\ ']+[\)\"])/).flatten
      nicks.each { |n|
        nm.gsub!(/#{n}/, "").strip!
        n.gsub!(/["\(\)]/, ' ')
      }
      nicks.join(" ").strip
    end

    # Internal: parse last name from string
    #
    # nm - string to get the last name from
    # format - symbol defaulting to "first last". See parse()
    #
    # Returns string of the last name found or an empty string
    def self.parse_last(nm, format = :fl)
      last = ''
      if format == :fl && n = nm.match(/\p{Blank}(?<fam>#{COMPOUNDS}[\p{L}\-\']+)\z/i)
        last = n[:fam]
        nm.sub!(last, "").strip!
      elsif format == :lf && n = nm.match(/\A(?<fam>#{COMPOUNDS}[\p{Alpha}\-\']+)\p{Blank}/i)
        last = n[:fam]
        nm.sub!(last, "").strip!
      elsif format == :lcf && n = nm.match(/\A(?<fam>#{COMPOUNDS}[\p{Alpha}\-\'\p{Blank}]+),/i)
        last = n[:fam]
        nm.sub!(last, "").strip!
        nm.sub!(',', "").strip!
      end
      last
    end

    # Internal: parse the first name, and middle name if any
    #
    # nm - the string to get the first name from
    # namecount - the number of spaces in the first name to consider
    #
    # Returns an array containing the first name and middle name if any
    def self.parse_first(nm, namecount = 0)
      nm.tr! '.', ' '
      first, middle = nm.split ' ', namecount

      [first || "", middle || ""]
    end

  end
end