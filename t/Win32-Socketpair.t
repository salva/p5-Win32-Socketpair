# -*- Mode: cperl -*-

use Test::More tests => 3;

use Win32::Socketpair 'winsocketpair', 'winopen2';
ok(1, "loaded");

alarm 60;

my $data;

{ local $/; $data = <DATA> }

my $in = $data;
my $out = '';
my $mid = '';
my $mid_done;

my ($here, $there) = winsocketpair;

my $true = 1;
ioctl( $here, 0x8004667e, \$true );
ioctl( $there, 0x8004667e, \$true );

while (1) {
    my $vin = '';
    vec($vin, fileno $there, 1) = 1 unless $mid_done;
    vec($vin, fileno $here, 1) = 1;

    my $vout = '';
    vec($vout, fileno $here, 1) = 1 if length $in;
    vec($vout, fileno $there, 1) = 1 if length $mid;

    if (select($vin, $vout, undef, undef) > 0) {
    if (vec($vin, fileno $there, 1)) {
        unless (sysread($there, $mid, 20, length $mid)) {
        $mid_done = 1;
        shutdown($there, 1) unless length $mid;
        }
    }
    if (vec($vin, fileno $here, 1)) {
        sysread($here, $out, 1037, length $out)
        or last;
    }
    if (vec($vout, fileno $here, 1)) {
        my $written = syswrite($here, $in, 980);
        last unless $written;
        substr($in, 0, $written, '');
        shutdown($here, 1) unless length $in;
    }
    if (vec($vout, fileno $there, 1)) {
        my $written = syswrite($there, $mid, 1356);
        last unless $written;
        substr($mid, 0, $written, '');
        shutdown($there, 1) if (!length $mid and $mid_done);
    }
    }
}

is ($mid, "", "mid empty");
is ($out, $data, "transfer");

=disabled until I work out why it doesn't work.

my ($pid, $socket) = winopen2("more");
ok($pid, "winopen2 pid");
ok(fileno($socket), "winopen2 socket");
binmode($socket);
ioctl( $socket, 0x8004667e, \$true );

$in = $data;
$out = "";

while(1) {
    my $v = '';
    vec($v, fileno $socket, 1) = 1;

    my $vout = length $in ? $v : "";
    my $vin = $v;

    if (select($vin, $vout, undef, undef) > 0) {
    if (vec($vin, fileno($socket), 1)) {
        sysread($socket, $out, 30, length $out)
        or last;
    }
    if (vec($vout, fileno($socket), 1)) {
        my $written = syswrite($socket, $in, 5000)
        or last;
        substr($in, 0, $written, "");
        shutdown($socket, 1) unless length $in;
    }
    }
}
$out =~ s/[^a-z]//sg;
$data =~ s/[^a-z]//sg;
is($out, $data, "open2 more");
=cut

alarm 0;

0;
__DATA__


Rosal�a de Castro - Conto gallego

[Nota preliminar: Edici�n digital a partir de Almanaque gallego... por
Manuel de Castro y L�pez, Buenos Aires, 1923, pp. 95-104, cotejada con
la edici�n cr�tica de Mauro Armi�o (Obra completa, III, Madrid, Akal,
1980, pp. 517-530) y la de Manuel Arroyo Stephens (Obras completas,
II, Madrid, Fundaci�n Jos� Antonio Castro, 1993, pp. 617-627).]


Un d�a de inverno � caer da tarde, dous amigos que eran amigos desde a
escola, e que contaban de anos o maldito n�mero de tres veces dez,
cami�aban a bon paso un sobre unha mula branca, gorda e de redondas
ancas, i outro encima dos seus p�s, que non parec�an asa�arse das
pasadas lixeiras que lles fac�a dar seu dono.

O da pe corr�a tanto como o de acabalo, que vendo o sudor que lle
corr�a � seu compa�eiro pola frente i as puntas dos cabelos, d�xolle:

