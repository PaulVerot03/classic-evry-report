# classic-evry-report

A Typst report template for Université Évry Paris-Saclay students.

This is a fork of [classic-aau-report](https://typst.app/universe/package/classic-aau-report), modified to fit my uni's colours and logos (Université Évry Paris-Saclay), for my personal use. 

## Local Installation
**Installation Instructions are eroneous, they will not work, i am fixing them**
Since this template is designed for local use with your Typst files located outside this directory, you'll need to install it as a local package.

### Method 1: Using the install script (recommended)

```bash
git clone <your-repo-url>
cd classic-evry-report
bash scripts/package "@local"
```

### Method 2: Manual installation

If the script doesn't work, install manually:

```bash
# Navigate to the template directory
cd classic-evry-report

# Create the local package directory
mkdir -p ~/.local/share/typst/packages/local/classic-evry-report/0.3.1

# Copy the necessary files
cp -r lib.typ src/ AAUgraphics/ ~/.local/share/typst/packages/local/classic-evry-report/0.3.1/
```

### Verifying installation

Check that the package is installed:

```bash
ls ~/.local/share/typst/packages/local/classic-evry-report/0.3.1/
```

You should see `lib.typ`, `src/`, and `AAUgraphics/` directories.

### Updating the package

After making changes to the template, re-run the installation command to update:

```bash
bash scripts/package "@local"
# OR manually copy files again
```

## Usage

In your Typst project (which can be anywhere on your system), import the template:

```typ
#import "@local/classic-evry-report:0.3.1": project, mainmatter, chapters, backmatter, appendix

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
  en: (
    title: "My  Project",
    theme: "Petri Net",
    abstract: [This is a brief summary of the project...],
  ),
  fr: (
    title: "Mon Projet ",
    theme: "Réseau de Petri",
    abstract: [Ceci est un bref résumé du projet...],
  ),
)

#show: mainmatter
#include "chapters/introduction.typ"

#show: chapters
#include "chapters/analysis.typ"
#include "chapters/implementation.typ"

#show: backmatter
#include "chapters/conclusion.typ"
#bibliography("references.bib", title: "References")

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

- `is-draft`: Set to `true` to skip frontmatter generation (default: `false`)
- `margins`: Page margins (default: `(inside: 2.8cm, outside: 4.1cm)`)
- `clear-double-page`: Clear to next odd page on chapters (default: `false`)
- `font`: Font family to use (default: `"Palatino Linotype"`)

## Show Rules

The template provides the following show rules to structure your document:

- **`mainmatter`**: Use for preface, introduction, and other front content (Arabic page numbering, no chapter numbers)
- **`chapters`**: Use for main content chapters (numbered as "Chapter 1", "Chapter 2", etc.)
- **`backmatter`**: Use for conclusion and similar sections (no chapter numbers)
- **`appendix`**: Use for appendices (numbered as "Appendix A", "Appendix B", etc.)

Each show rule accepts an optional `skip-double` parameter:
- `skip-double: true` (default): Skips to next odd page for chapters
- `skip-double: false`: Skips to next page only

Example:
```typ
#show: chapters.with(skip-double: false)
```

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
3. Reinstall the local package using `bash scripts/package "@local"`
4. Your changes will be available the next time you compile your Typst document

## Requirements

- Typst compiler version 0.13.0 or higher
- Font: Palatino Linotype (or modify the `font` parameter)
