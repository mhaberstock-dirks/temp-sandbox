create or replace 
function DIRKSPZM32.bde_pd_prod_r_ag_b_f
/*
Meldet eine Auftrag an der Maschine oder an allen Mschinen einer Linie oder Produktionsgruppe zum Rüsten an. 
--------------------------------------------------------------------------------------------------------------------
- In dieser Funktion wird der Status der Maschine geändert -- STATUS ist Rüsten
--------------------------------------------------------------------------------------------------------------------

-- Die Funktion fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_leitzahl        in bde_fa_auftrag.leitzahl           Fertigungsauftrag
@param in_fa_ag           in bde_fa_auftrag.fa_ag              Arbeitsgang
@param in_fa_upos         in bde_fa_auftrag.fa_upos            Unterposition bzw. Split
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_akt_term        in isi_arbeitsplatz.ip_name          Name der Arbeitstation, von der gebucht wird          
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

@return v_vorg_id bde_pd_prod.vorg_id ist die Vorgang-ID der Buchung
*/
(in_sid         in isi_sid.sid%type,
 in_firma_nr    in isi_firma.firma_nr%type,
 in_leitzahl    in bde_fa_auftrag.leitzahl%type,
 in_fa_ag       in bde_fa_auftrag.fa_ag%type,
 in_fa_upos     in bde_fa_auftrag.fa_upos%type,
 in_res_id  in isi_resource.res_id%type,
 in_ls_login_id in isi_user.login_id%type)
 return number is

	v_fa_akt  bde_fa_auftrag%rowtype; --  Lesen FA mit Leitzahl Aktuell
	--v_fa_leit bde_fa_auftrag%rowtype; --  Lesen FA mit Leitzahl für Rohstoffe
	--v_res_lam isi_resource_lam_akt%rowtype; --  Aktuelle Lager_ID'S Rohstoffe dieser Maschine
	--v_lam     lvs_lam%rowtype; --  Lagerbestand
	v_res_zus isi_resource_zust_akt%rowtype; --  Aktueller Zustands dieser Maschine
	v_sysdate date; --  Datum und Zeit dieses Vorgangs
  v_res isi_resource%rowtype; -- Maschinendaten
	v_s_cfg   isi_res_status_cfg%rowtype; --  Configdaten des Maschinenstatus
	v_vorg_id bde_pd_prod.vorg_id%type; --  ID des Vorgangs

  v_lam_lte_waren_typ lvs_lte.waren_typ%type;
  v_lam_lte_leitzahl  lvs_lam.leitzahl%type;
	v_ins_lte_r lvs_lte.lte_id%type;  --

	-------------------------------------------------------------------------------------------------------
	-- Standard Fehler Felder für Exception
	-------------------------------------------------------------------------------------------------------
	v_error exception;
	v_err_nr   number;
	v_err_text varchar2(255);

	-- Lesen Palette mit Auskunft über Kartons und deren FA's
	CURSOR c_lam_lte is
		select lte.waren_typ,
           decode (min(lam.leitzahl), max(lam.leitzahl), max(lam.leitzahl), NULL) leitzahl
      from lvs_lte lte,
           lvs_lam lam
     where lte.lte_id = v_res_zus.lte_id
       and lte.lte_id = lam.lte_id(+)
     group by lam.lte_id, lte.waren_typ;

	-- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
	cursor c_bde_fa_auftrag is
		select *
			from bde_fa_auftrag fa_a
		 where fa_a.sid = in_sid
			 and fa_a.firma_nr = in_firma_nr
			 and fa_a.leitzahl = in_leitzahl
			 and fa_a.fa_ag = in_fa_ag
			 and nvl(fa_a.fa_upos, 0) = nvl(in_fa_upos, 0);

	/*
  cursor c_bde_res_lam_akt is
		select lam_akt.*
			from isi_resource_lam_akt lam_akt
		 where lam_akt.res_id = in_res_id;
  */

	-- Lesen aller AG's Rohstoffe für diese Leitzahl an dieser Maschine
	/*
  cursor c_leit_fa_auftrag is
		select *
			from bde_fa_auftrag fa_leit
		 where fa_leit.sid = in_sid
			 and fa_leit.firma_nr = in_firma_nr
			 and fa_leit.leitzahl = in_leitzahl
			 and fa_leit.fa_ag < in_fa_ag
		 order by fa_leit.fa_ag desc;
  */

	-- Holen der LAM_ID für eine Artikel_ID auf dieser Maschine
  /*
	cursor c_bde_res_lam is
		select *
			from isi_resource_lam_akt lam_akt
		 where lam_akt.sid = in_sid
			 and lam_akt.res_id = in_res_id;
  */

	-- Lesen des Lagerbestand
	/*
  cursor c_lam is
		select * from lvs_lam where lam_id = v_res_lam.lam_id;
  */

  -- Lesen der Resource
  CURSOR c_res_linie is
    select *
      from isi_resource t
     where t.linie_res_id = in_res_id
       and t.typ = 'MS';

  -- Lesen der Resource
  CURSOR c_res_mpg is
    select *
      from isi_resource t
     where t.gruppe = v_res.gruppe
       and t.typ = 'MS';

  -- Holen der Maschinendaten
  cursor c_resource is
    select t.*
      from isi_resource t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.res_id = in_res_id;

	-- Holen des aktuellen Zustands dieser Maschine
	cursor c_res_zust_akt is
		select *
			from isi_resource_zust_akt zust_akt
		 where zust_akt.sid = in_sid
       and zust_akt.firma_nr = in_firma_nr
			 and zust_akt.res_id = in_res_id;

	-- Lesen der Statusconfiguration für Ersren Eintrag Rüsten
	cursor c_res_status_cfg is
		select t.*
			from isi_res_status_cfg t
		 where t.sid = in_sid
			 and t.firma_nr = in_firma_nr
       and t.res_typ = v_res.typ
			 and t.st_gruppe = 'R'
		 order by nvl(t.res_st_id, 0);

  v_found boolean;