-�E ti, Lourenzo, por que non mercas un come-toxos que te leve e te
traia por estes cami�os de Dios? Que esto de andar leguas a p� por
montes e areales � bo pr�s c�s.

-�Come-toxos! Anda, e que os monten aqueles pra quens se fixeron, que
non � Lourenzo. Cabalo grande, ande ou non ande, e xa que grande non o
podo ter, sin �l me quedo e s�rvome dos meus p�s que nin beben, nin
comen, nin lle fan menester arreos.

-Verdade � que o teu modo de cami�ar � m�is barato que ning�n �negro
de min!, que ora te�o que pagar o portasgo s�lo porque vou en besta, e
non coma ti, nestes p�s que Dios me dou. Pro... as� coma as�, gusto de
andar as xornadas en pernas alleas pra que as de un non cansen, e xa o
dixen: deb�as mercar un farroupeiro pra o teu descanso. Mais ti fas
coma o outro: hoxe o gano, hoxe o como, que ma��n Dios dir�. Nin tes
arrello nin cousa que o valla; g�stanche os birbirichos i as
birbiricheiras, o vi�o do Ribeiro e as ostras do Carril. �Lourenzo!,
deb�as casarte que � fin o tempo vai andando, os anos corren, e un
probe de un home faise vello e cr�bese de pelos brancos antes de que
poida ter manta na cama e aforrar pra unha ocasi�n; e esto, Lourenzo,
non se fai sin muller que te�a man da casa e garde o di�eiro que un
gana.

-Boi solto, ben se lambe.

-�O vento! Esas sonche faladur�as. �� derradeiro, pra qu� os homes
naceron si non � pra axuntarse cas mulleres, fillo da t�a nai?
(Lourenzo tuse). Seica te costipache co res�o da ser�n, malo de
ti. (Lourenzo volve a tusir). L�veme Dios si non � certo, e tanto non
tusiras si ora vi�eras a carranchaperna enriba de un farroupeiro.

-�Costipado eu? Non o estiven na mi�a vida e penso que ora
tampouco. Pro... sempre que se me fala de casar dame unha tos
que... �hem!... �hem!... seica esto non � boa si�al. �Non cho parece,
Xan?

-O que me par�s � que eres rabudo como as uvas do cacho, e eso venche
xa de nacenza, que non polo ben que te estimo deixo de conocer que
eres atravesado coma os cangrexos. Nin podo adivi�ar por que falas mal
das mulleres, que tan ben te queren e que te arrolan nas fiadas e nas
festas coma a fillo de rei e sabendo que t�a nai foi muller, e que, si
t�a nai non fora, ti non vi�eras � mundo coma cada un de tantos.

-Nin moito se perdera anque nunca ac� chegara. Que mellor que sudando
polos cami�os pra ganar o pan de boca, e mellor que rechinar nas
festas e non nas festas, con meni�as que caras se venden sin valer un
chavo, enga�ando �s homes, estar�a al� na mente de Dios.

-�Diancre de home!, que mesmo �s veces penso se eres de aqueles que
sa�dan � crego s�lo por que non digan. E pois, ti es dono de decir
canto queiras, pro eu tam�n che digo que me fai falta un achegui�o, e
que me vou casare antes da festa, as� Dios me d� sa�de.

-E premita el Se�ore que non sudes moito, Xan, anque ora � inverno,
que entonces si que inda tusir�s m�is que eu cando de casar me
falan. E adiv�rtoche que te�as tino de non matar carneiros na festa,
que � mal encomenzo pra un casado, por aquelo dos cornos retortos que
se guindan � p� da porta, e xa se sabe que un mal tira por
outro. �Diono libre!

-�E ti qu�s saber que xa me van parecendo contos de vella eso que se
fala de cornos e de maldade das mulleres? Pois cando nesta nosa terra
se d� en decir que un can rabiou, sea certo ou non sea certo, corre a
b�la e m�tase o can. Mais eu por min che aseguro que no atopei nunca
muller solteir que non se fixese mui rogada, nin casada que o seu home
comigo falase; e par�seme que a�nda non fago tan mal rapaz, anque o
decilo sea fachenda.

