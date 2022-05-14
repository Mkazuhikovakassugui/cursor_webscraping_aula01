# --------------------------------------------------------------------------------------------#
#                                     Aula01 - Webscraping
#                                        Prof: Julio
#                                   Aluno: Marcio Vakassugui
#---------------------------------------------------------------------------------------------#


# Carregar os pacotes ---------------------------------------------------------------------

library(httr)
library(jsonlite)

# Explorando a página da Brasil API -------------------------------------------------------


# CEP -------------------------------------------------------------------------------------

u_base <- "https://brasilapi.com.br/api"                       # parte da url que não se altera.

endpoint_cep <- "/cep/v2/"          # parte que pode alterar a depender do objetivo da consulta.

cep <- "82220-180"                  # parte que pode alterar a depender do objetivo da consulta.

# a criação de duas variáveis facilitam a reutilização do código

u_cep <- paste0(u_base, endpoint_cep, cep)                                           # u de url. 

r_cep <- httr::GET(u_cep)                                                     # r de requisição.


u_cep <- paste0(u_base, endpoint_cep, cep)              # paste une os elementos formando a url.

r_cep <- httr::GET(u_cep)                    # GET do httr permite receber da API o requisitado.


# como obter o resultado em formato R (lista de listas  )

content(r_cep)

# como obter o resultado diretamente em formato json

content(r_cep, as = "text") |> 
    cat()

#obs. o padrão é o parsed, que reconhece o formato do dado

content(r_cep, as = "parsed")

# entendendo o jsonlite

content(r_cep, as = "text") |> 
jsonlite::fromJSON(simplifyDataFrame = TRUE)


# FIPE ------------------------------------------------------------------------------------

# Listar as marcas dos veículos referente ao tipo de veículo (carros, caminhões, motocicletas)

u_base <- "https://brasilapi.com.br/api"                       # parte da url que não se altera.

endpoint_fipe <- "/fipe/marcas/v1/" # parte que pode alterar a depender do objetivo da consulta.

veiculo <- "carros"                 # parte que pode alterar a depender do objetivo da consulta.


u_fipe <- paste0(u_base, endpoint_fipe, veiculo)                                     # u de url.

r_fipe <- httr::GET(u_fipe)                                                   # r de requisição.


# como obter o resultado em formato R (lista de listas  )

content(r_fipe, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    View()

# em formato tibble

content(r_fipe, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::tible()


content(r_fipe, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::tibble() |> 
    View()



u_base <- "https://brasilapi.com.br/api"

endpoint_fipe <- "/fipe/marcas/v1/"

tipo_veiculo <- "carros"

u_fipe <- paste0(u_base, endpoint_fipe, tipo_veiculo)

r_fipe <- httr::GET(u_fipe, as = "text")



content(r_fipe, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE)


content(r_fipe, simplifyDataFrame = TRUE) |> 
    tibble::as_tibble()


# FIPE com parâmetros ---------------------------------------------------------------------

# Consulta do preço do veículo segundo a tabela FIPE

## adquirimos a tabela que servirá de parâmetro para a próxima consulta (preço por modelo)

u_base <- "https://brasilapi.com.br/api"                                        # sem alteração.

endpoint_tabelas_fipe <- "/fipe/tabelas/v1"                          # endpoint para as tabelas.

u_tabelas_fipe <- paste0(u_base, endpoint_tabelas_fipe) # url a partir dos elementos anteriores.

r_tabelas_fipe <- httr::GET(u_tabelas_fipe)                                   # get das tabelas.

content(r_tabelas_fipe, as = "text") |>                               # visualizamos as tabelas.
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::as_tibble() |> 
    View()

# agora usamos a tabela com parâmetro da consulta

# primeira forma (manual)

u_fipe                                                                          # sem alteração.

u_fipe_param <- paste0(u_fipe, "?tabela_referencia= ", "150")
r_fipe_param_manual <- httr::GET(u_fipe_param)

content(r_fipe_param_manual, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::as_tibble()

# segunda forma (a mais usual)
q_fipe <- list(tabela_referencia = 150)
r_fipe_param <- GET(u_fipe, query = q_fipe)

content(r_fipe_param, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::as_tibble()


# pesquisar o preço de um carro na fipe

# Esta API não disponibiliza uma lista com todos os modelos de carros
# Pode-se obter o código de um modelo em outros sites. Ex. Audi E-tron Performance 
# Black Automático (Elétrico) -- codigo 008258-9

cod_carro <-  "0082589"
endpoint_carro_fipe <- "/fipe/preco/v1/"
u_carro <- paste0(u_base, endpoint_carro_fipe, cod_carro)
r_carro <- httr::GET(u_carro)

content(r_carro, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::as_tibble() |> 
    View()


u_fipe                                                                          # sem alteração.

u_fipe_param <- paste0(u_fipe, "?tabela_referencia= ", "215")
r_fipe_param_manual <- httr::GET(u_fipe_param)

content(r_fipe_param_manual, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::as_tibble()

# segunda forma (a mais usual)
q_fipe <- list(tabela_referencia = 215)
r_fipe_param <- GET(u_fipe, query = q_fipe)

content(r_fipe_param, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::as_tibble()


# pesquisar o preço de um carro na fipe

# Esta API não disponibiliza uma lista com todos os modelos de carros
# Pode-se obter o código de um modelo em outros sites. Ex. Jeep Compass Limited 4x2 flex 16 v
# automático -- codigo 0170470

cod_carro <-  "0170470"
endpoint_carro_fipe <- "/fipe/preco/v1/"
u_carro <- paste0(u_base, endpoint_carro_fipe, cod_carro)
r_carro <- httr::GET(u_carro)

content(r_carro, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) |> 
    tibble::as_tibble() |> 
    select(valor, anoModelo, marca)

q_fipe <- q_fipe <- list(tabela_referencia = 237)
r_carr19 <- httr::GET(u_carro, query = q_fipe)

da_carro_2019 <- content(r_carr19, simplifyDataFrame = TRUE) |> 
    tibble::as_tibble() |> 
    View()



# SABESP COM API ESCONDIDA ----------------------------------------------------------------

# https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/2022-05-02

u_base <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
data_sabesp <- "2022-05-09"

u_dados_sabesp <- paste0(u_base, data_sabesp)
r_dados_sabesp <- httr::GET(u_dados_sabesp)

resultado <- content(r_dados_sabesp, as = "text") |> 
    jsonlite::fromJSON(simplifyDataFrame = TRUE) 

da_sabesp <- resultado |> 
    purrr::pluck("ReturnObj", "sistemas") |> 
    janitor::clean_names() |> 
    tibble::as_tibble() |> 
    View()




