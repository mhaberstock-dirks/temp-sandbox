create or replace 
function DIRKSPZM32.bde_pd_lte_insert
/*
Traegt eine LTE zum Befüllen an einer Maschine ein.
Diese Palette wird dann auf den Staus B = Befüllen aktiv gesetzt. Zusälich wird diese Palette dann an der Maschine als aktuelle Palette zum befülle angemeldet.
-- Diese Funktion wird von BDE_C_PD_LTE_INSERT aufgerufen.
-- HISTORY ---
-- 21.10.2013 -MM- Kommentare in JavaDoc-Style geändert
-- 11.02.2015 -AG- Kommentare überarbeitet
--
Diese Funktion füht ein Commit aus (sollte aber nicht #ToDo Pruefen).

@param in_sid                 in isi_sid.sid Alte System ID (Normalerweise immer 01 und soll in zukünftigen Versionen entfallen)
@param in_res_id              in isi_resource.res_id Ressourcen-ID
@param in_ls_login_id         in isi_user.login_idLogin ID aktueller User
@param in_lte_name            in lvs_lte_cfg.lte_name -> Euro, Indu, ...
@return LTE-ID wenn alles OK
*/
(
in_sid in isi_sid.sid%type,
in_res_id in isi_resource.res_id%type,
in_ls_login_id in isi_user.login_id%type,
in_lte_name in lvs_lte_cfg.lte_name%type
)
return varchar2 is
  v_result lvs_lte.lte_id%type;
  v_lte_lhm_anz number;                       -- LTE Leer ?
  v_res         isi_resource%rowtype;              -- Maschinendaten
  v_found       boolean;
  v_frima       isi_firma%rowtype;                 -- Firmendaten
  v_charge_id   lvs_charge.charge_id%type;
  v_charge      lvs_charge.charge_bez%type;
  v_artikel_id  isi_artikel.artikel_id%type;
  v_leitzahl    bde_fa_auftrag.leitzahl%type;
  v_fa_ag       bde_fa_auftrag.fa_ag%type;
  v_fa_upos     bde_fa_auftrag.fa_upos%type;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_fa_auftrag       bde_fa_auftrag%rowtype;
  v_art_ctrl                     isi_artikel_ctrl%rowtype;

  v_typ                          varchar2(10);
  v_hersteller                   isi_hersteller.hersteller%type;

  cursor c_res is                        -- Lesen der Machinendaten (Resource)
    select *
    from isi_resource res
    where res.sid = in_sid and
          res.res_id = in_res_id;

  cursor c_res_lte is                     -- Lesen ob leere LTE an der Maschine
    select res_lte.lte_id, res_lte.lte_akt_lhm
    from lvs_lte res_lte
    where res_lte.lte_akt_lhm = 0 and
          res_lte.sid = v_res.sid and
          res_lte.firma_nr = v_res.firma_nr and
          res_lte.lgr_platz = v_res.lager_fertig;

  CURSOR c_res_zus_akt is
    select fa.ag_artikel_id,
           c.charge_bez,
           c.charge_id,
           fa.leitzahl,
           fa.fa_ag,
           fa.fa_upos
      from isi_resource_zust_akt r,
           bde_fa_auftrag fa,
           lvs_charge c
    where r.sid = in_sid
      and r.res_id = in_res_id
      and r.sid = fa.sid
      and r.firma_nr = fa.firma_nr
      and r.leitzahl = fa.leitzahl
      and r.fa_ag = fa.fa_ag
      and r.fa_upos = fa.fa_upos
      and fa.sid = c.sid
      and fa.charge_id = c.charge_id;

begin
  v_err_nr := NULL;
  OPEN c_res;                            -- Öffnen der Resourcendaten
  FETCH c_res into v_res;                -- Lesen der Daten
  v_found := c_res%FOUND;
  CLOSE c_res;

  v_charge := NULL;
  v_artikel_id := NULL;

  if not v_found then
    v_err_nr := 10;
    v_err_text := 'Fehler beim Lesen der Maschinendaten RES ID' || in_res_id;
    raise v_error;
  end if;

  if not isi_p_base.get_isi_firma (in_sid, v_res.firma_nr, v_frima)
  then
    v_err_nr := 20;
    v_err_text := 'Fehler Firmenstammdaten für Firma NR.: ' || to_char(v_res.firma_nr) || ' fehlt.';
    raise v_error;
  else
    OPEN c_res_zus_akt;
    FETCH c_res_zus_akt into v_artikel_id, v_charge, v_charge_id, v_leitzahl, v_fa_ag, v_fa_upos;
    CLOSE c_res_zus_akt;
  end if;

  -- In jedem Fall eine neue Palette anlegen
  v_result := NULL;

  if not bde_p_base.get_fa_ag(in_sid,                  -- SID der Maschine
                              v_res.firma_nr,           -- Firma der Maschine
                              v_leitzahl,
                              v_fa_ag,
                              v_fa_upos,
                              v_fa_auftrag)
  then
    v_fa_auftrag := NULL;
  end if;

  v_hersteller := substr(v_fa_auftrag.ma_hersteller_kuerzel_liste, 1, length(v_fa_auftrag.ma_hersteller_kuerzel_liste) -1);

  if isi_p_base.get_artikel_ctrl_typ (in_sid,
                                      v_fa_auftrag.ab_artikel_id,
                                      v_hersteller,
                                      v_art_ctrl)
  then
    v_typ := v_art_ctrl.prod_params;
  else
    v_typ := '0000000000';
  end if;




  v_result := lvs_p_lte.lvs_lte_insert_v359 (in_sid,                  -- SID der Maschine
                                             v_res.firma_nr,           -- Firma der Maschine
                                             in_lte_name,              -- Palettemtype Bsp. 'EURO'
                                             v_result,                 -- ID der Transporteinheit
                                             in_ls_login_id,           -- Login ID aktuelle User
                                             NULL,                     -- Kein Lager
                                             v_res.lager_fertig,       -- Fertigwarenlager der Maschine
                                             'B',                      -- Status ist auf befüllen gesetzt
                                             null,
                                             null,
                                             v_charge_id,              -- Charge ID
                                             v_charge,                 -- Charge
                                             v_artikel_id,             -- Artikel ID
                                             v_fa_auftrag.packschema_kopf_id,
                                             null,                    -- Auto Depal ist unbekannt
                                             null,                    -- wickelprogramm ist unbekannt,
                                             null,                    -- wickelprogramm_einl ist unbekannt
                                             v_typ,                   -- in_typ                  in varchar2,
                                             v_hersteller);           -- in_h_tag                in isi_hersteller.tag%type


  update isi_resource_zust_akt
     set lte_id = v_result                            -- Ergebnis im aktuellen Maschinenzustand SPEICHERN
   where sid = in_sid and
         res_id = in_res_id;

  return (v_result);
exception

  -- Im Fehlerfall ist der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
 when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    raise;
  when others then
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
end bde_pd_lte_insert;
/



-- sqlcl_snapshot {"hash":"503f0fdf3e4c66a28c926d7b49b96b8d1f1f9fd2","type":"FUNCTION","name":"BDE_PD_LTE_INSERT","schemaName":"DIRKSPZM32","sxml":""}