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
  title: "Informe Trabajo caudalímetros",
  sub: "Instrumentación y control Industrial",
  authors: (
    "Tomás Vidal (69854/4)",
  ),
  date: "6 de Mayo de 2026",
)[

  = Tema

  Se eligió el tema: *sensor de nivel por presión diferencial*. 

  = Preguntas

  1. ¿Se puede usar el transmisor de presión Rosemount 3051S para medir nivel de líquido en un tanque, donde el rango de presiones puede variar entre 0 y 2 bar?

  2. De ser factible, determine cómo debería configurarse si el tanque está presurizado sin ventilación (cuántos transmisores y ubicados dónde), el alcance (o span), información sobre linealidad, exactitud y precisión, y si puede enviar los datos de manera inalámbrica. Además, a qué precio se consigue y si tiene proveedores locales.

  3. ¿Y el SITRANS PDS III/P410 de Siemens?

  = Respuestas

  1. Sí, es totalmente factible utilizar el Rosemount 3051S para medir nivel de líquido en ese rango La propia documentación indica que el equipo es apto para medición diferencial y nivel:

  _"Rosemount 3051S Coplanar Pressure Transmitters are the industry leader for Differential, Gage, and Absolute pressure measurement."_

  La tabla de rangos diferenciales indica:  _"-1000 to 1000 inH2O (-2.48 to 2.48 bar)"_ y _"-150 to 150 psi (-10.34 to 10.34 bar)"_

  2. Como el tanque está cerrado y presurizado, se puede emplear el modo differencial de medición del sensor, por lo que se necesitaría solamente uno (aunque por robustez sería mejor dejar al menos dos). Se debería conectar el puerto de HIGH en el punto de presión mayor (al fondo del tanque), y el puerto LOW (en la parte superior del tanque).

  == Alcance

  El alcance es de 0 a 2 bars, por lo que se ajustaría para todo ese rango, ya que la documentación dice: _"Zero and span values can be set anywhere within the range."_

  Cuando se hace la diferencia de presión se elimina el término constante, por lo que queda:
  $#math.Delta P = #math.rho g h$
  Por lo que la altura (h) es lineal con la presión se que mide.

  == Exactitud y precisión

  La documentación especifica:

  _"Ultra: 0.025% span accuracy"_
  _"Classic: 0.035% span accuracy"_

  == Comunicación inalámbrica

  _"WirelessHART® capabilities"_
  _"Wireless Plantweb housing"_
    _"2.4 GHz DSSS, IEC 62591 (WirelessHART"_

  Por lo que se pueden transmitir datos inalámbricamente

  == Precio y proveedores

  Localmente se puede conseguir a través de mercado libre y tiene un precio que ronda ARS 1.300.000

  = SITRANS PDS III/P410 de Siemens

  - Tiene presión diferencial también
  - Puede transmitir datos inalámbricamente
  - Puede medir 30 bars en modo diferencial
  - Error total: ±0.075% del span
  - No se consigue en mercado libre o localmente
  
  = Bibliografía
  - #lk("https://www.emerson.com/is/content/emerson/en/measurement-instrumentation/technical/products/pressure/documents/dl-rmt-ms-00813-0100-6200.pdf", "https://www.emerson.com/is/content/emerson/en/measurement-instrumentation/technical/products/pressure/documents/dl-rmt-ms-00813-0100-6200.pdf")
      - #lk("https://cache.industry.siemens.com/dl/files/485/109477485/att_849207/v1/A5E00047092-10en_DS3_HART_Ex_OI_en-US.pdf", "https://cache.industry.siemens.com/dl/files/485/109477485/att_849207/v1/A5E00047092-10en_DS3_HART_Ex_OI_en-US.pdf")

]