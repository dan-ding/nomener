#-- encoding: UTF-8
require 'nomener/base'

module Nomener
  # Module for title information
  module Titles
    extend Nomener::Base

    # Internal: Regex for matching name prefixes such as honorifics
    #  and other formalities
    TITLES = %r/\b(?:
      خانم                              # Persian Mrs ?
      | (?:רעב|'ר)                     # Yiddish Mr.
      | አቶ                             # Amharic Mr.
      | Adi                             # Fiji
      | Air\p{Blank}(?:Commander|Commodore|Marshall)            # Air Commander, Commodore, Marshall
      | Ald(?:erman|\.)?
      | (?:Arch)?Du(?:ke|chess)         # Duke, Archduke, Duchess, Archduchess
      | Ato                             # Amharic Mr.
      | Baron(?:ess)?
      | Bishop
      | Bulou                           # Fiji
      | Brig(?:adier)?
      | Brother
      | Capt(?:ain|\.)?
      | Cdr\.?                          # Commander
      | Chaplain
      | Colonel
      | Comm(?:ander|odore)             # Commander, Commodore
      | Count(?:ess)?
      | Dame
      | Det\.?
      | Dhr\.?
      | Doctor
      | Dr\.?
#      | Dona                           # Always with first name
#      | Don                            # Always with first name
      | Dom
      | Erzherzog(?:in)?                # Erzherzog, Erzherzogin
      | Father
      | Field\p{Blank}Marshall
      | Flt?\.?(?:\p{Blank}(?:Lt|Off)\.?) # Fl Lt, Flt Lt, Fl Off, Flt Off
      | Flight(?:\p{Blank}(?:Lieutenant|Officer)) # Flight Lieutenant, Flight Officer
      | Frau
      | Fr\.?
      | Gen(?:eral|\.)?                 # General
      | H[äe]rra                        # Estonian, Finnish Mr
      | Herr
      | Hra?\.?                         # Finnish
      | (?:Rt\.?|Right)?\p{Blank}?Hon\.?(?:ourable)?  # Honourable, Right Honourable
      | Insp\.?(?:ector)?               # Inspector
      | Judge
      | Justice
      | Khaanom                         # Persian Mrs
      | Lady
      | Lieutenant(?:\p{Blank}(?:Commander|Colonel|General))?   # Lieutenant, Lieutenant Commander, Lieutenant Colonel, Lieutenant General
      | Lt\.?(?:\p{Blank}(?:Cdr|Col|Gen)\.?)? # Lt, Lt Col, Lt Cdr, Lt Gen
      | (?:Lt|Leut|Lieut)\.?
      | Lord
#      | M\.?                            # French
      | Madam(?:e)?
      | Mademoiselle                    # French
      | Maid
      | Ma[îi]tre                       # French
      | Major(?:\p{Blank}General)?      # Major, Major General
      | Maj\.?(?:\p{Blank}Gen\.?)?      # Maj, Maj Gen
      | (?:Master|Technical|Staff)?\p{Blank}?Sergeant
      | [MTS]?Sgt\.?                    # Master, Staff, Technical, or just Sergeant
      | Mast(?:er|\.)?
      | Matron
      | Menina
      | Messrs
      | Meneer
      | Mlle\.?                         # French
      | Miss\.?
      | Mister
      | Mn[er]\.?                       # Mne (Mnr) Afrikaans Mr.
      | Mme\.?                          # French
      | Mons(?:ignor|\.?)               # Monsignor
      | Monsieur                        # French
      | Most\p{Blank}Rever[e|a]nd
      | Mother(?:\p{Blank}Superior)?    # Mother, Mother Superior
      | Mrs?\.?
      | Msgr\.?                         # Monsignor
      | M\/?s\.?                        # Ms, Ms
      | Mt\.?\p{Blank}Revd?\.?
      | Mx\.?
      | (?-i:ông)                       # Vietnamese Mr. must be lowercase
      | Pastor
      | Private
      | Prof(?:essor|esseur|\.)?        # Professor, Professeur, Prof
      | Pte\.?                          # Private
      | Pvt\.?                          # Private
      | PFC                             # Private first class
      | Rabbi
      | Ratu                            # Fiji Sir
      | Reb\.?                          # Yiddish Mr.
      | Rever[e|a]nd
      | Revd?\.?
      | Ro(?:ko)?                       # Fiji
      | Se[nñ]h?orita                   # senorita, señorita, senhorita
      | Se[nñ]h?ora                     # senora, señora, senhora
      | Se[nñ][hy]?or(?:\p{Blank}Dom)?  # senor,señor,senhor,senyor,senor dom
      | Sénher
      | Seigneur
      | Signor(?:a|e)
      | Sig(?:a|ra)?\.?
      | Sioro                           # Ido Mr.
      | Sro\.?                          # Ido Mr.
      | Sir
      | Sister
      | Sr(?:a|ta)?\.?
      | V\.?\ Revd?\.?
      | Very\ Rever[e|a]nd
    )\b/xi

    # Internal: pull off a title if we can
    #   Modifies given string in place.
    #
    # nm - string of the name to parse
    #
    # Returns string of the title found or and empty string
    def self.parse_title!(nm)
      return '' if nm.to_s.empty?
      dustoff gut!(nm, TITLES)
    end
  end
end
