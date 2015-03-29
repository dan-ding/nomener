module Nomener
  module Compounders

    # Internal: Regex last name prefixes.
    COMPOUNDS = %r!(?<part>(?:
      Ab
      | Ap
      | Abu
      | Al
      | Bar
      | Bath?
      | Bet
      | Bint?
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
      | L[aeo]
      | M[ai\']?c?
      | Mhic
      | Maol
      | M[au]g
      | Naka
      | 中
      | Neder
      | N[ií]'?[cgn]?
      | Nord
      | Norr
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
      | Zu
      | (?-i:y)
      | 't
    )\p{Blank}\g<part>*)*!xi
  end
end
