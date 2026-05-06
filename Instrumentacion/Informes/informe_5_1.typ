// #align(center)[
//     #figure(
//       table(
//         columns: (auto, auto, auto, auto),
//         align: (center, center, center, center),
//         [*Fracción Tu*], [*n [rpm]*], [*P_u [kW]*], [*T_u = P_u / ω [N·m]*],
//
//         [0], [1471], [0.085], [0.552],
//         [1/4], [1460], [0.253], [1.655],
//         [2/4], [1436], [0.513], [3.411],
//         [3/4], [1413], [0.751], [5.075],
//         [4/4], [1383], [0.987], [6.815],
//       ),
//       caption: [Característica mecánica],
//       placement: top,
//       supplement: "Tabla",
//     )
//   ]

#let numEquations = counter("mycounter");
#context numEquations.step()

#let cmd(t) = text[
  #set text(font: "Verdana", fill: rgb("#4171ba"))
  _#raw(t, lang: "bash")_
]

#let lk(href, nombre) = text[
  #text(blue)[#link(href)[_#text(nombre)_]]
]

#let equation(equation) = {
  v(1em)
  block(width: 100%, inset: 0pt, {
    align(center)[
      $#equation$
    ]
    place(right, dx: -1em)[
      (#context numEquations.get().first())
    ]
  })
  context numEquations.step()
  v(1em)
}

#let project(title: "", sub: "", authors: (), date: none, body) = {
  // Set document metadata
  set document(author: authors.join(", "), title: title)
  set text(lang: "es")
  // IEEE page setup for US Letter (8.5in × 11in)
  set page(
    paper: "us-letter",
    margin: (top: 19mm, bottom: 25.4mm, left: 15.875mm, right: 15.875mm),
    columns: 2, // Enable two-column layout
    numbering: "1",
    number-align: center,
  )
  // Set text properties (IEEE uses 10pt for body text)
  set text(font: "Noto Sans", size: 10pt, lang: "en")
  // Configure headings (IEEE style: numbered, bold)
  set heading(numbering: "1.")
  show heading: it => [
    #set text(weight: "bold", size: 11pt)
    #it
    #v(0.5em)
  ]
  // Configure figures for IEEE style (9pt caption, centered images)
  show figure: it => [
    #set text(size: 9pt)
    #v(0.5em)
    #align(center)[
      #it.body
      #v(0.25em)
      #it.caption
    ]
    #v(0.5em)
  ]
  // Title page (single-column for title)
  set page(columns: 1) // Temporarily switch to single-column for title
  align(center)[
    #v(10em)
    #text(16pt, weight: "bold")[#title]
    #v(1em)
    #text(14pt, style: "italic")[#sub]
    #v(1em)
    // Render list of authors
    // #text(12pt)[#authors.join(", ")]
    #text(11pt)[#date]
    #v(1.5em)
    // Uniform image size (e.g., 80% of column width)
    #for author in authors {
      text(11pt, style: "italic")[#author]
      v(.1em)
    }

    #v(4em)
    #image("unlp_logo.png", width: 60%)

  ]
  // Switch back to two-column layout for the body
  set page(columns: 2)
  body
}

// Document content
#project(
  title: "Informe Trabajo Logix Pro",
  sub: "Instrumentación y control Industrial",
  authors: (
    "Tomás Vidal (69854/4)",
  ),
  date: "15 de Mayo de 2026",
)[

  = Tema elegido

  Se eligió el tema: compresor neumático, el cual consta de dos motores que se pueden automatizar.

  = Modo de operación A

  En este modo de operación el *motor A* se automatiza para que regule la presión en un rango seleccionado con el sensor de presión, el motor se activa y desactiva para mantener el nivel de presión.

  = Modo de operación B

  Este modo es prácticamente lo mismo que el *modo de operación A*, simplemente que sólo se activa el otro motor (B).

  = Modo de operación C

  En este modo de operación ambos motores se activan y desactivan simultáneamente para regular un nivel de presión dentro de un rango.

// #align(center)[
//     #figure(
//       table(
//         columns: (auto, auto, auto, auto),
//         align: (center, center, center, center),
//         [*Fracción Tu*], [*n [rpm]*], [*P_u [kW]*], [*T_u = P_u / ω [N·m]*],
//
//         [0], [1471], [0.085], [0.552],
//         [1/4], [1460], [0.253], [1.655],
//         [2/4], [1436], [0.513], [3.411],
//         [3/4], [1413], [0.751], [5.075],
//         [4/4], [1383], [0.987], [6.815],
//       ),
//       caption: [Característica mecánica],
//       placement: top,
//       supplement: "Tabla",
//     )
//   ]

]

