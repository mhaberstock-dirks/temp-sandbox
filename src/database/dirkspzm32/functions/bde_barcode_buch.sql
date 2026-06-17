create or replace 
function DIRKSPZM32.bde_barcode_buch
/*
  Zu einem Barcode werden Arbeitsgaenge etc. gebucht.
  Die Funktion fuehrt ein Commit durch
  Autor: ?
  ---- HISTORY ---
  21.10.2013 -MM- Kommentare in JavaDoc-Style geändert
  @param in_sid
  @param in_firma_nr
  @param in_barcode
  @param in_res_id
  @param in_ls_login_id
  @param in_menge_a
  @param in_menge_b
  @param in_schrott
  @param in_aufgabe
  @param in_fae_id
  @param in_fae_id_position
  @param out_leitzahl
  @param out_fa_ag
  @param out_fa_upos
  @return 0 Im Fehlerfall
*/
(   in_sid             in isi_sid.sid%type,
    in_firma_nr        in isi_firma.firma_nr%type,
    in_barcode         in lvs_lte.lte_id%type,
    in_res_id          in isi_resource.res_id%type,
    in_ls_login_id     in isi_user.login_id%type,
    in_menge_a         in lvs_lam.menge%type,
    in_menge_b         in lvs_lam.menge%type,
    in_schrott         in lvs_lam.menge%type,
    in_aufgabe         in varchar2,
    in_fae_id          in bde_pd_prod.fae_id%type,
    in_fae_id_position in bde_pd_prod.fae_id_position%type,
    out_leitzahl       out bde_fa_auftrag.leitzahl%type,
    out_fa_ag          out bde_fa_auftrag.fa_ag%type,
    out_fa_upos        out bde_fa_auftrag.fa_upos%type
)
return number is

  v_res_zus      isi_resource_zust_akt%rowtype;     --  Aktueller Zustand dieser Maschine
  v_barcode_ref  varchar2(3);                       --  Was ist das für ein Barcode
  v_barcode_best number;                            --  Bestand zu diesem Barcode
  v_found        boolean;                           --  Daten gefunden
  v_lam          lvs_lam%rowtype;                   --  LAM-Daten
  v_res_kat_typ  isi_resource.kategorie_typ%type;   --  Kategorietyp aus der ISI Resource

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerfelder für Exceptions
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- Holen des aktuellen Zustands dieser Maschine
  CURSOR c_bde_res_zus IS
  SELECT *
    FROM isi_resource_zust_akt zust_akt
    WHERE zust_akt.sid = in_sid AND
          zust_akt.res_id = in_res_id;

  -- CMe 20210325 Holen des Kategorie Typs. Default ist MAN (Manuell)
  CURSOR c_get_isi_res_kat_type IS
    SELECT nvl(res.kategorie_typ, 'MAN')
      FROM isi_resource res
     WHERE res.sid = in_sid
       AND res.res_id = in_res_id;


