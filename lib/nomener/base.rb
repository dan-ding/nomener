module Nomener
  # Module of constants, methods being used in other modules and classes
  module Base
    # probably unnecessary constant
    PERIOD = /\./

    # Internal: a softer clean we keep re-using
    #
    # str - the string to dust off
    #
    # Returns the nice clean
    def dustoff(str)
      str = str.gsub PERIOD, ' '
      str = str.squeeze ' '
      str.strip
    end

    # Internal: clean out a given string with a given pattern
    #   Modfies the given string
    #
    # str - the string to gut
    # pattern - the regext to cut with
    #
    # Returns the gutted pattern
    def gut!(str = '', pattern = / /)
      found = []
      str.gsub! pattern do |pat|
        found << pat.strip
        ''
      end
      found.join ' '
    end
  end
end
