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
  title: "Trabajo a la Introducción a la Robótica Industrial",
  sub: "Instrumentación y control Industrial",
  authors: (
    "Tomás Vidal (69854/4)",
  ),
  date: "9 de Junio de 2026",
)[

  = Selección del robot

  // TODO: optimizar área de trabajo representando las geometrías
  Se comenzó con una investigación de la oferta de manipuladores disponibles en la Argentina, en esta lista se tienen del tipo: 6 y 4 ejes, colaborativos, SCARA, y workstations, de la empresa *Turin* y *ABB*. También se pueden encontrar otros modelos y de otras marcas *usuados*, que se descartaron y sólo se van a considerar *nuevos*. \
  Considerando las tareas a realizar, el área efectiva de trabajo y el peso de los elementos involucrados, se podría pensar en un SCARA para esta aplicación, pero también es un buen criterio de ingeniería pensar en la _posibilidad de cambios futuros_, como por ejemplo, agregar más tareas, o cambiar el peso de los elementos, por lo que quizá sobredimensionar el manipulador y, elegir algo con más flexibilidad, sea una mejor opción. \
  Aunque no es lo más barato en el momento actual, quizá en un futuro no muy lejano tenga un gran impacto en tiempo y dinero (ya que no habría que comprar otro manipulador, ni hacer grandes cambios en el software o adquirir nuevos conocimientos técnicos del dispositivo). \
  Por lo que teniendo en consideración todo estos puntos mencionados, se decide adquirir un *robot articulado de 6 ejes*. \
  Se consideró el robot #lk("https://library.e.abb.com/public/62ba0b29a3b44ea799ae3e2f8695b8d3/IRB%201010%20datasheet_202407026.pdf?x-sign=NTK5JfebXX3ytJHjdIBIDs5WLEotEnnWnH7B8lKHli16ORMjSj3F9uUyDhRWYGO6", "ABB IRB 1010"), pero tiene un alcance efectivo casi al límite de lo deseado, ya que sólo deja un extra de $(20"mm")/(370"mm") * 100% = 5.4%$ (el área se calcula como la distancia desde el robot hasta el centro de la pieza, suponiendo que el _'gripper'_ se posiciona en el centro de la pieza), quisiera que sea de al menos un 20%, para una posible aplicación futura. \
  Por lo que se elige el robot #lk("https://search.abb.com/library/Download.aspx?DocumentID=9AKK108468A6159&LanguageCode=en&DocumentPartId=&Action=Launch", "ABB IRB 1090"), que tiene un área de trabajo mayor, $(330"mm")/(580"mm") * 100% = 56.8%$.
  Además se eligió uno de ABB en vez de Turin, porque Turin no ofrece la documentación fácilmente para ver las especificaciones.

  #align(center)[
    #figure(
      image("./6axis_specifications.png", width: 100%),
      caption: [Especificaciones técnicas del robot],
      supplement: "Figura",
    )
  ]

  #align(center)[
    #figure(
      image("./area_trabajo_tp6.png", width: 100%),
      caption: [Representación del área de trabajo],
      supplement: "Figura",
    )
  ]

  En la figura se puede ver que el fabricante garantiza un alcance de 0.58m = 580mm, por lo que cumple el requisito de alcance. \
  _Esto es suponiendo que la pieza esta orientada como se muestra en la *figura 2*, y que el mínimo alcance necesario es en el centro de la pieza, si es que se tiene un 'gripper' que tome la pieza por el centro._ \

  = Diseño y selección del sistema de seguridad

  La estación robotizada deberá encontrarse rodeada por una barrera física metálica para impedir el acceso accidental al área de trabajo del manipulador. Debido a que existen zonas de acceso para mantenimiento y para el reemplazo de cajas, se implementarán distintos dispositivos de seguridad según la función de cada acceso.

  == Barrera perimetral

  Se utilizará un cerramiento de malla metálica industrial de aproximadamente 2 m de altura rodeando completamente la estación.

  Su función es impedir el ingreso de personas al área de trabajo mientras el robot se encuentra en funcionamiento.

  == Acceso para mantenimiento

  El acceso para mantenimiento se realizará mediante una puerta de seguridad equipada con un interruptor de enclavamiento (interlock).

  Componente seleccionado: *Schmersal AZM201*

  Tipo:

  Interruptor de seguridad con bloqueo electromagnético.
  Categoría de seguridad hasta PLe (ISO 13849-1).

  Funcionamiento:

  Cuando la puerta se abre, el sistema de seguridad elimina inmediatamente la energía de movimiento del robot y de la cinta transportadora.
  El robot no puede volver a ponerse en marcha hasta que la puerta se cierre y se realice un rearme manual.

  Justificación:

  Durante tareas de mantenimiento el operario puede ingresar completamente a la celda.
  Se requiere garantizar la parada segura antes de permitir el acceso.

  == Zona de operación (cambio de cajas)

  La zona donde el operario retira y reemplaza las cajas requiere acceso frecuente.

  Para esta aplicación resulta más conveniente utilizar una barrera fotoeléctrica de seguridad.

  Componente seleccionado: *SICK deTec4 Core*

  Tipo:

  Cortina de luz de seguridad.
  Nivel de seguridad SIL3 / PLe.

  Funcionamiento:

  Cuando una persona introduce una mano o atraviesa la cortina, se interrumpen los haces infrarrojos.
  El robot y la cinta se detienen inmediatamente.
  Una vez liberada la zona se requiere rearme para volver a operar.

  Justificación:

  Permite acceso frecuente sin necesidad de abrir puertas.
  Reduce tiempos de operación durante el cambio de cajas.
  Es la solución habitualmente utilizada en estaciones de carga y descarga.

  == Botón de parada de emergencia

  Se instalarán pulsadores de parada de emergencia en:

  - Frente de la estación.
  - Zona de mantenimiento.
  - Panel de control.

  Componente seleccionado: *Schneider Electric XB4-BS542*

  Características:

  - Cabeza tipo seta roja.
  - Enclavamiento mecánico.
  - Contactos normalmente cerrados.

  Funcionamiento:

  Al accionarse, se elimina inmediatamente la energía de movimiento del robot y de la cinta transportadora.
  El restablecimiento requiere accionamiento manual.

  == Relé de seguridad

  Todos los elementos de seguridad se conectarán a un relé de seguridad dedicado.

  Componente seleccionado: *SICK UE410 o Schneider Preventa XPS*

  Funciones:

  Supervisión de la cortina óptica.
  Supervisión de la puerta de mantenimiento.
  Supervisión de los pulsadores de emergencia.
  Gestión del rearme manual.

  == Secuencia de funcionamiento segura
  El robot opera normalmente dentro del cerramiento.
  Si se abre la puerta de mantenimiento:
  El interlock actúa.
  Robot y cinta se detienen.
  Si un operario atraviesa la cortina óptica:
  Robot y cinta se detienen.
  Si se presiona cualquier parada de emergencia:
  Se realiza una parada segura inmediata.
  Para reanudar la producción:
  Deben restablecerse todas las condiciones de seguridad.
  El operador debe realizar un rearme manual.

  = Bibliografía
  - #lk("https://new.abb.com/products/robotics/es/robots", "https://new.abb.com/products/robotics/es/robots")
  - #lk("https://turinrobot.com.ar/index/manipuladores/", "https://turinrobot.com.ar/index/manipuladores/")
  - #lk("https://www.sick.com/de/de/catalog/produkte/safety/sicherheitssteuerungen/flexi-classic/ue410-xu4t50/p/p54581", "https://www.sick.com/de/de/catalog/produkte/safety/sicherheitssteuerungen/flexi-classic/ue410-xu4t50/p/p54581")
  - #lk("https://products.schmersal.com/en_US/azm201-1000073828", "https://products.schmersal.com/en_US/azm201-1000073828")
  - #lk("https://www.se.com/us/en/product/XB4BS542/complete-emergency-switching-off-push-button-harmony-xb4-red-%C3%B8-40-stop-%C3%B822-mm-latching-turn-release-1nc/", "https://www.se.com/us/en/product/XB4BS542/complete-emergency-switching-off-push-button-harmony-xb4-red-%C3%B8-40-stop-%C3%B822-mm-latching-turn-release-1nc/")

]

