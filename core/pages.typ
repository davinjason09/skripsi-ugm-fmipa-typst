#import "../config.typ": *
#import "constants.typ" as const
#import "utils.typ": fmt-date

#let cover(force-thesis: false) = {
  set align(center)

  let cover-title = const.thesis.at(lang)
  let year = datetime.today().year()

  strong[#cover-title]
  v(1.5cm, weak: true)
  strong[#upper(title.id)]
  v(1.5cm, weak: true)
  strong[#upper(title.en)]

  if doc-type == "proposal" and not force-thesis {
    v(1.5cm, weak: true)
    const.proposal.at(lang)
  }

  v(1fr)
  image("../assets/logougm.png", width: 5.5cm)
  v(1fr)
  upper[#author.name\ #author.id]
  v(2cm, weak: true)

  let program-name = (const.program.prefix.name.at(lang), program.name)
  if lang == "en" {
    program-name = program-name.rev()
  }

  strong[
    #upper(program-name.join(" ")) \
    #upper[#const.program.prefix.dept.at(lang) #program.department] \
    #upper[#const.program.prefix.fact.at(lang) #program.faculty] \
    #const.program.uni.at(lang) \
    YOGYAKARTA \ \
    #year
  ]
}

#let approval() = {
  set align(center)
  v(0.8cm, weak: true)
  text(size: 14pt, strong(const.thesis.at(lang)))
  v(0.75cm, weak: true)
  upper(strong(title.at(lang)))
  v(1cm, weak: true)

  const.approval.proposed.at(lang)
  v(0.75cm, weak: true)
  [#upper(author.name) \ #author.id]
  v(1cm, weak: true)

  [#const.approval.presented.at(lang) #fmt-date(exam-date)]

  v(0.75cm, weak: true)
  const.approval.examiners.at(lang)

  let first_supervisor = ""
  let second_supervisor = ""

  if type(supervisor) == array {
    first_supervisor = supervisor.at(0)
    if supervisor.len() > 1 { second_supervisor = supervisor.at(1) }
  } else {
    first_supervisor = supervisor
  }

  context {
    let values = const.examiners.values().map(c => c.at(lang)) + examiners
    let max-name-width = calc.max(..values.map(content => {
      measure([#content]).width
    }))

    align(left, table(
      columns: (1fr, 1fr),
      align: (left, right),
      stroke: none,
      [
        #v(1.5cm) \
        #first_supervisor \
        #const.supervisor.at(lang) #if second_supervisor != "" [ I ]
      ],
      block(width: max-name-width)[
        #set align(left)
        #v(1.5cm) \
        #examiners.at(0) \
        #const.examiners.first.at(lang)
      ],

      [
        #if second_supervisor != "" [
          #v(1.5cm) \
          #second_supervisor \
          #const.supervisor.at(lang) II
        ]
      ],
      block[
        #set align(left)
        #v(1.5cm) \
        #examiners.at(1) \
        #const.examiners.second.at(lang)
      ],
    ))
  }
}

#let statement() = {
  set par(justify: true)
  v(1cm, weak: true)

  const.statement.content.at(lang)

  v(2cm, weak: true)
  set align(right)
  table(
    columns: auto,
    align: center + horizon,
    stroke: none,
    inset: 0%,
    [
      Yogyakarta, #fmt-date(exam-date) \
      #v(1cm) \
      #upper(author.name)
    ],
  )
}

#let outlines() = {
  outline(title: const.outlines.main.at(lang), indent: auto)
  pagebreak()
  outline(
    title: const.outlines.figure.at(lang),
    target: figure.where(kind: image),
  )
  pagebreak()
  outline(
    title: const.outlines.table.at(lang),
    target: figure.where(kind: table),
  )
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
