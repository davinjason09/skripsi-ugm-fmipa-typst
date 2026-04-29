#import "lib.typ": *

#show: thesis.with(
  doc: (
    type: "thesis",
    lang: "id",
  ),
)

= PRAKATA

#include "chapter/preface.typ"

// By default, calling outlines() will create the main outline (list of chapters) and outlines for table and image.
// However, you can add more to it by passing an array where the values can either be a function or string.
// Example
// #outlines(kinds: (image, table, raw, math.equation))
#outlines()

= INTISARI

#include "chapter/abstract_id.typ"

= ABSTRACT

#include "chapter/abstract_en.typ"

// WARNING: DO NOT REMOVE
// This single show rule will:
// - Update the heading numbering
// - Change the page numbering from roman numerals to arabic numeral
// - Reset the page counter to 1
#show: start-chapter

= PENDAHULUAN

#include "chapter/1.typ"

// Example for the next chapters
// = PENELITIAN TERKAIT
//
// #include "chapter/2.typ"
//
// = METODE DAN RANCANGAN PENELITIAN
//
// #include "chapter/3.typ"
//
// = JADWAL PENELITIAN
//
// #include "chapter/4.typ"

// Remove heading numbering, resetting the show rule above
#show: end-chapter

#bibliography("ref.bib")

// If you have any attachment, uncomment this and include the attachments
// e.g. `#include "chapter/lampiran.typ"`
// = LAMPIRAN
