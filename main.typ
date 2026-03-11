#import "lib.typ": *

#show: project

= PRAKATA

#include "chapter/preface.typ"

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
#set heading(numbering: none)

#bibliography("ref.bib")

// If you have any attachment, uncomment this and include the attachments
// e.g. `#include "chapter/lampiran.typ"`
// = LAMPIRAN
