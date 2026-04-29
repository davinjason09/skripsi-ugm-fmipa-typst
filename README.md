# Thesis Template for FMIPA UGM in Typst

A Typst thesis/proposal template for FMIPA UGM, converted from the original [LaTeX template](https://github.com/muhrifqii/skripsi-fmipa-ugm-latex/).

The document entry point is `main.typ`. Most of the metadata you will change lives there, while the actual thesis content is organized in the `chapter/` directory.

## Why Typst?

- Fast incremental compilation
- Simpler syntax than LaTeX for daily writing
- Better scripting support for reusable document logic
- Modern, reliable output

## Repository layout

```txt
.
├── assets/              -- Images and other assets
│   └── logougm.png      -- UGM logo used by the cover page
├── chapter/             -- Your thesis content files (preface, abstracts, chapters)
├── core/                -- Internal template logic
│   ├── pages.typ        -- Front-matter page generation (cover, approval, etc.)
│   └── utils.typ        -- Utility helpers and translation loaders
├── lang/                -- Translation files (Fluent format)
│   ├── en.ftl           -- English labels
│   └── id.ftl           -- Indonesian labels
├── lib.typ              -- Main template logic and defaults
├── main.typ             -- Main entrypoint
└── ref.bib              -- Bibliography database
```

## Prerequisites

### 1. Install Typst

Install Typst locally by following the official [installation guide](https://github.com/typst/typst#installation).

### 2. Install Fonts

The template is configured to use these fonts by default:

- **Text**: `Liberation Serif`
- **Code**: `JetBrainsMonoNL NF`

If those fonts are not installed, Typst will substitute other available fonts from your system.

Check your installed fonts with:

```bash
typst fonts
```

## Quick Start

After creating a repository from this template or cloning it:

1. Edit the `doc: (...)` block in `main.typ`.
2. Replace content in the `chapter/` folder.
3. Compile the document:

```bash
# Build once
typst compile main.typ

# Rebuild automatically while you write
typst watch main.typ --open
```

## Template Usage

### 1. Configure `main.typ`

The `#show: thesis.with(...)` call in `main.typ` sets up your document metadata. You only need to provide the keys you want to override, as the template merges your input with defaults defined in `lib.typ`.

The helper functions used throughout this template—such as `thesis`, `abstract`, `outlines`, `start-chapter`, and `end-chapter`—are provided by `lib.typ`, which `main.typ` already imports.

> [!IMPORTANT]
> By default, the template will take care of the main cover, title page, approval page, and statement page. The placement for pages like preface and outline is determined by the user.

#### Important `doc` keys:

- `type`: `"proposal"` or `"thesis"`.
- `lang`: `"id"` or `"en"`.
- `font` and `raw-font`: your preferred fonts.
- `title`: dictionary with `id` and `en` keys.
- `author`: dictionary with `name` and `id` (student ID).
- `program`: dictionary with `name`, `department`, `faculty`, and `degree`.
- `supervisor`: one or two supervisor names.
- `examiners`: at least two examiner names.
- `exam-date`: a string or `datetime` object. Use `""` for a placeholder.

Example setup:

```typst
#show: thesis.with(
  doc: (
    type: "thesis",
    lang: "id",
    title: (
      id: "Judul Skripsi Saya",
      en: "My Thesis Title",
    ),
    author: (
      name: "Nama Lengkap",
      id: "24/123456/PA/12345",
    ),
  ),
)
```

### 2. Organizing Content

`main.typ` serves as the outline. Use `#include` to pull in files from the `chapter/` directory.

- **Level-1 Headings**: Define these in `main.typ` (e.g., `= PENDAHULUAN`).
- **Chapter Content**: Use level-2 headings and below in your chapter files (e.g., `== Latar Belakang`).
- **Abstracts**: Use the `#abstract(...)` function in your abstract files.

```typst
// chapter/abstract_id.typ
#import "../lib.typ": abstract

#abstract(
  lang: "id",
  keywords: ("Kata", "Kunci"),
  [Isi intisari di sini...]
)


```

#### Default configuration:

```typ
#let _defaults = (
  doc: (
    type: "thesis",
    lang: "id",
    font: "Liberation Serif",
    raw-font: "JetBrainsMonoNL NF",
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
    supervisor: (
      "Supervisor Name"
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
```

### 3. Chapter Flow

- **`#outlines()`**: Generates the Table of Contents, List of Figures, and List of Tables.
- **Optional outline kinds**: If you also want a list of code listings, use `#outlines(kinds: (image, table, raw))`.
- **`#show: start-chapter`**: Switches page numbering to Arabic, resets the page counter to `1`, and enables chapter-based numbering for figures and equations. Call this before your first main chapter.
- **`#show: end-chapter`**: Disables heading numbering. Useful for the Bibliography or Appendix sections.

### 4. Bibliography

Add your entries to `ref.bib`. Cite them in your text using `@citekey` for the default format `(name, year)`. The template uses APA style by default.

```typst
#bibliography("ref.bib")
```

More information about citing is available [here](https://typst.app/docs/reference/model/cite/).

### 5. Customize Built-in Labels in `lang/`

Labels like "Bab", "Daftar Pustaka", "Halaman Pengesahan", and the outline titles are managed in `lang/id.ftl` and `lang/en.ftl`. These files use the Fluent format via the `transl` package.

Edit `lang/*.ftl` when you want to change wording without changing template behavior. Common keys to customize are:

- `chapter`
- `refs-title`
- `outline-main`, `outline-image`, `outline-table`, `outline-raw`, `outline-equation`
- `cover-heading`, `approval-heading`, `statement-heading`
- `abstract-by`, `abstract-keyword`

Example:

```ftl
# lang/id.ftl
outline-main = DAFTAR ISI
outline-raw = DAFTAR KODE
refs-title = DAFTAR PUSTAKA
```

Best practices for editing translation files:

- keep the same message keys in both `lang/id.ftl` and `lang/en.ftl`
- keep placeholder variables unchanged unless you also update the template code, for example `{ $name }`, `{ $degree }`, and `{ $date }`
- use `lang/*.ftl` for wording changes, and use `core/pages.typ` or `lib.typ` only when you want to change behavior or layout

### 6. Customize `#outlines()`

By default, `#outlines()` generates:

- the table of contents
- the list of figures
- the list of tables

If you also want a list of code listings, call it like this:

```typst
#outlines(kinds: (image, table, raw))
```

### 7. Customize Template Behavior

If you want to change the template-wide default behavior, edit the `#let outlines(kinds: (image, table)) = { ... }` function in `core/pages.typ`.

As a rule of thumb:

- change `lang/*.ftl` if you only want different titles or terms
- change `core/pages.typ` if you want different cover, layout, etc.
- keep all styling inside of `lib.typ`, inside of the `thesis` function.
- keep `main.typ` as the single compile target even if you customize template internals.

### 7. Best Practices

- Use consistent label prefixes:
  - `fig:` for figures
  - `tab:` for tables
  - `eq:` for equations
  - `sec:` for sections
  - `lst:` for code listings
- Keep labels lowercase and stable, for example `fig:system-architecture`, `tab:dataset-summary`, or `eq:loss-function`.
- Reference labels with Typst references such as `@fig:system-architecture`.
- Keep wording changes in `lang/*.ftl`, and keep structure/layout changes in `core/pages.typ` or `lib.typ`.
- Update both `lang/id.ftl` and `lang/en.ftl` together so translation keys do not drift apart.

Example figure label:

```typst
#figure(
  image("assets/diagram.png", width: 80%),
  caption: [System architecture],
) <fig:system-architecture>

As shown in @fig:system-architecture, ...
```

### 8. Display Overrides

You can toggle specific front-matter pages. This is mainly useful for proposals:

```typst
#show: thesis.with(
  doc: (
    type: "proposal",
  ),
  display: (
    second-cover: true,
    approval: false,
    statement: false,
  )
)
```

> [!IMPORTANT]
> For `type: "thesis"`, the template always shows the second cover, approval page, and statement page. The `display` toggles mainly affect `type: "proposal"`.

## Editor Setup

### Neovim

For Neovim, the most practical setup is Tinymist as the language server plus your usual LSP plugin such as [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig/blob/master/lsp/tinymist.lua).

1. Install `tinymist` first, for example through Mason, Cargo, or your system package manager.
2. Open `main.typ` and trigger the pin-main mapping once per Neovim session. This tells Tinymist that `main.typ` is the entry file for the included files in `chapter/`.
3. If you want live preview inside a browser, use [`chomosuke/typst-preview.nvim`](https://github.com/chomosuke/typst-preview.nvim) with `tinymist` installed.
4. If you prefer a simpler workflow, keep `typst watch main.typ --open` running in a terminal while editing.

> [!IMPORTANT]
> The pinned main file is session-local, so after restarting Neovim you should open `main.typ` and pin it again before working in the chapter files.

If you want a concrete real-world example, you can also look at these Neovim configuration files:

- [`after/ftplugin/typst.lua`](https://github.com/davinjason09/dotfiles/blob/main/home/dot_config/nvim/after/ftplugin/typst.lua)
- [`lua/lang/typst.lua`](https://github.com/davinjason09/dotfiles/blob/main/home/dot_config/nvim/lua/lang/typst.lua)
- [`lsp/tinymist.lua`](https://github.com/davinjason09/dotfiles/blob/main/home/dot_config/nvim/lsp/tinymist.lua)

### Helix

Helix works well with Tinymist too, but multi-file projects like this one need a small project-local configuration so the language server knows that `main.typ` is the entry point.

First, install `tinymist`. If you want format-on-save, also install `typstyle`.

Global Helix configuration in `~/.config/helix/languages.toml`:

```toml
[language-server.tinymist]
command = "tinymist"

[[language]]
name = "typst"
language-servers = ["tinymist"]
formatter = { command = "typstyle" } # optional
auto-format = true
```

Then add a project-local file at `.helix/languages.toml` in the repository root:

```toml
[language-server.tinymist.config]
typstExtraArgs = ["main.typ"]
```

That project-local file is what makes diagnostics, references, and completion work correctly when you edit files inside `chapter/`.

If you want live browser preview from Tinymist, add the preview options under the same `[language-server.tinymist]` section instead of creating a second one:

```toml
[language-server.tinymist]
command = "tinymist"
config = { preview.background.enabled = true, preview.background.args = ["--data-plane-host=127.0.0.1:0", "--open"] }
```

If you do not want browser preview, the simpler fallback is still `typst watch main.typ --open` in a terminal.

To verify that Helix sees the language server correctly, run:

```bash
hx --health typst
```

Important caveat: only files reachable from `main.typ` get full Typst language features, so keep the `.helix/languages.toml` file in the project root and point it at the actual compile target.

### VS Code / VSCodium + Tinymist

The recommended environment is VS Code or VSCodium with the [**Tinymist** extension](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist).

1. **Live Preview**: Open `main.typ` and run the `Typst Preview` command.
2. **Multi-file Support**: Since this project uses multiple files, you should **pin** the main entrypoint. Open `main.typ` and run the `Typst Pin Main` command. This ensures that the preview remains on your thesis even when you are editing files in the `chapter/` folder.
   - _Note_: Pinning does not persist between VS Code sessions. You'll need to re-pin when restarting.
3. **Advanced Workflow**: If you want a persistent multi-file setup, set `tinymist.projectResolution` to `"lockDatabase"` and run `tinymist compile --save-lock main.typ` once. Tinymist will then remember the project root through the generated lock file.
4. **Formatting**: You can optionally use [**Typstyle**](https://github.com/Enter-tainer/typstyle) for consistent formatting, for example through Tinymist's formatter integration.

### Manual Workflow

If you prefer other editors, keep the `typst watch main.typ` command running in a terminal to see changes as you save.

## Important Notes

- Do not remove `assets/logougm.png`.
- The template handles Roman (front matter) and Arabic (chapters) page numbering automatically through `#show: start-chapter`.
- Do not remove `#show: end-chapter` if you want the bibliography and attachment section to stay unnumbered.
- `main.typ` is the single compile target for this repository.
- Generated PDFs such as `main.pdf` are local build artifacts and are ignored by Git.
- Only compile projects you trust.

## License

This project is licensed under the MIT License.
