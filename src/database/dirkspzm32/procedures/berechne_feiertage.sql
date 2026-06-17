create or replace 
procedure DIRKSPZM32.berechne_feiertage(p_jahr in number) is
falsewert             exception;
berechnungsfehler     exception;
keinedaten            exception;

-- variablen für gaußsche osterberechnung
a          number;
b          number;
c          number;
k          number;  -- jahrhundert
p          number;  -- säkularzahl
q          number;  -- korrigierte säkularzahl
m          number;  -- mondparameter
n          number;  -- sonnenparameter
d          number;  -- erster vollmond
e          number;  -- sonntagskorrektur

ostern                date;
--rosenmontag           date;
karfreitag            date;
ostermontag           date;
himmelfahrt           date;
pfingsten             date;
pfingstmontag         date;
fronleichnam          date;
neujahr               date;
silvester             date;
jahr                  varchar2(4);
meifeiertag           date;
deutsche_einheit      date;
heiligabend           date;
erste_weinachtstag    date;
zweite_weinachtstag   date;
heilige_drei_koeninge date;
h_gefunden            boolean := false;
maria_h               date;
maria_h_gefunden      boolean := false;
reformations_tag      date;
r_gefunden            boolean := false;
allerheiligen         date;
a_gefunden            boolean := false;
bu_u_b_tag            date;
bu_gefunden           boolean := false;

begin
-- validierung des jahres
if p_jahr between 1583 and 8702 then
jahr := to_char(p_jahr);
else
raise falsewert;
end if;

-- *** korrigierte osterberechnung nach gauß ***
begin
a := mod(jahr, 19);
b := mod(jahr, 4);
c := mod(jahr, 7);
k := trunc(jahr / 100);
p := trunc((13 + 8 * k) / 25);
q := trunc(k / 4);
m := mod(15 - p + k - q, 30);
n := mod(4 + k - q, 7);
d := mod(19 * a + m, 30);

-- sonderfälle für vollmond
if (d = 29 and a > 10) or (d = 28 and a > 10) then
d := d - 1;
end if;

e := mod(2 * b + 4 * c + 6 * d + n, 7);

-- bestimmung des osterdatums
if (22 + d + e) > 31 then
ostern := to_date((d + e - 9) || '.04.' || jahr, 'dd.mm.yyyy');
else
ostern := to_date((22 + d + e) || '.03.' || jahr, 'dd.mm.yyyy');
end if;

-- ausnahmen für april
if d = 29 and e = 6 then
ostern := to_date('19.04.' || jahr, 'dd.mm.yyyy');
elsif d = 28 and e = 6 and a > 10 then
ostern := to_date('18.04.' || jahr, 'dd.mm.yyyy');
end if;

exception
when others then
raise berechnungsfehler;
end;

-- berechnung der abhängigen feiertage
--rosenmontag   := ostern - 48;
karfreitag    := ostern - 2;
ostermontag   := ostern + 1;
himmelfahrt   := ostern + 39;
pfingsten     := ostern + 49;
pfingstmontag := ostern + 50;
fronleichnam  := ostern + 60;

-- berechnung der festen feiertage
neujahr             := to_date('01.01.' || jahr, 'dd.mm.yyyy');
silvester           := to_date('31.12.' || jahr, 'dd.mm.yyyy');
meifeiertag         := to_date('01.05.' || jahr, 'dd.mm.yyyy');
heiligabend         := to_date('24.12.' || jahr, 'dd.mm.yyyy');
erste_weinachtstag  := to_date('25.12.' || jahr, 'dd.mm.yyyy');
zweite_weinachtstag := to_date('26.12.' || jahr, 'dd.mm.yyyy');

-- tag der deutschen einheit (vor/nach 1990)
if to_number(jahr) <= 1990 then
deutsche_einheit := to_date('17.06.' || jahr, 'dd.mm.yyyy');
else
deutsche_einheit := to_date('03.10.' || jahr, 'dd.mm.yyyy');
end if;

-- feiertage in einzelnen bundesländern
heilige_drei_koeninge := to_date('06.01.' || jahr, 'dd.mm.yyyy');
h_gefunden            := true;

maria_h              := to_date('15.08.' || jahr, 'dd.mm.yyyy');
maria_h_gefunden     := true;

reformations_tag := to_date('31.10.' || jahr, 'dd.mm.yyyy');
r_gefunden       := true;

