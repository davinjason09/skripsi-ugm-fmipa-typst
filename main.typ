#import "lib.typ": *

#show: project

= PRAKATA

#include "chapter/preface.typ"

#outlines()

= INTISARI

#include "chapter/abstract_id.typ"

= ABSTRACT

#include "chapter/abstract_en.typ"

// Update the heading numbering
#set heading(numbering: "1.1")

// Set the page numbering to use numbers and reset the counter
#set page(numbering: "1")
#counter(page).update(1)

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

// Remove heading numbering
#set heading(numbering: none)

#bibliography("ref.bib")

// If you have any attachment, uncomment this and include the attachments
// e.g. `#include "chapter/lampiran.typ"`
// = LAMPIRAN
