#-- encoding: UTF-8
require "nomener/name"
require "nomener/titles"
require "nomener/suffixes"
require "nomener/compounders"
require "nomener/helper"

module Nomener
  class Parser
    include Nomener::Titles
    include Nomener::Suffixes
    include Nomener::Compounders

    # regex for stuff at the end we want to get out
    TRAILER_TRASH = /[,|\s]+$/

    # regex for name characters we aren't going to use
    DIRTY_STUFF = /[^,'(?:\p{Alpha}(?<\.))\p{Alpha}\p{Blank}]{2,}/

    # regex for boundaries we'll use to find leftover nickname boundaries
    NICKNAME_LEFTOVER = /["'\(\)]{2}/

    # regex for matching enclosed nicknames
    NICKNAME = /(?<=["'\(])([\p{Alpha}\-\ '\.\,]+?)(?=["'\)])/

    # regex for matching last names in a "first last" pattern
    FIRSTLAST_MATCHER = /\p{Blank}(?<fam>#{COMPOUNDS}[\p{Alpha}\-\']+)\Z/i

    # regex for matching last names in a "last first" pattern
    LASTFIRST_MATCHER = /\A(?<fam>#{COMPOUNDS}\b[\p{Alpha}\-\']+)\p{Blank}/i

    # regex for matching last names in a "last, first" pattern
    LASTCOMFIRST_MATCHER = /\A(?<fam>#{COMPOUNDS}\b[\p{Alpha}\-\'\p{Blank}]+),/i

    # period. probably not much performance help.
    PERIOD = /\./

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
    def self.parse(name, format = {:order => :auto, :spacelimit => 1})
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
    def self.parse!(name, format = {:order => :auto, :spacelimit => 0})
      raise ArgumentError, "Name to parse not provided" unless (name.kind_of?(String) && !name.empty?)

      name = Nomener::Helper.reformat name
      newname = { :title => "", :first => "", :nick => "", :middle => "", :last => "", :suffix => "" }

      # grab any identified nickname before working on the rest
      newname[:nick] = parse_nick! name
      name.sub! NICKNAME_LEFTOVER, ""
      cleanup! name

      # grab any suffix' we can find
      newname[:suffix] = parse_suffix! name
      cleanup! name

      newname[:title] = parse_title! name
      name = dustoff name

      newname[:last] = name # possibly mononyms

      
      case name
      when /,/ # if there's a comma, it may be a useful hint
        clues = name.split(",").each { |i| i.strip! }

        raise ParseError, "Could not decipher commas in \"#{name}\"" if clues.length > 2

        # convention is last, first when there's a comma
        newname[:last], newname[:first] = clues
        
        # check the last by comparing a re-ordering of the name
        # Mies van der Rohe, Ludwig
        # Snepscheut, Jan L. A. van de
        unless newname[:first].nil? || newname[:first].split(" ").length == 1
          check = parse_last!("#{newname[:first]} #{newname[:last]}", :fl)

          # let's trust the full name
          if check != newname[:last]
            newname[:first] = "#{newname[:first]} #{newname[:last]}".sub(check, "").strip
            newname[:last] = check
          end
        end

        # titles which are part of the first name...
        newname[:title] = parse_title!(newname[:first]) if newname[:title].empty?
        
      when / / # no comma, check for space on first then last
        newname[:last] = parse_last!(name, format[:order])
        newname[:first], newname[:middle] = parse_first!(name, format[:spacelimit])
      end

      cleanup! newname[:last], newname[:first], newname[:middle]

      newname
    end

    # Internal: pull off a title if we can
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the title found or and empty string
    def self.parse_title!(nm)
      dustoff gut!(nm, TITLES)
    end

    # Internal: pull off what suffixes we can
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the suffixes found or and empty string
    def self.parse_suffix!(nm)
      dustoff gut!(nm, SUFFIXES)
    end

    # Internal: parse nickname out of string. presuming it's in quotes
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the nickname found or and empty string
    def self.parse_nick!(nm)
      dustoff gut!(nm, NICKNAME)
    end

    # Internal: parse last name from string
    #   Modifies given string in place.
    #
    # nm - string to get the last name from
    # format - symbol defaulting to "first last". See parse()
    #
    # Returns string of the last name found or an empty string
    def self.parse_last!(nm, format = :fl)
      last = ""

      format = :fl  if (format == :auto && nm.index(",").nil?)
      format = :lcf if (format == :auto && nm.index(","))

      # these constants should have the named match :fam
      nomen = case format
        when :fl
          nm.match( FIRSTLAST_MATCHER )
        when :lf
          nm.match( LASTFIRST_MATCHER )
        when :lcf
          nm.match( LASTCOMFIRST_MATCHER )
      end

      unless nomen.nil? || nomen[:fam].nil?
        last = nomen[:fam].strip
        nm.sub!(last, "")
        nm.sub!(",", "")
      end

      last
    end

    # Internal: parse the first name, and middle name if any
    #   Modifies given string in place.
    #
    # nm - the string to get the first name from
    # namecount - the number of spaces in the first name to consider
    #
    # Returns an array containing the first name and middle name if any
    def self.parse_first!(nm, namecount = 0)
      nm.tr! ".", " "
      nm.squeeze! " "
      first, middle = nm.split " ", namecount

      [first || "", middle || ""]
    end

    private
    # Internal: Clean up a string where there are numerous consecutive and trailing non-name characters.
    #   Modifies given string in place.
    #
    # args - strings to clean up
    #
    # Returns nothing
    def self.cleanup!(*args)
      args.each do |dirty|
        next if(dirty.nil? || !dirty.kind_of?(String))

        dirty.gsub! DIRTY_STUFF, ""
        dirty.squeeze! " "
        # remove any trailing commas or whitespace
        dirty.gsub! TRAILER_TRASH, ""
        dirty.strip!
      end
    end

    # Internal: a softer clean we keep re-using
    #
    # str - the string to dust off
    #
    # Returns the nice clean
    def self.dustoff(str)
      str = str.gsub PERIOD, " "
      str = str.squeeze " "
      str = str.strip
    end

    # Internal: clean out a given string with a given pattern
    #   Modfies the given string
    # str - the string to gut
    # pattern - the regext to cut with
    #
    # Returns the gutted pattern
    def self.gut!(str = "", pattern = / /)
      found = []
      str.gsub! pattern do |pat|
        found << pat.strip
        ""
      end
      found.join " "
    end
  end
end
