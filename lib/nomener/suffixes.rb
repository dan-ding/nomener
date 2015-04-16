#-- encoding: UTF-8
require 'nomener/base'

module Nomener
  # Module for suffix information
  module Suffixes
    extend Nomener::Base

    # Internal: Regex to match suffixes or honorifics after names
    SUFFIXES  = %r/(?<=\p{^Alpha})(?:
      AB                                           # Bachelor of Arts
      | APC
      | Attorney[\p{Blank}\-]at[\p{Blank}\-]Law\.? # Attorney at Law
      | B[AS]c?                                    # Bachelor of Arts,Science
      | C\.?P\.?A\.?
      | CHB
      | DBE
      | D\.?[DMOPV]\.?[SMD]?\.?                    # DMD, DO, DPM, DDM, DVM
      | DSC
      | Esq(?:\.|uire\.?)?                         # Esq, Esquire
      | FAC(?:P|S)                                 # FACP, FACS
      | fils
      | FRSL
      | (?:[VX]?I{1,3})(?!\.)                      # roman numbers
      | (?:IX|IV|V|VI|XI)(?!\.)                    # roman numbers
      | (?:X{1,3})(?!\.)                           # roman numbers
      | Jn?r\.?
      | Junior
      | LLB
      | M\.?[BDS]\.?ed?                            # MB, MD, MS, MSed
      | MPH
      | P\.?\p{Blank}?A\.?
      | PC
      | p[èe]re
      | Ph\.?\p{Blank}?D\.?
      | RN
      | SC
      | Sn?r\.?                                    # Snr, Sr
      | Senior
      | V\.?M\.?D\.?
    )(?=[^\p{Alpha}\p{Blank}]+|\z)/x

    # Internal: pull off what suffixes we can
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the suffixes found or and empty string
    def self.parse_suffix!(nm)
      return '' if nm.to_s.empty?

      suffix = dustoff gut!(nm, SUFFIXES)
      Cleaner.cleanup! nm
      suffix
    end
  end
end
