#import "utils.typ": *

#let defaults = (
  meta: (
    project-group: "No group name provided",
    participants: (),
    supervisors: (),
    email: (),
    field-of-study: none,
    project-type: "Semester Project",
    note: none,
    uni: none,
    repository: none,
  ),
  en: (
    title: "Untitled",
    theme: none,
    abstract: none,
    department: "Department of Computer Science",
    department-url: "univ-evry.fr",
    personal-url:"",
  ),
  fr: (
    title: "Sans titre",
    theme: none,
    abstract: none,
    department: "Département d'informatique",
    department-url: "univ-evry.fr",
    personal-url:"",
  ),

)

#let project-lang = state("project-lang", "en")

#let mainmatter(skip-double: true, lang: auto, body) = context {
  // Use project language if lang is auto
  let effective-lang = if lang == auto { project-lang.get() } else { lang }

  //clear-page(skip-double)
  set page(numbering: "1", header: custom-header(lang: effective-lang), footer: custom-footer(
    <chapter>,
  ))
  counter(page).update(1)
  set par(first-line-indent: 0pt)
  // Enable figure numbering with section numbers even when heading numbering is off
  set figure(numbering: dependent-numbering("1.1"))
  set math.equation(numbering: dependent-numbering("(1.1)"))
  set-chapter-style(
    numbering: "1.1",
    name: none,
    double-page-skip: skip-double,
    lang: effective-lang,
    body,
  )
}

#let chapters(skip-double: true, lang: "en", body) = {
  let chapter-name = if lang == "fr" { "Chapitre" } else { "Chapter" }
  set-chapter-style(
    numbering: "1.1",
    name: chapter-name,
    double-page-skip: skip-double,
    lang: lang,
    body,
  )
}

#let backmatter(skip-double: true, lang: "en", body) = {
  set-chapter-style(
    numbering: "1.1",
    name: none,
    double-page-skip: skip-double,
    lang: lang,
    body,
  )
}

#let appendix(skip-double: true, lang: "en", body) = {
  let appendix-name = if lang == "fr" { "Annexe" } else { "Appendix" }
  set-chapter-style(
    numbering: "A.1",
    name: appendix-name,
    double-page-skip: skip-double,
    lang: lang,
    body,
  )
}

#let smallprint(size: 9pt, git-text: none, git-url: none, body) = {
  set text(size: size)
  set par(first-line-indent: 0pt, spacing: 0.5em)
  place(
    bottom + center,
    float: true,
    clearance: 2em,
    {
      if git-text != none and git-url != none {
        [#git-text #link(git-url)]
        if body != none {
          v(0.5em)
          body
        }
      } else if body != none {
        body
      }
    }
  )
}

// English Abstract page.
#let titlepage-en(meta, en) = {
  page(
    grid(
      columns: (1fr, 1fr),
      rows: (3fr, 7fr, 30pt),
      column-gutter: 10pt,
      image("/classic-evry-report/graphics/Logo_noir_centré.svg", width: 90%),
      align(right + horizon)[
        #strong(en.department)\
        Université Évry Paris-Saclay\
        #link("www." + en.department-url)[#en.department-url] \
        #link("https://" + en.personal-url)[#en.personal-url]
      ],

      grid(
        gutter: 16pt,
        //..info.filter(i => i != none)
      ),
      if en.abstract != none {
        [*Abstract:*\ #box(width: 100%, stroke: .5pt, inset: 4pt, en.abstract)]
      } else { [] },

      grid.cell(
        colspan: 2,
        text(size: 10pt)[
         // _The content of this report is freely available, but publication (with reference) may only be pursued due to agreement with the author._
        ],
      ),
    ),
  )
}




