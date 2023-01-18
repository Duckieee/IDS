-- Databazove systemy 2020/2021
-- Projekt 4. cast
-- Kateřina Cibulcová (xcibul12)
-- 2. 5. 2021


SET serveroutput ON;
DROP SEQUENCE id_pivo_pocet;

DROP TABLE Pivo CASCADE CONSTRAINTS;
DROP TABLE Uzivatel CASCADE CONSTRAINTS;
DROP TABLE Prodejna CASCADE CONSTRAINTS;
DROP TABLE Hodnoceni CASCADE CONSTRAINTS;
DROP TABLE Distribuce CASCADE CONSTRAINTS;
DROP TABLE Sladek CASCADE CONSTRAINTS;
DROP TABLE Hospoda CASCADE CONSTRAINTS;
DROP TABLE Pivovar CASCADE CONSTRAINTS;
DROP TABLE Slad CASCADE CONSTRAINTS;
DROP TABLE Chmel CASCADE CONSTRAINTS;
DROP TABLE Kvasnice CASCADE CONSTRAINTS;
DROP TABLE Suroviny CASCADE CONSTRAINTS;
DROP TABLE Pivo_Suroviny CASCADE CONSTRAINTS;
DROP TABLE Suroviny_Prodejna CASCADE CONSTRAINTS;
DROP TABLE Prodejna_Distribuce CASCADE CONSTRAINTS;
DROP TABLE Hospoda_Distribuce CASCADE CONSTRAINTS;
DROP TABLE Hospoda_Pivovar CASCADE CONSTRAINTS;
DROP TABLE Pivo_Sladek CASCADE CONSTRAINTS;
DROP TABLE Pivovar_Sladek CASCADE CONSTRAINTS;

/*------------------------------------------------------------------------
                     	VYTVARENI TABULEK
------------------------------------------------------------------------*/

CREATE TABLE Pivo (
"id" number NOT NULL PRIMARY KEY,
nazev varchar(50) NOT NULL,
barva varchar(50) NOT NULL,
obsah_alkoholu varchar(10) NOT NULL CHECK (REGEXP_LIKE(obsah_alkoholu, '^[0-9]{1,3}(\.?[0-9]+)*%$')),
blizsi_specifikace_typu varchar(50),
styl_kvaseni varchar(50)

);

CREATE TABLE Suroviny (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
puvod varchar(50) NOT NULL
);

CREATE TABLE Slad (
id_slad number NOT NULL PRIMARY KEY,
barva varchar(20) NOT NULL,
extrakt varchar(20) NOT NULL CHECK (REGEXP_LIKE(extrakt, '^[0-9]{1,3}(\.?[0-9]+)*%$')),
CONSTRAINT id_slad_suroviny_fk FOREIGN KEY (id_slad) references Suroviny ("id") 
	ON DELETE CASCADE
);

CREATE TABLE Chmel (
id_chmel number NOT NULL PRIMARY KEY,
aroma varchar(50) NOT NULL,
podil_alfa_kyselin varchar(20) NOT NULL,
doba_sklizne varchar(20),
CONSTRAINT id_chmel_suroviny_fk FOREIGN KEY (id_chmel) references Suroviny ("id") 
	ON DELETE CASCADE
);

CREATE TABLE Kvasnice (
id_kvasnice number NOT NULL PRIMARY KEY,
typ varchar(20) NOT NULL CHECK (typ IN ('svrchní', 'spodní')),
skupenstvi varchar(20) NOT NULL CHECK (skupenstvi IN ('sušené', 'tekuté')),
CONSTRAINT id_kvasnice_suroviny_fk FOREIGN KEY (id_kvasnice) references Suroviny ("id") 
	ON DELETE CASCADE
);

CREATE TABLE Prodejna (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
nazev varchar(50) NOT NULL,
cislo_popisne number(10) NOT NULL,
ulice varchar(50) NOT NULL,
mesto varchar(50) NOT NULL,
telefon number(15) NOT NULL
);

CREATE TABLE Distribuce (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
"id_pivo" number NOT NULL,
CONSTRAINT Distribuce_Pivo FOREIGN KEY ("id_pivo") references Pivo ("id")
	ON DELETE CASCADE,
forma varchar(50) NOT NULL
);