-� que eso vai no axeitarse, e ti seica no acertache, Xan; que �
demais coma un home queira, non queda can tras palleiro. Eu cho digo,
non hai neste mundo m�is muller boa pra os homes que aquela que os
pariu, i as�, arrenega de elas coma do demo, Xan, que a muller demo �,
seg�n di non sei que santo moi sabido; i o demo hastra � cruz lle fai
os cornos de lonxe.

-�Volta cos cornos!

-� tan sabido que si tanto mal che fai anomealos, � porque xa che dan
sombra dende o tellado da que a de ser t�a muller.

-�Seica me queres aqueloutrare! Pouco a pouco, Lourenzo, que nin debes
falar as� de quen non conoces, nin t�daslas mulleres han de ter o ollo
alegre, que por moitas eu sei por quen se poidera po�er, non unha,
sen�n cen vidas.

-O dito, dito queda, que cando eu falo � con concencia; e rep�toche
que, sendo muller, non quedo por ningunha, anque sea condesa ou de
sangre nobre, como solen decir, que unhas e outras foron feitas da
mesma masa e coxean do mesmo p�. Dios che mas libre do meu lar, que
ora no lar alleo a�nda nas cuspo.

-�Ah! ladr�n da honra allea, l�veche o de�o si eu quixera que cuspiras
na do meu, que o pensamento de que quizais terei que manter muller pra
un rabudo coma ti faime p�r os cabelos dreitos e o entendimento
pensatible. Pro... falemos craros, Lourenzo, coma bos compa�eiros que
somos. Ti es m�is listo que eu, ben o vexo, e por donde andes s�beste
ama�ar que adimira, mentras que eu me quedo � p� do lume vendo como o
pote ferve e cantan os grilos. Se conto, o conto vai no ama�o... pro
esto de que as has de botar todas nunha manada, sin deixar unha pra
min, v�llanme t�dolos santos que me fai suare. �Vaia!, dime que a�nda
viches mulleres boas, e que non todas lle saben po�er a un home
honrado os cornos na testa.

-Todas, Xan, todas; e pra os Xans a�nda m�is; que mesmo par�s que o
nome as atenta.

-�Condenicado de min, que seique � certo! Pro meu pai e mi�a nai
cas�ronse e ieu me quero casare, que mesmo se me van os ollos cando
vexo � anoitecido un matrimonio que fala paseni�o sentado � porta da
eira, mentras corren os meni�os � luz do luar por embaixo das
figueiras.

-�� aire, � aire! �E d�ixate de faladur�as! Paseni�o que paseni�o,
tam�n se dan beliscos e rabu�adas, e paseni�o se fan as figas.

-En verdade, malo me vai parecendo o casoiro, pro moito me temo que a
afici�n non me faga prevaricare. Mais sempre que me case, caisareime
cunha do meu tempo, che��a de carne, con xu�cio e facendosa, que poida
que neso no haxa tanto mal... �Que me dis?

-Que es terco coma unha burra. Ti telo de�o, Xan, i ora estache
facendo as c�chegas co casoiro. Pro ten entendido que non hai volta
sin�n que Diolo mande, que trat�ndose de aquelo da franqueza das
mulleres, todas deitan coma as cestas e c�n coma si non tivesen p�s.

As� falando Xan e Lourenzo, iban chegando a cerca de un lugar. E como
xa de lonxe empezasen a sentir berros e choros, despois de un alto,
por saber o que al� pasaba, viron que era un enterro, e a un rapaz que
vi�a polo camino pregunt�ronlle polo morto, e respondeulles que era un
home de unha muller que inda moza quedaba viuda e sin fillos que nunca
tivera, e que o morto non era nativo de aquela aldea, pro que ti�a
noutra hardeiros.

Foise o rapaz, e Lourenzo, cheg�ndose a Xan, d�xolle entonces:

