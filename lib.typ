#import "core/utils.typ": end-chapter, no-indent, start-chapter
#import "core/pages.typ": abstract, outlines

#let _defaults = (
  doc: (
    type: "proposal",
    lang: "id",
    font: "Liberation Serif",
    raw-font: "JetBrainsMonoNL NF",
    title: (
      id: "title-id",
      en: "title-en",
    ),
    author: (
      name: "John Doe",
      id: "xx/xxxxxx/xx/xxxxx",
    ),
    program: (
      name: "Ilmu Komputer",
      department: "Ilmu Komputer dan Elektronika",
      faculty: "Matematika dan Ilmu Pengetahuan Alam",
      degree: "Komputer",
    ),
    supervisor: (
      "Jane Doe"
    ),
    examiners: (
      "Examiner 1",
      "Examiner 2",
    ),
    exam-date: "",
  ),
  display: (
    second-cover: true,
    approval: true,
    statement: true,
  ),
)

#let thesis(
  doc: (:),
  display: (:),
  body,
) = {
  import "@preview/transl:0.2.0": transl
  import "core/utils.typ": merge, setup-transl
  import "core/pages.typ": approval, cover, statement

  doc = merge(doc, _defaults.doc)
  display = merge(display, _defaults.display)

  let should-show = toggle => doc.type == "thesis" or toggle
  state("doc").update(doc)

  let transl-db = setup-transl()
  transl(data: transl-db)

  context {
    set document(
      title: doc.title.at(doc.lang),
      author: doc.author.name,
    )
    set bibliography(style: "apa", title: transl("refs-title"))
    set text(font: doc.font, size: 12pt, lang: doc.lang, hyphenate: true)

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
      let count = counter(heading).at(here()).first()
      if count != none { numbering("1.1", count, it) } else { numbering("1", it) }
    })
    show figure.where(kind: image): set figure.caption(position: bottom)
    show figure.where(kind: table): set figure.caption(position: top)
    show figure.where(kind: raw): set figure.caption(position: bottom)
    show figure: set block(breakable: true)

    set raw(tab-size: 2)
    show raw: set text(font: doc.raw-font, size: 10pt)
    set math.equation(numbering: it => {
      let count = counter(heading).at(here()).first()
      if count != none { numbering("(1.1)", count, it) } else { numbering("(1)", it) }
    })

    show ref: it => {
      let el = it.element

      if el != none and el.func() == math.equation {
        let loc = el.location()
        let head-count = counter(heading).at(loc).first()
        let math-count = counter(math.equation).at(loc)
        link(loc)[#el.supplement #numbering("1.1", head-count, ..math-count)]
      } else {
        it
      }
    }

    show table.cell: cell => {
      set par(justify: true, leading: 0.6em)
      cell
    }

    show heading: it => {
      if it.level > 1 {
        set text(size: 12pt)

        let cnt = counter(heading).display(it.numbering)
        let spacing = (top: 0.85em, bottom: 0.15em)
        if it.level == 2 {
          spacing = (top: 1.2em, bottom: 0.55em)
        } else if it.level == 3 {
          spacing = (top: 1.05em, bottom: 0.35em)
        }

        v(spacing.top)
        block(cnt + h(1em) + it.body)
        v(spacing.bottom)
      } else {
        pagebreak(weak: true)
        set align(center)
        set text(weight: "bold", size: 14pt)

        let kinds = query(figure).map(fig => fig.kind).dedup()
        for kind in kinds { counter(figure.where(kind: kind)).update(0) }
        counter(math.equation).update(0)

        if it.numbering != none {
          let num = counter(heading).display(it.numbering)
          upper[#transl("chapter") #num\ #it.body]
        } else {
          upper(it.body)
        }
        v(1.0em, weak: it.numbering != none)
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

      let entry-body = {
        box(width: 100% - spacing, {
          it.body()
          box(width: 1fr, inset: (left: 0.2cm), it.fill)
        })
        sym.wj
        box(width: spacing, align(end, it.page()))
      }

      let item = link(el.location(), it.indented(
        it.prefix(),
        box(baseline: 100% - 0.65em, width: 1fr, entry-body),
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

    cover(doc)

    set page(numbering: "i")
    counter(page).update(2)

    if should-show(display.second-cover) { cover(doc) }
    if should-show(display.approval) { approval(doc) }
    if should-show(display.statement) { statement(doc) }

    set par(
      justify: true,
      first-line-indent: (amount: 2.5em, all: true),
      leading: 1em,
      linebreaks: "optimized",
    )

    body
  }
}
