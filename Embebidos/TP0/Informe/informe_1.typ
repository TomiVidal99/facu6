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
  title: "Problemas entregables 1",
  sub: "Sistemas Embebidos",
  authors: (
    "Tomás Vidal (69854/4)",
  ),
  date: "19 de Marzo de 2026",
)[

  = Ejercicio 4

  Se quiere implementar la siguiente máquina de estados en C.

  #figure(
    image("Imagenes/E1_FSM.png", width: 100%),
    caption: [Máquina de estados],
    supplement: "Figura",
  )

  Se tienen 3 *estados*: _PRE_DISPARO, DISPARO y REPOSO_. Hay un *pseudoestado* (círculo negro), que decide si ir a DISPARO o PRE_DISPARO. El sistema comienza en REPOSO, y se tienen los siguiente eventos: *nueva_muestra* y *desarmar_alarma*. Las condiciones son: *muestra >= UMBRAL*, *muestra < UMBRAL* y *contador < MAX_CUENTAS*. Las acciones son: *contador=contador+1*, *detener_alarma()*, *disparar_alarma()*, *contador=0* y *contador=1*.

  Para poder implementar el problema se tuvieron que generar los eventos "manualmente", se simulan haciendo que el usuario los ingrese con la entrada en la terminal, luego se procesa en la máquina de estados.

  La máquina de estados está encapsulada en dos funciones: fsm_inicio y al_evento_efsm_procesar_evento, la primera configura la máquina para poder comenzar con sus valores inciales correctamente, y la segunda función hace la iteración entre los estados dado un estado actual y un evento.

  La función de debug permite "ver" la información "relevante" de la máquina de estados, así se puede debugear si fuera necesario.

  _En los archivos main.c, include.h, alarma.c y alarma.h se puede ver en detalle el código implementado, pero es simplemente una máquina de estados con la función de debug y se acciona con las dos funciones mencionadas anteriormente._

  == Aclaraciones sobre la compilación

  Se compiló como se detalla en el Makefile (con Linux). Para compilar sólo hay que ejecutar con el comando: _make_.

  = Ejercicio 22

  Se implementó la siguiente máquina de estados que logra cumplir con los requisitos. Lo hace considerando que hay una variable que es '1' cuando ambos sensores detectan algo (*AMBOS_SENSORES*), y otra variable que se activa con '1' cuando uno de los detectores detectan (*UN_SENSOR*), esto se podría haber hecho de varias maneras, como por ejemplo teniendo una variable para un sensor izquierdo y otro sensor derecho, y hacer operaciones lógicas entre estas dos variables para lograr el mismo resultado, también se podrían haber considerado más estados de la máquina, donde el motor girase en un sentido u otro, pero esta máquina es minimalista y resuelvo lo pedido.

  #figure(
    image("Imagenes/E2_FSM.png", width: 100%),
    caption: [Máquina de estados],
    supplement: "Figura",
  )


]