CREATE TABLE Hospoda (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
nazev varchar(50) NOT NULL,
cislo_popisne number(10) NOT NULL,
ulice varchar(50) NOT NULL,
mesto varchar(50) NOT NULL,
telefon number(15) NOT NULL
);

CREATE TABLE Pivovar (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
nazev varchar(50) NOT NULL,
cislo_popisne number(10) NOT NULL,
ulice varchar(50) NOT NULL,
mesto varchar(50) NOT NULL,
telefon number(15) NOT NULL
);

CREATE TABLE Sladek (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
jmeno varchar(20) NOT NULL,
prijmeni varchar(30) NOT NULL,
rodne_cislo varchar(10) NOT NULL,
cislo_popisne number(10) NOT NULL,
ulice varchar(50) NOT NULL,
mesto varchar(50) NOT NULL,
telefon number(15) NOT NULL,
odbornost varchar(20) NOT NULL
);

CREATE TABLE Uzivatel (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
vypite_pivo varchar(10),
login varchar(20) NOT NULL,
heslo varchar(20) NOT NULL,
email varchar(50) NOT NULL CHECK (REGEXP_LIKE(email, '^[0-9a-zA-Z]+@[0-9a-zA-Z]+\.[a-z]+$')),
certifikace varchar(3) NOT NULL CHECK (certifikace IN ('ano', 'ne'))
);


CREATE TABLE Hodnoceni (
"id" number GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
datum date NOT NULL,
znamka number(2) NOT NULL CHECK (znamka BETWEEN 1 AND 10),
"id_pivo" number,
CONSTRAINT Pivo_Hodnoceni FOREIGN KEY ("id_pivo") references Pivo ("id")
	ON DELETE CASCADE,
"id_hospoda" number,
CONSTRAINT Hospoda_Hodnoceni FOREIGN KEY ("id_hospoda") references Hospoda ("id")
	ON DELETE CASCADE,
"id_uzivatel" number NOT NULL,
CONSTRAINT Uzivatel_Hodnoceni FOREIGN KEY ("id_uzivatel") references Uzivatel ("id")
	ON DELETE CASCADE);

CREATE TABLE Pivo_Suroviny (
"id_pivo" number,
"id_sur" number NOT NULL,
CONSTRAINT Pivo_Suroviny PRIMARY KEY ("id_pivo", "id_sur"), 
CONSTRAINT Pivo_Suroviny2 FOREIGN KEY ("id_pivo") references Pivo ("id") 
	ON DELETE CASCADE,
CONSTRAINT Pivo_Suroviny3 FOREIGN KEY ("id_sur") references Suroviny ("id")
	ON DELETE CASCADE
);

CREATE TABLE Suroviny_Prodejna (
"id_sur" number,
"id_prodejna" number NOT NULL,
CONSTRAINT Suroviny_Prodejna PRIMARY KEY ("id_prodejna", "id_sur"), 
CONSTRAINT Suroviny_Prodejna2 FOREIGN KEY ("id_prodejna") references Prodejna ("id") 
	ON DELETE CASCADE,
CONSTRAINT Suroviny_Prodejna3 FOREIGN KEY ("id_sur") references Suroviny ("id")
	ON DELETE CASCADE
);


CREATE TABLE Prodejna_Distribuce (
"id_prodejna" number,
"id_dist" number,
mnozstvi varchar(30) NOT NULL,
CONSTRAINT Prodejna_Distribuce PRIMARY KEY ("id_prodejna", "id_dist"), 
CONSTRAINT Prodejna_Distribuce2 FOREIGN KEY ("id_prodejna") references Prodejna ("id") 
	ON DELETE CASCADE,
CONSTRAINT Prodejna_Distribuce3 FOREIGN KEY ("id_dist") references Distribuce ("id")
	ON DELETE CASCADE
);

CREATE TABLE Hospoda_Distribuce (
"id_hospoda" number,
"id_dist" number NOT NULL,
mnozstvi varchar(30) NOT NULL,
CONSTRAINT Hospoda_Distribuce PRIMARY KEY ("id_hospoda", "id_dist"), 
CONSTRAINT Hospoda_Distribuce2 FOREIGN KEY ("id_hospoda") references Hospoda ("id") 
	ON DELETE CASCADE,
CONSTRAINT Hospoda_Distribuce3 FOREIGN KEY ("id_dist") references Distribuce ("id")
	ON DELETE CASCADE
);

