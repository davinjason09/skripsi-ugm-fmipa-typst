#import "core/utils.typ": start-chapter
#import "core/pages.typ": abstract, approval, cover, outlines, statement
#import "core/constants.typ" as const
#import "config.typ": *

#let project(doc) = {
  set document(
    title: title.at(lang),
    author: author.name,
  )
  set bibliography(style: "apa", title: const.bibliography.at(lang))
  set text(font: font, size: 12pt, lang: lang)
  set page(
    paper: "a4",
    margin: (
      left: 4cm,
      top: 4cm,
      right: 3cm,
      bottom: 3cm,
    ),
  )

  set figure(numbering: it => {
    let count = counter(heading.where(level: 1)).at(here()).first()
    if count != none { numbering("1.1", count, it) } else { numbering("1", it) }
  })
  show figure.where(kind: image): set figure.caption(position: bottom)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure: set block(breakable: true)

    }

  set outline.entry(fill: pad(left: 0.2cm, right: 0.6cm, repeat([.], gap: 0.4em)))
  show outline: set heading(outlined: true)
  show outline: set par(first-line-indent: 0pt)
  show outline.entry: it => {
    let el = it.element
    let is-top = el.func() == heading and el.level == 1

    v(if is-top { 1.5em } else { 0.8em }, weak: true)

    if is-top {
      show repeat: none
      strong(it)
    } else if el.func() == figure {
      show it.element.caption.at("supplement").text: none
      it
    } else {
      it
    }
  }

  cover()
  show heading: it => {
    if it.level > 1 {
      set text(size: 12pt)

      let display = counter(heading).display(it.numbering)
      let gap = (top: 0.85em, bottom: 0.15em)
      if it.level == 2 {
        gap = (top: 1.2em, bottom: 0.55em)
      } else if it.level == 3 {
        gap = (top: 1.05em, bottom: 0.35em)
      }

      v(gap.top)
      block(display + h(1em) + it.body)
      v(gap.bottom)
    } else {
      pagebreak(weak: true)

      set align(center)
      set text(weight: "bold", size: 14pt)

      let kinds = query(figure).map(fig => fig.kind).dedup()
      for kind in kinds { counter(figure.where(kind: kind)).update(0) }
      counter(math.equation).update(0)

      if it.numbering != none {
        let num = counter(heading).display(it.numbering)
        let prefix = const.chapter.at(lang)

        block(upper[#prefix #num\ #it.body])
        v(1.0em, weak: true)
      } else {
        block(upper(it.body))
        v(1.0em)
      }
    }
  }

  set page(numbering: "i")
  set heading(numbering: none)
  counter(page).update(2)

  [ = #const.approval.title.at(lang) ]
  approval()

  [ = #const.statement.title.at(lang) ]
  statement()

  set par(justify: true, first-line-indent: (amount: 2.5em, all: true), leading: 1em)

  doc
}
