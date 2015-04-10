module Nomener
  module Suffixes

    # Internal: Regex to match suffixes or honorifics after names
    SUFFIXES  = %r/\b(?:
      AB                                                  # Bachelor of Arts
      | APC
      | Attorney[\p{Blank}\-]at[\p{Blank}\-]Law\.?        # Attorney at Law, Attorney-at-Law
      | B[AS]c?                                           # Bachelor of Arts, Bachelor of Science
      | C\.?P\.?A\.?
      | CHB
      | DBE
      | D\.?[DMOPV]\.?[SMD]?\.?                           # DMD, DO, DPM, DDM, DVM
      | DSC
      | Esq(?:\.|uire\.?)?                                # Esq, Esquire
      | FAC(?:P|S)                                        # FACP, FACS
      | fils
      | FRSL
      | (?:[VX]?I{1,3})(?!\.)                             # roman numbers
      | (?:IX|IV|V|VI|XI)(?!\.)                           # roman numbers
      | (?:X{1,3})(?!\.)                                  # roman numbers
      | Jn?r\.?
      | Junior
      | LLB
      | M\.?[BDS]\.?ed?                                   # MB, MD, MS, MSed
      | MPH
      | P\.?\p{Blank}?A\.?
      | PC
      | p[èe]re
      | Ph\.?\p{Blank}?D\.?
      | RN
      | SC
      | Sn?r\.?                                           # Snr, Sr
      | Senior
      | V\.?M\.?D\.?
    )\b/x
  end
end

