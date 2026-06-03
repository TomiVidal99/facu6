
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
  set page(columns: 1)
  body
}

#project(
  title: "TP N°5 PLC",
  sub: "Instrumentación y Control Industrial",
  authors: (
    "Tomás Vidal (69854/4)",
    "Gende Agustín (72645/0)",
  ),
  date: "02 de Mayo de 2026",
)[

  = Tema elegido

  Se eligió el tema: *compresor neumático*, el cual consta de dos motores que se pueden automatizar con sensores de presión.

  = Explicación de los modos y su funcionamiento

  A continuación se explican cómo funcionan los modos

  == Modo de operación A

  En este modo de operación el *motor A* se automatiza para que regule la presión en un rango seleccionado con el sensor de presión, el motor se activa y desactiva para mantener el nivel de presión.

  == Modo de operación B

  Los motores *A* y *B* se activan intercaladamente con un periodo y ciclo de trabajo dado por los *timers 1 y 2*. Se pueden ajustar los valores de estos timers para cambiar el periodo y/o ciclo de trabajo.

  == Modo de operación C

  En este modo de operación *ambos motores* se activan y desactivan simultáneamente para regular un nivel de presión dentro de un rango.

  = Componentes empleados

  #align(center)[
    #figure(
      table(
        columns: (auto, auto),
        align: (center, center),

        [*NOMBRE*], [*DESCRIPCIÓN*],
        [START], [Pulsador que comienza la autoregulación de presión],
        [STOP], [Pulsador que detiene la autoregulación de presión],
        [RUN], [Luz que indica el encendido, además se emplea para controlar el activado y desactivado general],
        [SENSOR_PRESION], [Entrada que indica el estado de la presión],
        [PRESION_BAJA], [Activo si la presión es baja (por debajo del mínimo)],
        [PRESION_ALTA], [Activo si la presión es alta (por encima del máximo)],
        [A_SELECT], [Llave selectora del modo A],
        [B_SELECT], [Llave selectora del modo B],
        [C_SELECT], [Llave selectora del modo C],
        [TIMER_1], [Temporizador 1, que junto al 2 permiten el activado/desactivado de los *motores A y B*],
        [SALIDA_TIMER_1], [Salida del timer 1],
        [SALIDA_TIMER_2], [Salida del timer 2]
      ),
      caption: [Tabla de descripción de componentes],
      placement: top,
      supplement: "Tabla",
    )]

    #figure(
      image("screenshot_tp5.png", width: 52%),
      caption: [Screenshot del código funcionando],
      supplement: "Figura",
    )


  ]
