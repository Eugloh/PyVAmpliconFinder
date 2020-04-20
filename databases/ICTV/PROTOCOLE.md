## Branche Polyoma-dev 
## fiche protocole d'obtention des fichiers d'analyses

Plusieurs pistes sont envisagées pour l'études des polyomavirus à l'aide de l'outil PyVAmpliconFinder.
L'étude de ces derniers en récupérant les séquences des gènes LTAG, VP1 et VP2 sur la totalité des séquences référencées n'a pas montré son efficacité. Sur 131 génomes complets référencés entre RefSeq et GenBank les génomes de polyomavirus ont parus trop éloignés à leur étude couplée. 

Notamment, l'annotation de toutes les références ne permets pas d'avoir une étude sur l'ensemble des organismes classifiés. De plus, la région VP2 ne permets pas de procéder à un alignement multiple, les séquences récupérées ne sont pas similaires entre les polyomavirus. Ce constat a été fait en gardant 126 séquences (2 sorex, les séquences refeseq auxquelles certaines autres séquences ont été retirées) 

L'étude peut se faire sur 114 séquences de mammifères et une sequence de sparus aurata pour enraciné la phylogénie. A ce moment l'étude sur les gènes n'a pas encore été testée, à voir si elle peut l'être. 

à partir d'un fichier gbff contenant toutes les fiches des polyomavirus référencés dans genbank + refseq les séquences sont récupérées, parfois inversées si nécéssaire, en fonction de la similarité avec les autres séquences sur le brin complement ( certaines références de génomes complets ont été annotés sur le brin reverse et inversé pour cette étude ) 

Un script python GenBankparse.py permets la récupération des séquences 
- du génome complets
- des séquences de LTAG 
- des séquences de VP1
- des séquneces de VP2 

selon l'objet d'étude d'intérêt. 

	to do: amélioration du script pour automatiser ces choix en ligne de commande 
	- donner un fichier d'entrée avec les code des séquences d'intérêt 
	- éventuellement donner un fichier de renommage des séquences sachant que ces dernieres sont renommées ensuite avec un script R. 
	- pouvoir choisir en ligne de commande si ce qui est choisi d'étudier (VP1, LTAG, génome complet)

Les séquences récupérées sont renommées avec un script R analyserename.R 
