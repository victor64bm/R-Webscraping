#Web Scraping con rvest

#Carga de librerias
library(rvest)
library(dplyr)
library(stringr)

#1) Ejemplo base

#Vemos una URL
html <- "http://dataquestio.github.io/web-scraping-pages/simple.html"

#Leemos la URL
ejemplo <- read_html(html)

#Podemos extraer todo el texto de la página
ejemplo %>% html_text()

#Vamos a ver un nodo puntual de la página
ejemplo %>% html_nodes("p") %>% html_text()

#2) Ejemplo últimos sismos en el mundo

#URL
html <- "http://www.iris.washington.edu/latin_am/evlist.phtml?region=mundo"

#Leemos la URL
lectura <- read_html(html)

#Extraigamos todo el texto de la página
lectura %>% html_text()


#Extraigamos todos los parrafos (p) de la página
lectura %>% html_nodes("p") %>% html_text()

#Extraigamos el titulo
lectura %>% html_nodes("#banner span") %>% html_text() #Nomenclatura Selector Gadget (CSS)
lectura %>% html_nodes("#banner > h1 > span") %>% html_text() #Nomenclatura Inspector de elementos (CSS)
lectura %>% html_nodes(xpath = "/html/body/span/div[1]/h1/span") %>% html_text() #Nomenclatura Inspector de elementos (xpath)

#Extraigamos uno de los parrafos del final
lectura %>% html_nodes("br+ p") %>% html_text()
lectura %>% html_nodes("body > span > div:nth-child(5) > div > font > blockquote:nth-child(1) > p:nth-child(3)") %>% html_text()


#Limpiemos un poco este texto
texto_a_limpiar <- lectura %>% html_nodes("br+ p") %>% html_text()
texto_a_limpiar %>% str_replace_all("\n"," ") %>% str_replace_all("[:space:]+"," ")

#Ahora extraigamos solo los datos de localidad de la página
lectura %>%  html_nodes("td.region") %>%  html_text()

#Ahora vamos a extraer la tabla entera
terremotos <- lectura %>% html_nodes("#evTable") %>% html_table(header = TRUE) %>% as.data.frame()

#3) Ejemplo LATAM

#URL
html <- "https://www.latam.com/es-cl/vuelos-a-costa-rica"

#Leemos la URL
lectura <- read_html(html)

#Extraigamos el valor al día de hoy
lectura %>% html_nodes(".fr-pb-2") %>%  html_text()

#Pasemos esta información a un dataframe de manera ordenada
texto_a_limpiar_latam <- lectura %>% html_nodes(".fr-pb-2") %>%  html_text()
fecha_inicial <- texto_a_limpiar_latam %>% str_remove(".*O.\\d{2}/\\d{2}/\\d{4}") %>% str_remove(",.*")
fecha_final <- texto_a_limpiar_latam %>% str_remove(".*\\d{2}/\\d{2}/\\d{4}") %>% str_remove(",.*")
precio <- texto_a_limpiar_latam %>% str_extract("US\\$\\d+")

#Generamos un dataframe final
datos <- data.frame(fecha_inicial,fecha_final,precio)

#4) Ejemplo datos de calidad del aire

#URL
html <- "http://aqicn.org/city/chile/las-encinas-temuco/"

#Leemos la URL
lectura <- read_html(html)

#Extraemos la información necesaria
lectura %>% html_nodes("#aqiwgtinfo div , #aqiwgtinfo span , #aqiwgtvalue") %>%  html_text()

#La pasamos a un dataframe
texto_a_limpiar_aire <- lectura %>% html_nodes("#aqiwgtinfo div , #aqiwgtinfo span , #aqiwgtvalue") %>%  html_text()
indice_calidad <- texto_a_limpiar_aire[1]
estado_calidad <- texto_a_limpiar_aire[2]
fecha <- Sys.Date()

datos <- data.frame(indice_calidad,estado_calidad,fecha)

#5) PC Factory

#URL
html <- "https://www.pcfactory.cl/notebooks?categoria=735&papa=636"

#Leemos la URL
lectura <- read_html(html)

#Extraemos la información necesaria
lectura %>% html_nodes(".txt-precio , .marca") %>% html_text()

#Ordenamos la información
texto_a_limpiar_pcfactory <- lectura %>% html_nodes(".txt-precio , .marca") %>% html_text()

marcas <- texto_a_limpiar_pcfactory[seq(1,length(texto_a_limpiar_pcfactory),by = 2)]
precio <- texto_a_limpiar_pcfactory[seq(2,length(texto_a_limpiar_pcfactory),by = 2)]
marcas <- marcas %>% str_remove("  . ")
precio <- precio %>% str_remove_all("\\D") %>% as.numeric()
datos_pcfactory <- data.frame(marcas,precio)

#Grafico simple
plot(as.factor(datos_pcfactory$marcas),datos_pcfactory$precio)
