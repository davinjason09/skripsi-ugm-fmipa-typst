// The type of the document ("proposal" | "thesis")
#let doc-type = "proposal"

// An ISO 639-1/2/3 language code ("id" | "en")
#let lang = "id"

// Document Font (pick one of these 3, make sure the font is installed in your system)
#let font = "Liberation Serif"
// #let font = "Times New Roman"
// #let font = "Calibri"

// Raw Font (used for quotes and codeblocks, make sure the font is installed in your system)
#let raw-font = "JetBrainsMonoNL NF"
// #let raw-font = "DejaVu Sans Mono" // default

// Your Thesis title, in 2 languages, Indonesian and English
#let title = (
  id: "title-id",
  en: "title-en",
)

// You can also use content instead of string:
// #let title = (
//   id: [title-id],
//   en: [title-en],
// )

// The name and id of the author
#let author = (
  name: "John Doe",
  id: "xx/xxxxxx/xx/xxxxx",
)

// Bachelor degree details
// name      : The degree you're pursuing
// department: The department your degree falls into
// faculty   : The faculty's name
#let program = (
  name: "Ilmu Komputer",
  department: "Ilmu Komputer dan Elektronika",
  faculty: "Matematika dan Ilmu Pengetahuan Alam",
)

// List of examiners (at least 1)
// The order determines who the main supervisor is
#let supervisor = (
  "Jane Doe"
)

// List of examiners (at least 2)
// The first examiner automatically become the chief examiner
// The second examiner automatically become the examiner member
#let examiners = (
  "Examiner 1",
  "Examiner 2",
)

// Your exam date
// Possible values:
// - datetime object (e.g. `datetime.today()`)
// - string
//
// empty string will be automatically changed to Soon™
#let exam-date = ""
