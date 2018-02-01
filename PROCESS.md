## Week 2
### 15/01
Opzetten van Firebase Authentication. Gebruikers kunnen nu inloggen en accounts aanmaken via de app.

### 16/01
Werken aan verbinding met API en het ophalen van alle gegevens in een xcode playground. Daarna ook al geschreven in de app zelf. 
Class aangemaakt waar de data opgehaald wordt. 

### 17/01
_Op woensdag was ik ziek en heb ik niet echt aan de app kunnen werken._

### 18/01
Op donderdag heb ik gewerkt aan het correct weergeven van alle films in de app. De filmposters worden nu met titel weergegeven op de 
homepagina in een collection view. De weergegeven films zijn de populairste films op dit moment, dit is een van de query mogelijkheden
van de API die ik gebruik. Voor de zoekfunctie van de app worden de queries via de titel van de film gedaan. Deze films wil ik weer gaan geven met alleen titel in een lijst, zodat de gebruiker dan het gewenste resultaat kan bekijken.

### 19/01
Op vrijdag heb ik gewerkt aan het weergeven van film details. Als er op een film geklikt wordt, komt er een pagina met details van de 
film, namelijk het plot de poster en een aantal knoppen. Daarnaast was het de bedoeling om te werken aan de zoekfunctie en deze helemaal af te maken, maar dat is nog niet helemaal gelukt.

## Week 3
### 22/01
De zoekfunctie is afgemaakt en werkt helemaal goed. Als er geen poster is dan wordt er een default afbeelding ingeladen. De gevonden films worden weergegeven in een collection view.

### 23/01
Gebruikers komen met username in de database en de data van gebruikers wordt ingeladen in een collection view. Voor nu komt de watchlist van de gebruiker al op de profielpagina. Deze zijn nu nog handmatig toegevoegd in de database, maar worden wel al correct weergegeven. Als hier op een film geklikt wordt, komt de gebruiker op detail pagina van de film.

### 24/01
Films toevoegen aan watchlist werkt nu helemaal goed. Was de bedoeling om aangeraden films en watchlist films via segmented control weer te geven maar dit is nog niet gelukt.

### 25/01
Afmaken van MVP. Vrienden toevoegen en films aanraden aan vrienden. Segmented control is gelukt en wordt ook gebruikt voor het weergeven van vrienden/alle gebruikers. Het is alleen nog de bedoeling om bij een film te laten zien door wie de film aangeraden is aan de gebruiker. Dit kan makkelijk opgehaald worden via database.

### 26/01
_Presenteren van MVP. Alle functionaliteiten werken naar behoren en voor volgende week moeten alleen een paar kleine aanpassingen worden gemaakt en de code moet verbeterd worden._

### 29/01
Planning maken voor de week en analyseren van de code via Better Code Hub. Uit de analyse blijkt dat er veel stukken dubbele code zijn, wat klopt. De dubbele code is voornamelijk voor het inladen van data in de collection views (die gebruikt worden op de home pagina, profiel pagina en zoek pagina). Vandaag heb ik verder gewerkt aan wat kleine interface details.

### 30/01
Stukken code herschrijven zodat functies op meerdere plekken gebruikt kunnen worden. 

### 31/01
Processbook aanvullen en werken aan het verslag. Verder heb ik gewerkt aan het herbruikbaar maken van de functies voor de collection views.

### 01/02
Het hergebruiken van de collection views door middel van een aparte class is niet gelukt. Daarnaast is er gewerkt aan overige dubbele code en het toevoegen van comments. Alle overige zaken rondom het project, zoals het verslag zijn ook afgerond vandaag.
