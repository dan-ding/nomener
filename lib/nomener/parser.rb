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
      raise ArgumentError, 'Name to parse not provided' unless (name.kind_of?(String) && !name.empty?)

      name = Nomener::Helper.reformat(name)

      # grab any identified nickname before working on the rest
      nick = parse_nick!(name)
      title = parse_title!(name)

      # grab any suffix' we can find
      suffix = parse_suffix!(name)
      first = last = middle = ""

      # if there's a comma, it may be a useful hint
      if !name.index(',').nil? # && (format[:order] == :auto || format[:order] == :lcf)
        clues = name.split(",")
        # convention is last, first
        if clues.length == 2
          last, first = clues

          # Mies van der Rohe, Ludwig
          # Snepscheut, Jan L. A. van de
          # check the last by comparing a re-ordering of the name
          first_parts = first.split " "
          unless first_parts.length == 1
            check = parse_last!("#{first} #{last}", :fl)
            # let's trust the full name
            if check != last
              first = "#{first} #{last}".sub(check, '').strip
              last = check
            end
          end
          # titles are part of the first name
          title = parse_title!(first) if title.nil? || title.empty?
        else
          raise ParseError "Could not understand #{rename}"
        end
      elsif !name.index(" ").nil?
        last = parse_last!(name, format[:order])
        first, middle = parse_first!(name, format[:spacelimit])
      elsif name.index(" ").nil?
        first = name[0] # mononym
      else
        raise ParseError "Could not understand #{rename}"
      end

      {
        :title => (title || "").strip,
        :suffix => (suffix || "").strip,
        :nick => (nick || "").strip,
        :first => (first || "").strip,
        :last => (last || "").strip,
        :middle => (middle || "").strip
      }
    end

    # Internal: Clean up a string where there are numerous consecutive and trailing non-name characters.
    #   Modifies given string in place.
    #
    # dirty - string to clean up
    #
    # Returns nothing
    def self.cleanup!(dirty)
      dirty.gsub! /[^,'\p{Alpha}]{2,}/, ''
      dirty.squeeze! " "
      # remove any trailing commas or whitespace
      dirty.gsub! /[,|\s]+$/, ''
      dirty.strip!
    end

    # Internal: pull off a title if we can
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the title found or and empty string
    def self.parse_title!(nm)
      titles = []
      nm.gsub! TITLES do |title|
        titles << title.strip
        ''
      end
      cleanup!(nm)
      titles.join " "
    end

    # Internal: pull off what suffixes we can
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the suffixes found or and empty string
    def self.parse_suffix!(nm)
      suffixes = []
      nm.gsub! SUFFIXES do |suffix|
        suffixes << suffix.strip
        ''
      end
      cleanup!(nm)
      suffixes.join " "
    end

    # Internal: parse nickname out of string. presuming it's in quotes
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the nickname found or and empty string
    def self.parse_nick!(nm)
      nm.sub!(/(?<=["'\(])([\p{Alpha}\-\ ']+?)(?=["'\)])/, '')
      nick = $1.strip unless $1.nil?
      nm.sub! /["'\(\)]{2}/, ''
      nm.squeeze! " "
      nick || ""
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

      if format == :auto
        format = :fl if nm.index(',').nil?
      #  format = :lcf if !nm.index(',').nil?
      end

      if format == :fl && n = nm.match(/\p{Blank}(?<fam>#{COMPOUNDS}[\p{Alpha}\-\']+)\Z/i)
        last = n[:fam].strip
        nm.sub!(last, "").strip!
      elsif format == :lf && n = nm.match(/\A(?<fam>#{COMPOUNDS}\b[\p{Alpha}\-\']+)\p{Blank}/i)
        last = n[:fam].strip
        nm.sub!(last, "").strip!
      elsif format == :lcf && n = nm.match(/\A(?<fam>#{COMPOUNDS}\b[\p{Alpha}\-\'\p{Blank}]+),/i)
        last = n[:fam].strip
        nm.sub!(last, "").strip!
        nm.sub!(',', "").strip!
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
      first, middle = nm.split ' ', namecount

      [first || "", middle || ""]
    end

  end
end