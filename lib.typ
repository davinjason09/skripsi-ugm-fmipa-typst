#import "core/utils.typ": no-indent, to-string

#let thesis(
  doc: (
    type: "thesis",
    lang: "id",
    font: "Liberation Serif",
    code-font: "JetBrainsMonoNL NF",
    raw-font: "DejaVu Sans Mono",
    title: (
      id: "JUDUL BAHASA INDONESIA",
      en: "ENGLISH TITLE",
    ),
    author: (
      name: "STUDENT NAME",
      id: "xx/xxxxxx/xx/xxxxx",
    ),
    program: (
      name: "Ilmu Komputer",
      department: "Ilmu Komputer dan Elektronika",
      faculty: "Matematika dan Ilmu Pengetahuan Alam",
      degree: "Komputer",
    ),
    supervisor: "Supervisor Name",
    examiners: ("Examiner 1", "Examiner 2"),
    exam-date: "",
  ),
  pages: (
    approval: "",
    statement: "",
    preface: "",
    motto: "",
    outlines-kind: (image, table),
    abstract-id: "",
    abstract-en: "",
    keywords-id: (),
    keywords-en: (),
    bibliography: "",
    appendix: "",
  ),
  overrides: (
    display: (
      second-cover: false,
      approval: false,
      statement: false,
      preface: false,
      motto: false,
    ),
  ),
  misc: (
    transl: (:), /// <- dictionary of strings
  ),
  body,
) = {
  import "@preview/transl:0.2.0": transl
  import "core/utils.typ": (
    display_pdf_or_page, end-chapter, fmt-date, merge, setup-transl, start-appendix, start-chapter,
  )
  import "core/pages.typ": abstract, approval, cover, outlines, preface, statement
  import "core/defaults.typ": _defaults

  let _doc = merge(doc, _defaults.doc)
  let _display = merge(overrides.display, _defaults.overrides.display)
  let _pages = merge(pages, _defaults.pages)
  _doc.exam-date = fmt-date(_doc.exam-date, lang: _doc.lang)
  let conf = (doc: _doc, pages: _pages)

  let should-show = toggle => _doc.type == "thesis" or toggle

  let transl-db = setup-transl(misc.transl)
  transl(data: transl-db)

  set document(
    title: _doc.title.at(_doc.lang),
    author: _doc.author.name,
  )
  set text(font: _doc.font, size: 12pt, lang: _doc.lang, hyphenate: true)
  set bibliography(style: "apa", title: none)

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
  show raw.where(block: true): set text(font: _doc.code-font, size: 8.25pt)
  show raw.where(block: false): set text(font: _doc.raw-font, size: 10pt)
  set math.equation(numbering: it => {
    let count = counter(heading).at(here()).first()
    if count != none { numbering("(1.1)", count, it) } else { numbering("(1)", it) }
  })

  show ref: it => {
    let el = it.element
    let content = str(it.target)

    // TODO: harden this path, force figure, table, list, eq prefix when labelling
    if query(it.target).len() <= 0 and content.starts-with(regex("\\w{2,3}-")) {
      underline(stroke: (paint: red, thickness: 2pt, dash: "densely-dotted"), [undefined: \@#content])
      return
    }

    if el == none { return it }

    let loc = el.location()
    if el.func() == math.equation {
      let head-count = counter(heading).at(loc).first()
      let math-count = counter(math.equation).at(loc)
      link(loc)[#el.supplement #numbering("1.1", head-count, ..math-count)]
    } else if el.func() == heading {
      let prefix = transl(if el.level == 1 { "section" } else { "subsection" })
      link(loc)[#prefix #numbering(el.numbering, ..counter(heading).at(el.location()))]
    } else if el.func() == figure and el.kind == "algorithm" {
      let prefix = transl("algorithm")
      link(loc)[#prefix #numbering(el.numbering, ..counter(figure).at(el.location()))]
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

      let num = if it.numbering != none { counter(heading).display(it.numbering) } else { none }
      block(
        if num != none {
          upper[#transl("chapter") #num\ #it.body]
        } else {
          upper(it.body)
        },
      )
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

    let prefix = it.prefix()
    if el.func() == math.equation {
      prefix = to-string(prefix).match(regex("\\d+.\\d+")).text
    }

    let item = link(el.location(), it.indented(prefix, box(width: 1fr, entry-body)))

    if is-top {
      show repeat: none
      strong(item)
    } else if el.func() == figure and el.caption != none {
      show el.caption.at("supplement").text: none
      item
    } else {
      item
    }
  }

  if _pages.bibliography == "" { panic[Bibliography should not be empty!] }

  set page(numbering: none)
  cover(_doc)

  set page(numbering: "i")
  counter(page).update(2)

  if should-show(_display.second-cover) { cover(_doc) }
  if should-show(_display.approval) {
    display_pdf_or_page(_pages.approval, "approval", approval(_doc))
  }
  if should-show(_display.statement) {
    display_pdf_or_page(_pages.statement, "statement", statement(_doc))
  }
  if should-show(_display.preface and _pages.preface != "") { preface(conf) }
  if should-show(_display.motto and _pages.motto != "") { _pages.motto }

  outlines(kinds: _pages.outlines-kind)
  abstract(conf)
  abstract(conf, lang: "en")

  set par(
    justify: true,
    first-line-indent: (amount: 2.5em, all: true),
    leading: 1em,
    linebreaks: "optimized",
  )

  set page(numbering: "1")
  counter(page).update(1)

  show: start-chapter

  body

  show: end-chapter

  context [ = #transl("refs-title", mode: str) ]
  _pages.bibliography

  show: start-appendix
  if should-show(_pages.appendix != "") {
    context [ = #transl("appendix-title", mode: str) ]
    _pages.appendix
  }
}