CREATE TABLE Hospoda_Pivovar (
"id_hospoda" number,
"id_pivovar" number,
sleva varchar(20) NOT NULL CHECK (REGEXP_LIKE(sleva, '^[0-9]{1,3}(\.?[0-9]+)*%$')),
od date NOT NULL,
do date NOT NULL,
CONSTRAINT Hospoda_Pivovar PRIMARY KEY ("id_hospoda", "id_pivovar"), 
CONSTRAINT Hospoda_Pivovar2 FOREIGN KEY ("id_hospoda") references Hospoda ("id") 
	ON DELETE CASCADE,
CONSTRAINT Hospoda_Pivovar3 FOREIGN KEY ("id_pivovar") references Pivovar ("id")
	ON DELETE CASCADE
);

CREATE TABLE Pivovar_Sladek (
"id_pivovar" number,
"id_sladek" number NOT NULL,
od date NOT NULL,
do date NOT NULL,
CONSTRAINT Pivovar_Sladek PRIMARY KEY ("id_sladek", "id_pivovar"), 
CONSTRAINT Pivovar_Sladek2 FOREIGN KEY ("id_sladek") references Sladek ("id") 
	ON DELETE CASCADE,
CONSTRAINT Pivovar_Sladek3 FOREIGN KEY ("id_pivovar") references Pivovar ("id")
	ON DELETE CASCADE
);

CREATE TABLE Pivo_Sladek (
"id_pivo" number,
"id_sladek" number NOT NULL,
od date NOT NULL,
do date NOT NULL,
CONSTRAINT Pivo_Sladek PRIMARY KEY ("id_sladek", "id_pivo"), 
CONSTRAINT Pivo_Sladek2 FOREIGN KEY ("id_sladek") references Sladek ("id") 
	ON DELETE CASCADE,
CONSTRAINT Pivo_Sladek3 FOREIGN KEY ("id_pivo") references Pivo ("id")
	ON DELETE CASCADE
);


/*------------------------------------------------------------------------
                     		 TRIGGERY
------------------------------------------------------------------------*/

-- Trigger pro kontrolu rodneho cisla
CREATE OR REPLACE TRIGGER Kontrola_RC

	BEFORE INSERT OR UPDATE OF rodne_cislo ON Sladek
	FOR EACH ROW

DECLARE
	rc varchar (10);
	delka_rc number(2);
	koncovka number(4);
	rok varchar (4);
	mesic number (2);
	den number (2);
	datum_narozeni varchar (10);
	datum_naroz date;
BEGIN
	rc := :NEW.rodne_cislo;
	delka_rc := LENGTH(rc);
	rok := SUBSTR(rc, 0, 2 );
	mesic := SUBSTR(rc, 3, 2);
	den := SUBSTR(rc, 5, 2);
	koncovka := SUBSTR(rc, 7, 4);


IF (LENGTH(TRIM(TRANSLATE(rc, '0123456789', ' '))) != NULL) THEN
	raise_application_error (-20002, 'Rodne cislo neni numericke.');
END IF;

IF (delka_rc < 9 OR delka_rc > 10) THEN 
	raise_application_error (-20000, 'Delka rodneho cisla je nepripustna.');
END IF;

IF (delka_rc = 9 AND koncovka = '000')  THEN
	raise_application_error (-20001, 'Koncovka rodneho cisla 000 je nepripustna.');
END IF;

IF (mesic > 50) THEN
	mesic := mesic - 50;
END IF;

IF (koncovka = 3) THEN
	IF (TO_NUMBER(rok) > 53) THEN
		rok := CONCAT('18', rok);
	ELSE
		rok := CONCAT('19', rok);
	END IF;
ELSE
	IF (TO_NUMBER(rok) > 53) THEN
		rok := CONCAT('19', rok);
	ELSE
		rok := CONCAT('20', rok);
	END IF;
END IF;

datum_narozeni := rok || '-' || mesic || '-' || den;

datum_naroz := TO_DATE(datum_narozeni, 'YYYY-MM-DD');

IF (delka_rc = 10 AND MOD(TO_NUMBER(rc), 11) <> '0') THEN
	 raise_application_error (-20005, 'Rodne cislo neni delitelne jedenacti.');
