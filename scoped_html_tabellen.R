library(dplyr)
library(glue)
library(stringr)


#data = een dataframe
#caption = optioneel: Korte omschrijving van de tabel als string
#row_header_column = optioneel: De kolom waarvan de waarden tot de row-headers worden gedoopt als string 
#voorbeeld: iris %>% maak_simpele_html_tabel_met_scope(caption = "Afmetingen Irisbloemen", row_header_column = "Species") 

maak_simpele_html_tabel_met_scope <- function(data, caption = NULL, row_header_column = NULL){
  
  #Eventuele factorvariabelen omzetten naar character. 
  data <- data %>% dplyr::mutate_if(is.factor, as.character)
  
  #vector met alle kolomheaders maken obv colnames dataframe
  columnnames = glue::glue("<th scope = 'col'>{names(data)}</th>")
  
  #Als een kolom is opgegeven voor row-headers:
  #index van kolom die de row-headers moet geven opzoeken
  index_column_row_headers <- NULL
  
  if(!is.null(row_header_column)){
    
    index_column_row_headers = which(names(data) == row_header_column)
    
    #Als er een waarde voor row_header_column is opgegeven die niet als kolomnaam voorkomt in het df:
    #warning
    if(length(index_column_row_headers) == 0){
      warning(glue::glue("Kolomnaam voor row-headers niet in dataset. Geen rowheaders aangemaakt.
              Controleer de spelling van: '{row_header_column}'"))
    }

  }
  
  #Loop langs alle rijen
  all_rows <- lapply(1:nrow(data), function(x){
    
    #Loop langs alle cellen in een rij
    cells_per_row <- lapply(1:length(data), function(y){
      
      data_cell = data[x,y]
      
      #Als het om de kolom gaat die de row-header geeft; 
      #geef scope-argument
      #shiny::isTruthy gebruikt omdat dit naar FALSE evalueert bij een object dat NULL is 
      #Kan vast beter.
      if(shiny::isTruthy(y == index_column_row_headers)){

        glue::glue("<th scope = 'row'>{data_cell}</th>")
        
      }else{
        
        glue::glue("<td>{data_cell}</td>")
      }
      
    })
    
    cells_per_row <- cells_per_row %>% unlist() %>% paste(collapse = '')
    
    #Plak alle cellen op een rij aan elkaar met regeleinden <tr></tr> eromheen 
    glue("<tr>{cells_per_row}</tr>")
    
    
  })
  #Plak alle rijen achter elkaar.
  #collapse op \n. veranderd niks aan de gerenderde tabel maar maakt de ruwe html-output leesbaarder
  all_rows <- all_rows %>% unlist() %>% paste(collapse = '\n')
  
  #Caption toevoegen als deze is opgegeven  
  if(!is.null(caption)){
    caption = glue("\n <caption>{caption}</caption> \n")
  } else{
    caption = ""
  }
  
  #Alles aan elkaar plakken
  html_tabel = glue::glue(
    "<table> {caption} <tr> \n{paste(columnnames,collapse = '\n')} \n </tr> \n{all_rows} \n </table>")
  
  return(html_tabel)
  
}

#maak_irreguliere_html_tabel_met_scope()
#zelfde functie uitgebreid met optie om extra headers boven kolommen te voegen welke meerdere kolommen omvatten

#In excel zou dit een merged-cell zijn. bv zo:
#####NAAM GEMEENTE######
#Klas 2 #Klas 3 #Totaal

#nieuw argument #column_headers_above: 
#Een named-numeric vector waarbij de de namen de bovengevoegde headers zijn en de nummers het aantal kolommen
#die de toegevoegde header moet omvatten.

#Voorbeeld:
 # df = data.frame("Kolom_1" = c(1,2,3), "Kolom_2" = c(5,6,7), "Kolom 3" = c(T,F,T))
 # df %>% maak_irreguliere_html_tabel_met_scope(column_headers_above = c("A" = 2, "B" = 1)) 

#maakt:
#       A	          B
# Kolom_1	Kolom_2	Kolom_3
# 1	      5	      TRUE
# 2	      6	      FALSE
# 3	      7	      TRUE


maak_irreguliere_html_tabel_met_scope <- function(data, caption = NULL, row_header_column = NULL, column_headers_above = NULL){
  
  if(!is.null(column_headers_above)){
    
    colgroups <- lapply(unname(column_headers_above), function(x){
      glue("<colgroup span = '{x}'></colgroup>")
      
    }) %>% unlist() %>% paste(collapse = '\n')
    
    colspan_and_names <- lapply(1:length(column_headers_above), function(x){
      
      span = unname(column_headers_above[x])
      name = names(column_headers_above[x])
      
      glue("<th colspan='{span}' scope ='colgroup'>{name}</th>")
      
    }) %>% unlist() %>% paste(collapse = '\n')
    
    
    column_headers_above <-  glue("<col>{colgroups}<tr>{colspan_and_names}</tr>")
    
  }
  
  
  columnnames = glue::glue("<th scope = 'col'>{names(data)}</th>")
  
  index_column_row_headers <- NULL
  
  if(!is.null(row_header_column)){
    
    index_column_row_headers = which(names(data) == row_header_column)
    
    if(length(index_column_row_headers) == 0){
      warning(glue::glue("Kolomnaam voor row-headers niet in dataset. Geen rowheaders aangemaakt.
              Controleer de spelling van: '{row_header_column}'"))
    }
    
    if(is.factor(data[[row_header_column]])){
      data[[row_header_column]] <- as.character(data[[row_header_column]])
      
      warning(glue::glue("Kolom voor row-headers: {row_header_column} is een factorvariabele. Naam van factor gebruikt."))
    }
    
  }
  
  all_rows <- lapply(1:nrow(data), function(x){
    
    cells_per_row <- lapply(1:length(data), function(y){
      
      data_cell = data[x,y]        
      
      if(shiny::isTruthy(y == index_column_row_headers)){
        glue::glue("<th scope = 'row'>{data_cell}</th>")
        
      }else{
        
        glue::glue("<td>{data_cell}</td>")
      }
      
    })
    
    cells_per_row <- cells_per_row %>% unlist() %>% paste(collapse = '')
    
    glue("<tr>{cells_per_row}</tr>")
    
    
  })
  
  all_rows <- all_rows %>% unlist() %>% paste(collapse = '\n')
  
  
  #caption = NULL
  if(!is.null(caption)){
    caption = glue("\n <caption>{caption}</caption> \n")
  } else{
    caption = ""
  }
  
  html_tabel = glue::glue(
    "<table> {caption} {column_headers_above} <tr> \n{paste(columnnames,collapse = '\n')} \n </tr> \n{all_rows} \n </table>")
  
  return(html_tabel)
  
  
}
