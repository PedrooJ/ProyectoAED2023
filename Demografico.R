# Obtener las rutas de cada excel
archivos_barrios <- list.files(path = "./data/Barrios2022", pattern = 'Districte', full.names = TRUE)
area <- 1:length(df$Barrio)
poblacion <- 1:length(df$Barrio)
nombre <- 1:length(df$Barrio)

library(readxl)
for (i in 1:length(archivos_barrios)) {
  Barrio <- read_excel(archivos_barrios[i], sheet = "Padrón")
  fila <- grep('Padró' ,Barrio[[1]])[1]
  nombre_barrio <- Barrio[[1]][fila]
  nombre[i] <-trimws(toupper(substring(nombre_barrio, 36)))
  fila <- grep('Superficie' ,Barrio$...2)
  area[i] <- Barrio$...2[fila + 1]
  fila <- grep('Personas', Barrio[[1]])[1]
  poblacion[i] <- Barrio[[1]][fila + 1]
}
demografico <- data.frame(nombre, area, poblacion)


# Hay algunos nombres que se han guardado mal, por lo que vamos a tener que tratarlos. Vemos que todos los que estan mal comienzan por ".  " o por "[0-9].  "

for (i in 1:length(demografico$nombre)) {
  if (grepl('^[^A-Za-z]',demografico$nombre)[i]) {
    demografico$nombre[i] <- str_remove(demografico$nombre[i], "([0-9]|). ")
  }
}
# También falta el dato de un barrio, asi que hay una fila de más
demografico <- demografico[!(demografico$nombre == '88'), ]

# Vemos quales de los nombres del dataframe nuevo no están en el principal
df$Barrio[!(demografico$nombre %in% df$Barrio)]

# Hay que poner de la misma maera que estan en el data-frame pricipal
demografico$nombre[demografico$nombre == "GRAN VIA"] <- "LA GRAN VIA"
demografico$nombre[demografico$nombre == "EXPOSICIÓ"] <- "EXPOSICIO"
demografico$nombre[demografico$nombre == "CIUTAT UNIVERSITÀRIA"] <- "CIUTAT UNIVERSITARIA"
demografico$nombre[demografico$nombre == "SANT MARCEL·LÍ"] <- "SANT MARCEL.LI"
demografico$nombre[demografico$nombre == "CAMÍ REAL"] <- "CAMI REAL"
demografico$nombre[demografico$nombre == "MONT-OLIVET"] <- "MONTOLIVET"
demografico$nombre[demografico$nombre == "FONTETA DE SANT LLUÍS"] <- "LA FONTETA S.LLUIS"
demografico$nombre[demografico$nombre == "CIUTAT DE LES ARTS I DE LES CIÈNCIES"] <- "CIUTAT DE LES ARTS I DE LES CIENCIES"
demografico$nombre[demografico$nombre == "EL CABANYAL- EL CANYAMELAR"] <- "CABANYAL-CANYAMELAR"
demografico$nombre[demografico$nombre == "EL BOTÀNIC"] <- "EL BOTANIC"
demografico$nombre[demografico$nombre == "BETERÓ"] <- "BETERO"
demografico$nombre[demografico$nombre == "CAMÍ FONDO"] <- "CAMI FONDO"
demografico$nombre[demografico$nombre == "CIUTAT JARDÍ"] <- "CIUTAT JARDI"
demografico$nombre[demografico$nombre == "LA BEGA BAIXA"] <- "LA VEGA BAIXA"
demografico$nombre[demografico$nombre == "CAMÍ DE VERA"] <- "CAMI DE VERA"
demografico$nombre[demografico$nombre == "ORRIOLS"] <- "ELS ORRIOLS"
demografico$nombre[demografico$nombre == "SANT LLORENÇ"] <- "SANT LLORENS"
demografico$nombre[demografico$nombre == "CASES DE BÀRCENA"] <- "LES CASES DE BARCENA"
demografico$nombre[demografico$nombre == "MAUELLA"] <- "MAHUELLA-TAULADELLA"
demografico$nombre[demografico$nombre == "\t\nBORBOTO"] <- "BORBOTO"
demografico$nombre[demografico$nombre == "\t\nBENIMAMET"] <- "BENIMAMET"
demografico$nombre[demografico$nombre == "EL CASTELLAR-L'OLIVERAR"] <- "CASTELLAR-L'OLIVERAL"

# Guardar el RData
save(demografico, file = "./data/demografico.RData")