#TOERH API/WebClient
==============

Här kommer instruktioner om hur du går till väga för att installera API och webapplikationen.

###API
==============
1. root-katalogen är: accApp. Bortse från alla andra filer.
2. Gå till /documentation för att få instruktioner för resten av processen.



###Webapplikationen
==============
1. root-mappen är "WebClient".
2. Kopiera mappen till din root och kör sedan index.html

Fungerande inloggning [anv: Jabob@test.com, pass: jacob123]



###Ändringar under andra fasen
==============
Det har varit en del att reflektera över efter den första delen av kursen. 
Viktigaste ändringar som gjorts kring APIt är:
1. /Search fungerar nu utan att vara inloggad
2. Endast inloggade användare kan använda PUT/DELETE/POST på resurser
3. En användare kan endast radera och uppdatera sina egna resurser och inte andras.
4. En "get" på /resources skickar nu med count, offset och limit så att pagination är möjligt på webklienten
