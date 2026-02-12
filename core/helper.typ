#import "@preview/icu-datetime:0.2.1" as icu

#let to-roman(n) = {
  let map = (
    (1000, "M"),
    (900, "CM"),
    (500, "D"),
    (400, "CD"),
    (100, "C"),
    (90, "XC"),
    (50, "L"),
    (40, "XL"),
    (10, "X"),
    (9, "IX"),
    (5, "V"),
    (4, "IV"),
    (1, "I"),
  )

  let result = ""
  for (val, sym) in map {
    while n >= val {
      result += sym
      n -= val
    }
  }

  result
}

#let fmt-date(date) = {
  if type(date) == datetime {
    icu.fmt(date, locale: lang, length: "long")
  } else {
    if date == "" [Soon™] else { date }
  }
}
