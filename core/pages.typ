#import "@preview/transl:0.2.0": transl

#import "utils.typ": fmt-date

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
      header: if final > 1 { align(right, counter(page).display()) } else { none },
    )

    if final-cover {
      show heading: none
      [ = #transl("cover-heading") ]
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

#let approval(doc) = {
  set page(footer: none)
  set align(center)

  [ = #transl("approval-heading") ]

  v(0.8cm, weak: true)
  text(size: 14pt, strong(transl("document")))
  v(0.75cm, weak: true)
  upper(strong(doc.title.at(doc.lang)))
  v(1cm, weak: true)

  transl("approval-proposed")
  v(0.75cm, weak: true)
  [ #upper(doc.author.name) \ #doc.author.id ]
  v(1cm, weak: true)

  [ #transl("approval-presented", date: fmt-date(doc.exam-date)) ]

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

  [ = #transl("statement-heading") ]

  v(1cm, weak: true)

  transl("statement-content")

  v(2cm, weak: true)
  align(right, table(
    columns: auto,
    align: center + horizon,
    stroke: none,
    inset: 0%,
    [
      Yogyakarta, #fmt-date(doc.exam-date) \
      #v(1cm) \
      #upper(doc.author.name)
    ],
  ))
}

#let outlines(kinds: (image, table)) = {
  outline(title: transl("outline-main"), indent: auto)

  let fig-kind = (image, table, raw)
  for kind in kinds {
    let target = if kind in fig-kind { figure.where(kind: kind) } else { kind }

    pagebreak()
    outline(
      title: transl("outline-" + repr(kind)),
      target: target,
    )
  }
}

#let abstract(lang: "id", keywords: (), content) = context {
  set text(lang: lang)

  {
    set align(center)
    set par(justify: false, first-line-indent: 0pt, leading: 0.8em)

    v(0.8cm)


    let doc = state("doc").get()
    upper(strong(doc.title.at(lang)))
    pad(top: 0.25cm, bottom: 0.25cm, transl("abstract-by"))
    [#upper(doc.author.name)\ #doc.author.id]
  }

  set par(justify: true, first-line-indent: 3em, leading: 0.6em)
  v(0.8cm)
  content

  v(0.8cm, weak: true)
  [#transl("abstract-keyword"): #keywords.join(", ")]
}
