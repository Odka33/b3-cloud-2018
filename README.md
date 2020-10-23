# TP1 Cloud : Architectures complexes cloud-like.

## Prérequis.

1. mettez vous par deux et reliez vous avec un câble RJ, ça évitera de tout faire péter sur vos machines. Mettez-vous dans un petit réseau en /24 on sera large

2. Récupérez le projet git https://github.com/coreos/coreos-vagrant.

3. explorez un peu le Vagrantfile

4. ajouter un disque de 10 g

5. Créez ensuite 5 machines à l'aide de ce Vagrantfile (ça se fait facilement à l'aide d'une variable déjà créée dans le fichier Vagrantfile)



Réponse 1 

Lors de ce TP il était demandé de connecté 2 ordinateur à l'aide d'un cable RJ45 malheureusement je ne dispose pas de port sur mon ordinateur. Je vais alors faire ce TP en n'abordant pas se problème.

Réponse 2

##### Terminal.

```
git clone https://github.com/coreos/coreos-vagrant 
```

Réponse 3 


- La syntaxe du Vagrantfile est ruby.

- Le Vagrantfile appel une librairie "fileutils".

- Il est ensuite précisé la version du Vagrantfile "1,60".

- Ligne 9 à 19 on procède à l'installation d'un plugin "igniton". L'installation à était scripté afin que si il est présent il ne se réinstalle pas et inversement .

- Ligne 26 à 36 des variables de configuration son instancié.

- Ligne 40 à 59 crée un nombre de VM exact à la valeur de la variable "$num_instance" ainsi qu'application des variables "vm_memory", "vm_cpu".
- Ligne 61 à 74 configuration de l'agent SSH et du nom des VMs.

- Ligne 61 à la fin configuration du founisseur de virtualisation VMware, Hyper-v, Virtualbox et application des variable d'environnement au VM mise en place d'un partage de dossier entre host et vm.

Réponse 4:

Afin d'ajouter un disque de 10Go à core il faut ajouter les lignes de code suivante au Vagrantfile.

##### Fichier ( ligne 136 ).

```
        file_to_disk = 'disk2.vdi'
        unless File.exist?(file_to_disk)
          vb.customize ['createhd', '--filename', file_to_disk, '--size', 10 * 1024]
        end
        vb.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk] 

```

Réponse 5: 

Afin de crée 5 machines simultanéments il faut changer la valeur de la variable "$num_instance" qui est par défaut à 1 pour 5.

##### Fichier ( ligne 26 ).

```
# Change default to 5
$num_instances = 5
```

##### Terminal.

Aller à la racine du référentiel coreOS
```
cd /coreos-vagrant/
```
Démarrer les VMs à l'aide de la commande suivante
```
Vagrant up
```
Les VMs vont poper dans votre envirronement virtualbox.