END IF;

END Kontrola_RC;
/

-- Trigger pro autogenerovani id piva
CREATE SEQUENCE id_pivo_pocet;

CREATE OR REPLACE TRIGGER autogener
	BEFORE INSERT ON Pivo 
	FOR EACH ROW
BEGIN
	:new."id" := id_pivo_pocet.nextval;
END autogener;
/




/*------------------------------------------------------------------------
                     		 VKLADANI DAT
------------------------------------------------------------------------*/


INSERT INTO Pivo (nazev, barva, obsah_alkoholu, blizsi_specifikace_typu, styl_kvaseni) VALUES ('Pilsner Urquell', 'světlá', '4.4%', 'ležák', 'spodní');

INSERT INTO Pivo (nazev, barva, obsah_alkoholu, blizsi_specifikace_typu, styl_kvaseni) VALUES ('Chotěboř Prémium', 'světlá', '5.1%', 'ležák', 'spodní');

INSERT INTO Pivo (nazev, barva, obsah_alkoholu, blizsi_specifikace_typu, styl_kvaseni) VALUES ('Poutník', 'světlá', '5.0%', 'ležák', 'spodní');

INSERT INTO Pivo (nazev, barva, obsah_alkoholu, blizsi_specifikace_typu, styl_kvaseni) VALUES ('Svijanský Máz', 'světlá', '4.8%', 'ležák', 'spodní');

INSERT INTO Pivo (nazev, barva, obsah_alkoholu, blizsi_specifikace_typu, styl_kvaseni) VALUES ('Ježek', 'světlá', '4.8%', 'ležák', 'spodní');




