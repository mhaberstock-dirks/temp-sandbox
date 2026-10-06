-- namen_vorschau.sql
-- Zeigt, welchen Fantasienamen jede Personalnummer bekäme - ohne etwas zu ändern (reines SELECT).
-- Gleiche Listen und gleiche Logik wie in anonymisieren.sql. Die Listen hier bei Änderungen dort mitziehen.
--
-- Zwei Varianten nebeneinander:
--   *_stabil : idx aus der PERS_NR (PERS_NR * a mod m)  -> Name hängt nur an der eigenen Nummer,
--              eindeutig nur, solange die PERS_NR-Spanne kleiner als m ist
--   *_pos    : idx aus der Position (row_number nach PERS_NR) -> eindeutig bis m Personen,
--              aber neue/entfernte Personen verschieben die Namen der nachfolgenden
-- anzahl_* > 1 heißt: dieser Name ist mehrfach vergeben.
--
-- Die Abfrage gibt nur PERS_NR, das aus der Anrede abgeleitete Geschlecht und die neuen Namen aus,
-- keine Klarnamen. Benötigt die Funktion STRSPLIT des Schemas.
-- In TOAD als einzelne Anweisung ausführen (F9 bzw. Strg+Enter). Zusammenfassung: siehe unten.

with
params as (
    select 'Anna,Barbara,Christina,Daniela,Elena,Franziska,Gabriele,Hannah,Ines,Julia,'
        || 'Katharina,Laura,Maria,Nina,Olga,Petra,Renate,Sabine,Tanja,Ursula,'
        || 'Vanessa,Waltraud,Yvonne,Zoe,Andrea,Birgit,Carina,Doris,Eva,Frieda,'
        || 'Greta,Heike,Ingrid,Jana,Karin,Lena,Monika,Nadine,Paula,Silke,'
        || 'Alexandra,Angelika,Antonia,Beate,Bettina,Brigitte,Carla,Charlotte,Claudia,Corinna,'
        || 'Denise,Diana,Edith,Elisabeth,Emma,Erika,Esther,Fabienne,Felicitas,Gisela,'
        || 'Helga,Helene,Hildegard,Irene,Isabel,Jasmin,Johanna,Josefine,Judith,Jutta,'
        || 'Kerstin,Klara,Lara,Lea,Lisa,Luise,Magdalena,Maren,Marion,Martina,'
        || 'Melanie,Miriam,Nicole,Nora,Patricia,Regina,Rita,Ronja,Rosa,Sandra,'
        || 'Sarah,Sofia,Stefanie,Susanne,Svenja,Theresa,Ulrike,Vera,Viktoria,Wiebke' as vn_w,
           'Andreas,Bernd,Christian,Daniel,Erik,Frank,Georg,Hans,Ingo,Jan,'
        || 'Klaus,Lukas,Markus,Norbert,Oliver,Peter,Ralf,Stefan,Thomas,Uwe,'
        || 'Volker,Werner,Xaver,Yannick,Achim,Boris,Carsten,Dieter,Egon,Felix,'
        || 'Gerd,Heinz,Jens,Karl,Lars,Martin,Nils,Otto,Paul,Sven,'
        || 'Adrian,Albert,Alexander,Anton,Armin,Benjamin,Bernhard,Bruno,Clemens,Dennis,'
        || 'Dominik,Edgar,Elias,Emil,Fabian,Florian,Friedrich,Gregor,Gustav,Harald,'
        || 'Helmut,Henrik,Herbert,Holger,Hubert,Jakob,Joachim,Johannes,Jonas,Josef,'
        || 'Julian,Kai,Konrad,Leon,Lorenz,Ludwig,Manfred,Matthias,Max,Michael,'
        || 'Moritz,Niklas,Oskar,Patrick,Philipp,Rainer,Reinhard,Robert,Rudolf,Sebastian,'
        || 'Simon,Timo,Tobias,Torsten,Ulrich,Valentin,Viktor,Walter,Wolfgang,Zacharias' as vn_m,
           'Ahorn,Birken,Buchen,Eichen,Erlen,Eschen,Fichten,Linden,Tannen,Weiden,'
        || 'Rosen,Wiesen,Falken,Finken,Lerchen,Hasel,Kirsch,Apfel,Sonnen,Mond,'
        || 'Nuss,Holler,Kranich,Rabens,Adler' as nn_anfang,
           'berg,feld,bach,hof,tal,brunn,au,hain,stein,wald' as nn_endung,
           -- Multiplikator: muss teilerfremd zu m sein (m = 100 x 250 = 25000; 15451 ist es).
           -- anonymisieren.sql sucht ihn selbst (erster teilerfremder Wert ab 0,618 x m).
           15451 as a
      from dual),
