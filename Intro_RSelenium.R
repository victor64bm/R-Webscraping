#Web Scraping con RSelenium

library(RSelenium)

#Realiza una conexi�n a trav�s de un navegador definido
rD <- rsDriver(browser="firefox", port=4546L, verbose=F)

#Asigna la conexi�n al objeto remDr, para que luego pueda ser manipulado
remDr <- rD$client

#Ingresa a una p�gina web
remDr$navigate("https://www.google.com/") 

#Podemos comenzar a utilizar algunos m�todos
remDr$getCurrentUrl()

#Buscar elementos dentro de la p�gina
webElem <- remDr$findElement(using = "css", value = ".gLFyf")
webElem$getElementAttribute("class")

#Ingresemos alguna busqueda
webElem$sendKeysToElement(list("Juan Carlos Bodoque",key = "enter"))

#Busquemos un nuevo tema
webElem <- remDr$findElement(using = "css", value = ".gLFyf")
webElem$sendKeysToElement(list("Calcetin con Rombosman"))

#Primero tenemos que borrar contenido anterior
webElem$clearElement()
webElem$sendKeysToElement(list("Calcetin con Rombosman"))

#Vamos a selccionar la lupita y hacer click en ella
lupita <- remDr$findElement(using = "css",value = ".FAuhyb > span:nth-child(1) > svg:nth-child(1)")
lupita$clickElement()

#Quiero volver atr�s
remDr$goBack()

#Me arrepent�, vuelvo adelante
remDr$goForward()


#Quiero una imagen de Calcetin con Rombosman
imagenes <- remDr$findElement(using = "css",value = "div.hdtb-mitem:nth-child(2) > a:nth-child(1)")
imagenes$clickElement()

imagen_calcetin  <- remDr$findElement(using = "css",value = "div.isv-r:nth-child(1) > a:nth-child(1) > div:nth-child(1) > img:nth-child(1)")
imagen_calcetin$clickElement()

#Cerrar navegador
remDr$close()

#Cerrar el servidor selenium
rD$server$stop()
