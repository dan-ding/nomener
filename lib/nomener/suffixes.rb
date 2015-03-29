module Nomener
  module Suffixes

    # Internal: Regex to match suffixes or honorifics after names
    SUFFIXES  = %r!\b(?:
      AB                                                  # Bachelor of Arts
      | APC
      | Attorney[\p{Blank}\-]at[\p{Blank}\-]Law\.?        # Attorney at Law, Attorney-at-Law
      | B[AS]c?                                           # Bachelor of Arts, Bachelor of Science
      | C\.?P\.?A\.?
      | CHB
      | D\.?[DMOPV]\.?[SMD]?\.?                           # DMD, DO, DPM, DDM, DVM
      | DSC
      | Esq(?:\.|uire\.?)?                                # Esq, Esquire
      | FAC(?:P|S)                                        # FACP, FACS
      | (?:X{0,3}I{0,3}(?:X|V)?I{0,3})[IXV]{1,}\.?       # roman numbers I - XXXXVIII, if they're written proper
      | Jn?r\.?
      | Junior
      | LLB
      | M\.?[BDS]\.?ed?                                   # MB, MD, MS, MSed
      | MPH
      | P\.?\p{Blank}?A\.?
      | PC
      | Ph\.?\p{Blank}?D\.?
      | RN
      | SC
      | Sn?r\.?                                           # Snr, Sr
      | Senior
      | V\.?M\.?D\.?
    )\b!xi
  end
end