# Final Report
## Beschrijving
Er zijn diverse apps beschikbaar om een watchlist bij te houden voor films. Wat hier ontbreekt is de mogelijkheid tot interactie tussen gebruikers. In het dagelijks geven vrienden elkaar vaak aanbevelingen op het gebied van films, maar de keuze maken voor een film is toch vaak lastig. De app Rec. biedt hiervoor een oplossing door gebruikers de mogelijkheid te geven om niet alleen films aan een watchlist toe te voegen, maar ook aan te raden aan vrienden.

## Ontwerp
Alle viewcontrollers, structs en modellen worden hieronder uitgelegd. Alle view controllers (behalve de Login/SignUp) zijn embedded in een navigation view controller, om zo de navigatie optimaal te maken tussen de verschillende schermen.

### LoginViewController/SignUpViewController
Het eerste scherm bij het opstarten van de app is het login scherm. Als de gebruiker een account heeft kan hier ingelogd worden met het emailadres en een wachtwoord. Anders is het mogelijk om een account aan te maken met email, gebruikersnaam en wachtwoord. Na allebei de acties wordt de gebruiker doorgestuurd naar het beginscherm van de applicatie. Als de gebruiker de velden niet correct invult of als een email adres bijvoorbeeld al bestaat bij het aanmelden voor een account, verschijnt er een pop-up met de juiste error.

### MovieViewController
Na het inloggen of aanmelden komt de gebruiker terecht bij dit scherm. Hier worden via the movie database API de populaire films van dit moment ingeladen in een collection view met behulp van LoadMovies. In deze collection view wordt via een columnlayout automatisch een indeling gemaakt voor alle data. Om de films weer te geven worden de posters gebruikt, die dus automatisch de juiste grootte worden. De grootte wordt altijd gebaseerd op een bepaalde afstand tussen de posters en 3 cellen per rij. Als er op een film geklikt wordt, komt de gebruiker bij de MovieDetailsViewController.

### AccountViewController
Deze controller wordt gebruikt om informatie te laten zien van de gebruiker zelf of andere gebruikers, afhankelijk van de weg naar deze controller toe. Als deze bereikt wordt vanuit de gebruikerslijst, wordt de informatie van de gekozen gebruiker meegegeven om de viewcontroller te vullen. Anders wordt de data van de huidige gebruiker weergegeven. Onder de gebruikersnaam staat of de tekst "This is you" of "Add as a friend", daarnaast wordt de tweede tekst uitgeschakeld als de gebruikers al bevriend zijn.  Onder de gebruikersnaam wordt door middel van segmented control filmdata weergegeven uit Firebase. Het eerste segment laat de watchlist zien in een collection view en het tweede segment laat de aangeraden films zien. Ook hier gelt weer dat wanneer er op een film geklikt wordt de gebruiker bij de MovieDetailsViewController terecht komt. Vanaf de profielpagina is het ook mogelijk om uit te loggen. 

### FriendsViewController
In deze controller is ook gebruik gemaakt van segmented control. Het eerste segment laat de vrienden van de huidige gebruiker zien en het tweede segment toont alle gebruikers van de app in een table view. Bij het klikken op een cell gaat de gebruiker naar de AccountViewController waarbij de data van de geselecteerde gebruiker wordt meegegeven. 

### MovieDetailsViewController
Deze controller wordt vanuit verschillende schermen bereikt en laat details van de geselecteerde film zien. De poster wordt groot weergegeven met daar onder het plot van de film. Naast de poster staan knoppen om de film aan de watchlist toe te voegen of de film aan te raden. Als de film al op de watchlist staan zijn de knoppen en de tekst anders, want dan kan de film van de watchlist verwijderd worden. Bij het aanraden van een film wordt er geschakeld naar de RecommendViewController. Via de segue wordt de data van de film meegegeven. Als de geselecteerde film aangeraden is aan de huidige gebruiker door een vriend, is dit ook te zien in een textlabel.

### RecommendViewController/ConfirmRecommendationViewController


### SearchViewController


### TableViewCell/CollectionViewCell


### Movie/User structs


### PosterImageView


### LoadMovies


### ColumnFlowLayout



![Storyboard](docs/Storyboard.png)


## Uitdagingen
Het was erg lastig voor mij om de films op een duidelijke manier weer te geven die er ook mooi uitzag. Uiteindelijk heb ik gekozen voor een collection view waarin alleen de posters zichtbaar zijn. Met behulp van tutorials en door veel te proberen is dit uiteindelijk gelukt. Gedurende het project zijn wel mijn doelstellingen aangepast. Het idee was om nog meer interactie te implementeren tussen gebruikers. Het idee was hier dat gebruikers een stem konden uitbrengen op een aangeraden film. Stel persoon A raadt een film aan aan persoon B, dan kan persoon C nog stemmen of hij het er mee eens is of juist niet. Dit leek mij een leuke interactie omdat het in het dagelijks leven soms ook zo kan gaan, maar het toch vaal een uitdaging is om een fiml uit te zoeken. Dit was echter wel vrij complex en daarnaast is het ook niet zeker of gebruikers echt zo veel moeite willen steken in het gebruikern van de app. Daarom is het idee iets simpeler gehouden.

## Later werk
In de toekomst zou het mooi zijn om ook te zorgen dat films beoordeeld kunnen worden. Om deze films weer te geven kan simpelweg op de profielpagina nog een segment toegevoegd worden. Dit was alleen niet meer mogelijk in dit tijdsbestek.

[![BCH compliance](https://bettercodehub.com/edge/badge/SophieEnsing/Programmeerproject?branch=master)](https://bettercodehub.com/)
