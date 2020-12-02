Cretan Institutional Inscriptions
====

The database **Cretan Institutional Inscriptions** was created by Irene Vagionakis as part of her PhD research project 
at the University of Venice Ca’ Foscari (2016-2019; supervisors: Claudia Antonetti and Gabriel Bodard). 
The database, built by using the **EpiDoc Front-End Services (EFES)** platform, collects the EpiDoc editions of 
600 inscriptions shedding light on the institutions of the political entities of Crete from the VII to the I century BC.

**EpiDoc Front-End Services (EFES)** is a free, easy to use, highly customisable platform for the online 
publication of ancient texts in EpiDoc XML. EFES allows the creation of multiple indices, search and browse 
interface, geographical visualisation, and integration with linked open data.
EFES is a fork of **Kiln**, an open source multi-platform framework for building 
and deploying complex websites whose source content is primarily in XML.


How to access the database locally (for git users)
====

* Clone the repository
* Go to your local copy of the repository via the Terminal with **cd folder_path**
* Run the command **build.sh** (Mac OS X/Linux) or **build.bat** (Windows) on the Terminal and leave its window open
* If you get a Java error message, install the latest JDK from https://www.oracle.com/java/technologies/javase-jdk15-downloads.html
* Open your browser and go to http://127.0.0.1:9999/ (NB: it takes a while to load)


How to access the database locally (for other users)
====
* Download the repository from ‘Code’ > ‘Download ZIP’
* Unzip the downloaded file and move the unzipped folder to your desktop, without changing its name
* Open the Terminal / Command Line / Command Prompt (Windows: type **cmd** in the search box in the Start menu; Mac OS X/Linux: type **terminal** in the search box in the menu bar)
* Type in the Terminal the command **cd Desktop\\CretanInscriptions-master** (Windows) or **cd Desktop/CretanInscriptions-master** (Mac OS X/Linux) and then press Enter (NB: if you saved the folder in a different place, e.g. inside another folder on the desktop or in Downloads, you should replace **Desktop** in the command with the actual path of the folder)
* Type in the Terminal the command **build.sh** (Mac OS X/Linux) or **build.bat** (Windows), then press Enter and leave the Terminal window open
* If the messages that appear in the Terminal include **Development server is running at http://127.0.0.1:9999**, everything is fine. If not, you need to install a more recent version of Java (7 or later) from here https://www.oracle.com/java/technologies/javase-jdk15-downloads.html, choosing the download option corresponding to your Operating System and then selecting ‘Accept License Agreement’
* Open your browser and go to http://127.0.0.1:9999/ (NB: it takes a while to load)


EFES and Kiln code and documentation
====

* https://github.com/EpiDoc/EFES
* https://github.com/EpiDoc/EFES/wiki/
* https://github.com/kcl-ddh/kiln/
* http://kiln.readthedocs.org/en/latest/
----

EFES is licensed under the Apache 2.0 open software license,
and is copyright the University of London, King's College London,
and all listed individual contributors.
