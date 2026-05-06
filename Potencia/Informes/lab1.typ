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
  title: "Laboratorio N°1",
  sub: "Electrónica de potencia",
  authors: (
    "Tomás Vidal (69854/4)",
    "Mateo Natale (75316/9)",
    "Santiago Barbero (74165/7)",
    "Ignacio Nahuel Chantiri (69869/1)",
    "Juan Pablo Jouanny (71310/4)",
    "Mariano López Lastra (65682/4)",
  ),
  date: "20 de Abril de 2026",
)[

  = Introducción

  En el presente trabajo práctico se estudió el funcionamiento de un convertidor monofásico CA/CC aplicado a la alimentación de la armadura de un motor de corriente continua (CC) con excitación independiente. El sistema de alimentación está compuesto por un rectificador semicontrolado que regula la tensión media de armadura mediante el ajuste del ángulo de disparo de los tiristores.
  
  El objetivo principal de la experiencia fue analizar el comportamiento eléctrico del rectificador operando en régimen estacionario y en modo de conducción discontinua (MCD), con el fin de determinar experimentalmente los parámetros del modelo equivalente de la armadura: resistencia $R_a$, inductancia $L_a$ y fuerza electromotriz inducida $E_a$.
  Para ello se realizaron mediciones de tensión y corriente utilizando osciloscopio con puntas diferenciales y de corriente, registrando las formas de onda características del sistema.

  = Objetivos

  - Determinar experimentalmente los parámetros eléctricos $R_a$ y $L_a$ del modelo equivalente de armadura del motor de CC.
  - Estimar la fuerza electromotriz inducida $E_a$ a partir de mediciones directas.
  - Analizar el comportamiento del rectificador en modo de conducción discontinua.
  - Evaluar la validez de las aproximaciones teóricas utilizadas para la estimación de la inductancia.

  = Marco teórico

  El modelo eléctrico equivalente de la armadura del motor de CC está compuesto por:

  - Resistencia de armadura $R_a$
  - Inductancia de armadura $L_a$
  - Fuerza electromotriz inducida $E_a$

  La FEM inducida es propocional a la velocidad de giro:

  #equation($E_a = k_E n$)

  El torque desarrollado es proporcional a la corriente de armadura:

  #equation($T_m = k_T I_a$)
  
  En régimen estacionario, el circuito de armadura es:

  #equation($V_a = E_a + I_a R_a$)

  De donde puede obtenerse la resistencia:

  #equation($R_a = (V_a - E_a) / I_a$)

  Durante el intervalo de conducción del diodo de rueda libre, la dinámica de la corriente está gobernada por:

  #equation($L_a (d i_a)/(d t) + R_a i_a + E_a = 0 $)

  Si se desprecia el término $R_a i_a$, puede aproximarse:

  #equation($L_a (#math.Delta i_a) / (#math.Delta t) approx - E_a$)

  _Esta aproximación surge de considerar que, en un motor, la constante de tiempo relacionada al circuito R-L es grande y por lo tanto no se aprecia el comportamiento de limitacion de corriente de la resistencia durante un intervalo de tiempo suficientemente pequeño. Es decir, la corriente parece decrecer linealmente durante el intervalo de trabajo como si se tratara de un circuito L-E en lugar de R-L-E_

  = Descripción del experimento

  El banco de ensayo estuvo compuesto por:

  - Motor de corriente continua con excitación independiente.
  - Rectificador semicontrolado monofásico para alimentación de armadura.
  - Rectificador en puente para excitación de campo.
  - Freno electromagnético regulado al 50% de carga.
  - Osciloscopio digital con punta de corriente y punta diferencial de tensión.

  El control de velocidad se realizó mediante la variación del ángulo de disparo de los tiristores a través del potenciómetro del gabinete de control.

  El rectificador se operó en modo de conducción discontinua con el fin de poder medir la FEM inducida durante los intervalos en los cuales la corriente de armadura se anulaba.

  = Procedimiento experimental

  1. Se configuró el freno electromagnético al 50% de carga.
  2. Se ajustó la velocidad del motor a distintos valores, primero a 1000rpm y luego a 1500rpm.
  3. Se registraron los valores del osciloscopio:
    - Tensión de armadura.
    - Corriente de armadura.
  4. Se midieron:
    - Valor medio de $V_a$
    - Valor medio de $I_a$
    - Valor medio de $E_a$
    - Valor pico $I_#math.pi$
    - Intervalo de tiempo $#math.Delta t$ durante la descarga
  5. Se calcularon:
    - Resistencia $R_a$
    - Inductancia $L_a$

  = Resultados

  #align(center)[
    #figure(
      table(
        columns: (auto, auto, auto, auto, auto, auto, auto, auto),
        align: (center, center, center, center, center, center, center, center, center),

        [*RPM*], [*E_a [V]*], [*I_a [A]*], [*V_a [V]*], [*$I_#math.pi [A]$*], [*$#math.Delta t ["mS"]$*], [*R_a [$#math.Omega$]*], [*L_a [mH]*],

        [1000], [66.2], [2.9], [84.5], [6], [3.44], [6.3], [38],
        [1500], [99.1], [2.8], [114], [5.12], [2.18], [5.32], [42.2]
      ),
      caption: [Mediciones obtenidas],
      placement: top,
      supplement: "Tabla",
    )
  ]

  En la primera fila se muestran los resultados de las mediciones para la velocida de 1000rpm, y en la segunda fila para cuando se tuvieron 1500rpm.

  = Conclusiones

  En la presente experiencia se logró:

  - Determinar experimentalmente la resistencia e inductancia de armadura del motor.
  - Verificar la proporcionalidad entre la FEM inducida y la velocidad de rotación.
  - Analizar el comportamiento operando en modo de conducción discontinua.
  - Evaluar la validez de las simplificaciones adoptadas para el cálculo de la inductancia.

  Los resultados obtenidos fueron coherentes con el modelo teórico del motor de corriente continua, validando el procedimiento experimental empleado.

  En primer lugar se verifica la relacion proporcional entre la FEM y la velocidad de giro, con una constante de proporcionalidad de aproximadamente $66"mV"/"rpm"$. Tambien se observa que la corriente de armadura es practicamente invariante frente al cambio en la velocidad de giro ya que esta es proporcional al torque que se mantuvo constante.
  Los valores de resistencia y inductancia son similares en el primer caso y en el segundo pero se esperaba que sean constantes. Se asocia estas variaciones a los errores de medición, a las aproximaciones implementadas, y a la propagacion de errores.
  El aumento de la tensión promedio de armadura es el cambio esperado al disminuir el angulo de disparo. 
  Por otro lado, el valor de la corriente Ipi es afectado por distintos factores, por lo que es dificil establecer una relacion directa, es de esperar que en un circuito R-L-E el valor de Ipi aumente cuando se disminuye el angulo de disparo, pero en este circuito al disminuir el angulo de disparo tambien aumenta la FEM es decir la "E". Vemos que la tension de armadura aumenta menos que la FEM en valores relativos (30% contra 50%), podriamos suponer que esto disminuye el crecimiento de la corriente en el inductor, disminuyendo el valor de Ip.

  #equation($#math.tau _1 = L/R = (38"mH")/(6.3#math.Omega) = 6"ms"$)
  #equation($#math.tau _2 = L/R = (42.2"mH")/(5.32#math.Omega) = 7.9"ms"$)

  La descarga del inductor durante el funcionamiento del diodo de rueda libre sucede en un intervalo de tiempo que es aproximadamente el 50% de la constante de tiempo del circuito en el caso 1 (1000rpm) y un intervalo de tiempo de casi 25% en el caso 2. Si bien estan por fuera del criterio tipico para la aproximacion lineal de la exponencial (menor al 10%), los errores asociados a estos calculos son del orden, o menores, a los errores de medicion y arrastre durante el procedimiento. Es decir, a fines practicos, resulta una aproximacion valida.


]