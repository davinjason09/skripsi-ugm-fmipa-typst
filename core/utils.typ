#import "@preview/icu-datetime:0.2.1" as icu

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

#let fmt-date(date) = {
  if type(date) == datetime {
    icu.fmt(date, locale: lang, length: "long")
  } else {
    if date == "" [Soon™] else { date }
  }
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

  set page(numbering: "1")
  counter(page).update(1)

  body
}

#let end-chapter(body) = {
  set heading(numbering: none)
  body
}

#let no-indent(body) = {
  set par(first-line-indent: 0em)
  body
}
