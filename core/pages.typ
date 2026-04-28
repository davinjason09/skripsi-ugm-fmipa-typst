#import "constants.typ" as const
#import "utils.typ": fmt-date

#let cover-count = counter("cover")

#let cover(cfg) = {
  cover-count.step()
  set align(center)

  let doc = cfg.doc
  let cover-title = const.cover_title.at(doc.lang)
  let year = datetime.today().year()

  let program-name = (const.program_labels.prefix.name.at(doc.lang), doc.program.name)
  if doc.lang == "en" { program-name = program-name.rev() }

  context {
    let current = cover-count.get().first()
    let final = cover-count.final().first()
    let final-cover = current == final

    set page(
      footer: none,
      header: if final-cover and final == 2 {
        align(right, counter(page).display())
      } else {
        none
      },
    )

    if final-cover {
      show heading: none
      [= #const.cover_heading.at(doc.lang)]
    }

    strong[#cover-title]
    v(1.5cm, weak: true)
    strong[#upper(doc.title.id)]
    v(1.5cm, weak: true)
    strong[#upper(doc.title.en)]

    if final-cover {
      v(1.5cm, weak: true)
      if doc.type == "proposal" {
        const.proposal_text.at(doc.lang)
      } else {
        [#const.thesis_text.at(doc.lang) #doc.program.degree]
      }
    }

    v(1fr)
    image("../assets/logougm.png", width: 5.5cm)
    v(1fr)
    upper[#doc.author.name\ #doc.author.id]
    v(2cm, weak: true)

    strong[
      #upper(program-name.join(" ")) \
      #upper[#const.program_labels.prefix.dept.at(doc.lang) #doc.program.department] \
      #upper[#const.program_labels.prefix.fact.at(doc.lang) #doc.program.faculty] \
      #const.program_labels.uni.at(doc.lang) \
      YOGYAKARTA \ \
      #year
    ]
  }
}

#let approval(cfg) = {
  set page(footer: none)
  set align(center)
  let doc = cfg.doc

  [ = #const.approval.title.at(doc.lang) ]

  v(0.8cm, weak: true)
  text(size: 14pt, strong(const.cover_title.at(doc.lang)))
  v(0.75cm, weak: true)
  upper(strong(doc.title.at(doc.lang)))
  v(1cm, weak: true)

  const.approval.proposed.at(doc.lang)
  v(0.75cm, weak: true)
  [#upper(doc.author.name) \ #doc.author.id]
  v(1cm, weak: true)

  [#const.approval.presented.at(doc.lang) #fmt-date(doc.exam-date)]

  v(0.75cm, weak: true)
  const.approval.examiners.at(doc.lang)

  let first_supervisor = ""
  let second_supervisor = ""

  if type(doc.supervisor) == array {
    first_supervisor = doc.supervisor.at(0)
    if doc.supervisor.len() > 1 { second_supervisor = doc.supervisor.at(1) }
  } else {
    first_supervisor = doc.supervisor
  }

  let values = const.examiner_labels.values().map(c => c.at(doc.lang)) + doc.examiners
  let max-name-width = calc.max(..values.map(content => measure([#content]).width))

  // Examiners box
  align(left, table(
    columns: (1fr, 1fr),
    align: (left, right),
    stroke: none,
    [
      #v(1.5cm) \
      #first_supervisor \
      #const.supervisor_label.at(doc.lang) #if second_supervisor != "" [ I ]
    ],
    block(width: max-name-width)[
      #set align(left)
      #v(1.5cm) \
      #doc.examiners.at(0) \
      #const.examiner_labels.first.at(doc.lang)
    ],

    [
      #if second_supervisor != "" [
        #v(1.5cm) \
        #second_supervisor \
        #const.supervisor_label.at(doc.lang) II
      ]
    ],
    block[
      #set align(left)
      #v(1.5cm) \
      #doc.examiners.at(1) \
      #const.examiner_labels.second.at(doc.lang)
    ],
  ))
}

#let statement(cfg) = {
  set par(justify: true)

  let doc = cfg.doc

  [ = #const.statement.title.at(doc.lang) ]

  v(1cm, weak: true)

  const.statement.content.at(doc.lang)

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

#let outlines(kinds: (image, table)) = context {
  let lang = state("lang").get()
  let fig-kind = (image, table, raw)

  outline(title: const.outline_titles.main.at(lang), indent: auto)
  for kind in kinds {
    pagebreak()

    let str_repr = repr(kind)
    let target = kind
    if kind in fig-kind { target = figure.where(kind: kind) }

    outline(
      title: const.outline_titles.at(str_repr, default: (id: "", en: "")).at(lang),
      target: target,
    )
  }
}

#let abstract(lang: "id", keywords: (), content) = {
  {
    set align(center)
    set par(justify: false, first-line-indent: 0pt, leading: 0.8em)

    v(0.8cm)
    strong(title.at(lang))
    pad(top: 0.25cm, bottom: 0.25cm, const.abstract.by.at(lang))
    [#upper(author.name)\ #author.id]
  }

  set par(justify: true, first-line-indent: 3em, leading: 0.6em)
  v(0.8cm)
  content

  v(0.8cm, weak: true)
  [#const.abstract.keyword.at(lang): #keywords.join(", ")]
}
