create or replace 
procedure DIRKSPZM32.bde_pd_prod_r_ag_e_p
/*
In dieser Procedure wird Produktion Auftrag Rüsten Ende gebucht -> Diese Procedur ist zur internen Verwendung und darf nur über bde_pd_prod_r_ag_e aufgerufen werden

-- Die procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden hier nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_leitzahl        in bde_fa_auftrag.leitzahl           Fertigungsauftrag
@param in_fa_ag           in bde_fa_auftrag.fa_ag              Arbeitsgang
@param in_fa_upos         in bde_fa_auftrag.fa_upos            Unterposition bzw. Split
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_sysdate         in date                              Buchungsdatum
@param in_menge_a         in bde_pd_prod.Menge_a               Menge A-Qualität Wenn alle Mengen NULL oder 0, dann werden diese aus den Bucungen in der BDE_PD_PROD ermittelt
@param in_menge_b         in bde_pd_prod.Menge_b               Menge B-Qualität - 2te Wahl
@param in_schrott         in bde_pd_prod.schrott               Schrottmenge
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

*/
(in_sid         in isi_sid.sid%type,
 in_firma_nr    in isi_firma.firma_nr%type,
 in_leitzahl    in bde_fa_auftrag.leitzahl%type,
 in_fa_ag       in bde_fa_auftrag.fa_ag%type,
 in_fa_upos     in bde_fa_auftrag.fa_upos%type,
 in_res_id      in isi_resource.res_id%type,
 in_sysdate     date,
 in_menge_a     in bde_pd_prod.menge_a%type,
 in_menge_b     in bde_pd_prod.menge_b%type,
 in_schrott     in bde_pd_prod.schrott%type,
 in_ls_login_id in isi_user.login_id%type) is
  -- -AG- Speichern, welche Mengen an den Host geschickt wurden

  v_res      isi_resource%rowtype;
  v_res_zus  isi_resource_zust_akt%rowtype; --  Aktueller Zustands dieser Maschine
  v_sysdate  date; --  Datum und Zeit dieses Vorgangs
  v_menge_a  bde_pd_prod.menge_a%type; --  Für die Summe der GutStück
  v_mde_a    bde_fa_auftrag.mde_ist_mg%type; --  Für die Summe der GutStück
  v_menge_b  bde_pd_prod.menge_b%type; --  Für die Summe der 2.Wahl
  v_schrott  bde_pd_prod.schrott%type; --  Für die Summe der Schrottmenge
  v_s_cfg    isi_res_status_cfg%rowtype; --  Configdaten des Maschinenstatus

  v_bew_id   s_send_bew.bew_id%type;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr     number;
  v_err_text   varchar2(255);
  v_fa_auftrag bde_fa_auftrag%rowtype; --  Fertigungsauftrag
  v_ruest_std  number;
  v_ruest_std_erf  number; -- Stunden Mitarbeiter für den aktuellen Rüstvorgang

  -- Holen der Maschinendaten
  cursor c_resource is
    select t.*
      from isi_resource t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.res_id = in_res_id;

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

  -- Holen des aktuellen Zustands dieser Maschine
  cursor c_bde_res_zus is
    select t.*
      from isi_resource_zust_akt t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.res_id = in_res_id;

  -- Lesen und Summieren der Produktionsleistung falls der Auftrag nicht von Hand beendet
  cursor c_bde_pd_prod_all is
    select sum(menge_a),
           sum(menge_b),
           sum(schrott)
      from bde_pd_prod pd_p_all
     where pd_p_all.sid = in_sid
       and pd_p_all.res_id = in_res_id
       and pd_p_all.vorg_typ = 'PR'
       and pd_p_all.leitzahl = v_res_zus.leitzahl
       and pd_p_all.fa_ag = v_res_zus.fa_ag
       and nvl(pd_p_all.fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
       and pd_p_all.prod_beginn >= v_res_zus.akt_aufgabe_seit
       and pd_p_all.prod_beginn <= v_sysdate
     group by pd_p_all.leitzahl;

  -- Lesen der Statusconfiguration für Rüsten
  cursor c_res_status_cfg is
    select *
      from isi_res_status_cfg s_cfg
     where s_cfg.sid = in_sid
       and s_cfg.firma_nr = in_firma_nr
       and s_cfg.res_st_id = v_res_zus.status_id
       and s_cfg.res_typ = v_res.typ;

  v_found boolean;

begin
  OPEN c_resource;
  FETCH c_resource into v_res;
  CLOSE c_resource;

  if v_res.typ = 'LI'   -- Res ist eine Linie
  then
    OPEN c_res_linie;
    LOOP
      FETCH c_res_linie into v_res;
      EXIT when c_res_linie%NOTFOUND;
      bde_pd_prod_r_ag_e_p (in_sid,                -- in_sid         in isi_sid.sid%type,
                          in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
                          in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                          in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                          in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                          v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                          in_sysdate,            -- in_sysdate     date,
                          NULL,                  -- in_menge_a     in bde_pd_prod.Menge_a%type,
                          NULL,                  -- in_menge_b     in bde_pd_prod.Menge_b%type,
                          NULL,                  -- in_schrott     in bde_pd_prod.schrott%type,
                          in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type) is
    end LOOP;
    CLOSE c_res_linie;
  end if;

  if v_res.typ = 'MPG'  -- Res ist eien Produktionsgruppe
  then
    OPEN c_res_mpg;
    LOOP
      FETCH c_res_mpg into v_res;
      EXIT when c_res_mpg%NOTFOUND;
      bde_pd_prod_r_ag_e_p (in_sid,                -- in_sid         in isi_sid.sid%type,
                          in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
                          in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                          in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                          in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                          v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                          in_sysdate,            -- in_sysdate     date,
                          NULL,                  -- in_menge_a     in bde_pd_prod.Menge_a%type,
                          NULL,                  -- in_menge_b     in bde_pd_prod.Menge_b%type,
                          NULL,                  -- in_schrott     in bde_pd_prod.schrott%type,
                          in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type) is
    end LOOP;
    CLOSE c_res_mpg;
  end if;

  -- Erst mal kein Fehler
  v_err_nr   := null;
  v_err_text := null;


  v_sysdate := nvl(in_sysdate, sysdate);

  -- Holen der Maschinendaten
  open c_resource;

  fetch c_resource
    into v_res;
  v_found := c_resource%found;

  close c_resource;

  -- Wenn nicht gefunden dann setze Fehlertext !!
  if not v_found
  then
    v_err_nr   := 5;
    v_err_text := 'Maschine ID: ' || in_res_id || ' nicht vorhanden';
    raise v_error;
  end if;

  -- Holen des aktuelle Zustands der Maschine
  open c_bde_res_zus;

  fetch c_bde_res_zus
    into v_res_zus;
  v_found := c_bde_res_zus%found;

  close c_bde_res_zus;

  -- Wenn nicht gefunden dann setze Fehlertext !!
  if not v_found
  then
    v_err_nr   := 10;
    v_err_text := 'Zustand der Maschine ID: ' || in_res_id ||
                  ' nicht vorhanden';
    raise v_error;
  end if;

  v_mde_a := bde_funktionen.get_mde_gut_mengen(in_res_id, v_res.res_ext_name, in_leitzahl, v_res_zus.akt_aufgabe_seit, v_sysdate);

  if nvl(v_res_zus.akt_aufgabe, 0) != 'R'
  then
    v_err_nr   := 20;
    v_err_text := 'Kein FA Auftrag mit Status Rüsten der Maschine angemeldet.';
    raise v_error;
  end if;
  if in_leitzahl = v_res_zus.leitzahl
     and in_fa_ag = v_res_zus.fa_ag
     and v_res_zus.akt_aufgabe = 'R'
     and nvl(in_fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
  then
    if nvl(in_menge_a, 0) = 0
       and nvl(in_menge_b, 0) = 0
       and nvl(in_schrott, 0) = 0
    then
      open c_bde_pd_prod_all;
      fetch c_bde_pd_prod_all
        into v_menge_a, v_menge_b, v_schrott;
      if c_bde_pd_prod_all%notfound
      then
        v_menge_a := 0;
        v_menge_b := 0;
        v_schrott := 0;
      end if;
      close c_bde_pd_prod_all;
    else
      v_menge_a := nvl(in_menge_a, 0);
      v_menge_b := nvl(in_menge_b, 0);
      v_schrott := nvl(in_schrott, 0);
    end if;

    -- -AG- 23.09.2008 Wenn LHM während des Ruesten gebucht wurde, dann muss der bei der Abmeldung geloescht werden
    bde_funktionen.c_set_zug_menge_lhm_fa(in_sid,
                                          in_firma_nr,
                                          v_res_zus.leitzahl,
                                          v_res_zus.fa_ag,
                                          v_res_zus.fa_upos,
                                          0);
    update bde_pd_prod pd_p
       set pd_p.prod_ende = v_sysdate,
           pd_p.menge_a   = v_menge_a,
           pd_p.menge_b   = v_menge_b,
           pd_p.schrott   = v_schrott
     where pd_p.sid = in_sid
       and pd_p.firma_nr = in_firma_nr
       and pd_p.leitzahl = v_res_zus.leitzahl
       and pd_p.fa_ag = v_res_zus.fa_ag
       and nvl(pd_p.fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
       and pd_p.vorg_typ = 'RA'
       and pd_p.prod_ende is null;
  end if;

  fls_p_bde_lvs.c_bde_res_print_lte(in_sid, in_res_id);
  -- Update des Aktuelle Zustands der Maschine
  -- -AG- 19.09.2008 LTE in Res nicht löschen, da evtl. weiter benötigt wird
  update isi_resource_zust_akt res_akt
     set res_akt.leitzahl = NULL,
         res_akt.akt_aufgabe = NULL,
         res_akt.fa_ag    = NULL,
         res_akt.fa_upos  = NULL,
         res_akt.fa_seit  = NULL,
         --res_akt.lte_id   = NULL,
         res_akt.abfuell_abschalt_grob   = NULL,
         res_akt.abfuell_abschalt_mittel = NULL,
         res_akt.abfuell_abschalt_fein   = NULL,
         res_akt.abfuell_toleranz_plus   = NULL,
         res_akt.abfuell_toleranz_minus  = NULL,
         res_akt.abfuell_silo            = NULL,
         res_akt.abfuell_soll            = NULL,
         res_akt.abfuell_ist             = NULL,
         res_akt.prod_params             = NULL,
         res_akt.auftrag_status          = 'F'
     where res_akt.sid = in_sid and
           res_akt.res_id = in_res_id;

  --CMe 20210325 Wenn die Rüstmenge nicht übernommen wird muss die LTE aus den aktuell Zustand gelöscht werden
  --wenn dies nicht passiert kann es zu folge Fehlern bei automatischen Produktionen
  if  isi_allg.c_get_firma_cfg_param (in_sid,
                                      in_firma_nr,
                                      'CFG',                   -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      NULL,                    -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'RUEST_MG_IN_PROD_MG',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'BDE',                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                   -- in_typ                   in isi_firma_cfg.typ%type,
                                      'F',                     -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN') = c.C_FALSE   -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
  then
    update isi_resource_zust_akt res_akt
       set res_akt.lte_id   = NULL
     where res_akt.sid = in_sid and
           res_akt.res_id = in_res_id;
  end if;

  commit;

  -- CFG Daten für Status holen (Std ist kleinste Nr. der Gruppe R)
  open c_res_status_cfg;
  fetch c_res_status_cfg
    into v_s_cfg;
  if c_res_status_cfg%notfound
  then
    -- Nichts gefunden dann auf Undef. setzen
    v_s_cfg.res_st_id := null;
    v_s_cfg.st_gruppe := null;
    v_s_cfg.st_text   := null;
  end if;
  close c_res_status_cfg;

  -- Status der Maschine steht auf Rüsen ?
  if v_s_cfg.st_gruppe = 'R'
  then
    -- Status auf "Maschine läuft" setzen (der aktuelle Status wird automatisch beendet)
    res_status.res_status_beg(in_sid,
                              in_firma_nr,
                              in_res_id,
                              in_ls_login_id,
                              0,
                              v_res.typ,
                              null,
                              null,
                              v_sysdate);
  end if;

  if bde_p_base.get_fa_ag(in_sid,
                         in_firma_nr,
                         in_leitzahl,
                         in_fa_ag,
                         in_fa_upos,
                         v_fa_auftrag)
  then
    if v_fa_auftrag.anz_res = 1
    then
      if v_fa_auftrag.satzart = 'VR'
      then
        v_fa_auftrag.freig_status := 'F';
      else
        v_fa_auftrag.freig_status := 'A'; -- Auftrag kann angefangen werden
      end if;
    end if;
  end if;

  -- Erstmal nur die Daten ermitteln
  v_ruest_std := bde_funktionen.get_fa_zeiten_upos(in_sid, in_firma_nr, in_leitzahl, in_fa_ag, in_fa_upos, NULL);
  -- -AG- BugFix: Hier werden Minuten benötig
  v_ruest_std := bde_funktionen.get_ruest_std() * 60;
  -- -DTs- 20190919 Ermitteln der MA-Zeiten in dem FA für die aktuelle anmeldung
  v_ruest_std_erf := bde_funktionen.get_ma_erf_zeiten(v_res_zus.sid, v_res_zus.firma_nr, v_res_zus.res_id, v_res_zus.akt_aufgabe_seit, sysdate) * 60;
  -- Update des Aktuelle Zustands des Arbeitsgangs
  update bde_fa_auftrag fa
     set fa.freig_status      = v_fa_auftrag.freig_status,
         fa.anz_res           = fa.anz_res - 1,
         fa.mde_ist_mg        = nvl(fa.mde_ist_mg, 0) -
                                nvl(fa.mde_ist_mg_t, 0), -- Mengen geht ins Rüsten
         fa.mde_ist_mg_ruesten = fa.mde_ist_mg_ruesten + fa.mde_ist_mg_t,
         fa.ruest_zeit_ist    = v_ruest_std,
         fa.ruest_zeit_erf = nvl(fa.ruest_zeit_erf, 0) + v_ruest_std_erf,
         fa.mde_ist_mg_t       = 0,
         fa.termin_ende_ist   = v_sysdate
   where fa.sid = in_sid
     and fa.leitzahl = in_leitzahl
     and fa.fa_ag = in_fa_ag
     and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);
  v_fa_auftrag.anz_res := v_fa_auftrag.anz_res - 1;

  -- Soll Ruestenende gemeldet werden ?
  if isi_allg.c_get_firma_cfg_param(in_sid,
                                     in_firma_nr,
                                     'BDE_FA_AB',           -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                     NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                     'SEND_RE_TO_HOST',     -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                     'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                     'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                     'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                     'BOOLEAN') = c.C_TRUE  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
  then
    if bde_p_base.get_fa_ag(in_sid,                -- in_sid        in  bde_fa_auftrag.sid%type,
                            in_firma_nr,           -- in_firma_nr   in  bde_fa_auftrag.firma_nr%type,
                            in_leitzahl,           -- in_fa_nr      in  bde_fa_auftrag.leitzahl%type,
                            in_fa_ag,              -- in_fa_ag      in  bde_fa_auftrag.fa_ag%type,
                            nvl(in_fa_upos, 0),    -- in_fa_upos    in  bde_fa_auftrag.fa_upos%type,
                            v_fa_auftrag)          -- out_bde_fa_ag out bde_fa_auftrag%rowtype) return boolean is
    then
      if  v_fa_auftrag.anz_res = 0
      then
        -- Merken, das Rüsten Ende ist
        v_fa_auftrag.freig_status := 'RF';
        v_bew_id := s_schnittstelle.write_host_prod_bew(in_sid, v_fa_auftrag.firma_nr,
                                                        v_fa_auftrag, NULL, NULL, NULL, NULL, 'S_FA', 'UE');

        -- -AG- Auftrag Status hat sich geändert und Mengen und zeit sind zum Host übergeben
        update bde_fa_auftrag fa
           set fa.rcv_ag_ist_mg         = fa.ag_ist_mg,
               fa.rcv_ag_ist_mg_b       = fa.ag_ist_mg_b,
               fa.rcv_ag_ist_mg_schrott = fa.ag_ist_mg_schrott,
               fa.rcv_ag_ist_mg_ruesten = fa.ag_ist_mg_ruesten,
               fa.rcv_ruest_zeit_ist    = fa.ruest_zeit_ist,
               fa.rcv_prod_zeit_ist     = fa.prod_zeit_ist,
               fa.rcv_stoer_zeit_ist    = fa.stoer_zeit_ist
         where fa.sid = in_sid and
               fa.firma_nr = in_firma_nr and
               fa.leitzahl = in_leitzahl and
               fa.fa_ag = in_fa_ag and
               nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);
      end if;
    end if;
  end if;

  commit;
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
end bde_pd_prod_r_ag_e_p;
/



-- sqlcl_snapshot {"hash":"35d400f94392f21be1fc94ef31a77b6dd104b4b6","type":"PROCEDURE","name":"BDE_PD_PROD_R_AG_E_P","schemaName":"DIRKSPZM32","sxml":""}