-�E ti qu�s, Xan, que che faga ver o que son as mulleres, que ora a
ocasi�n � boa?

-�E pois como?

-Facendo que esa viuda, que non sei quen �, nin vin na mi�a vida, me
d� nesta mesma noite palabra de casamento pra de aqu� a un mes.

-�E ti est�s cordo, Lourenzo?

-M�is que ti, Xan; �qu�s ou non qu�s?

-E pois ben, tolo. Vamos a apostare, e si ganas perdo a mi�a mula
branca que herdei do meu pai logo far� un ano, e que a estimo por esto
e por ser boa como as ni�as dos ollos. Curareime entonces do mal de
casoiro; pro si ti perdes, tes que mercar un farroupeiro e non volver
a falar mal das mulleres, mi�as xoias, que a�nda as quero m�is que �
mi�a muli�a branca.

-Apostado. B�ixate, pois, da mula, e fai desde agora todo o que che eu
diga sin chistar, e hastra ma��n pola fresca nin ti es Xan nin eu
Lourenzo, sin�n que ti es meu criado i eu son teu amo. Agora ven tras
min tendo conta da mula, que eu irei diante, e di a todo am�n.

Meu dito, meu feito.

Lourenzo tirou diante e Xan botou a p�, indo detr�s ca mula polas
bridas, que eran monas, as� coma os demais arreos, e met�an moita
pantalla.

� mesmo tempo que eles iban chegando � Campo Santo, i�a chegando tam�n
o enterro, rompendo a marcha o estandarte negro e algo furado da
parroquia, o crego i as mulleres que lle fac�an o pranto, turrando,
turrando polos pelos como si fosen cousa allea, berrando hastra
enroucare e agarr�ndose � tomba de tal maneira que non deixaban andar
�s que a levaban.

-�Ai, Ant�n! �Ant�n! -dec�a unha po��ndose como a Madalena cas mans
cruzadas enriba da cabeza-. Ant�n, meu amigo, que sempre me dec�as:
��Adi�s, Mariqui�a!� cando me topabas no cami�o. �Adi�s, Ant�n, que xa
non te verei m�is!

I outra, indo arrastro atr�s da caixa e pegando en s�, des�a tam�n:

-�En onde est�s, Ant�n, que xa non me falas? Ant�n, malpocadi�o, que
che fixeron as mi�as m�s uns calz�s de lenzo cr�o e non os puxeches,
Ant�n; �quen ha de p�r agora a t�a chaqueta nova i os teus calz�s,
Ant�n?

I a viuda, i unhas sobri�as da viuda, todas cubertas de b�goas,
vestidas de loito e os periquitos desfeitos de tanto turrar por eles,
e os panos desatados, berrando ainda m�is; sobre todo a viuda, que
indo de cando en cando a meterse debaixo da mesma tomba, de donde a
ti�an que arrancar por forza, dec�a:

-�Ai, meu t�o!1�Ai, meu t�o, bonito como unha prata e roxi�o como un
ouro, que cedo che vai comela terra as t�as carni�as de manteiga! �E
ti vaste, meu t�o! �Ti vaste? �E quen sera agora o meu achegui�o, e
quen me dir� como me dec�as ti, meu ben: �Come, Margaridi�a, come pra
engordare, que o teu � meu, Margaridi�a, e si ti coxeas, tam�n a min
me perece que estou coxo�? �Adi�s, meu t�o, que xa nunca m�is
dormiremos xunti�os nun leito! �Quen me dera ir contigo na tomba,
Ant�n, meu t�o, que � fin contigo, mi�a xo��a, ent�rrase meu coraz�n!

As� a viudi�a se desdichaba seguindo � morto, cando de repente,
met�ndose Lourenzo entre as mulleres, cubertos os ollos cun pano e
saloucando como si lle sa�se da ialma, escramou berrando, a�nda m�is
que as do pranto:

