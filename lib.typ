#import "core/utils.typ": start-chapter
#import "core/pages.typ": abstract, approval, cover, outlines, statement
#import "core/constants.typ" as const
#import "config.typ": *

#let project(
  display: (
    second-cover: true,
    approval: true,
    statement: true,
  ),
  doc,
) = {
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

  set raw(tab-size: 2)
  show raw: set text(font: raw-font, size: 10pt)
  set math.equation(numbering: it => {
    let count = counter(heading.where(level: 1)).at(here()).first()
    if count != none { numbering("(1.1)", count, it) } else {
      numbering("(1)", it)
    }
  })

  show ref: it => {
    let el = it.element

    if el != none and el.func() == math.equation {
      let loc = el.location()
      let head-count = counter(heading.where(level: 1)).at(loc).first()
      let math-count = counter(math.equation).at(loc)
      link(loc)[#el.supplement #numbering("1.1", head-count, ..math-count)]
    } else {
      it
    }
  }

  show table.cell: cell => {
    set par(justify: true, linebreaks: "simple", leading: 0.9em)
    cell
  }

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

  set outline.entry(fill: repeat([.], gap: 0.4em))
  show outline: set heading(outlined: true)
  show outline: set par(first-line-indent: 0pt)
  show outline.entry: it => {
    let el = it.element
    let is-top = el.func() == heading and el.level == 1
    let spacing = 0.8cm

    v(if is-top { 1.5em } else { 0.8em }, weak: true)

    let body = {
      box(width: 100% - spacing, {
        it.body()
        box(width: 1fr, inset: (left: 0.2cm), it.fill)
      })
      sym.wj
      box(width: spacing, align(end, it.page()))
    }

    let item = link(el.location(), it.indented(
      it.prefix(),
      box(baseline: 100% - 0.65em, width: 1fr, body),
    ))

    if is-top {
      show repeat: none
      strong(item)
    } else if el.func() == figure {
      show it.element.caption.at("supplement").text: none
      item
    } else {
      item
    }
  }

  cover(force-thesis: display.second-cover)

  set page(numbering: "i")
  counter(page).update(2)

  if display.second-cover {
    set page(
      footer: none,
      header: context { align(right, counter(page).display()) },
    )
    show heading: none

    [= HALAMAN JUDUL]
    cover()
  }

  if display.approval {
    set page(footer: none)

    [ = #const.approval.title.at(lang) ]
    approval()
  }

  if display.statement {
    [ = #const.statement.title.at(lang) ]
    statement()
  }

  set par(
    justify: true,
    first-line-indent: (amount: 2.5em, all: true),
    leading: 1em,
    linebreaks: "optimized",
  )

  doc
}
