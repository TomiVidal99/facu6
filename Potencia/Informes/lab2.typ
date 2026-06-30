  // #figure(
  //   image("Imagenes/modeloMAT.png", width: 100%),
  //   caption: [Modelo de la máquina asincrónica trifásica],
  //   supplement: "Figura",
  // )
  
  // #equation($s_m = R_2/sqrt(R_"th"^2 + (X_"th" + X_2)^2), "(forma típica)"$)

  // #align(center)[
  //   #figure(
  //     table(
  //       columns: (auto, auto, auto, auto, auto, auto, auto),
  //       align: (center, center, center, center, center, center, center, center),

  //       [*Fracción $T_u$*], [*$P_u$[kW]*], [*$P_e$ [kW]*], [*$#math.eta$ [%]*], [*$f_p$*], [*_s_ [%]*], [*I [A]*],

  //       [0], [0.085], [0.51], [16.7], [0.056], [1,93], [2.4],
  //       [1/4], [0.255], [0.86], [29.7], [0.089], [2,67], [2.8],
  //       [2/4], [0.525], [1.5], [35.0], [0.123], [4,27], [3.2],
  //       [3/4], [0.796], [2.06], [38.6], [0.143], [5,8], [3.8],
  //       [4/4], [1.107], [2.76], [40.1], [0.151], [7,8], [4.8],
  //     ),
  //     caption: [Parámetros de funcionamiento],
  //     placement: top,
  //     supplement: "Tabla",
  //   )
  // ]

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
  set text(font: "Times New Roman", size: 10pt, lang: "es")
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
  set footnote.entry(clearance: 8em)
  // set footnote.entry(breakeable: true)
  // Switch back to two-column layout for the body
  set page(columns: 2)
  body
}

#project(
  title: "Laboratorio N°2",
  sub: "Electrónica de potencia",
  authors: (
    "Tomás Vidal (69854/4)",
    "Mateo Natale (75316/9)",
    "Santiago Barbero (74165/7)",
    "Ignacio Nahuel Chantiri (69869/1)",
    "Juan Pablo Jouanny (71310/4)",
    "Mariano López Lastra (65682/4)",
  ),
  date: "19 de Mayo de 2026",
)[

  = Introducción

  = Marco Teórico

  = Resultados

  #align(center)[
    #figure(
      table(
        columns: (auto, auto, auto, auto, auto),
        align: (center, center, center, center),
        
        [*C_n*], [*C_i [V]*], [*Velocidad sin torque [rpm]*], [*Velocidad con torque [rpm]*], [*$#math.tau$*],
        [], [], [], [], [],
        [], [], [], [], [],
        [], [], [], [], [],
        [], [], [], [], [],
      ),
      caption: [Mediciones obtenidas],
      placement: top,
      supplement: "Tabla",
    )
  ]

  = Respuestas

  == 1
  #figure(
    image("Imagenes2/bloques_completo.png", width: 100%),
    caption: [Diagrama en bloques del sistema completo],
    supplement: "Figura",
  )

  #figure(
    image("Imagenes2/lazo_w.png", width: 100%),
    caption: [Lazo de control de velocidad],
    supplement: "Figura",
  )

  En este lazo de control, se realimenta un conteo de vueltas *n* (proveniente del tacómetro) que luego pasa por un VCO, que posee una constante $K_n = (-3 "mV") / "rpm"$ (hay que notar el símbolo de negativo, que es importante para después); esta tensión es entonces sumada a la tensión *Ref*, puesto que la topología del OPAMP es sumador de tensiones, y como la entrada no inversora está a tierra, entonces la transferencia del bloque será:

  #equation($ V_"ow"/n = (R_6  K_n )/ (R_2 (1-a)) (1 + 1/( s R_6 C )) $)

  _*a* es para representar el porcentaje del potenciómetro._


  == 2 
  == 3 
  == 4 

]