-�Ai, meu t�o!, �ai, meu t�o, que ora vexo ir morti�o nesa tomba!
Nunca eu aqu� vi�era pra non te atopar vivo, e non � polo testamento
que fixeches en favor meu deix�ndome por hardeiro, que sempre te
quisen como a pai, e esto que me hab�as de chamar para despedirte de
min e que te hei de ver xa morto, p�rteme as cordas do coraz�n. �Ai,
meu t�o! �ai, meu t�o!, que mesmo me morro ca pena.

Cando esto o�ron todas as do pranto, pux�ronse arredor de Lourenzo,
que mesmo se desfac�a � u�a de tanto d�r como parec�a ter.

-�E logo ti como te chamas, meu fillo? -lle preguntaron moi
compadecidas de el.

-Eu ch�mome Andruco, e son sobri�o do meu t�o, que me deixou por
hardeiro e me mandou chamare por unha carta pra se despedir de min
antes de morrer; pro, como tiven que andar moita terra, xa s�lo o podo
ver na tomba. �Ai, meu t�o! �Ai, meu t�o!

-�E ti de onde es, mozo?

-Eu son da terra do meu t�o -volveu a desir Lourenzo, saloucando
hastra cort�rselle a fala.

-�E teu t�o de d�nde era?

-Meu t�o era da mi�a terra.

E sin que o poideran quitar de esto, Lourenzo, proseguindo co pranto,
foise achegando � viudi�a, que, a�nda por entre as b�goas que a
curb�an, poido atisvare aquel mozo garrido que tanto choraba polo seu
t�o. Despois que se viron xuntos, logo lle dixo Lourenzo que era
hardeiro do difunto, i ela mirouno con moi bos ollos, e, acabado o
enterro, d�xolle que ti�a que ir co ela � s�a casa, que non era xusto
parase noutra o sobri�o do seu home, e que as� chorar�an xuntos a s�a
disgrasia.

-Disgrasia moita. �Ai, meu t�o! -dixo Lourenzo-; pro consol�devos, que
co que �l me deixou conto facerlle decir moitas misas pola ialma, para
que el descanse e poidamos ter n�s maior consolo ac� na terra, que �
fin, �a t�a, Dios m�ndanos ter pacencia cos traballos, e... que
queiras que non queiras, como dixo o ioutro, a terri�a cai enriba dos
corpos mortos e... �que hai que facer? N�s tam�n temos que ir, que as�
� o mundo.

As� falando e chorando, tornaron cami�o da casa da viuda, e Xan, que
iba detr�s ca mula e que nun principio non entendera nin chisca do que
quer�a facer Lourenzo, comenzou a enxergare e pasoulle as�, polas
carnes unha especie de escallofr�o, pensando en si ir�a a perder a s�a
mula branca. Anque, a ver o dor e as b�goas da viudi�a, que non lle
deixaban de correr a f�o pola cara afrixida, volveu a ter confianza en
Dios e nas mulleres, a quen tan ben quer�a.

-�E v�s, �a t�a, ter�s un siti�o pra meter esta mula i o meu criado,
que un e outro de tanto cami�are ve�en cansados coma raposos?

-Todo terei pra v�s, sobri�o do meu t�o, que mesmo con vervos pareceme
que o estou vendo e s�rveme de moito consolo.

-�Dencho ca viudi�a, os consolos que atopa! -marmurou Xan pra si
metendo a mula no pesebre. Pro de esto a casarse -a�adeu, contento de
si mesmo-, a�nda hai la mare.

E co esta espranza p�xose a comer con moitas ganas un bo anaco de
lac�n que a viuda lle deu, moll�ndoo co unha cunca de vi�o do Ribeiro
que ard�a nun candil e que lle alegrou a pestana, mentras t�a e
sobri�o estaban al� enriba no sobrado, falando da herencia e do morto
cos que os acompa�aban.

