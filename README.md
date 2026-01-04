# classic-evry-report
This is a fork of [classic-aau-report](https://typst.app/universe/package/classic-aau-report), modified to fit my uni's colours and logos (Université Évry Paris-Saclay), for my personal use. 


# Installation


```bash
# Download the repository and place it wherever conveniant 
git clone https://github.gom/PaulVerot03/classiv-evry-report.git

# Either make a full copy or a symlink into your working directory
ln -s /wherever/this/might/be/classic-evry-report/ classic-evry-report

```
Recommended if you wnat to use this regularly: 
make script to do it automaticaly
```bash
setup-typst(){
	TEMPLATE_DIR="~/Documents/classic-evry-report"
	TARGET_DIR="${1:-.}"

	if [ ! -d "$TARGET_DIR" ]; then
	    echo "Error: Directory $TARGET_DIR does not exist"
	    exit 1
	fi

	cd "$TARGET_DIR" || exit 1

	if [ -e "classic-evry-report" ]; then
	    echo "classic-evry-report already exists in this directory"
	    exit 0
	fi

	ln -s "$TEMPLATE_DIR" classic-evry-report
  cp ~/Documents/main.typ "$TARGET_DIR"
	echo "Created symlink to classic-evry-report template"
	echo "You can now use: #import \"classic-evry-report/lib.typ\": ..."
```
I appended this into my `.bashrc` so that it creates a symlink and copies a example file when I use the `setup-typst` command 



## Usage

In your Typst project (which can be anywhere on your system), import the template:

```typ
#import "classic-evry-report/lib.typ": (
  appendix, backmatter, chapters, mainmatter, project, smallprint,
)
#import "classic-evry-report/template/setup/macros.typ": *

#show: project.with(
  meta: (
    project-group: "M1 Informatique",
    participants: (
      "Alice Dupont",
      "Bob Martin",
    ),
    supervisors: "Dr. Marie Curie",
    field-of-study: "Computer Science",
    project-type: "Semester Project",
  ),
  fr: (
    title: "Mon Projet",
    theme: "Réseau de Petri",
    abstract: [Ceci est un bref résumé du projet...],
  ),
  lang: "fr",  // Set document language (affects page numbering, etc.)
)

#outline(depth: 2)

#show: mainmatter  // Language auto-inherited from project
#include "chapters/introduction.typ"

#show: chapters
#include "chapters/analysis.typ"
#include "chapters/implementation.typ"

#show: backmatter
#include "chapters/conclusion.typ"
#bibliography("references.bib", title: "Références")

#show: appendix
#include "appendices/code.typ"
```

## Configuration Options

### `meta`: Project Metadata

- `project-group`: Project group identifier (default: `"No group name provided"`)
- `participants`: Array of participant names (default: `()`)
- `supervisors`: Supervisor name or array of names (default: `()`)
- `field-of-study`: Field of study (default: `none`)
- `project-type`: Type of project (default: `"Semester Project"`)

### `en`: English Language Settings

- `title`: Project title (default: `"Untitled"`)
- `theme`: Project theme/subtitle (default: `none`)
- `abstract`: English abstract content (default: `none`)
- `department`: Department name (default: `"Department of Computer Science"`)
- `department-url`: Department URL (default: Évry CS department URL)

### `fr`: French Language Settings

- `title`: Project title in French (default: `"Sans titre"`)
- `theme`: Project theme/subtitle in French (default: `none`)
- `abstract`: French abstract content (default: `none`)
- `department`: Department name in French (default: `"Département d'informatique"`)
- `department-url`: Department URL (default: Évry CS department URL)

**Note:** You can omit the `fr` parameter entirely to create an English-only document, or omit `en` for a French-only document.

### Other Options

- `lang`: Document language - `"en"` or `"fr"` (default: `"en"`)
  - Sets the language for page numbering format ("X of Y" vs "X sur Y")
  - Automatically inherited by `mainmatter`, `chapters`, `backmatter`, and `appendix`
- `is-draft`: Set to `true` to skip frontmatter generation (default: `false`)
- `margins`: Page margins (default: `(inside: 2.8cm, outside: 4.1cm)`)
- `clear-double-page`: Clear to next odd page on chapters (default: `false`)
- `font`: Font family to use (default: `"Libertinus Serif"`)

## Show Rules

The template provides the following show rules to structure your document:

- **`mainmatter`**: Use for preface, introduction, and other front content (Arabic page numbering, no chapter numbers)
  - Automatically uses the language set in `project.with(lang: ...)`
  - Figures are numbered as section_number.figure_number (e.g., 1.1, 1.2, 2.1)
- **`chapters`**: Use for main content chapters (numbered as "Chapter 1" or "Chapitre 1", etc.)
- **`backmatter`**: Use for conclusion and similar sections (no chapter numbers)
- **`appendix`**: Use for appendices (numbered as "Appendix A" or "Annexe A", etc.)

Each show rule accepts optional parameters:
- `skip-double`: `true` (default) skips to next odd page for chapters, `false` skips to next page only
- `lang`: Override the document language for this section (defaults to auto-inherit from `project`)

Examples:
```typ
#show: mainmatter.with(skip-double: true)  // lang auto-inherited from project
#show: chapters.with(skip-double: false, lang: "fr")  // Override language
```

## Compiling 
To compile to a PDF file, run `typst compile 'your_file'.typ`

## Example Project Structure

```
my-project/
├── main.typ
├── references.bib
├── chapters/
│   ├── introduction.typ
│   ├── analysis.typ
│   └── conclusion.typ
└── appendices/
    └── code.typ
```

## Customizing the Template

To modify the template itself:

1. Clone this repository
2. Make your edits to files in the `src/` directory
3. Your changes will be available the next time you compile your Typst document if you went with the symlink

## Requirements

- Typst compiler version 0.13.0 or higher
- Font: Libertinus Serif (included with most Typst installations)
  - Alternative: modify the `font` parameter in `project.with()` to use any available font