#import "core/helper.typ": to-roman
#import "core/pages.typ": approval, cover, outlines, statement
#import "core/constants.typ" as const
#import "config.typ": *

#let project(doc) = {
  set document(
    title: title.at(lang),
    author: author.name,
  )
  set bibliography(style: "apa", title: const.bibliography.at(lang))
  set text(font: "Times New Roman", size: 12pt, lang: lang)
  set page(
    paper: "a4",
    margin: (
      left: 4cm,
      top: 4cm,
      right: 3cm,
      bottom: 3cm,
    ),
  )

  show heading.where(level: 1): it => {
    pagebreak(weak: true)

    set align(center)
    set text(weight: "bold", size: 14pt)

    if it.numbering != none {
      let num = counter(heading).display(it.numbering)
      let prefix = const.chapter.at(lang)
      block[#upper(prefix) #num \ #upper(it.body)]
      v(1.5em, weak: true)
    } else {
      block[#upper(it.body)]
      v(1.5em, weak: true)
    }
  }

  show heading.where(level: 2): it => {
    set text(size: 12pt)
    v(0.5em)
    block[#counter(heading).display() #it.body]
    v(0.5em)
  }

  show outline: set heading(outlined: true)
  show outline: set par(first-line-indent: 0pt)
  show outline.entry: it => context {
    let el = it.element
    let fill = [#box(width: 1fr, it.fill) #it.page()]
    v(1em, weak: true)

    if el.func() == heading {
      let c = counter(heading).at(el.location())

      link(el.location(), if el.numbering != none {
        let num = numbering("1.", ..c)

        if el.level == 1 {
          num = int(numbering("1", ..c))
          let prefix = const.chapter.at(lang)
          strong[#prefix #to-roman(num) #el.body#fill\ ]
        } else {
          it
        }
      } else {
        strong(el.body + fill + "\n")
      })
    } else if el.func() == figure {
      let count = el.counter.at(el.location())
      let num = numbering("1", ..count)
      let head = counter(heading).at(el.location()).at(0)

      if el.kind == image or el.kind == table {
        link(el.location(), strong[#el.supplement #head.#num #el.caption.body#fill\ ])
      }
    } else {
      it
    }
  }

  show figure.where(kind: image): set figure.caption(position: bottom)
  show figure.where(kind: table): set figure.caption(position: top)

  cover()

  set page(numbering: "i")
  counter(page).update(1)

  [ = #const.approval.title.at(lang) ]
  approval()

  [ = #const.statement.title.at(lang) ]
  statement()

  set par(justify: true, first-line-indent: (amount: 2.5em, all: true), leading: 1em)

  doc
}
