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

    // #v(4em)
    // #image("unlp_logo.png", width: 60%)

  ]
  // Switch back to two-column layout for the body
  set page(columns: 2)
  body
}

// Document content
#project(
  title: "Examen Mod 1 fecha 1",
  sub: "Sistemas embebidos",
  authors: (
    "Tomás Vidal (69854/4)",
  ),
  date: "24 de Abril de 2025",
)[

  = Configuración en CubeMX


  #image("Capturas/1.png", width: 100%)
  Se eligió "ACCESS TO MCU SELECTOR"

  #image("Capturas/2.png", width: 100%)
  Se eligió el "STM32F103C8T6" y se creó el proyecto.

  #image("Capturas/3.png", width: 100%)
  Se configuró el debug a serial

  #image("Capturas/4.png", width: 100%)
  Se configuró el clock externo para poder configurar los 72MHz posteriormente

  #image("Capturas/5.png", width: 100%)
  En "Clock configuration" se configuró el reloj a 72MHz

  #image("Capturas/6.png", width: 100%)
  Se configuró el USART1 para UART asíncrono con los pines PA10 (Rx) y PA9 (Tx)

  #image("Capturas/7.png", width: 100%)
  Se configuraron los GPIOs PA0, PA1, PA2 y PC13 como salida para LEDs y se usaron USER_LABELS para identificarlas de una mejor manera (LED_A, LED_B, LED_C y DEBUG_LED respectivamente)

  #image("Capturas/8.png", width: 100%)
  Se configuraron los GPIOs PB3, PB4 y PB5 como entrada para los botones, se configuraron en modo pull-up (es decir internamente tiene una conexión con una resistencia y alimentación), de esta manera solo tengo que colocar el pulsador y hacer la conexión a tierra.

  #image("Capturas/9.png", width: 100%)
  #image("Capturas/10.png", width: 100%)
  Se configuró el timer 2 para que dispare una interrupción cada 3 segundos, se configuró pensando que el clock que lo alimenta es de 16MHz, entonces se hace un prescale de 16000, y luego se cuenta hasta 3000 (tiene un ciclo de trabajo de 50% aunque no es relevante para esta aplicación)

  #image("Capturas/11.png", width: 100%)
  Se le dió un nombre el proyecto y se configuró el toolchain a "STM32CubeIDE"

  #image("Capturas/12.png", width: 100%)
  Se verificó que efectivamente el proyecto compila y se ejecuta correctamente en el uC viendo como parpadea un LED cada 1 segundo.

  = Codigo

  #image("Capturas/12.png", width: 100%)
  Se verifica que los botones y LEDs funcionan correctamente (y lo hacen)

  #image("Capturas/14.png", width: 100%)
  Estructuras y variables globales

  #image("Capturas/15.png", width: 100%)
  Main

  #image("Capturas/16.png", width: 100%)
  #image("Capturas/17.png", width: 100%)
  Máquina de estados

  #image("Capturas/18.png", width: 100%)
  Se debugea la máquina de estados con el "Live Expression"

  #image("Capturas/conexion.jpeg", width: 100%)
  Estas son las conexiones hechas

  #image("Capturas/fsm.jpeg", width: 100%)
  Esta es la máquina de estados que se hizo

  == Parte teórica

  === Ejercicio 1

  1. a, b e i se almacenan en .text porque se inicializan. 

  2.
  #image("Capturas/teoria1.png", width: 100%)
  Le lleva 6 instrucciones el incremento y la comparación para hacer el salto, por lo que serían 100*6/8MHz=0.75us

  === Ejercicio 2
  #image("Capturas/teoria2.png", width: 100%)



]