// French Abstract page.
#let titelside-fr(meta, fr) = {
  set text(lang: "fr")
  let info = (
    show-if-not-none(fr.title)[*Titre:*\ ],
    show-if-not-none(fr.theme)[*Thème:*\ ],
    show-if-not-none(meta.project-group)[*Groupe:*\ ],
    [*Participants:*\ #meta.participants.join("\n")],
    [*Email:*\ #meta.email.join("\n")],
    if type(meta.supervisors) == array [
      *Superviseurs:*\ #meta.supervisors.join("\n")
    ] else [
      *Superviseur:*\ #meta.supervisors
    ],
    [*Dépôt:*\ #meta.repository],
    //[*Copies:* 1],
    [*Nombre de pages:* \ #context counter(page).final().first()],
    [*Dernier changement:*\ #datetime.today().display("[day]-[month]-[year]")],
    if type(meta.note) == str [
      *Note*: \ #meta.note
    ] else [
      //nothing
    ],

  )
  page(
    grid(
      columns: (1fr, 1fr),
      rows: (3fr, 7fr, 30pt),
      column-gutter: 10pt,
      if meta.uni == "evry" {
        image("/classic-evry-report/graphics/Logo_noir_centré.svg", width: 90%)
      } else if meta.uni == "saclay" {
        image("/classic-evry-report/graphics/Logotype UPSaclay_NOIR.jpg", width: 90%)
      } else {
        []
      },
      align(right + horizon)[
      ],

      grid(
        gutter: 16pt,
        ..info.filter(i => i != none)
      ),
      if fr.abstract != none {
        [*Résumé:*\ #box(width: 100%, stroke: .5pt, inset: 4pt, fr.abstract)]
      } else { [] },

      grid.cell(
        colspan: 2,
        text(size: 10pt)[
         // _The content of this report is freely available, but publication (with reference) may only be pursued due to agreement with the author._
        ],
      ),
    ),
  )
  set text(lang: "en")
}

#let frontmatter(meta, primary-lang, en, en-is-set, fr, fr-is-set, clear-double-page, lang, body) = {
  // Front/cover page.
  page(
    background: if meta.uni == "evry" {
      image("/classic-evry-report/graphics/evry-waves.svg", width: 100%, height: 100%)
    } else if meta.uni == "saclay" {
      image("/classic-evry-report/graphics/saclay-waves.svg", width: 100%, height: 100%)
    } else {
      none
    },
    margin: auto,
    numbering: "1.1",
    grid(
      columns: 100%,
      rows: (50%, 20%, 30%),
      align(center + bottom, box(
        fill: if meta.uni == "evry" {
          theme-blue
        } else if meta.uni == "saclay" {
          theme-purple
        } else {
          none
        },
        inset: (x: 32pt, y: 26pt),
        radius: 6pt,
        width: 68%,
        clip: false,
        {
          set text(fill: white, 12pt)
          set par(justify: false)
          align(center)[
            #text(2em, weight: 600, primary-lang.title)
            #if primary-lang.theme != none [
              #v(6pt)
              #text(1.05em, style: "italic", fill: white.transparentize(15%), primary-lang.theme)
            ]
            #v(14pt)
            #line(length: 32%, stroke: 0.6pt + white.transparentize(55%))
            #v(14pt)
            #text(11pt, meta.participants.join(", ", last: " & "))
            #v(4pt)
            #text(8.5pt, tracking: 0.6pt, fill: white.transparentize(25%))[
              #upper(if meta.field-of-study != none [#meta.field-of-study -- ] else [])
              #upper(meta.project-group) -- #datetime.today().year()
            ]
            #v(12pt)
            #text(9pt, tracking: 1.2pt, weight: 500)[#upper(meta.project-type)]
          ]
        },
      )),
      none,
      align(center, if meta.uni == "saclay" {
        image("/classic-evry-report/graphics/Logotype UPSaclay_RVB.png", width: 40%)
      } else {
        image("/classic-evry-report/graphics/Logo_bleu_centré.svg", width: 25%)
      })
    ),
  )

  counter(page).update(1)

  // Colophon
  // page(align(bottom)[
  //   #set text(size: 10pt)
  //   #set par(first-line-indent: 0em)

  //   // Copyright #sym.copyright Aalborg University #datetime.today().year()\
  //   // #v(0.2cm)
  //   // This report is typeset using the Typst system.
  // ])

  if en-is-set {
    titlepage-en(meta, en)
  }

  if fr-is-set {
    if clear-double-page {
      clear-page(clear-double-page)
    }
    titelside-fr(meta, fr)
  }



  body
}

#let project(
  meta: (:),
  en: (:),
  fr: (:),
  lang: "en",
  is-draft: false,
  margins: (inside: 2.8cm, outside: 4.1cm),
  clear-double-page: false,
  font: "Libertinus Serif",
  body,
) = {
  let en-is-set = en != (:)
  let fr-is-set = fr != (:)
  meta = dict-merge(defaults.meta, meta)
  en = dict-merge(defaults.en, en)
  fr = dict-merge(defaults.fr, fr)
  let primary-lang = if en-is-set { en } else { fr }

  // Store the language in state for use by mainmatter
  project-lang.update(lang)
  // Store the university in state so the spiral() motif can match its colors
  project-uni.update(meta.uni)

  // Set the document's basic properties.
  set document(author: meta.participants, title: primary-lang.title)

  // Set document preferences, font family, heading format etc.
  // multiple fonts specify the default and a fallback
  set text(font: font, lang: lang)
  set par(first-line-indent: 0pt, spacing: 0.65em, justify: true)

  set figure(numbering: dependent-numbering("1.1"))
  set math.equation(numbering: dependent-numbering("(1.1)"))

  // spacing around enumerations and lists
  show enum: set par(spacing: .5cm) // spacing around whole list
  show list: set par(spacing: .5cm)
  set enum(
    indent: .5cm,
    spacing: .5cm,
  ) // indentation and spacing between elements
  set list(indent: .5cm, spacing: .5cm)

  show terms: set par(first-line-indent: 0pt, spacing: 1em)
  show quote: set pad(x: 2em)

  show link: it => if type(it.dest) == str {
    // external link
    underline(it)
  } else { it }

  show bibliography: set par(spacing: 1em)

  // Chapter styling (preface, outline etc)
  show heading.where(level: 1): it => {
    clear-page(clear-double-page)
    set par(first-line-indent: 0pt, justify: false)
    block({
      v(3cm)
      text(
        size: 24pt,
      )[#it.body <titlepages-chapter>] // label allows for header/footer to work properly
      v(.75cm)
    })
    iteration-page()
  }
  // style heading with spacing before and after + spacing between number and name
  show heading.where(level: 2): it => custom-heading(it, 10pt, 5pt)
  show heading.where(level: 3): it => custom-heading(it, 5pt, 3pt)
  set heading(outlined: false) // changed in frontmatter

  // can be customized with figure.where(kind: table) etc...
  show figure: f => pad(top: 5pt, bottom: 10pt, f)
  // bold the figure title and number
  show figure.caption: c => context {
    set text(10pt)
    strong[#c.supplement #c.counter.display(c.numbering)#c.separator]
    c.body
  }

  show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    strong(it)
  }

  if not is-draft {
    show: frontmatter.with(meta, primary-lang, en, en-is-set, fr, fr-is-set, clear-double-page, lang)
  }

  set page(footer: custom-footer(<titlepages-chapter>))

  body
}
