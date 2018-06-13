

# Teaching-HEIGVD-RES-2018-Labo-HTTPInfra

__Auteurs: Christophe Joyet et Patrick Neto__




## Step 1: serveur HTTP statique avec apache httpd

### Webcasts

* [Labo HTTP (1): Serveur apache httpd "dockerisé" servant du contenu statique](https://www.youtube.com/watch?v=XFO4OmcfI3U)

Pour cette première partie du laboratoire, il suffisait de mettre en place un serveur https Apache, mettant à disposition du contenu statique. Pour cela, il faut tout d'abord préparer une image Docker, contenant un serveur Apache fonctionnel.  Le Dockerfile correspondant est le suivant:

```dockerfile
FROM php:7.0-apache
COPY src/ /var/www/html/
```

Ce dernier permet de construire une image Apache avec la version 7.0 de PHP et copier dans `/var/www/html` (utilisé ici pour la mise à disposition du contenu statique) le contenu de `src/`. Dans ce dernier dossier, notre contenu statique téléchargé depuis le site suivant: https://startbootstrap.com/template-overviews/clean-blog/ . Ce template est gratuit et fonctionne avec un framework HTML/CSS appelé Boostrap, facilitant grandement la mise en page d'un site web.

Une fois l'arborescence mise en place et le Dockerfile prêt, il suffit de construire l'image Docker, à l'aide de la commande `docker build -t res/apache_php <chemin_absolu_vers_dockerfile>`.

Pour lancer le container, il suffit d'utiliser la commande: `docker run -d --name apache_static res/apache_php ls ` (le paramètre `—name` est pour nommer explicitement le container).



## Step 2: Serveur HTTP dynamique avec express.js

### Webcasts

* [Labo HTTP (2a): Application node "dockerisée"](https://www.youtube.com/watch?v=fSIrZ0Mmpis)
* [Labo HTTP (2b): Application express "dockerisée"](https://www.youtube.com/watch?v=o4qHbf_vMu0)

Pour cette étape, l'objectif est de mettre en place un serveur HTTP offrant du contenu dynamique, à l'aide du framework Node.js et la librairie express.js . La même procédure que dans l'étape 1 est requise, à savoir la création d'un Dockerfile qui va permettre de construire une image avec un environnement Node.js. Elle se présente comme ceci:

```dockerfile
FROM node:4.4
COPY src /opt/app

CMD ["node", "/opt/app/index.js"]
```

Ce dernier permet de mettre en place un environnement node.js version 4.4, dont le contenu de `/opt/app`  cope celui de `src/`, situé sur notre machine. Celui-ci contient les fichiers nécessaires au bon fonctionnement du serveur. 

C'est dans ce répertoire, que le fichier `index.js` est créé. Il contient le code qui permet de renvoyer au client HTTP une liste de villes, associées à un pays (son abréviation). A chaque requête, le serveur renvoie une liste aléatoires de ville sous format JSON, à l'aide de la librairie `Chance.js`. 

Les dépendances aux librairies requises pour ce code sont gérées à l'aide des fichiers `package-lock.json` et `package.json` . L'ajout des librairies utilisées pour ce code sont ajoutées à l'aide de la commande `nom install --save chance express`. 

Une fois que le code est fonctionnel, il suffit de construire l'image et démarrer le conteneur à l'aide des commandes suivantes:

```
docker build -t res/express_students <chemin_absolu_vers_dockerfile>
docker run -d --name express_dynamic res/express_students
```

Après cela, le serveur est fonctionnel et on peut y accéder à l'aide de l'adresse spécifique au conteneurs dockers et le port 3000.


## Step 3: Reverse proxy avec apache (configuration statique)

### Webcasts

* [Labo HTTP (3a): reverse proxy apache httpd dans Docker](https://www.youtube.com/watch?v=WHFlWdcvZtk)
* [Labo HTTP (3b): reverse proxy apache httpd dans Docker](https://www.youtube.com/watch?v=fkPwHyQUiVs)
* [Labo HTTP (3c): reverse proxy apache httpd dans Docker](https://www.youtube.com/watch?v=UmiYS_ObJxY)

Afin de mettre en place un serveur Apache Reverse Proxy, il faut activer le module *mod_proxy*. Pour ce faire, voici le Dockerfile a réaliser pour la création d'une image de Reverse Proxy fonctionnelle:

```dockerfile
FROM php:7.0-apache

COPY conf/ /etc/apache
RUN a2enmod proxy proxy_http
```

Avec cette configuration, on effectue une copie des fichiers de config générés statiquement pour le serveur apache. On fait également en sorte de lancer le programme d'activation de modules *proxy* et *proxy_http* pour la mise en place d'un reverse proxy.

Afin de mettre en place ce serveur, il faut également créer une configuration de virtual host (en plus de celle par défaut). On aura donc deux fichiers de configuration: un par défaut *000-default.conf* et un pour le nom de domaine prévu pour le reverse proxy *001-reverse-proxy.conf*, dont voici le contenu:

```
<VirtualHost *:80>
	ServerName demo.res.ch

	ProxyPass 			"/api/cities/" "http://172.17.0.3:3000/"
	ProxyPassReverse 	"/api/cities/" "http://172.17.0.3:3000/"

	ProxyPass 			"/" "http://172.17.0.2:80/"
	ProxyPassReverse 	"/" "http://172.17.0.2:80/"
</VirtualHost>
```

Cette configuration prend comme port d'entrée le 80 (à l'entrée du container, mais il faut encore le mapper avec le port 8080 qui communique avec l'extérieur). Le nom de domaine pour faire appel au serveur proxy est `demo.res.ch`. Ensuite deux paires de directives gère chacune la redirection de requêtes au serveur express dynamique (la première paire), ainsi que la redirection au serveur static (la seconde paire).

Les adresses IP de chaque serveur sont fixées statiquement. On va voir dans la partie 5 que le procédé peut être dynamiquement géré.

## Step 4: AJAX requests with JQuery

### Webcasts

* [Labo HTTP (4): AJAX avec JQuery](https://www.youtube.com/watch?v=fgpNEbgdm5k)

Maintenant que nous avons les deux serveurs de requêtes, chacun étant accédé par un seul point d'entrée géré par le reverse proxy, nous pouvons les faire interagir, afin d'afficher du contenu statique sur notre page d'accueil. Pour ce faire, il faut d'abord ajouter aux Dockerfile respectifs la directive suivante, afin d'installer *vim* au démarrage de l'image (nécessaire pour modifier des fichier de chaque serveur directement, lors de l'exécution du conteneur):

```dockerfile
RUN apt-get update && \ 
  apt-get install -y vim
```

Ensuite, il est nécessaire de faire un lien dans notre page HTML d'accueil vers le script `cities.js`, qui va ajouter dynamiquement des listes de villes dans le contenu static. Il suffit d'ajouter la ligne la ligne suivante en fin de code HTML:

```html
<!-- Custom scripts for printing list of cities -->
<script src="js/cities.js"></script>
```

Ce script javascript va permettre d'utiliser ajax pour mettre à jour notre page dynamiquement, sans avoir à la mettre à jour. Il se présente comme ceci:



Ce script va ajouter dynamiquement une liste de villes à la balise ".list-cities", de manière asynchrone.

## Step 5: Dynamic reverse proxy configuration

### Webcasts

* [Labo HTTP (5a): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=iGl3Y27AewU)
* [Labo HTTP (5b): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=lVWLdB3y-4I)
* [Labo HTTP (5c): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=MQj-FzD-0mE)
* [Labo HTTP (5d): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=B_JpYtxoO_E)
* [Labo HTTP (5e): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=dz6GLoGou9k)

Nous avons vu que notre reverse proxy spécifie les adresses IP de chaque serveur de manière statique. Ce n'est pas des plus pratique, car il faut à chaque fois lancer les conteneurs dans l'ordre pour être sûrs qu'ils aient les bonnes adresses. Afin de pallier à ce problème, une script PHP est généré, utilisant des variables d'environnement pour réécrire notre fichier de configuration du reverse proxy **001-reverse-proxy.conf*, mettant ainsi à jour dynamiquement les adresses qu'on aura spécifié dans les variables, au lancement du proxy. Voici à quoi ressemble le script mentionné:



Lors du lancement du conteneurs du serveur reverse proxy, nous spécifions donc les variables d'environnement à utiliser par le script, comme ceci:



Ainsi, il est possible de lancer les deux conteneurs de serveurs statique et dynamique, recupérer leurs adresses respectives et les mentionner dans les variables d'environnement.

## Additional steps to get extra points on top of the "base" grade

### Load balancing: multiple server nodes (0.5pt)

Afin de pouvoir ajouter plusieurs serveurs dynamiques/statique, repartissant ainsi la charge des requêtes, il faut tout d'abord modifier le Dockerfile du reverse proxy, pour que ce cas de figure puisse être géré. Voici la ligne à modifier dans le Dockerfile pour activer les modules nécessaires:



Une fois ceci fait, il suffit de modifier le script PHP pour qu'il puisse gérer deux paires d'adresses IP (par exemple) pour deux serveurs statiques et dynamiques qui se répartiront la charge. Voici le script, une fois modifié:



Celui-ci permet donc de repartir les requêtes entre les serveurs disponibles. Ceci peut être facilement vérifié en ajoutant l'adresse IP du serveur solicité en titre de page (pour le serveur statique), et dans le JSON (pour le serveur dynamique). En rafraîchissant plusieurs fois l'affichage, nous voyons que l'adresse change de temps à autre. On peut donc conclure que la charge est repartie.

### Management UI (0.5 pt)

-- 