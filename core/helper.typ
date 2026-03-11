#import "@preview/icu-datetime:0.2.1" as icu

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