INSERT INTO Prodejna (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Beershop', '9', 'Tyršova', 'Olomouc', '739125876');

INSERT INTO Prodejna (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Svět piva', '10', 'Příční', 'Brno', '739125877');

INSERT INTO Prodejna (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Pivotéka', '11', 'Kotlářská', 'Letovice', '739125878' );

INSERT INTO Prodejna (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Galerie piva', '12', 'Česká', 'Praha', '739125879');
INSERT INTO Prodejna (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Pivní maják', '13', 'Olomoucká', 'Ostrava', '739125888');




INSERT INTO Distribuce (forma, "id_pivo") VALUES ('PET láhev', '4');
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('sud', '1');
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('sud', '2');
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('sud', '3');
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('tank', '1');
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('skleněná láhev', '3');
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('skleněná láhev', '1');
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('skleněná láhev', '2');



INSERT INTO Hospoda (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Stopkova', '5', 'Česká', 'Brno', '517070080');
INSERT INTO Hospoda (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('U zlatého tygra', '17', 'Husova', 'Praha', '222221111');
INSERT INTO Hospoda (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('U Pinkasů', '15', 'Jungmannovo náměstí', 'Praha', '221111152' );
INSERT INTO Hospoda (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Na Stojáka', '16', 'Běhounská', 'Brno', '702222048');
INSERT INTO Hospoda (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('U Bláhovky', '54', 'Gorkého', 'Brno', '543553310');



INSERT INTO Pivovar (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Plzeňský prazdroj', '7', 'U Prazdroje', 'Plzeň', '222710159');
INSERT INTO Pivovar (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Pivovar Svijany', '25', 'Svijany', 'Svijany', '481770770');
INSERT INTO Pivovar (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Pivovar Chotěboř', '1755', 'Průmyslová', 'Chotěboř', '134111152' );
INSERT INTO Pivovar (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Pivovar Poutník', '856', 'Pivovarská', 'Pelhřimov', '986222048');
INSERT INTO Pivovar (nazev, cislo_popisne, ulice, mesto, telefon) VALUES ('Pivovar Jihlava', '2', 'Vrchlického', 'Jihlava', '549233310');


INSERT INTO Sladek (jmeno, prijmeni, rodne_cislo, cislo_popisne, ulice, mesto, telefon, odbornost) VALUES ('Josef', 'Novák', '0011040799', '1', 'Tyršova', 'Brno', '222710159','odborník');
INSERT INTO Sladek (jmeno, prijmeni, rodne_cislo, cislo_popisne, ulice, mesto, telefon, odbornost) VALUES ('Helena', 'Dvořáková', '9360129823', '2', 'Pražská', 'Plzeň', '222710159', 'odborník');
INSERT INTO Sladek (jmeno, prijmeni, rodne_cislo, cislo_popisne, ulice, mesto, telefon, odbornost) VALUES ('Marek', 'Zachař', '9605201199', '3', 'Vrchlického', 'Praha', '222710159','na volné noze');
INSERT INTO Sladek (jmeno, prijmeni, rodne_cislo, cislo_popisne, ulice, mesto, telefon, odbornost) VALUES ('Jiří', 'Ševčík', '9204111906', '4', 'Masarykova', 'Pardubice', '222710159', 'na volné noze');
INSERT INTO Sladek (jmeno, prijmeni, rodne_cislo, cislo_popisne, ulice, mesto, telefon, odbornost) VALUES ('Pavel', 'Všetička', '9211056855', '5', 'Palackého', 'Brno', '222710159', 'amatér');



INSERT INTO Uzivatel (login, heslo, vypite_pivo, certifikace, email) VALUES ('beruska1', '12345', '2 litry', 'ne', 'beruska1@gmail.com');
INSERT INTO Uzivatel (login, heslo, vypite_pivo, certifikace, email) VALUES ('franta98', '12skd', '8 litrů', 'ne', 'franta98@gmail.com');
INSERT INTO Uzivatel (login, heslo, vypite_pivo, certifikace, email) VALUES ('josefnovak', '12dfs345', '4 litry', 'ne', 'josefnovak@gmail.com');
INSERT INTO Uzivatel (login, heslo, vypite_pivo, certifikace, email) VALUES ('jiris', '12sdfd5', '1 litr', 'ne', 'jiris@gmail.com');
INSERT INTO Uzivatel (login, heslo, vypite_pivo, certifikace, email) VALUES ('kaktus69', '1skdssjd45', '15 litrů', 'ano', 'kaktus69@gmail.com');


INSERT INTO Hodnoceni (datum, znamka, "id_hospoda", "id_uzivatel") VALUES ('15/MAR/2019', '1', '2', '3');
INSERT INTO Hodnoceni (datum, znamka, "id_pivo", "id_uzivatel") VALUES ('19/MAR/2019', '6', '3', '4');
INSERT INTO Hodnoceni (datum, znamka, "id_pivo", "id_uzivatel") VALUES ('18/MAR/2019', '10', '1', '5');
INSERT INTO Hodnoceni (datum, znamka, "id_hospoda", "id_uzivatel") VALUES ('17/MAR/2019', '2', '2', '3');
INSERT INTO Hodnoceni (datum, znamka, "id_pivo", "id_uzivatel") VALUES ('16/MAR/2019', '3', '1', '4');


INSERT INTO Suroviny (puvod) VALUES ('Česká republika');
INSERT INTO Suroviny (puvod) VALUES ('Rakousko');
INSERT INTO Suroviny (puvod) VALUES ('Německo');



INSERT INTO Slad (id_slad, barva, extrakt) VALUES ('3', '10 EBC', '81.5%');
INSERT INTO Slad (id_slad, barva, extrakt) VALUES ('1', '3 EBC', '82.5%');



INSERT INTO Chmel (id_chmel, aroma, podil_alfa_kyselin, doba_sklizne) VALUES ('1', 'květinový nádech', '3.5%', '2017');
INSERT INTO Chmel (id_chmel, aroma, podil_alfa_kyselin, doba_sklizne) VALUES ('2', 'jemné chmelové', '3.28%', '2018');
INSERT INTO Chmel (id_chmel, aroma, podil_alfa_kyselin, doba_sklizne) VALUES ('3', 'příjemné chmelové', '5.06%', '2018');


INSERT INTO Kvasnice (id_kvasnice, typ, skupenstvi) VALUES ('1', 'svrchní', 'sušené');
INSERT INTO Kvasnice (id_kvasnice, typ, skupenstvi) VALUES ('2', 'spodní', 'sušené');


INSERT INTO Suroviny_Prodejna ("id_sur", "id_prodejna") VALUES ('1', '2');
INSERT INTO Suroviny_Prodejna ("id_sur", "id_prodejna") VALUES ('2', '3');

INSERT INTO Pivo_Suroviny ("id_pivo", "id_sur") VALUES ('1', '1');
INSERT INTO Pivo_Suroviny ("id_pivo", "id_sur") VALUES ('4', '2');

INSERT INTO Prodejna_Distribuce ("id_prodejna", "id_dist", mnozstvi) VALUES ('1', '7', '50');
INSERT INTO Prodejna_Distribuce ("id_prodejna", "id_dist", mnozstvi) VALUES ('4', '8', '100');
INSERT INTO Prodejna_Distribuce ("id_prodejna", "id_dist", mnozstvi) VALUES ('5', '6', '3');

INSERT INTO Hospoda_Distribuce ("id_hospoda", "id_dist", mnozstvi) VALUES ('1', '3', '10');
INSERT INTO Hospoda_Distribuce ("id_hospoda", "id_dist", mnozstvi) VALUES ('2', '5', '2');
INSERT INTO Hospoda_Distribuce ("id_hospoda", "id_dist", mnozstvi) VALUES ('1', '4', '10');


INSERT INTO Hospoda_Pivovar ("id_hospoda", "id_pivovar", sleva, od, do) VALUES ('3', '1', '5%', '13/APR/2014', '13/APR/2015');
INSERT INTO Hospoda_Pivovar ("id_hospoda", "id_pivovar", sleva, od, do) VALUES ('4', '2', '3%', '17/APR/2014', '17/APR/2015');

INSERT INTO Pivovar_Sladek ("id_pivovar", "id_sladek", od, do) VALUES ('3', '1', '12/JUN/2017', '12/JUN/2018');
INSERT INTO Pivovar_Sladek ("id_pivovar", "id_sladek", od, do) VALUES ('4', '2', '20/JUN/2017', '20/JUN/2018');

INSERT INTO Pivo_Sladek ("id_pivo", "id_sladek", od, do) VALUES ('1', '3', '19/SEP/2012', '19/SEP/2015');
INSERT INTO Pivo_Sladek ("id_pivo", "id_sladek", od, do) VALUES ('2', '4', '18/SEP/2012', '18/SEP/2015');


/*------------------------------------------------------------------------
                     		 PROCEDURY
------------------------------------------------------------------------*/


--Procedura, ktera vypise prodavana piva v zadane hospode
CREATE OR REPLACE PROCEDURE Piva_v_hospode(nazev_hospody IN VARCHAR2)
IS 
	prodavana_piva varchar (200);
	nase_id Hospoda."id"%TYPE;
	kontrola number;
	CURSOR c1 IS 
		SELECT Hospoda_Distribuce."id_hospoda" idhospoda, Pivo.nazev nazevpiva FROM Pivo, Distribuce, Hospoda_Distribuce
		WHERE Pivo."id" = Distribuce."id_pivo" AND Distribuce."id" = Hospoda_Distribuce."id_dist";
	CURSOR c2 IS 
		SELECT Hospoda.nazev nazev, Hospoda."id" id
		FROM Hospoda;
BEGIN
	nase_id := -1;
	kontrola := 0;
	prodavana_piva := 'Hospoda prodava tato piva: ';
	FOR ITEM IN c2 
	LOOP 
	IF (ITEM.nazev = nazev_hospody) THEN
		nase_id := ITEM.id;
	END IF;
	END LOOP;
	IF (nase_id = '-1') THEN 
		DBMS_OUTPUT.PUT_LINE('Zadana hospoda neni v databazi.');
	ELSE 
		FOR ITEM IN c1
		LOOP
		IF (nase_id = ITEM.idhospoda) THEN
			IF (kontrola = '0') THEN
				prodavana_piva := prodavana_piva || ITEM.nazevpiva;
				kontrola := 1;	
			ELSE
				prodavana_piva := prodavana_piva || ', ' ||ITEM.nazevpiva;
				kontrola := 1;
			END IF;
		END IF;
		END LOOP;
		IF (kontrola = 0) THEN
			prodavana_piva := 'Hospoda neprodava zadna piva.';
		END IF;
		DBMS_OUTPUT.PUT_LINE(prodavana_piva);
	END IF;
END;
/
 

EXECUTE Piva_v_hospode('Stopkova');


--Procedura, ktera vypise prumerne hodnoceni zadaneho piva
CREATE OR REPLACE PROCEDURE Prumerne_hodnoceni_piva(nazev_piva IN VARCHAR2)
IS 
	kontrola number(1);
	prumer_hodnoceni float;
	nase_id Pivo."id"%TYPE;
	CURSOR c1 IS
		SELECT Pivo.nazev nazev, Pivo."id" id
		FROM Pivo;
	CURSOR c2 IS
	SELECT Hodnoceni."id_pivo" idpivo
		FROM Hodnoceni;
		
	
BEGIN
	kontrola := 0;
	prumer_hodnoceni := -1;
	nase_id := -1;
	FOR ITEM IN c1
	LOOP 
	IF (ITEM.nazev = nazev_piva) THEN
		nase_id := ITEM.id;
	END IF;
	END LOOP;
	
	IF (nase_id = '-1') THEN 
		DBMS_OUTPUT.PUT_LINE('Zadane pivo neni v databazi.');
	ELSE
		FOR ITEM IN c2
		LOOP
		IF (ITEM.idpivo = nase_id) THEN
			kontrola := 1;
		END IF;
		END LOOP;
		IF (kontrola = 1) THEN
			SELECT AVG(Hodnoceni.znamka) INTO prumer_hodnoceni
			FROM Hodnoceni
			WHERE nase_id = Hodnoceni."id_pivo";	
			DBMS_OUTPUT.PUT_LINE('Prumerne hodnoceni zadaneho piva: ' || prumer_hodnoceni || ' z 10 bodu.');
		ELSE
			
			DBMS_OUTPUT.PUT_LINE('Zadane pivo nema zadne hodnoceni.');
		END IF;
			--		
	END IF;

END;
/

EXECUTE Prumerne_hodnoceni_piva('Pilsner Urquell');


/*------------------------------------------------------------------------
                      PRISTUPOVA PRAVA
------------------------------------------------------------------------*/


GRANT ALL ON Pivo TO xcibul12;
GRANT ALL ON Distribuce TO xcibul12;
GRANT ALL ON Prodejna_Distribuce TO xcibul12;
GRANT ALL ON Prodejna TO xcibul12;
GRANT ALL ON Hospoda_Distribuce TO xcibul12;
GRANT ALL ON Hospoda TO xcibul12;

GRANT EXECUTE ON Piva_v_hospode TO xcibul12;
GRANT EXECUTE ON Prumerne_hodnoceni_piva TO xcibul12;


/*------------------------------------------------------------------------
                      MATERIALIZOVANY POHLED
------------------------------------------------------------------------*/

DROP MATERIALIZED VIEW VIEW1;

CREATE MATERIALIZED VIEW VIEW1
CACHE 
BUILD IMMEDIATE
REFRESH ON COMMIT
ENABLE QUERY REWRITE
AS SELECT Pivo.nazev AS nazev_piva FROM Pivo, Distribuce WHERE Pivo."id" = Distribuce."id_pivo";
GRANT ALL ON VIEW1 TO xcibul12;

SELECT * FROM VIEW1; 
INSERT INTO Distribuce (forma, "id_pivo") VALUES ('sud', '5');
SELECT * FROM VIEW1;
COMMIT;

SELECT * FROM VIEW1;


/*------------------------------------------------------------------------
              EXPLAIN PLAN S POUZITIM INDEXU PRO OPTIMALIZACI
------------------------------------------------------------------------*/

DROP INDEX index_piva;

EXPLAIN PLAN FOR
SELECT AVG(Hodnoceni.znamka), Pivo.nazev
FROM Hodnoceni JOIN Pivo ON(Pivo."id" = Hodnoceni."id_pivo")
WHERE Pivo.nazev = 'Pilsner Urquell'
GROUP BY Pivo.nazev;
SELECT * FROM TABLE(DBMS_XPLAN.display);

CREATE INDEX index_piva ON Pivo (nazev);

EXPLAIN PLAN FOR
SELECT AVG(Hodnoceni.znamka), Pivo.nazev
FROM Hodnoceni JOIN Pivo ON(Pivo."id" = Hodnoceni."id_pivo")
WHERE Pivo.nazev = 'Pilsner Urquell'
GROUP BY Pivo.nazev;
SELECT * FROM TABLE(DBMS_XPLAN.display);