allerheiligen := to_date('01.11.' || jahr, 'dd.mm.yyyy');
a_gefunden    := true;

if to_number(jahr) > 1990 then
bu_u_b_tag  := to_date('20.11.' || jahr, 'dd.mm.yyyy');
bu_gefunden := true;
end if;

-- einfügen der feiertage in die tabelle
begin
-- heilige drei könige
if h_gefunden then
insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (heilige_drei_koeninge, 'Heilige drei Könige', 'DE-BW;DE-BY;DE-ST', isi_utils.iso_weekday(heilige_drei_koeninge), 'F');
end if;

-- mariä himmelfahrt
if maria_h_gefunden then
insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (maria_h, 'Mariä Himmelfahrt', 'DE-BY;DE-SL', isi_utils.iso_weekday(maria_h), 'F');
end if;

-- rosenmontag
--insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag)
--values (rosenmontag, 'rosenmontag', 'de-nw;de-rp', isi_utils.iso_weekday(rosenmontag));

-- ostern und abhängige feiertage
insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (ostern, 'Ostern', 'DE', isi_utils.iso_weekday(ostern), 'F');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (karfreitag, 'Karfreitag', 'DE', isi_utils.iso_weekday(karfreitag), 'F');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (ostermontag, 'Ostermontag', 'DE', isi_utils.iso_weekday(ostermontag), 'SF');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (himmelfahrt, 'Christi Himmelfahrt', 'DE', isi_utils.iso_weekday(himmelfahrt), 'F');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (pfingsten, 'Pfingsten', 'DE', isi_utils.iso_weekday(pfingsten), 'F');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (pfingstmontag, 'Pfingstmontag', 'DE', isi_utils.iso_weekday(pfingstmontag), 'SF');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag)
values (fronleichnam, 'Fronleichnam', 'DE-BW;DE-BY;DE-HE;DE-NW;DE-RP;DE-SL', isi_utils.iso_weekday(fronleichnam));

-- feste feiertage
insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (neujahr, 'Neujahr', 'DE', isi_utils.iso_weekday(neujahr), 'SF');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag)
values (silvester, 'Silvester', 'DE', isi_utils.iso_weekday(silvester));

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (meifeiertag, 'Tag der Arbeit', 'DE', isi_utils.iso_weekday(meifeiertag), 'SF');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (heiligabend, 'Heiligabend', 'DE', isi_utils.iso_weekday(heiligabend), 'SF');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (erste_weinachtstag, '1. Weihnachtstag', 'DE', isi_utils.iso_weekday(erste_weinachtstag), 'SF');

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag)
values (zweite_weinachtstag, '2. Weihnachtstag', 'DE', isi_utils.iso_weekday(zweite_weinachtstag));

insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag)
values (deutsche_einheit, 'Tag der Deutschen Einheit', 'DE', isi_utils.iso_weekday(deutsche_einheit));

-- reformationstag
if r_gefunden then
insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (reformations_tag, 'Reformationstag', 'DE-BB;DE-MV;DE-NI;DE-SN;DE-ST', isi_utils.iso_weekday(reformations_tag), 'F');
end if;

-- allerheiligen
if a_gefunden then
insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (allerheiligen, 'Allerheiligen', 'DE-BW;DE-BY;DE-NW;DE-RP;DE-SL', isi_utils.iso_weekday(allerheiligen), 'F');
end if;

-- buß- und bettag
if bu_gefunden then
insert into isi_feiertage (f_datum, f_name, region_codes_csv, f_wochentag, f_sonder_feiertag)
values (bu_u_b_tag, 'Buß- und Bettag', 'DE-SN', isi_utils.iso_weekday(bu_u_b_tag), 'F');
end if;

commit;
exception
when others then
raise keinedaten;
end;

exception
when falsewert then
raise_application_error(-20000, 'Ungültiges Jahr');
when berechnungsfehler then
raise_application_error(-20001, 'Fehler bei Osterberechnung');
when keinedaten then
raise_application_error(-20002, 'Fehlende Daten');
end berechne_feiertage;
/



-- sqlcl_snapshot {"hash":"e3f63eb8534adee837430f69750e334f577d36b9","type":"PROCEDURE","name":"BERECHNE_FEIERTAGE","schemaName":"DIRKSPZM32","sxml":""}