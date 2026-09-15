#import "@preview/hydra:0.6.2": hydra

#let theme-blue = rgb("#003b69")

#let blue(body) = text(fill: rgb("#003b69"), body)

// courtesy of https://github.com/jbirnick/typst-headcount/blob/d796ab0294d608f9746f3609a71d80b9a93499b8/lib.typ
#let normalize-length(array, length) = {
  if array.len() > length {
    array = array.slice(0, length)
  } else if array.len() < length {
    array += (length - array.len()) * (0,)
  }

  return array
}

#let dependent-numbering(style, levels: 1) = n => context {
  let heading-numbers = counter(heading).get()
  if heading-numbers.len() > 0 and heading-numbers.first() > 0 {
    numbering(style, ..normalize-length(heading-numbers, levels), n)
  } else {
    // Fallback when heading counter is 0 or empty
    numbering("1", n)
  }
}


// courtesy of https://github.com/jneug/typst-tools4typst/blob/32f774377534339f7bd073133fded363cb4a200f/src/get.typ#L176-L196
// removed type() == "string" comparison
#let dict-merge(..dicts) = {
  if dicts.pos().all(v => std.type(v) == dictionary) {
    // if all-of-type("dictionary", ..dicts.pos()) {
    let c = (:)
    for dict in dicts.pos() {
      for (k, v) in dict {
        if k not in c {
          c.insert(k, v)
        } else {
          let d = c.at(k)
          c.insert(k, dict-merge(d, v))
        }
      }
    }
    return c
  } else {
    return dicts.pos().last()
  }
}

#let today = datetime.today()
#let summer = datetime(year: today.year(), month: 7, day: 1)
#let is-spring-semester = today < summer


// -------- Iteration motif: title-page fractal toggle --------
// Call `#spiral()` anywhere before your first heading to turn it on (or
// `#spiral(false)` to turn it back off). Each level-1 heading then gets
// its own title page with a Heighway dragon-curve motif -- built up one
// more generation (and slightly larger) with every chapter -- rendered
// with a radial gradient in the report's own blues (layout borrowed from
// the hei-synd-report cover, recolored to match theme-blue). Also an
// homage to the growing fractal illustrations opening each "Iteration" in
// Jurassic Park (2nd edition).

#let show-iterations = state("show-iterations", false)

#let spiral(value: true) = show-iterations.update(value)

// Turn sequence for an order-`depth` dragon curve, built by the standard
// doubling construction: seq(n) = seq(n-1) + "L" + flip(reverse(seq(n-1)))
#let dragon-turns(depth) = {
  let seq = ()
  for i in range(depth) {
    let flipped = seq.rev().map(t => if t == "L" { "R" } else { "L" })
    seq = seq + ("L",) + flipped
  }
  seq
}

// Walks the turn sequence on a unit grid (4 cardinal directions) to get
// the curve's vertices.
#let dragon-points(depth) = {
  let turns = dragon-turns(depth)
  let dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))
  let dir-idx = 0
  let x = 0
  let y = 0
  let points = ((0, 0),)
  for i in range(turns.len() + 1) {
    let (dx, dy) = dirs.at(dir-idx)
    x = x + dx
    y = y + dy
    points = points + ((x, y),)
    if i < turns.len() {
      dir-idx = if turns.at(i) == "L" {
        calc.rem(dir-idx + 1, 4)
      } else {
        calc.rem(dir-idx + 3, 4)
      }
    }
  }
  points
}

#let iteration-motif(n) = {
  // depth is capped so later chapters stay legible instead of turning
  // into an unreadable smudge; the canvas keeps growing a bit past that
  let depth = calc.clamp(n + 2, 3, 12)
  let size = calc.min(10cm, 4cm + (n - 1) * 0.5cm)

  let points = dragon-points(depth)
  let xs = points.map(p => p.at(0))
  let ys = points.map(p => p.at(1))
  let span = calc.max(calc.max(..xs) - calc.min(..xs), calc.max(..ys) - calc.min(..ys))
  let scale = size / span
  let min-x = calc.min(..xs)
  let min-y = calc.min(..ys)
  let scaled = points.map(p => (
    (p.at(0) - min-x) * scale,
    (p.at(1) - min-y) * scale,
  ))

  let grad = gradient.radial(
    rgb("#061320"),
    theme-blue,
    rgb("#1971c2"),
    rgb("#4dabf7"),
    rgb("#d0ebff"),
    center: (50%, 50%),
    radius: 75%,
    relative: "self",
  )

  box(width: size, height: size, curve(
    stroke: 0.45pt + grad,
    curve.move(scaled.at(0)),
    ..scaled.slice(1).map(p => curve.line(p)),
  ))
}