De esta maneira pasouse o d�a e chegou a noite, e quedaron solos na
casa a viuda, Lourenzo e Xan, que desque viu cerrar as portas estuvo �
axexa, co coraz�n posto na muli�a branca, a ialma en Lourenzo e a
espranza en Dios, que non era pra menos. E, non sin pena, veu coma a
viudi�a e Lourenzo foron ceando, antre as b�goas, uns bocados de porco
e de vaca que pu�an medo �s cristianos e uns xarros de vi�o que foran
capaces de dar �nimos � peito m�is angustiado. Pro � mesmo tempo nada
se falaba do particulare, e Xan non pod�a adivi�are como se axeitar�a
Lourenzo, pra ganar a aposta, que v�a por s�a.

� fin trataron de se ir deitar, e a Xan pux�ronselle os cabelos
dreitos cando veu que en toda a casa non hab�a m�is que a cama do
matrimonio, e que a viudi�a tanto petelescou pra que Lourenzo se
deitase nela que aqu�l tivo que obedecer, indo ela, envolta nun
mantelo, a meterse detr�s de un trabado que no sobrado hab�a.

Xan, ca ialma nun f�o, viu, desde o faiado, donde lle votaron unhas
pallas, coma a viudi�a matou o candil e todo quedou �s escuras.

-Seica quedar�s comigo, mi�a muli�a branca, i abof� que te vin perdida
-escramou entonces-; � fin as mulleres foron feitas de unha nosa
costilla e algo han de ter de bo. S�lvame, viudi�a, s�lvame de este
apreto, que inda serei capaz de me casar contigo.

Deste modo falaba Xan pra si, anque � mesmo tempo non pod�a cerrar
ollo, que a cada paso lle parec�a que rux�an as pallas.

As� pasou unha hora longa, en que Xan, contento, xa iba a dormir,
descoidado, cando de pronto oieu, primeiro un sospiro, e despois
outro, cal si aqueles sospiros fosen de alma do outro mundo;
estremeceuse Xan e ergueuse pra escoitar mellore.

-�Ai!, �meu t�o!, �meu t�o! -dixo entonces a viudi�a; �que fr�a estou
neste taboado, pro m�is fr�o est�s, ti, meu t�o, nesa terri�a que te
vai comere!

-�Ai, meu t�o!, �meu t�o! -escramou Lourenzo da outra banda, como si
falase consigo mesmo-; canto me acordo de ti, que estou no quente, e
ti no Campo Santo, nun leito de terra donde xa non tes compa��a.

-�Ai! �Antonci�o! -volveu a decir a viuda-, �que ser� de ti naquel
burato, meu queridi�o, cando eu que estou baixo cuberto...!, �bu, bu,
bu!... �qu� fr�o va!, �tembro como si tuvese a perles�a!, �bu, bu,
bu!...

-�Mi�a t�a!

-�E seica non dormes, meu sobri�o?

-E seica v�s tampouco, �a t�a, que vos sento tembrare como unha vara
verde.

-�Como qu�s ti que durma, acord�ndome nesta noite de xiada do teu t�o,
que ora dorme no Campo Santo, fr�o como a neve, cando si el vivira
dormir�amos ambos quenti�os nese leito donde ti est�s?

-�E non podiades v�s po�ervos aqu� nun ladi�o, anque fora envolta no
mantelo coma estades, e a�nda m�is habendo necesid� como agora, xa que
non queres que eu vaia dormir � chan, que mesmo pode darvos un frato
co d�r e co fr�o, i � pecado, �a t�a, tentar contra a sa�de?

-Deixa, meu fillo, deixa; que aunque penso que mal no houbera en que
eu me deitase � lado de un sobri�o como ti, envolta no mantelo e por
riba da roupa, estanto como estoxi tembrando, �bu, bu, bu!... qu�rome
ir afacendo, que moitas de estas noites han de vir pra min no mundo,
que si antes fora rica e casada agora son viuda e probe; e canto tiven
meu agora teu �, que a min non me queda m�is que o ceo i a terra.

-E... pois, mi�a t�a... Aqu� pra entre dous pecadores, e sin que naide
nos oia m�is que Dios, vouvos a decire que eu sei de un home rico e da
sangre do voso difunti�o que, si v�s quix�rades, tomar�avos por
muller.

