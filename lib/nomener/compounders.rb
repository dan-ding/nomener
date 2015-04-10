module Nomener
  module Compounders
    # Many of these are from http://en.wikipedia.org/wiki/List_of_family_name_affixes

    # Internal: Regex last name prefixes.
    COMPOUNDS = %r!(?<part>(?:
      Ab
      | Ap
      | Abu
      | Al
      | Bar
      | Bath?
      | Bet
      | Bint?             # Arabic
      | Da
      | De\p{Blank}Ca
      | De\p{Blank}La
      | De\p{Blank}Los
      | de\p{Blank}De\p{Blank}la
      | Degli
      | De[lnrs]?
      | Dele
      | Dell[ae]
      | D[iu]t?
      | Dos
      | El
      | Fitz
      | Gil
      | Het
      | in
      | in\p{Blank}het
      | Ibn
      | Kil
      | L[aeo]            # French, Italian
      | M'
      | M[ai]c
      | Mc
      | Mhic
      | Maol
      | M[au]g
      | Naka              # Japanese
      | 中                # Japanese
      | Neder             # Swedish
      | N[ií]'?[cg]?      # Irish, Scottish
      | Nin               # Serbian
      | Nord              # German, Swedish, Danish, Norwegian
      | Norr              # German, Swedish, Danish, Norwegian
      | Ny
      | Ó
      | Øst
      | Öfver
      | Öst
      | Öster
      | Över
      | Öz
      | Pour
      | St\.?
      | San
      | Stor
      | Söder
      | Ter?
      | Tre
      | U[ií]?
      | Vd
      | V[ao]n
      | V[ao]n
      | Ved\.?
      | Vda\.?
      | Vest
      | Väst
      | Väster
      | wa
      | Zu
      | (?-i:y)
      | 't
    )\b\p{Blank}?\g<part>*)*!xi
  end
end