// This heading's index among all level-1 headings so far in the whole
// document, ignoring any per-section counter(heading) resets, so the
// motif keeps growing continuously across mainmatter/chapters/backmatter,
// including standalone headings outside those wrappers (e.g. a bare `=`
// with no mainmatter/chapters call).
//
// Note: outline()'s own title (e.g. "Contents") is itself a level-1
// heading, so it counts too and -- if #spiral() runs before #outline()
// -- would get swept into the motif treatment. Call #spiral() *after*
// #outline() to avoid that; see the starter template.
#let iteration-number(loc) = query(
  selector(heading.where(level: 1)).before(loc),
).len()

// Call from inside a level-1 heading show rule to append the growing
// motif and break to a fresh page, turning the heading into a title page.
#let iteration-page() = context {
  if show-iterations.get() {
    align(center, iteration-motif(iteration-number(here())))
    v(1cm)
    pagebreak(weak: true)
  }
}


#let is-chapter-page(chapter-label) = {
  let current = counter(page).get()
  return query(chapter-label).any(m => (
    counter(page).at(m.location()) == current
  ))
}

// only applies when pages are not roman numbered, thus no label argument
#let custom-header(name: none, lang: "en") = context {
  if not is-chapter-page(<chapter>) {
    let page-format = if lang == "fr" {
      "1 sur 1"
    } else {
      "1 of 1"
    }
    if calc.even(here().page()) [
      #counter(page).display(page-format, both: true)
      #h(1fr)
      #name #hydra(1)
    ] else [
      #hydra(2)
      #h(1fr)
      #counter(page).display(page-format, both: true)
    ]
  }
}



#let custom-footer(chapter-label) = context {
  // Don't show page numbers on chapter pages
  none
}

#let clear-page(skip-double) = {
  pagebreak(weak: true)
}


#let set-chapter-style(
  numbering: none,
  name: none,
  double-page-skip: true,
  lang: "en",
  body,
) = {
  set heading(numbering: numbering, outlined: true)
  set page(header: custom-header(name: name, lang: lang))
  counter(heading).update(
    0,
  ) // Reset the chapter counter (appendices start at A)
  // numbering of figures and equations - only override if numbering is set
  set figure(numbering: dependent-numbering(numbering)) if (
    numbering != none
  )
  set math.equation(numbering: dependent-numbering("(" + numbering + ")")) if (
    numbering != none
  )

  // references show chapter / appendix
  show heading.where(level: 1): set heading(supplement: name)

  show heading.where(level: 1): it => {
    clear-page(double-page-skip)

    // Increment heading counter for figure numbering even when numbering is none
    if numbering == none {
      counter(heading).step()
    }

    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    counter(math.equation).update(0)

    set par(first-line-indent: 0pt, justify: false)
    block({
      v(3cm)
      if name != none {
        // set chapter/appendix whatever if exists
        text(size: 18pt)[#it.supplement #counter(heading).display()]
        v(.5cm)
      }
      text(
        size: 24pt,
      )[#it.body <chapter>] // allow us to query this label to make header work properly
      v(.75cm)
    })
    // Typst's own outline()/bibliography()/glossary() each render their
    // own level-1 heading ("Contents", "References", ...) with an
    // explicit numbering: none, overriding the numbering set above --
    // real chapter/section headings resolve it to a real value. Skip
    // those so a reference list doesn't get its own fractal title page.
    if numbering == none or it.numbering != none {
      iteration-page()
    }
  }
  body // actually show what comes afterwards
}

#let custom-heading(it, p-top, p-bottom) = {
  if it.numbering == none {
    block(pad(top: p-top, bottom: p-bottom, it.body))
  } else {
    pad(top: p-top, bottom: p-bottom, grid(
      columns: (30pt, 1fr),
      counter(heading).display(it.numbering), it.body,
    ))
  }
}

#let show-if-not-none(val, name) = {
  if val != none [#name #val]
}

#let use-roman-numbering() = {
  set page(numbering: "I")
}

#let use-arabic-numbering() = {
  set page(numbering: "1")
}

#let custom-outline(lang: "en", title: auto, ..args) = {
  let outline-title = if title == auto {
    if lang == "fr" { "Table des matières" } else { "Contents" }
  } else {
    title
  }

  outline(
    title: outline-title,
    ..args
  )
}