-Cala, sobri�o, e no me fales de outro home... que inda par�s que o
que tiven est� vivo.

-Deix�, mi�a t�a, que as� non perderedes nin casa, nin leito, nin
facenda, que � moito perder de unha vez, sin contar co meu t�o; a quen
lle hei de dicir moitas misas, como d�as ten o ano, pra que descanse e
non vos ve�a a chamar nas noites de inverno. As� el estar� al� ben, e
v�s aqu�; e si el vivira, non outra cousa vos aconsellara, sen�n que
tom�rades outra ves home da s�a sangre, a quen lle deixou o que �l e
v�s com�chedes xuntos na s�a vida.

-E seica tes raz�n, meu sobri�o, pro... �si este era o teu pensamento,
Ant�n, meu t�o!, �por que non mo dixeche antes de morrer, que entonces
eu o fixera anque fora contra voluntade, s�lo por te servire?

-Pola mi�a conta, �a t�a, que si meu t�o nada vos dixo, foi porque se
lle esquenceu co conto das agon�as, e non vos estra�e, que a calquera
lle pasara outro tanto.

-Tes raz�n, tes; a morte � moi negra e naquela hora todo se
esquence. �Ai!, �meu t�o!, �meu t�o! �Que non fixera eu por che dar
gusto?, bu, bu, bu!... �que fr�o vai!

-Vinde pra aqu�, que, si non vos asa��s, direivos que eu son o que vos
quer por muller.

-�Ti que me dis, home? Pro, � ver que o adivi�ei logo; que s�lo un
sobri�o do meu t�o lle quixera cumprir as� a voluntade...

-Pro � ser, ti�a que ser de aqu� a un mes, que despois te�o que ir a
Cais en busca de outra herencia, e quixera que antes qued�rades outra
vez dona do que foi voso. O que ha de ser, sea logo, que � fin meu t�o
haio de estar deseando desde a tomba.

-�Ai!, �meu t�o!, �meu t�o!, que sobri�o che dou Dios, que mesmo de
o�lo par�ceme que te estou o�ndo; pro... meu fillo... � a�nda moi
cedo, e anque ti m�is eu nos volv�ramos a casar ca intenci�n de lle
facer honra e recordar � difunto, o mundo murmura... e...

-Deix�vos do mundo, que casaremos en secreto e naide o saber�.

-E pois ben, meu sobri�o, e s�lo pro que es da sangre do meu t�o, e xa
que me dis que se ha de alegrar na tomba de vernos xuntos... co
dem�is... �ai!, Dios me valla... eu quer�alle moito a meu t�o! �Bu,
bu, bu!... �como x�a!

-Vinde pra onda min envolta no mantelo, que non � pecado xa que hab�s
de ser mi�a muller.

-Pro... a�nda non a son, meni�o, e te�o remorsos... �Bu, bu, bu!, que
frato me d� pola cabeza e polo corazon.

-�a t�a, vinde e deix�vos de atentar contra a sa�de, que se al
pec�sedes, antes de casar t�monos que confesare.

-Irei, logo... irei, que necesito un pouco de calori�o.

Entonces sint�ronse pasadas, ruxiron as pallas, e a viuda escramou con
moita dolore:

-�Ai, mi�a Virxen do Carmen, que axi�a te ofendo!

-�Ai, mi�a muli�a branca, que axi�a te perdo! -marmurou entonces Xan,
con sentimento e con coraxe. E cheg�ndose enseguida � porta do
sobrado, berrou con forza:

-�Meu amo, a casa arde!

-Non arde, home, non, que � rescoldo.

-Pois rescoldo ou l�a, si agora non vindes voume ca mula.

E Lourenzo, saltando de un golpe � chan, dixo:

-Agarda logo... Esperaime, �a t�a, que logo volvo.

E hai cen anos que foi esto, e a�nda hoxe espera a viuda polo sobri�o
do seu t�o.


