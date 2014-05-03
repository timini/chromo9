Project: chromo9
Web url: http://student.cryst.bbk.ac.uk/~gseed01/web 
GitHub: https://github.com/timini/chromo9.git

Contributors:
GS George Seed
HG Hakim George
TR Tim Richardson

GS frontend
HG middlelayer
TR database

HG Release and release comments
TR Project directory structure
TR GitHub setup 

Summary:
The project adopts a classic three tier logical architecture realised on two tiers.

The logical architecture consistes of a front end where html pages and associated presentation layer scripts implemented in perl. 

he middle tier layer consists of perl module which act as controller and does not contain any presentation logic. 

The database layer consists of Mysql database populated using "python" scripts acting on flat files extracted form the chromosome file. 

The queries were simple so there was no need to make a data access object layer.


Flow:
An index html page is presented, this is controlled via a css sheet. The page prsents a simple form with a simple GET style form. The CGI calls use a parameterised command facade pattern, this CGI script provides all the rest of the HTML generation, some simple control logic, and connection to the middle tier APIs which manage the database retrieval and data preparation.

Communication:
Meeting at BBK, SMS text, email, Skype
