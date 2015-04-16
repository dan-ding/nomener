#-- encoding: UTF-8
require 'nomener/base'
require 'nomener/compounders'
require 'nomener/cleaner'
require 'nomener/name'
require 'nomener/suffixes'
require 'nomener/titles'

module Nomener
  # Class containing the blades for carving a string into a name
  #
  # The two significant methods are:
  #   parse returning a hash or nil
  #   parse! returning a hash or raising an exception
  module Parser
    extend Nomener::Base
    extend Nomener::Cleaner
    extend Nomener::Titles

    include Nomener::Compounders

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

    # Public: parse a string into name parts
    #
    # name - a string to get the name from
    # format - hash of options to parse name
    #   default {:order => :fl, :spacelimit => 0}
    #   :order - format the name. defaults to "last first" of the available
    #     :fl - presumes the name is in the format of "first last"
    #     :lf - presumes the name is in the format of "last first"
    #     :lcf - presumes the name is in the format of "last, first"
    #   :spacelimit - the number of spaces to consider in the first name
    #
    # Returns a Nomener::Name of a parsed name of the string or nil
    def self.parse(name, format = { order: :auto, spacelimit: 1 })
      self.parse!(name, format)
      rescue
        nil
    end

    # Public: parse a string into name parts
    #
    # name - string to parse a name from
    # format - has of options to parse name. See parse()
    #
    # Returns a hash of name parts or nil
    # Raises ArgumentError if 'name' is not a string or is empty
    def self.parse!(name, format = { order: :auto, spacelimit: 0 })
      raise ArgumentError,
        'Name to parse not provided' if name.to_s.empty?

      name = Cleaner.reformat name

      # we want the hash in this order as it helps with parsing out pieces
      newname = { first: '', middle: '', last: '' }
      newname[:nick] = parse_nick!(name) # grab any identified nickname
      newname[:suffix] = Suffixes.parse_suffix!(name) # grab any suffix'
      newname[:title] = Titles.parse_title!(name)

      # stop here if we know we'll be confused
      raise ParseError,
        "Could not decipher commas in \"#{name}\"" if name.count(',') > 1

      newname[:last] = dustoff name # possibly mononyms

      if name.count(',') > 0
        newname[:last], newname[:first] = splitcomma(name)
        # titles which are part of the first name...
        newname[:title] = Titles.parse_title!(newname[:first]) if newname[:title].empty?
      else
        newname[:last] = parse_last!(name, format[:order])
        newname[:first], newname[:middle] = parse_first!(name, format[:spacelimit])
      end

      Cleaner.cleanup! newname[:last], newname[:first], newname[:middle]
      newname[:first] = dustoff newname[:first]

      newname
    end

    # Internal split on the comma to get the first and last names
    #
    # str - the name
    #
    # Returns an array of the last and first names found
    def self.splitcomma(str)
      last, first = str.split(',').each(&:strip!)

      # check the last by comparing a re-ordering of the name
      # Mies van der Rohe, Ludwig
      # Snepscheut, Jan L. A. van de
      unless first.to_s.count(' ') == 0
        check = parse_last!("#{first} #{last}", :fl)

        # trust the full name and remove the parsed last
        if check != last
          first = "#{first} #{last}".sub(check, '').strip
          last = check
        end
      end
      [last, first]
    end

    # Internal: parse nickname out of string. presuming it's in quotes
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the nickname found or and empty string
    def self.parse_nick!(nm)
      return '' if nm.to_s.empty?

      nick = dustoff gut!(nm, NICKNAME)
      nm.sub! NICKNAME_LEFTOVER, ''
      Cleaner.cleanup! nm
      nick
    end

    # Internal: parse last name from string
    #   Modifies given string in place.
    #
    # nm - string to get the last name from
    # format - symbol defaulting to "first last". See parse()
    #
    # Returns string of the last name found or an empty string
    def self.parse_last!(nm, format = :fl)
      last = ''

      format = :fl  if format == :auto
      format = :lcf if format == :auto && nm.index(',')

      # these constants should have the named match :fam
      nomen = case format
        when :fl
          nm.match FIRSTLAST_MATCHER
        when :lf
          nm.match LASTFIRST_MATCHER
        when :lcf
          nm.match LASTCOMFIRST_MATCHER
      end

      unless nomen.nil? || nomen[:fam].nil?
        last = nomen[:fam].strip
        nm.sub!(last, '')
        nm.sub!(',', '')
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
      nm.tr! '.', ' '
      nm.squeeze! ' '
      first, middle = nm.split ' ', namecount

      [first || '', middle || '']
    end
  end
end
