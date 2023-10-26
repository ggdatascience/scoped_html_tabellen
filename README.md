# scoped_html_tabellen
R-functies om scoped html tabellen te maken t.b.v. digitoegankelijkheid.

Om met deze functies te gebruiken in Rmarkdown/Quarto kan je knitr::raw_html() gebruiken.

bijvoorbeeld:
 df %>% maak_simpele_html_tabel_met_scope(caption = "bla") %>% knitr::raw_html()

# Wat heb je hier aan?
Zie: https://www.w3.org/WAI/tutorials/tables/
Scoped tabellen zijn een vereiste voor digitoegankelijkheid (tenzij een tabel heel klein is en de waarden per kolom niet verward kunnen worden).

HTML tabellen zonder 'scoped' rij en kolom-headers worden snel verwarrend als ze door een screen-reader worden voorgelezen
Een screen reader leest dan namelijk alleen de waarde die in de cel staat voor.

In een tabel met veel kolommen geef alleen de waarde in een cel, bijvoorbeeld  **'34'** onvoldoende informatie.
Zeker als meerdere kolommen naast elkaar numerieke waarden kennen. Is 34 de leeftijd of de score van een deelnemer? 
En om welke deelnemer van de 30 ging het eigenlijk?

Als een tabel scoped rij- en kolomheaders heeft, leest een screen reader de cel voor als: "Rij 20 Jan; Kolom 4 Leeftijd; **'34'**"

Helaas lijken er geen standaardoplossingen te zijn om digitoegankelijke (dus scoped) tabellen te maken vanuit R/Rmarkdown.
Vandaar tijdelijk de onderstaande functies die een dataframe omzetten naar een scoped html tabel.

Het zou nog beter zijn als deze functionaliteit in  DT/kable o.i.d wordt gemaakt
Ik heb op github deze feature-request gevonden voor kable. Is nog hulp bij nodig.  https://github.com/yihui/knitr/issues/1747
 
