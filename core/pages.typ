#import "../config.typ": *
#import "constants.typ" as const
#import "helper.typ": fmt-date

#let cover() = {
  set align(center)

  let cover-title = const.thesis.at(lang)
  let year = datetime.today().year()

  strong[#cover-title]
  v(1.5cm, weak: true)
  strong[#upper(title.id)]
  v(1.5cm, weak: true)
  strong[#upper(title.en)]

  if doc-type == "proposal" {
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

#let approval() = [
  #set align(center)
  #v(1cm, weak: true)
  #strong(const.thesis.at(lang))
  #v(0.75cm, weak: true)
  #upper(strong(title.at(lang)))
  #v(1cm, weak: true)

  #const.approval.proposed.at(lang)
  #v(0.75cm, weak: true)
  #upper(author.name) \ #author.id
  #v(1cm, weak: true)

  #const.approval.presented.at(lang)
  #fmt-date(exam-date)

  #v(0.75cm, weak: true)
  #const.approval.examiners.at(lang)

  #let first_supervisor = ""
  #let second_supervisor = ""

  #if type(supervisor) == array {
    first_supervisor = supervisor.at(0)
    if supervisor.len() > 1 { second_supervisor = supervisor.at(1) }
  } else {
    first_supervisor = supervisor
  }

  #set align(left)
  #table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: 0%,
    [
      #v(3cm) \
      #first_supervisor \
      #const.supervisor.at(lang) #if second_supervisor != "" [ I ]
    ],
    [
      #v(3cm) \
      #examiners.at(0) \
      #const.examiners.first.at(lang)
    ],

    [
      #if second_supervisor != "" [
        #v(3cm) \
        #second_supervisor \
        #const.supervisor.at(lang) II
      ]
    ],
    [
      #v(3cm) \
      #examiners.at(1) \
      #const.examiners.second.at(lang)
    ],
  )
]

#let statement() = [
  #set par(justify: true)
  #v(1cm, weak: true)

  #const.statement.content.at(lang)

  #v(2cm, weak: true)
  #set align(right)
  #table(
    columns: auto,
    align: center + horizon,
    stroke: none,
    inset: 0%,
    [
      Yogyakarta, #fmt-date(exam-date) \
      #v(2cm) \ #upper(author.name)
    ],
  )
]

#let outlines() = {
  outline(title: const.outlines.main.at(lang), indent: auto)
  pagebreak()
  outline(title: const.outlines.figure.at(lang), target: figure.where(kind: image))
  pagebreak()
  outline(title: const.outlines.table.at(lang), target: figure.where(kind: table))
}