begin
  -- Lesen der Artikeldaten
  v_err_nr := NULL;
  v_err_text := NULL;
  v_res_kat_typ := NULL;

  -- Holen des Aktuellen Zustands der Maschine
  OPEN c_bde_res_zus;
  FETCH c_bde_res_zus INTO v_res_zus;
  v_found := c_bde_res_zus%FOUND;
  CLOSE c_bde_res_zus;

  -- Wenn nicht gefunden dann setze Fehlertext !!
  if not v_found then
    v_err_nr := 10;
    v_err_text := 'Zustand der Maschine ID: ' || in_res_id || ' nicht vorhanden.';
    raise v_error;
  end if;

  -- CMe 20210325 Kategorie Typ holen
  OPEN c_get_isi_res_kat_type;
  FETCH c_get_isi_res_kat_type into v_res_kat_typ;
  CLOSE c_get_isi_res_kat_type;

  -- Speichen der Auftragsnummer und Arbeitsgang
  out_leitzahl := v_res_zus.leitzahl;
  out_fa_ag := v_res_zus.fa_ag;
  out_fa_upos := v_res_zus.fa_upos;

  if out_leitzahl is NULL then
    v_err_nr := 11;
    v_err_text := 'Auf dieser Maschine ist kein Auftrag angemeldet. Buchungen nicht möglich.';
    raise v_error;
  end if;

  -- Hat der Barcod eine Referenz zum LHM oder LTE und gibt es Bestand ???
  v_barcode_ref := lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_barcode);
  if v_barcode_ref is not NULL and
     v_barcode_ref != 'NEU' then
    v_barcode_best := lvs_p_lte_lhm.lvs_lte_lhm_best_r30(in_sid, in_firma_nr, in_barcode, v_barcode_ref, c.C_FALSE);
  else
    v_barcode_best := 0;
  end if;

  if  v_barcode_best != 0
  and (in_aufgabe = 'PROD.R.MG.'
    or in_aufgabe = 'PROD+FA'
    or in_aufgabe = 'P+F.R.MG.'
    or in_aufgabe = 'LK'
    or in_aufgabe = 'PRODUKTION') then
    v_err_nr := 12;
    v_err_text := 'Barcode ist bereits vergeben. Buchung mit diesem Barcode nicht möglich!'; -- Standardfehlertext
    -- -AG- 20.09.2010 Ab hier neu
    if lvs_p_base.get_lam_by_lhm_id(in_sid, in_firma_nr, in_barcode, v_lam) -- -AG- 20.09.2010 Fehler genau analysieren
    then
      if v_lam.leitzahl != out_leitzahl
      or v_lam.fa_ag != out_fa_ag
      or v_lam.fa_upos != out_fa_upos
      then
        v_err_text := 'Stop! Stop! Falscher FA Neuen Barcode verwenden';
        /*v_err_text := 'Stop! Stop!' || CHR(13) || CHR(10) ||
                      'Falscher FA' || CHR(13) || CHR(10) ||
                      'Neuen Barcode' || CHR(13) || CHR(10) ||
                      'verwenden';*/
        v_lam.qs_status := isi_allg.c_get_firma_cfg_param(in_sid,
                                                          in_firma_nr,
                                                          'BDE_ERR_NOTE',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                          NULL,                       -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                          'BDE_BARCODE_ZUORDNUNG',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                          'BDE_DB',                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                          'CFG',                      -- in_typ                   in isi_firma_cfg.typ%type,
                                                          NULL,                       -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                          'STRING');                  -- in_default_param_typ

        if v_lam.qs_status is NOT NULL -- Falsche Zuordnung soll vermerkt werden.
        then
          lvs_util.c_set_lam_qs_status (in_sid,
                                        in_firma_nr,
                                        in_barcode,
                                        v_lam.qs_status);

        end if;
      end if;
    end if;
    -- -AG- 20.09.2010 Ende
    raise v_error;
  end if;

  if v_barcode_best = 0 and
     in_aufgabe = 'BESCHICKEN' then
    v_err_nr := 13;
    v_err_text := 'Keine Menge für diesen Barcode vorhanden. Buchung mit diesem Barcode nicht möglich!';
    raise v_error;
  end if;


  -- Es gibt bereits Bestand zu diesem Barcode, dann kann es nur ein Abgang sein
  if v_barcode_best != 0 then
    -- Versuch die hinter dem Barcode stehende Menge als Abgang in diese Maschine zu buchen
    bde_pd_prod_insert(in_sid, 'PM', in_firma_nr, in_barcode,
                       v_res_zus.leitzahl, v_res_zus.fa_ag, v_res_zus.fa_upos,
                       in_res_id, v_res_zus.pers_nr, NULL, NULL, NULL, in_ls_login_id,
                       in_fae_id, in_fae_id_position, NULL);
  else
    -- -AG- 18.09.2008 Bei Leerkartonscannung darf auch ein Auftrag im Rüsten angemeldet werden
    -- CMe 20210325 Bei Rüsten darf auch Produktion erzeugt werden, wenn die Maschiene automatisch Produziert
    if (v_res_zus.akt_aufgabe = 'P')
    or (v_res_zus.akt_aufgabe = 'R' and in_aufgabe = 'LK')
    or (v_res_zus.akt_aufgabe = 'R' and v_res_kat_typ is not null and v_res_kat_typ = 'AUT')
    then
      bde_pd_prod_insert(in_sid, 'PP', in_firma_nr, in_barcode,
                         v_res_zus.leitzahl, v_res_zus.fa_ag, v_res_zus.fa_upos,
                         in_res_id, v_res_zus.pers_nr, in_menge_a, in_menge_b, in_schrott, in_ls_login_id,
                         in_fae_id, in_fae_id_position, NULL);
      v_barcode_best := lvs_p_lte_lhm.lvs_lte_lhm_best_r30(in_sid, in_firma_nr, in_barcode, lvs_p_lte_lhm.lvs_lte_lhm_ref(in_sid, in_firma_nr, in_barcode), c.C_FALSE);
    else
      v_err_nr := 20;
      v_err_text := 'Auf dieser Maschine wird nicht Produziert. Produktionszugang nicht möglich!!';
      raise v_error;

    end if;
  end if;
  return(v_barcode_best);                      -- OK
exception
  -- Im Fehlerfall ist der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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
end bde_barcode_buch;
/



-- sqlcl_snapshot {"hash":"872035da9a13c78a76d4e86c90e78b098340dd30","type":"FUNCTION","name":"BDE_BARCODE_BUCH","schemaName":"DIRKSPZM32","sxml":""}