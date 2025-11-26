#import "@preview/classic-aau-report:0.3.1": (
  appendix, backmatter, chapters, mainmatter, project,
)
#import "setup/macros.typ": *

// revision to use for add, rmv and change

// it is also possible to apply show rules to the entire project
// it is more or less a search and replace when applying it to a string.
// see https://typst.app/docs/reference/styling/#show-rules
// #show "naive": "naïve"
// #show "Dijkstra's": smallcaps

// Initialize acronyms / glossary
// See https://typst.app/universe/package/glossy for additional details.
#show: init-glossary.with(
  (
    PBL: "Problem Based Learning", // will automatically infer plurality
    web: (
      short: "WWW", // @web will show WWW
      long: "World Wide Web",
    ),
    LTS: (
      short: "LTS",
      long: "Labelled Transition System",
      plural: "LTSs", // override plural explicitly
    ),
  ),
  term-links: true,
) // terms link to the index

#show: project.with(
  meta: (
    project-group: "Master 1 CNS-SR",
    participants: (
      "Eudes KOKPATA, 20220808",
      "Paul VEROT, 20212888",
    ),
    supervisors: "M.Sobieraj",
    // supervisors: ("John McClane", "Hans Gruber"),
    //field-of-study: "CS",
    project-type: "Projet de semestre 7"
  ),

  fr: (
    title: "",
    theme: "Réseaux de Petri",
    abstract: [#lorem(50)],
  ),
)

// put anything here that is to be included in the frontmatter, (with roman page numbers)
// like a preface, if so desired
// = Preface
// #lorem(100)

#outline(depth: 2)

// show a list of current todos

// use `show: mainmatter.with(skip-double: false)` to omit double page skips
// the same syntax appylies to 'chapters', 'backmatter' and 'appendix'.
#show: mainmatter
#include "chapters/introduction.typ"

#show: chapters
#include "chapters/problem-analysis.typ"
#include "chapters/custom-macros.typ"

// in the backmatter, the chapter numbers are removed again
// show the references here, along with other backmatter content, like a list of acronyms
#show: backmatter
#include "chapters/conclusion.typ"

// the documentation for this package includes a few different themes
// or even allows you to use your own custom one
#glossary(title: "List of Acronyms")
#bibliography("references.bib", title: "References")

#show: appendix
#include "appendices/scripting.typ"