begin
	-- Erst mal kein Fehler
	v_err_nr   := null;
	v_err_text := null;
	v_sysdate  := sysdate; -- Speichern der Zeitpunkts

  open c_resource;

  fetch c_resource
    into v_res;
  v_found := c_resource%found;

  close c_resource;

	-- Wenn nicht gefunden dann setze Fehlertext !!
	if not v_found
	then
		v_err_nr   := 5;
		v_err_text := 'Maschine ID: ' || in_res_id ||
									' nicht vorhanden';
		raise v_error;
  end if;

  if v_res.typ = 'LI'   -- Res ist eine Linie
  then
    OPEN c_res_linie;
    LOOP
      FETCH c_res_linie into v_res;
      EXIT when c_res_linie%NOTFOUND;
      v_res.res_id := bde_pd_prod_r_ag_b_f (in_sid,                -- in_sid         in isi_sid.sid%type,
                                            in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
                                            in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                            in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                            in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                            v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                                            in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type)
    end LOOP;
    CLOSE c_res_linie;
  end if;

  if v_res.typ = 'MPG'  -- Res ist eien Produktionsgruppe
  then
    OPEN c_res_mpg;
    LOOP
      FETCH c_res_mpg into v_res;
      EXIT when c_res_mpg%NOTFOUND;
      v_res.res_id := bde_pd_prod_r_ag_b_f (in_sid,                -- in_sid         in isi_sid.sid%type,
                                            in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
                                            in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                            in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                            in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                            v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                                            in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type)
    end LOOP;
    CLOSE c_res_mpg;
  end if;

	-- Holen des aktuelle Zustands der Maschine
	open c_res_zust_akt;

	fetch c_res_zust_akt
		into v_res_zus;
  v_found := c_res_zust_akt%found;

  close c_res_zust_akt;

	-- Wenn nicht gefunden dann setze Fehlertext !!
	if not v_found
	then
		v_err_nr   := 10;
		v_err_text := 'Zustand der Maschine ID: ' || in_res_id ||
									' nicht vorhanden';
		raise v_error;
  end if;

  -- Gleichen Auftrag ist quatsch!

  if in_leitzahl = v_res_zus.leitzahl
  	 and in_fa_ag = v_res_zus.fa_ag
  	 and v_res_zus.akt_aufgabe = 'R'
  	 and nvl(in_fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
  then
  	v_err_nr   := 20;
  	v_err_text := 'Dieser FA Auftrag ist bereits im Rüsten! FA:' ||
  								in_leitzahl || '/' || in_fa_ag || '/' ||
  								nvl(in_fa_upos, 0);
  	raise v_error;
  end if;

  -- Ist der letzte Produktionsauftrag nicht abgemeldet
  if v_res_zus.akt_aufgabe = 'P'
  then
  	v_err_nr   := 25;
  	v_err_text := 'Dieser FA Auftrag ist noch angemeldet! FA:' ||
  								v_res_zus.leitzahl || '/' || v_res_zus.fa_ag || '/' ||
  								nvl(v_res_zus.fa_upos, 0);
  	raise v_error;
  	bde_pd_prod_p_ag_e(in_sid,
  										 in_firma_nr,
  										 v_res_zus.leitzahl,
  										 v_res_zus.fa_ag,
  										 v_res_zus.fa_upos,
  										 in_res_id,
  										 v_sysdate,
  										 null,
  										 null,
  										 null,
  										 in_ls_login_id);
  elsif v_res_zus.akt_aufgabe = 'R'
  then
   	v_err_nr   := 26;
  	v_err_text := 'Der FA Auftrag ist noch zum Rüsten angemeldet! FA:' ||
  								v_res_zus.leitzahl || '/' || v_res_zus.fa_ag || '/' ||
  								nvl(v_res_zus.fa_upos, 0);
  	raise v_error;
  	bde_pd_prod_r_ag_e(in_sid,
  										 in_firma_nr,
  										 v_res_zus.leitzahl,
  										 v_res_zus.fa_ag,
  										 v_res_zus.fa_upos,
  										 in_res_id,
  										 v_sysdate,
  										 null,
  										 null,
  										 null,
  										 in_ls_login_id);
  end if;

	--------------------------------------------------------------------------------------------------------------------
	-- Holen der Auftragsdaten fuer ABNR und Artikel ID
	--------------------------------------------------------------------------------------------------------------------
	open c_bde_fa_auftrag;

  fetch c_bde_fa_auftrag
		into v_fa_akt;
  v_found := c_bde_fa_auftrag%found;

	close c_bde_fa_auftrag;

	-- Wenn nicht gefunden dann setze Fehlertext !!
	if not v_found
	then
		v_err_nr   := 30;
		v_err_text := 'FA Auftrag für NR: ' || in_leitzahl || '/' || in_fa_ag || '/' ||
									in_fa_upos || ' nicht vorhanden';
		raise v_error;
	end if;

	-- Update des Aktuelle Zustands der Maschine
	update isi_resource_zust_akt res_akt
		 set res_akt.leitzahl                = in_leitzahl,
				 res_akt.akt_aufgabe             = 'R',
				 res_akt.akt_aufgabe_seit        = v_sysdate,
				 res_akt.fa_ag                   = in_fa_ag,
				 res_akt.fa_upos                 = in_fa_upos,
				 res_akt.fa_seit                 = v_sysdate,
         res_akt.abfuell_abschalt_grob   = v_fa_akt.abfuell_abschalt_grob,
         res_akt.abfuell_abschalt_mittel = v_fa_akt.abfuell_abschalt_mittel,
         res_akt.abfuell_abschalt_fein   = v_fa_akt.abfuell_abschalt_fein,
         res_akt.abfuell_toleranz_plus   = v_fa_akt.abfuell_toleranz_plus,
         res_akt.abfuell_toleranz_minus  = v_fa_akt.abfuell_toleranz_minus,
         res_akt.abfuell_silo            = v_fa_akt.abfuell_silo,
         res_akt.abfuell_soll            = v_fa_akt.abfuell_soll,
         res_akt.abfuell_ist             = 0,
         res_akt.prod_params             = v_fa_akt.prod_params,
         res_akt.auftrag_status          = decode(nvl(res_akt.auftrag_status, 'F'),
                                                  'F', 'D',
                                                  res_akt.auftrag_status)

	 where res_akt.sid = in_sid
     and res_akt.firma_nr = in_firma_nr
		 and res_akt.res_id = in_res_id;
  commit;

	if v_res_zus.status_id = 0
	then
		-- CFG Daten für Status holen (Std ist kleinste Nr. der Gruppe R)
		open c_res_status_cfg;

		fetch c_res_status_cfg
			into v_s_cfg;
		if c_res_status_cfg%notfound
		then
			-- Nichts gefunden dann auf Undef. setzen
			v_s_cfg.res_st_id     := null;
			v_s_cfg.st_gruppe := null;
			v_s_cfg.st_text   := null;
		end if;

		close c_res_status_cfg;

    if v_s_cfg.res_st_id is not NULL
    then
      -- Werte setzen, evtl Unbegründete Störung (res_st_id is NULL)
      res_status.res_status_beg(in_sid,
                                in_firma_nr,
                                in_res_id,
                                in_ls_login_id,
                                v_s_cfg.res_st_id,
                                v_s_cfg.res_typ,
                                null, -- res_st_ug_id
                                null, -- fehler_res_id
                                v_sysdate);

  	end if; -- v_res_zus.status_id = 0
	end if; -- v_res_zus.status_id = 0

	-- Update des Aktuelle Zustands des Arbeitsgangs
	if nvl(v_fa_akt.anz_res, 0) = 0
	then
		v_fa_akt.freig_status := 'AR';
	end if;

	update bde_fa_auftrag fa
		 set fa.freig_status     = v_fa_akt.freig_status,
				 fa.anz_res          = nvl(v_fa_akt.anz_res, 0) + 1,
				 fa.termin_start_ist = nvl(fa.termin_start_ist, v_sysdate),
         fa.Status_Freigabe  = 100,
         fa.mde_ist_mg       = nvl(fa.mde_ist_mg, 0),
         fa.mde_ist_mg_b     = nvl(fa.mde_ist_mg_b, 0),
         fa.mde_ist_mg_schrott = nvl(fa.mde_ist_mg_schrott, 0),
         fa.mde_ist_mg_ruesten = nvl(fa.mde_ist_mg_ruesten, 0),
         fa.mde_micro_stop   = nvl(fa.mde_micro_stop, 0),
         fa.mde_ist_mg_t     = 0,
         fa.mde_ist_mg_b_t   = 0,
         fa.mde_ist_mg_schrott_t = 0,
         fa.mde_ist_mg_ruesten_t = 0,
         fa.mde_micro_stop_t     = 0
	 where fa.sid = in_sid
		 and fa.leitzahl = in_leitzahl
		 and fa.fa_ag = in_fa_ag
		 and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);

  -- -AG- 19.09.2008 Auch beim Rüsten anfangen eine Palette bereitstellen
  if v_fa_akt.lte_name is not NULL
  then
    if isi_allg.c_get_firma_cfg_param(in_sid,
                                      in_firma_nr,
                                      'BDE',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'BDE_ANMELD_FA_AUTO_CRT_LEER_LTE',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                      'T',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN') = c.C_TRUE  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    then
      v_lam_lte_leitzahl := NULL;
      open c_lam_lte;
      fetch c_lam_lte into v_lam_lte_waren_typ, v_lam_lte_leitzahl;
      CLOSE c_lam_lte;

      if v_lam_lte_waren_typ != c.LEERPAL
      or v_lam_lte_waren_typ is NULL
      then
        if  nvl(v_lam_lte_leitzahl, 0) != in_leitzahl
        then
          v_ins_lte_r := bde_pd_lte_insert(v_fa_akt.sid,
                                           in_res_id,
                                           0,
                                           v_fa_akt.lte_name);
        end if;
      end if;
    end if;
  end if;
	-- Jetzt noch neuen Auftrag in der Produktionstabelle speichen
	select seq_vorg_id.nextval into v_vorg_id from dual;

	insert into bde_pd_prod
	values
		(in_sid,
		 v_vorg_id,
		 'RA',
		 in_firma_nr,
		 v_fa_akt.leitzahl,
		 v_fa_akt.fa_ag,
		 v_fa_akt.fa_upos,
		 v_fa_akt.abnr,
		 in_res_id,
		 v_sysdate,
		 null,
		 v_res_zus.pers_nr,
		 null,
		 v_fa_akt.ag_artikel_id,
		 null,
		 null,
		 null,
		 in_ls_login_id,
     NULL,
     v_fa_akt.abfuell_abschalt_grob,
     v_fa_akt.abfuell_abschalt_mittel,
     v_fa_akt.abfuell_abschalt_fein,
     v_fa_akt.abfuell_toleranz_plus,
     v_fa_akt.abfuell_toleranz_minus,
     v_fa_akt.abfuell_silo,
     v_fa_akt.abfuell_soll,
     0,
     v_fa_akt.prod_params,
     NULL,
     NULL,
     NULL,
     NULL);

	commit;
	return (v_vorg_id);
exception
	-- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
 when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
    rollback;
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end bde_pd_prod_r_ag_b_f;
/



-- sqlcl_snapshot {"hash":"d87d98c8f36b691ba2405bdb75a95a8cf436db0e","type":"FUNCTION","name":"BDE_PD_PROD_R_AG_B_F","schemaName":"DIRKSPZM32","sxml":""}