![](https://i.imgur.com/264rmTX.png)

![](https://i.imgur.com/VR8awNl.png)

Il est maintenant possible de se connecté aux différente VMs Coreos à l'aide de la commande suivante:

##### Terminal.
```
Vagrant ssh core-0$x
```

Soit la variable x le nombre correspondant à la vm choisie

---

# IMPORTANT. DE FOU.

* Cette partis du TP ne met pas accessible du à mon manque de port Ethernet .

---

# Docker Swarm

* Dans cette partis il nous est demandé d'utiliser la technologie "Swarm" de docker. Nous allons mettre en place un swarm de 5 noeuds : 3 managers et 2 workers.


## Mise en place

1. Configurer le mode experimental et la clause métric-addr au démon docker.

2. Mise en place d'un swarm 3 managers 2 workers.


Réponse 1:
Pour ajouter le mode "experimental" et la publication des metrics il faut ajouté ces close au fichier de configuration du démon docker comme suis.

##### Fichier.

( Si vous n'avez pas encore utiliser docker le répertoire "/etc/docker" n'existe pas encore pour le crée il suffit de taper une commande docker tel que `docker info`).

Création du fichier:

##### Terminal.
```
touch daemon.json
```

Editer le fichier et y ajouter les clauses suivantes.

![](https://i.imgur.com/2kP1CWV.png)

Réponse 2:

Initialisation du swarm:
##### Terminal.
![](https://i.imgur.com/yLJPtBi.png)

Génération d'un commande d'ajout de managers au swarm:

![](https://i.imgur.com/XNTD7bk.png)

Création d'un commande d'ajout de workers au swarm:

![](https://i.imgur.com/dPC3lGS.png)

Une fois les commandes généraient. Il suffit d'une simple éxectution sur les machines ditent "Managers", "Workers" et elles seront ajoutés au swarm.

Pour les Managers:

![](https://i.imgur.com/HUgHp9U.png)

Pour les Workers:

![](https://i.imgur.com/8j5L8Ao.png)

Ont peut vérifier que la configuration fonctionne en utilisant la commande `Docker node ls` qui check l'état des liens sur notre swarm docker.

![](https://i.imgur.com/v2khU1r.png)

Managers:

- core-01
- core-02
- core-03

Workers:

- core-04
- core-05 


---

# Dumb Service - Part 1

Dans cette partie du travaux pratique tous nos services, nos applicatifs, tourneront sous la forme de stacks ou services Swarm.

#### Les images utilisées dans le docker-compose.yml doivent être accessibles sur tous les noeuds >

Pour simplifier la tâche et aller plus vite lors de phase d'exécution j'ai bricolé un script utile pour éxecuter une même commande sur toute les machines du swarm.

##### Fichier.

```
#!/bin/bash
for i in $(seq 1 5)
do
    vagrant ssh core-0$i -c '<the command>'
    # Example
    vagrant ssh core-0$i -c 'mkdir /test'
done
```

Installation de "docker-compose" sur les machine.


Création d'un répertoire "/opt/bin/":

##### Terminal.
```
cd / && sudo mkdir -p /opt/bin
```

Téléchargement puis installation du binaire "docker-compose":

##### Terminal.
```
cd / && sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose
```

Réglage des permissions pour utilisation du pacquet:

##### Terminal.
```
cd / && sudo chmod +x /opt/bin/docker-compose
```

#### Utilisez le compose.yml fourni afin d'avoir une stack de test. Il pop l'archi suivante : `BDD <--- AppPython <--- NGINX` >

Ensuite on télécharge le référentiel avec le "docker-compose.yml" sur chacun des noeuds:

##### Terminal.
```
git clone https://github.com/It4lik/B3-Cloud-2018.git
```

Enfin pour déployer l'infrastructure sur tout les hôtes. Il faut exécuter la commande suivante sur l'hote "core-01" manager et leader du swarm pour propager le déploiment de configurations:

##### Terminal.
```
cd /docker stack deploy python_dirty_app -c docker-compose.yml
```

Il est possible de vérifier que l'essaim c'est bien déployé avec la commande qui suit:

##### Terminal.
![](https://i.imgur.com/7N8QZiU.png)

Si l'ont veut vérifier que les services sont correctement démarrer il existe la commande:

##### Terminal.
![](https://i.imgur.com/jInaRcw.png)

#### Une fois démarrée l'appli devrait être joignable sur le port 8080 de votre cluster>

L'application est bien joingnable sur le port 8080 car si ont effectue une commande curl depuis la machine sur le localhost et le port 8080 le code de l'apps web nous est bien renvoyé:

##### Terminal.
![](https://i.imgur.com/zrtK4em.png)

Pour effectuer la fin du TP correctement nous allons supprimer notre nouvelle pile d'application avec la commande:

##### Terminal.
```
docker stack rm python_dirty_app
```


---

# Weave Cloud

* Weave Cloud outils Saas de monitoring et métrologie directement depuis interface très performant. Il permet de monitorer un swarm. Durant cette partie nous allons déployé et configurer cet outils sur notre swarm.



#### Inscrivez-vous (n'hésitez pas à utiliser un mail jetable >

Avec github.

#### Demandez une connexion à une instance de Docker Swarm pour récupérer votre token >

![](https://i.imgur.com/Rk5XNjn.png)

![](https://i.imgur.com/AR6HKRM.png)

Executer la commande sur le leader du swarm pour lancer les services:

![](https://i.imgur.com/QE6XnLP.png)

#### Q1 : comment ce conteneur a-t-il pu lancer des conteneurs sur votre hôte ? >

Le conteneur va se servir de son propre socket docker et monter le répertoire sur le conteneur lancer par la commande. C'est le principe "docker in docker" le conteneur pourras alors utiliser le  socket docker de l'hote pour lancer des conteneur depuis celui-ci.

![](https://i.imgur.com/2CmExBl.png)

Il est possible par l'interface web weave de surveiller les performances des applications et leur évènement. 


- stockage des données 
- organisation des données 
- accès aux métiques
- visualisation des donnée
- journalisation des logs 
- surveillance continue
- Automatisation
- alerte automatique

---

# A. CEPH ooooouuuuu...

## Présentation

## Mise en place

## Monitors 

#### Sur votre premier host:
```
docker run -d --net=host \
--restart always \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph/ \
-e MON_IP=<IP_HOST_ONLY>  \
-e CEPH_PUBLIC_NETWORK=<HOST_ONLY_CIDR_NETWORK> \
--name="ceph-mon" \
ceph/daemon mon
```
* MON_IP c'est pour "monitor IP".
* suite à ça, déplacer tout le contenu de /etc/ceph/ sur tous les autres noeuds.
* exécuter de nouveau la commande docker run ci-dessus sur deux autres noeuds (ce sera vos 3 monitors).
* n'oubliez pas de changer la variable MON_IP sur chacun de vos 3 monitors.

J'execute la commande sur mon premier hote.

![](https://i.imgur.com/pKx1qPL.png)

Il est possible que les configuration ne soit pas bonne alors on peut modifier le fichier de configuration ceph "/etc/ceph" pour y rajoutez ces configurations réseaux valide pour mon cas:

##### Terminal.

```
cat /etc/ceph/ceph.conf
```
 
##### Fichier.

![](https://i.imgur.com/j178AuE.png)

Je partage ensuite ma configurations avec mes autres hôtes via github:

##### Terminal.

```
#core-01
cd /etc/ceph/
git init 
git add .
git commit -m "first commit"
git remote add origin https://github.com/Odka33/Docker-provision.git
git push -u origin master
```
```
#core-0{2,3}
mkdir -P /etc/ceph
sudo git clone https://github.com/Odka33/Docker-provision.git .
```

Ensuite j'éxecute de nouveau la commande "docker run":

##### Terminal.

(core-02)
![](https://i.imgur.com/5TmubQH.png)

(core-03)
![](https://i.imgur.com/2BjBVPc.png)

Ont peut vérifié que la configurtaion fonctionne en effectuant les commandes "ceph df" et "ceph status":

![](https://i.imgur.com/vXInnZR.png)

## Managers 

* Sur les 3 mêmes hôtes que les monitors :
```
docker run -d --net=host \
--privileged=true \
--pid=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph/ \
--name="ceph-mgr" \
--restart=always \
ceph/daemon mgr
````

* Effectuer une vérification.

J'execute la commande sur les 3 même hôtes que les moniteurs soit core-01 ""-02 et ""-03. j'effectue une vérification de configurations: 

![](https://i.imgur.com/W5BKjIk.png)

Si le service "mgr" est apparue et est actif alors c'est bon.

## OSDs 

1. Récupérez l'output de la commande ceph auth get client.bootstrap-osd et stockez le dans un fichier.

2. Sur tous les noeuds : copier le contenu du fichier précédemment créé dans /var/lib/ceph/bootstrap-osd/ceph.keyring, effacez s'il existe déjà, créez s'il n'existe pas

3. Puis executé :

```
docker run -d --net=host \
--privileged=true \
--pid=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph/ \
-v /dev/:/dev/ \
-e OSD_FORCE_ZAP=1 \
-e OSD_DEVICE=<CHEMIN_VERS_NEW_DISK_IN_/dev> \
-e OSD_TYPE=disk \
--name="ceph-osd" \
--restart=always \
ceph/daemon osd_ceph_disk
```

4. n'oubliez pas de changer CHEMIN_VERS_NEW_DISK_IN_/dev par /dev/sdb par exemple

5. check cluster status

##### Réponse 1:

On peut récupérér l'output de la commande avec:

Terminal.
```
docker exec ceph-mon ceph auth get client.bootstrap-osd > file.txt
```

##### Réponse 2:

Pour créer le chemin s'il n'existe pas:

Terminal.
```
mkdir -p /var/lib/ceph/bootstrap-osd/
```

Modifier ou crée s'il n'existe pas ceph.keyring:

Fichier.
![](https://i.imgur.com/hEQaZ1z.png)

##### Réponse 3 et 4:

Nous exécutons la commande suivante:

```
docker run -d --net=host \
--privileged=true \
--pid=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph/ \
-v /dev/:/dev/ \
-e OSD_FORCE_ZAP=1 \
-e OSD_DEVICE=/dev/sdc> \
-e OSD_TYPE=disk \
--name="ceph-osd" \
--restart=always \
ceph/daemon osd_ceph_disk
```

Pour "/dev/sdc" emplacement du bloc de 10go ajoutez plutôt dans les prérequis.

##### Réponse 5:

Ont check que la configurtation et correct:

Terminal.

![](https://i.imgur.com/ORgDajR.png)


## MDS

1. Sur tous les noeuds:

```
docker run -d --net=host --name ceph-mds --restart always -v /var/lib/ceph/:/var/lib/ceph/ -v /etc/ceph:/etc/ceph -e CEPHFS_CREATE=1 -e CEPHFS_DATA_POOL_PG=128 -e CEPHFS_METADATA_POOL_PG=256 ceph/daemon mds
```

2. Sur un noeud, pour éviter de péter vos machines :

```
ceph osd pool set cephfs_data size 2
ceph osd pool set cephfs_metadata size 2
ceph osd set nodeep-scrub
```

##### Réponse 1:

On démarre le conteneur mds via la commande. Mds démon du serveur de métadonnée.

On peut voir que le démon a démarrer en executant la commande `docker ps`.

Terminal.
![](https://i.imgur.com/Xdm2RQf.png)

##### Réponse 2:

Exécution des commandes sur l'hôte core-01.

![](https://i.imgur.com/HO9ADKH.png)

![](https://i.imgur.com/0fDz1le.png)

![](https://i.imgur.com/Mf5HZWn.png)

## Configuration finale

1. Dans un des conteneurs monitor, on va créer un secret qui nous permettra d'accéder au volume CEPH sur tous nos noeuds:

```
ceph auth get-or-create client.dockerswarm osd 'allow rw' mon 'allow r' mds 'allow' > keyring.dockerswarm
cat keyring.dockerswarm
```

2. Puis sur tous les noeuds:

```
mkdir /data
echo "<MONITOR_IPS_COMMA_SEPARATED>:6789:/      /data/      ceph      name=dockerswarm,secret=<YOUR_SECRET_HERE>,noatime,_netdev 0 2" > /etc/fstab
mount -a`
```
Le répertoire /data devrait être accessible sur les noeuds.


##### Réponse 1:

On execute la commande suivante sur les monitors qui va générer une clé et l'enregistrer dans le fichier `keyring.dockerswarm`.

Terminal.
```
docker exec ceph-mon ceph auth get-or-create client.dockerswarm osd 'allow rw' mon 'allow r' mds 'allow' > keyring.dockerswarm
```
##### Réponse 2:

On va crée un répertoire data sur tout nos hôtes.

Terminal.
```
mkdir data
```

Ensuite on va écrire les configurations pour le stockage dans le fichier de configuration de filesystem `fstab` ont y ajoute les ips des moniteur ainsi que la clé générer dans la réponse 1.

Terminal.
```
echo "172.17.8.101,172.17.8.102,172.17.8.103:6789:/      /data/      ceph      name=dockerswarm,secret=AQAZq+lbbuAFJhAAkOBSYIVTs8N16zTGfkATKA==,noatime,_netdev 0 2" >> /etc/fstab
```

Ensuite ont monte le filesystem avec la commande mount.

Terminal.
```
mount -a
```

Pour finir ont peut vérifier que la configuration fonctionne et que le répertoire data et répliquer sur tout nos hôtes en créant un fichier dedans si il apparait sur tout les autres alors sa fonctionne.

![](https://i.imgur.com/2rPWtPw.png)

## Un peu de réflexion.

1. Expliquer rapidement le principe d'un système de fichiers distribué ( distributed filesystem ).
2. Proposer une façon d'automatiser le déploiement de cette configuration CEPH, sans passer par un volume de l'hôte ? 

actuel : CEPH --MDS--> Host --run -v--> conteneur

demandé : CEPH --MDS--run -v--> conteneur

##### Réponse 1:

Les principes du systèmes de fichier distribué sont une aborescence logique et des données partagé depuis des emplacemnts différents, assurer la redondance et la disponibilité des données grâce à la réplication, rassembler différents partages de fichiers à un endroit unique de façon transparente.

##### Réponse 2:

Pour automatiser le déploiement de CEPH j'utiliserai Vagrant et ansible. Je déploireais les hosts VM via vagrant et à la fin du script vagrant j'utiliserais l'automatisation et le déploiement d'ansible via les playbooks pour fournir les configurations CEPH à mes hosts simultanément.

Example:

Vagrant -> core-01, core-02, core-03, core-04, core-05
Ansible -> CEPH -> MDS-run -> conteneur 

---

# B..... NFS

1. Expliquez le principe d'un partage NFS, quels pourraient être ses limites dans le cas d'un swarm comme le nôtre (qui peut être amené à grandir) ?

2. Proposez une façon d'automatiser le déploiement cette conf NFS.


---

# Registry - Part 1

1. Où est lancé le service réellement ? (sur quel hôte, et comment on fait pour savoir ?) Combien y'a-t-il de conteneur(s) lancé(s) ?

2. Pourquoi le service est accessible depuis tous les hôtes ? Documentez vous sur internet.

##### Réponse 1:

Le service est lancé localement ont execute un registre local toute les images seront stocker sur le filesystem de la machine. Il n'y à aucun conteneur lancé à la suite de cette opération.

##### Réponse 2:

Le service est accessible sur tous les hôtes car il à était publié sur le port 5000 de la machine core-01 les autres machine étant sur le même réseaux elle peuvent accéder au registres.

---

# Dumb Service - Part 2

1. Hébergez les images du Dumb Service dans le registre

2. Utilisez le répertoire /data pour stocker ses données (docker-compose.yml, configurations, applications, données)

3. Observer son évolution sur Weave Cloud


##### Réponse 1:

Nous allons commencé par construire les images.

Terminal.
```
cd /app/
docker-compose build 
```

![](https://i.imgur.com/BbTvNL6.png)

Une fois l'image crée ont vas tager celle ci pour qu'elle pointe vers notre registre.

Terminal.
````
docker image tag m1.swarm:5000/python-app 127.0.0.1:5000/python
````

Enfin ont la pousse sur le registre.

```
docker push localhost:5000/python
```

On vérifie qu'elle à bien était pousser sur le registre.

Terminal.

![](https://i.imgur.com/aPUg1Em.png)

Nos images ont bien était poussé sur le registre.

Il est aussi possible de les download.

![](https://i.imgur.com/GIVpEAD.png)

##### Réponse 2:


Pour cette partis j'ai télecharger le contenus `/tp1/app/*` dans le répertoire `/data/` .

##### Réponse 3:

Ont déploit weave.

![](https://i.imgur.com/gvLXpcR.png)

![](https://i.imgur.com/HvGO1BC.png)

Terminal.
![](https://i.imgur.com/nm6y3hF.png)

On patiente et on peut ensuite visité l'interface qui nous permet d'avoir les metrics de informations de notre swarm.

![](https://i.imgur.com/JNWTiBI.png)

![](https://i.imgur.com/Qkoe8sL.png)

![](https://i.imgur.com/TsUMZ4y.png)

![](https://i.imgur.com/rMvUVER.png)

![](https://i.imgur.com/3XjVgrd.png)

---

# Keepalived

1. Lancez la commande sur tous vos hôtes, en modifiant la priorité à chaque fois. Une fois fait, vous n'accéderez à votre cluster plus qu'avec l'ip virtuelle


2. que fait le --net=host de la commande exactement ? Je veux voir une utilisation de nsenter en réponse à cette question. Pourquoi avoir besoin de ça sur Keepalived ?

3. A quoi sert --cap-add=NET_ADMIN ?

4. Le principe de priorité au sein de Keepalived et le fonctionnement simplifié de vrrp (schéma si vous voulez)


##### Réponse 1:

Ont execute la commande sur tout le cluster entier pour core-01 la priorité à 200 et pour le reste 199, 198, 197 etc...

![](https://i.imgur.com/dnlYltt.png)

![](https://i.imgur.com/MU4CRYi.png)

ont vérifie ensuite que la configuration à bien fonctionner.

En ping
![](https://i.imgur.com/9UEMWMm.png)

ou via l'interface réseau des hôte coreos
![](https://i.imgur.com/3faRCkb.png)

##### Réponse 2:

La directive `--net=host` sert à préciser le pilote réseau utiliser. Si elle est préciser elle a pour effet de ne pas isolée la pile réseaux de ce conteneur de l'hote docker.
Nous avons besoin de sa sur keepalived pour executer avec nsenter des commandes et configuration sur tout les hôtes docker à partir de l'ip virtuel préalablement crée.

##### Réponse 3:

`cap-add=NET_ADMIN` sert à donner les priviléges sur les cartes et interfaces réseaux du systèmes hôtes.

##### Réponse 4:

Le principe de priorité sert à désigner l'hote qui serviras de Master du swarm docker. Le principe de vrrp est de définir la passerelle par défaut pour les hôtes du réseau comme étant une adresse IP virtuelle.

---

# Show me your metrics

1. ce qu'est un 'collector' dans ce contexte

2. un peu plus en détail le fonctionnement de chacun des tools déployés par cette stack

grafana
![](https://i.imgur.com/TDt7cMS.png)
prometheus
![](https://i.imgur.com/7Tp3hrD.png)
alertmanager
![](https://i.imgur.com/pUPQFXu.png)
unsee
![](https://i.imgur.com/nj592M0.png)



##### Réponse 1:

Dans ce contexte un `collector` est un collecteur de metrics à des fins de visualisation dans le cas de grafana.

##### Réponse 2:

Prometheus:
Database monitoring tools

Grafana:
data vizualisation tools

Cadvisor:
Analyzes resource usage and performance characteristics of running containers.

AlertManager:
Le AlertManager gère les alertes envoyées par les applications clientes est une partis du projet prometheus

unsee:
Alert dashboard for Prometheus Alertmanager

caddy:
Caddy is the HTTP/2 web server with automatic HTTPS.

---

# Traefik
