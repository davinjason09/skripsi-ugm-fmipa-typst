#import "@preview/icu-datetime:0.2.1" as icu
#import "@preview/transl:0.2.0": transl

#let unique(arr) = {
  arr.map(s => (s, none)).to-dict().keys()
}

#let merge(config, default) = {
  unique(config.keys() + default.keys())
    .map(k => {
      let cfg = config.at(k, default: none)
      let def = default.at(k, default: none)

      if cfg == none { return (k, def) }
      if def == none { return (k, cfg) }

      if type(cfg) == dictionary { cfg = merge(cfg, def) }
      (k, cfg)
    })
    .to-dict()
}

#let setup-transl(user-cfg) = {
  let db = (l10n: "ftl")
  let langs = ("id", "en")

  for l in langs {
    let content = read("../lang/" + l + ".ftl")
    let user-content = user-cfg.at(l, default: "")
    if type(user-content) != str { panic[User's transl extension must be a string (lang: #l)] }

    db.insert(l, content + user-content)
  }

  db
}

#let fmt-date(date, lang: "id") = {
  if type(date) == datetime {
    lang = if lang == "en" { "en-GB" } else { lang }
    icu.fmt(date, locale: lang, length: "long")
  } else {
    if date == "" { "Soon™" } else { date }
  }
}

#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  } else {
    ""
  }
}

#let display_pdf_or_page(pdf, page-type, fallback) = {
  if type(pdf) == content and pdf.func() == image {
    show heading: none
    context [ = #transl(page-type + "-heading", mode: str) ]
    page(background: pdf, paper: "a4")[]
    return
  }

  fallback
}

#let start-chapter(body) = {
  set heading(numbering: (..nums) => {
    let levels = nums.pos()
    if levels.len() == 1 {
      numbering("I", levels.at(0))
    } else {
      numbering("1.1", ..levels)
    }
  })

  body
}

#let end-chapter(body) = {
  set heading(numbering: none)
  body
}

#let start-appendix(body) = {
  counter(heading).update(1)
  show heading.where(level: 2): set heading(
    numbering: (..nums) => numbering("A.", nums.pos().last()),
  )

  show heading.where(level: 2): it => {
    let kinds = query(figure).map(fig => fig.kind).dedup()
    for kind in kinds { counter(figure.where(kind: kind)).update(0) }
    counter(math.equation).update(0)
    it
  }

  set figure(numbering: it => {
    let count = counter(heading).at(here()).at(1)
    numbering("A.1", count, it)
  })

  body
}

#let no-indent(body) = {
  set par(first-line-indent: 0em)
  body
}