-- Vornamen mit Positionsnummer 0 .. n-1, getrennt nach Geschlecht
vn as (
    select 'W' as g, nr, vorname
      from (select rownum - 1 as nr, column_value as vorname
              from params, table(strsplit(params.vn_w, ',')))
    union all
    select 'M' as g, nr, vorname
      from (select rownum - 1 as nr, column_value as vorname
              from params, table(strsplit(params.vn_m, ',')))),
-- Nachnamen = jeder Wortanfang mit jeder Endung, Positionsnummer 0 .. n-1
nn as (
    select row_number() over (order by a.nr, e.nr) - 1 as nr, a.txt || e.txt as nachname
      from (select rownum as nr, column_value as txt from params, table(strsplit(params.nn_anfang, ','))) a
     cross join
           (select rownum as nr, column_value as txt from params, table(strsplit(params.nn_endung, ','))) e),
cnt as (
    select (select count(*) from vn where g = 'W') as cnt_vn,
           (select count(*) from nn)               as cnt_nn,
           (select count(*) from vn where g = 'W') * (select count(*) from nn) as m
      from dual),
pr as (
    select p.pers_nr,
           case
               when upper(trim(p.pers_anrede)) like 'FRAU%' then 'W'
               when upper(trim(p.pers_anrede)) like 'HERR%' then 'M'
               when mod(ora_hash(p.pers_nr, 4294967295, 3), 2) = 0 then 'W'   -- Anrede unbekannt
               else 'M'
           end as g,
           mod(mod(p.pers_nr * params.a, cnt.m) + cnt.m, cnt.m)  as idx_stabil,
           mod(row_number() over (order by p.pers_nr) - 1, cnt.m) as idx_pos
      from pzm_personal p
     cross join params
     cross join cnt),
namen as (
    select pr.pers_nr, pr.g, pr.idx_stabil,
           vs.vorname as vorname_stabil, ns.nachname as nachname_stabil,
           pr.idx_pos,
           vp.vorname as vorname_pos,    np.nachname as nachname_pos
      from pr
     cross join cnt
      left join vn vs on vs.g = pr.g and vs.nr = mod(pr.idx_stabil, cnt.cnt_vn)
      left join nn ns on ns.nr = trunc(pr.idx_stabil / cnt.cnt_vn)
      left join vn vp on vp.g = pr.g and vp.nr = mod(pr.idx_pos, cnt.cnt_vn)
      left join nn np on np.nr = trunc(pr.idx_pos / cnt.cnt_vn))
select namen.*,
       count(*) over (partition by vorname_stabil, nachname_stabil) as anzahl_stabil,
       count(*) over (partition by vorname_pos,    nachname_pos)    as anzahl_pos
  from namen
 order by pers_nr;

-- Zusammenfassung statt Einzelzeilen: die letzten vier Zeilen oben ("select namen.* ..." bis
-- "order by pers_nr;") durch Folgendes ersetzen:
--
-- select count(*)                                                          as personen,
--        min(pers_nr)                                                      as min_pers_nr,
--        max(pers_nr)                                                      as max_pers_nr,
--        max(pers_nr) - min(pers_nr) + 1                                   as spanne,
--        (select m from cnt)                                               as namensraum,
--        count(*) - count(distinct vorname_stabil || ' ' || nachname_stabil) as doppelt_stabil,
--        count(*) - count(distinct vorname_pos    || ' ' || nachname_pos)    as doppelt_pos
--   from namen;
