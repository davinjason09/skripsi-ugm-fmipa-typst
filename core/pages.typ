#import "@preview/transl:0.2.0": transl

#let cover-count = counter("cover")

#let cover(doc) = {
  cover-count.step()
  set align(center)

  context {
    let current = cover-count.get().first()
    let final = cover-count.final().first()
    let final-cover = current == final

    set page(
      footer: none,
      header: if final > 1 and current != 1 { align(right, counter(page).display()) } else { none },
    )

    if final-cover {
      show heading: none
      [ = #transl("cover-heading", mode: str) ]
    }

    strong(transl("document"))
    v(1.5cm, weak: true)
    strong(upper(doc.title.id))
    v(1.5cm, weak: true)
    strong(upper(doc.title.en))
    v(1.5cm, weak: true)

    if final-cover { transl(doc.type + "-text", degree: doc.program.degree) }

    v(1fr)
    image("../assets/logougm.png", width: 5.5cm)
    v(1fr)
    upper[#doc.author.name\ #doc.author.id]
    v(2cm, weak: true)

    strong[
      #transl("program-name", name: upper(doc.program.name)) \
      #transl("program-dept", name: upper(doc.program.department)) \
      #transl("program-fact", name: upper(doc.program.faculty)) \
      #transl("program-uni") \
      YOGYAKARTA \ \
      #datetime.today().year()
    ]
  }
}

#let approval(doc) = context {
  set page(footer: none)
  set align(center)

  [ = #transl("approval-heading", mode: str) ]

  v(0.8cm, weak: true)
  text(size: 14pt, strong(transl("document")))
  v(0.75cm, weak: true)
  upper(strong(doc.title.at(doc.lang)))
  v(1cm, weak: true)

  transl("approval-proposed")
  v(0.75cm, weak: true)
  [ #upper(doc.author.name) \ #doc.author.id ]
  v(1cm, weak: true)

  transl("approval-presented", date: doc.exam-date)

  v(0.75cm, weak: true)
  transl("approval-examiners")

  let first_supervisor = ""
  let second_supervisor = ""

  if type(doc.supervisor) == array {
    first_supervisor = doc.supervisor.at(0)
    if doc.supervisor.len() > 1 { second_supervisor = doc.supervisor.at(1) }
  } else {
    first_supervisor = doc.supervisor
  }

  let values = (transl("examiner-chief"), transl("examiner-member")) + doc.examiners
  let max-name-width = calc.max(..values.map(content => measure([#content]).width))

  // Examiners box
  align(left, table(
    columns: (1fr, 1fr),
    align: (left, right),
    stroke: none,
    [
      #v(1.5cm) \
      #first_supervisor \
      #transl("supervisor-label") #if second_supervisor != "" [ I ]
    ],
    block(width: max-name-width)[
      #set align(left)
      #v(1.5cm) \
      #doc.examiners.at(0) \
      #transl("examiner-chief")
    ],

    [
      #if second_supervisor != "" [
        #v(1.5cm) \
        #second_supervisor \
        #transl("supervisor-label") II
      ]
    ],
    block[
      #set align(left)
      #v(1.5cm) \
      #doc.examiners.at(1) \
      #transl("examiner-member")
    ],
  ))
}

#let statement(doc) = {
  set par(justify: true)

  context [ = #transl("statement-heading", mode: str) ]

  v(1cm, weak: true)

  transl("statement-intro")

  let start-year = "20" + doc.author.id.split("/").first()
  pad(left: -0.4em)[
    #set text(hyphenate: false)
    // @typstyle off
    #table(
      columns: (auto, auto, 1fr),
      stroke: none,
      [Nama],             [:], [#doc.author.name],
      [NIM],              [:], [#doc.author.id],
      [Tahun terdaftar],  [:], [#start-year],
      [Program studi],    [:], [#doc.program.name],
      [Fakultas/Sekolah], [:], [#doc.program.faculty],
    )
  ]

  transl("statement-content")

  v(2cm, weak: true)
  align(right, table(
    columns: auto,
    align: right + horizon,
    stroke: none,
    inset: 0%,
    [
      Yogyakarta, #doc.exam-date \
      #v(2.5cm) \
      #upper(doc.author.name) \
      #doc.author.id
    ],
  ))
}

#let preface(conf) = {
  let doc = conf.doc
  let pages = conf.pages

  context [ = #transl("preface-title", mode: str) ]

  set par(
    justify: true,
    first-line-indent: (amount: 2.5em, all: true),
    leading: 1em,
    linebreaks: "optimized",
  )

  pages.preface

  v(2cm, weak: true)
  align(right, table(
    columns: auto,
    align: center + horizon,
    stroke: none,
    inset: 0%,
    [
      Yogyakarta, #doc.exam-date \
      #v(0.5cm) \
      #transl("preface-writer")
    ],
  ))
}

#let outlines(kinds: (image, table)) = context {
  outline(title: transl("outline-main", mode: str), indent: auto)

  let fig-kind = (image, table, raw)
  for kind in kinds {
    let target = if kind in fig-kind or type(kind) == str { figure.where(kind: kind) } else { kind }
    let repr-kind = if type(kind) == str { kind } else { repr(kind) }

    pagebreak()
    outline(title: transl("outline-" + repr-kind, mode: str), target: target)
  }

  pagebreak()
}

#let abstract(lang: "id", conf) = {
  let doc = conf.doc
  let pages = conf.pages
  let title = if lang == "id" [INTISARI] else [ABSTRACT]
  let content = pages.at("abstract-" + lang)

  if content == "" { panic[Abstract can't be empty!] }

  set text(lang: lang)

  [ = #title ]

  {
    set align(center)
    set par(justify: false, first-line-indent: 0pt, leading: 0.8em)

    v(0.8cm)

    upper(strong(doc.title.at(lang)))
    pad(top: 0.25cm, bottom: 0.25cm, transl("abstract-by"))
    [#upper(doc.author.name)\ #doc.author.id]
  }

  set par(justify: true, first-line-indent: 3em, leading: 0.6em)
  v(0.8cm)
  content

  let keywords = pages.at("keywords-" + lang)
  v(0.8cm, weak: true)
  [#transl("abstract-keyword"): #keywords.join(", ")]
}
