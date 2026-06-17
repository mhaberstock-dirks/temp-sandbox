create or replace 
package body DIRKSPZM32.lvs_p_lte is
  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  26.04.2004 09:06:35
  __________________________________________________
  Description
  Lagerverwaltung Einlagern
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  28.07.2014   3.5.8       (-MM-)   Kundenspezifische LHM und LTE IDs
  21.11.2013   3.5.7.6     (-WK-)   Header added and new release and version handling
  27.11.2009   3.5.0.3     (-BW-)   Minor Release
  26.04.2004               (-AG-)   package created
  */

  v_build_number constant number := 6;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
  procedure reset_isi_error is
  begin
    v_err_nr := null;
    v_err_text := null;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_release return varchar2 is
  begin
    return(v_release_str);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2
                          ) is
  begin
    out_rel_major := v_release_major;
    out_rel_minor := v_release_minor;
    out_revision := v_revision;
    out_buid_number := v_build_number;
    out_rev_date := v_rev_date;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Function and procedure implementations
  -------------------------------------------------------------------------------------------------------

  -- Private declarations
  function LVS_LTE_AUSLAGERN(in_lte_id          in lvs_lte.lte_id%type,
                             in_tour_nr         in isi_order_pos.vorgang_id%type,
                             in_user_id         in isi_user.login_id%type
                            ) return varchar2;

/*******************************************************************************
 * procedure LVS_LTE_DRUCKEN(...)

 Druckt die übergebene Palette für den Übergebenen Kunden wenn dieser ein eigenes
        Etikettenlayout hat. Wenn der Kunde = NULL oder der Kunde kein eigenes
        Etikettenlayout hat dann Etikettenlayout aus dem Firmenstamm verwenden
 *******************************************************************************/
  procedure LVS_LHM_DRUCKEN (in_lhm_id       in lvs_lte.lte_id%type,
                             in_kunden_nr    in isi_adressen.adr_nr%type,
                             in_drucker_name in pe_drucker_cfg.drucker_name%type
                            )  is
    v_lhm_sid          lvs_lhm.sid%TYPE;
    v_lhm_firma_nr     lvs_lhm.firma_nr%TYPE;
    v_rave_datei       pe_jobs.rave_datei%TYPE;
    v_rave_report_name pe_jobs.rave_report_name%TYPE;
    v_job_daten_typ    pe_jobs.job_daten_typ%TYPE;
    v_job_daten        pe_jobs.job_daten%TYPE;
    v_job_nr           pe_jobs.job_nr%TYPE;
    v_anzahl_drucke    pe_jobs.anzahl%type;
  begin
    LVS_LTE_GET_DRUCK_DATEN(in_lhm_id,
                            in_kunden_nr,
                            v_lhm_sid,
                            v_lhm_firma_nr,
                            v_rave_datei,
                            v_rave_report_name,
                            v_job_daten_typ,
                            v_job_daten,
                            v_anzahl_drucke);

    PRINT_ENGINE.INSERT_NEW_JOB(v_lhm_sid,
                                v_lhm_firma_nr,
                                v_rave_datei,
                                v_rave_report_name,
                                v_job_daten_typ,
                                v_job_daten,
                                in_drucker_name,
                                v_anzahl_drucke,
                                v_job_nr);

    update lvs_lhm l
       set l.lhm_eti_druck_status = 'D'
     where l.sid = v_lhm_sid
       and l.firma_nr = v_lhm_firma_nr
       and l.lhm_id = in_lhm_id;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end LVS_LHM_DRUCKEN;

/*******************************************************************************
 * procedure LVS_LTE_DRUCKEN(...)

 Druckt die übergebene Palette für den Übergebenen Kunden wenn dieser ein eigenes
        Etikettenlayout hat. Wenn der Kunde = NULL oder der Kunde kein eigenes
        Etikettenlayout hat dann Etikettenlayout aus dem Firmenstamm verwenden
 commit;
 *******************************************************************************/
  procedure c_lvs_lhm_drucken (in_lhm_id       in lvs_lte.lte_id%type,
                               in_kunden_nr    in isi_adressen.adr_nr%type,
                               in_drucker_name in pe_drucker_cfg.drucker_name%type
                              )  is
  begin
    lvs_lhm_drucken (in_lhm_id,

                     in_kunden_nr,
                     in_drucker_name
                    );
    commit;
  end;

  -------------------------------------------------------------------------
  Function get_barcode_lfdn(in_sid        in lvs_charge.sid%type,
                            in_format     in varchar2,
                            in_barcode    in varchar)
                            return number is
    v_start_pos       number;
    v_lfdn_str        lvs_lte.lte_id%type;
    v_lfdn            number;
  begin
    v_lfdn := 0;
    v_start_pos := nvl(INSTR(in_format, '_', 1, 1), 1);
    if v_start_pos != 0
    then
      v_lfdn_str := substr(in_barcode, v_start_pos, 1);
      loop
        v_start_pos := v_start_pos + 1;
        exit when v_start_pos > length(in_barcode)
               or v_start_pos > length(in_format)
               or substr(in_format, v_start_pos, 1) != '_';
        v_lfdn_str := v_lfdn_str || substr(in_barcode, v_start_pos, 1);
      end loop;
      begin
        v_lfdn := to_number(v_lfdn_str);
      exception
        when others then NULL;
      end;
    end if;
    return (v_lfdn);
  end;

  -------------------------------------------------------------------------
  -- AG 03.03.2017 Multiuserfaehig machen auch bei schnell-Drehenden Daten
  Function get_datum_lid(in_key        in lvs_lte_datum_lid.lte_barcode_key%type)
                            return number is

   v_lid                    lvs_lte_datum_lid.lte_lid%type;
     cursor c_lte_datum_lid is
      select t.lte_lid
        from lvs_lte_datum_lid t
       where t.lte_barcode_key = in_key
         for update of t.lte_lid; -- AG 03.03.2017 Multiuserfaehig machen auch bei schnell-Drehenden Daten
    pragma autonomous_transaction;
  begin
    v_lid := NULL;
    open c_lte_datum_lid;
    fetch c_lte_datum_lid into v_lid;
    close c_lte_datum_lid;

    if v_lid is NULL
    then
      begin
        v_lid := 1;
        insert into lvs_lte_datum_lid t
          values (in_key,
                  v_lid + 1);
      exception
        when DUP_VAL_ON_INDEX then NULL;
      end;
    else
      update lvs_lte_datum_lid t
        set t.lte_lid = v_lid + 1
      where t.lte_barcode_key = in_key
        and t.lte_lid < v_lid + 1;
    end if;
    commit;
    return (v_lid);
  end;

  -------------------------------------------------------------------------
  function FORMAT_BARCODE(in_sid        in lvs_charge.sid%type,
                          in_format     in varchar2,
                          in_nummer     in number,
                          in_laenge     in number,
                          in_seq_basis  in varchar2,
                          in_charge     in lvs_charge.charge_bez%type,
                          in_artikel_id in isi_artikel.artikel_id%type,
                          in_basis_id   in varchar2,
                          in_menge      in number,
                          in_typ        in varchar2,
                          in_h_tag      in isi_hersteller.tag%type)
                          return varchar2 is
    v_barcode_lfdnkey varchar2(255);
    v_barcode_begin   varchar2(255);
    v_barcode_nr      varchar2(255);
    v_barcode_ende    varchar2(255);
    v_barcode_test    varchar2(255);
    v_barcode_spez    varchar2(255);
    v_return          varchar2(255);
    v_typ             varchar2(10);

    v_artikel             isi_artikel%rowtype;
    v_charge_bez          lvs_lte.lte_id%type;
    v_prod_datum_str      lvs_lte.lte_id%type;
    v_prod_datum_struktur lvs_lte.lte_id%type;
    v_menge_str           lvs_lte.lte_id%type;
    v_ean                 lvs_lte.lte_id%type;

    v_start_pos       number;
    v_ende_pos        number;
    v_laenge_nr       number;
    v_lid             number;
    v_mit_datum       boolean;
    v_mit_charge      boolean;
    v_mit_spez_barc   boolean;
    v_charge          lvs_charge%rowtype;

    cursor c_lte_datum_lid is
      select t.lte_lid
        from lvs_lte_datum_lid t
       where t.lte_barcode_key = v_barcode_test;
  BEGIN

    v_mit_spez_barc := FALSE;
    v_return    := '';
    v_start_pos := 1;
    v_ende_pos  := 1;
    v_ende_pos := nvl(INSTR(in_format, '_', v_start_pos, 1), 1);
    v_typ := in_typ;

    if INSTR(in_format, 'EAN', 1, 1) > 0
    or INSTR(in_format, 'MMM', 1, 1) > 0
    or INSTR(in_format, 'AAA', 1, 1) > 0
    or INSTR(in_format, 'TTT', 1, 1) > 0
    or INSTR(in_format, 'PY', 1, 1) > 0
    or INSTR(in_format, 'KW', 1, 1) > 0
    or INSTR(in_format, 'PDMMYY', 1, 1) > 0
    then
      v_mit_spez_barc := TRUE;
    end if;

    if INSTR(in_format, 'CCC', 1, 1) > 0
    then
      v_mit_spez_barc := TRUE;
      v_mit_charge := TRUE;
    end if;

    if v_mit_spez_barc
    then
      if not isi_p_base.get_isi_artikel(in_sid, in_artikel_id, v_artikel) -- Charge geht nur mit Artikel
      then
        v_mit_charge := False;
        v_artikel.artikel := '00000000000000000000';
        v_artikel.ean := '000000000000000';
      end if;
    end if;

    if in_laenge > nvl(length(in_format), 0)
    and not v_mit_spez_barc
    then
      v_barcode_begin := nvl(in_format, '');
      v_laenge_nr := in_laenge - nvl(length(in_format), 0);
      v_lid := in_nummer;
    else
      if v_mit_spez_barc
      and in_charge = 'KOMM'
      then
        v_mit_charge := NULL;
        v_lid := in_nummer;
        v_laenge_nr := in_laenge;
      else
        if (v_ende_pos > 0)
        or (v_start_pos > 0)
        then
          if (v_ende_pos > 0)
          then
            v_barcode_begin := '';
            if in_format is not null
            then
              v_barcode_begin := substr(nvl(in_format, ''),
                                        1,
                                        v_ende_pos - 1);
              if v_mit_spez_barc
              then
                v_barcode_spez := v_barcode_begin;
                isi_utils.spez_barcode_gen (v_artikel.artikel,      -- in_artikel              in  isi_artikel.artikel%type,
                                            in_charge,              -- in_charge               in  lvs_charge.charge_bez%type,
                                            in_menge,               -- in_menge                in  lvs_lam.menge%type,
                                            sysdate,                -- in_p_datum              in  lvs_lam.prod_datum%type,
                                            v_artikel.ean,          -- in_ean                  in  varchar2,
                                            v_typ,                  -- in_typ                  in  varchar2,
                                            in_h_tag,
                                            v_barcode_spez,
                                            v_barcode_begin);
              end if;
            end if;
            v_start_pos := v_ende_pos + 1;
            while ((nvl(INSTR(in_format, '_', v_start_pos, 1), 0) != 0)
                   and (v_start_pos <= in_laenge)) loop
              v_start_pos := v_start_pos + 1;
            end loop;

            v_barcode_ende := '';
          end if;
          if v_start_pos <= in_laenge
          then
            v_barcode_ende := substr(nvl(in_format, ''),
                                     v_start_pos,
                                     in_laenge - v_start_pos + 1);

            if v_mit_spez_barc
            then
              v_barcode_spez := v_barcode_ende;
              isi_utils.spez_barcode_gen (v_artikel.artikel,      -- in_artikel              in  isi_artikel.artikel%type,
                                          in_charge,              -- in_charge               in  lvs_charge.charge_bez%type,
                                          in_menge,               -- in_menge                in  lvs_lam.menge%type,
                                          sysdate,                -- in_p_datum              in  lvs_lam.prod_datum%type,
                                          v_artikel.ean,          -- in_ean                  in  varchar2,
                                          v_typ,                  -- in_typ                  in  varchar2,
                                          in_h_tag,
                                          v_barcode_spez,
                                          v_barcode_ende);
              if v_barcode_ende is NULL
              and v_barcode_spez is not NULL
              then
                v_barcode_ende := v_barcode_spez;
              end if;
            end if;

          end if;
          v_laenge_nr := in_laenge - nvl(length(v_barcode_begin), 0) - nvl(length(v_barcode_ende), 0);
        end if;
      end if;
    end if;

    v_mit_datum := false;
    if v_barcode_begin = 'DDMMYY'
    or v_barcode_begin = 'YYMMDD'
    or v_barcode_begin = 'MMYY'
    or v_barcode_begin = 'YYMM'
    or v_barcode_begin = 'YYYYMMDD'
    or v_barcode_begin = 'DDMMYYYY'
    then
      v_mit_datum := True;
      v_barcode_begin := to_char(sysdate, v_barcode_begin);
    end if;
    v_barcode_lfdnkey := NULL;
    if instr(in_format, 'PYKWD', 1, 1) > 0
    then
      v_barcode_lfdnkey := to_char(sysdate, 'YYYYMMDD');
    end if;
    if v_barcode_ende = 'DDMMYY'
    or v_barcode_ende = 'YYMMDD'
    or v_barcode_ende = 'MMYY'
    or v_barcode_ende = 'YYMM'
    or v_barcode_ende = 'YYYYMMDD'
    or v_barcode_ende = 'DDMMYYYY'
    then
      v_mit_datum := True;
      v_barcode_ende := to_char(sysdate, v_barcode_ende);
    end if;

    v_lid := in_nummer;

    if v_mit_charge
    then
      -- Bsp.:     AAAAAACCCCCC__MMMMmM
      if lvs_p_base.get_charge_bez(in_sid,                    -- in_sid        in lvs_charge.sid%type,
                                   in_charge,                 -- in_charge     in lvs_charge.charge_bez%type,
                                   in_artikel_id,             -- in_artikel_id in lvs_charge.artikel_id%type,
                                   v_charge)                  -- io_charge     in out lvs_charge%rowtype)
      then
        if in_basis_id is not null
        then
          if in_basis_id = c.BASIS_LTE
          then
            v_lid := v_charge.charge_lte_lfdn + 1;
            update lvs_charge t
               set t.charge_lte_lfdn = v_lid
             where t.charge_id = v_charge.charge_id;
          else
            v_lid := v_charge.charge_lhm_lfdn + 1;
            update lvs_charge t
               set t.charge_lhm_lfdn = v_lid
             where t.charge_id = v_charge.charge_id;
          end if;
        end if;
      else
        v_lid := nvl(v_lid, 1);
      end if;
    else
      if in_basis_id is not null
      and lvs_p_base.get_charge_bez(in_sid,                    -- in_sid        in lvs_charge.sid%type,
                                    in_charge,                 -- in_charge     in lvs_charge.charge_bez%type,
                                    in_artikel_id,             -- in_artikel_id in lvs_charge.artikel_id%type,
                                    v_charge)                  -- io_charge     in out lvs_charge%rowtype)
      then
        if in_basis_id = c.BASIS_LTE
        then
          update lvs_charge t
             set t.charge_lte_lfdn = t.charge_lte_lfdn + 1
           where t.charge_id = v_charge.charge_id;
        else
          update lvs_charge t
             set t.charge_lhm_lfdn = t.charge_lhm_lfdn + 1
           where t.charge_id = v_charge.charge_id;
        end if;
      end if;
    end if;
    if  v_mit_datum
    then
      v_barcode_test := v_barcode_begin || v_barcode_ende;
      v_lid := get_datum_lid(v_barcode_test);
    end if;
    if  v_barcode_lfdnkey is not NULL
    then
      v_barcode_test := v_barcode_lfdnkey;
      v_lid := get_datum_lid(v_barcode_test);
    end if;

    v_barcode_nr := lpad(to_char(v_lid), v_laenge_nr,'0');
    v_return := nvl(v_barcode_begin, '') || nvl(v_barcode_nr, '') || v_barcode_ende;
    if length(v_return) > in_laenge
    then
      raise_isi_error(10, LC.ec(LC.O_TXT_ID_LEANGENUEBERLAUF));
    end if;
    return(v_return);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LVS_C_LTE_ART_ERZ_EINLAG(...)   mit COMMIT
 * Artikelnummer und Charge werden übergeben, Der Transport wird eingetragen
 *******************************************************************************/
  procedure LVS_C_LTE_ART_ERZ_EINLAG (in_sid                 in isi_sid.sid%type,
                                      in_firma_nr            in isi_firma.firma_nr%type,
                                      in_lte_id              in lvs_lte.lte_id%type,
                                      in_artikel             in isi_artikel.artikel%type,
                                      in_menge_basis         in lvs_lam.menge_basis%type,
                                      in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                      in_charge              in lvs_charge.charge_bez%type,
                                      in_menge               in lvs_lam.menge%type,
                                      in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                      in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                      in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                      in_lte_name            in lvs_lte.lte_name%type,
                                      in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                      in_prod_datum          in lvs_lam.prod_datum%type,
                                      in_zug_datum           in lvs_lam.zug_datum%type,
                                      in_mhd                 in lvs_lam.lam_mhd%type,
                                      in_sep_nve             in lvs_lte.nve_nr%type,
                                      in_prod_nr             in lvs_lam.leitzahl%type,
                                      in_fa_ag               in lvs_lam.fa_ag%type,
                                      in_fa_upos             in lvs_lam.fa_upos%type,
                                      in_wa_status           in lvs_lam.labor_status%type,
                                      in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                      in_lgr_platz            in varchar2,
                                      in_fahrzeuge_IDs        in varchar2,
                                      in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                      in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                      in_prio                 in isi_transport.Prio%TYPE,
                                      in_progr_nr             in isi_transport.progr_nr%TYPE,
                                      in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                      in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                      in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                      in_aktuelle_position    in lvs_lam.lam_text%type,
                                      out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                      out_transport_id        out number,
                                      out_res_id              out isi_resource.res_id%type,
                                      in_login_id            in isi_user.login_id%type)
                                      is
    v_lte_hoehe           lvs_lte.lte_vol_hoehe%type;
    v_lte_breite          lvs_lte.lte_vol_breite%type;
    v_lte_tiefe           lvs_lte.lte_vol_tiefe%type;
    v_lte_name            lvs_lte.lte_name%type;
  begin

    if in_lte_hoehe != 0
    then
      v_lte_hoehe      := in_lte_hoehe;
    else
      v_lte_hoehe      := NULL;
    end if;

    if in_lte_breite != 0
    then
      v_lte_breite     := in_lte_breite;
    else
      v_lte_breite     := NULL;
    end if;

    if in_lte_tiefe != 0
    then
      v_lte_tiefe      := in_lte_tiefe;
    else
      v_lte_tiefe      := NULL;
    end if;

    if in_lte_name is NULL
    then
      v_lte_name       := c.Euro;  --// ToDo Nach Aenderung im Team
    else
      v_lte_name       := in_lte_name;
    end if;

    lvs_lte_artikel_erzeugen (in_sid,                    -- in_sid                 in isi_sid.sid%type,
                              in_firma_nr,               -- in_firma_nr            in isi_firma.firma_nr%type,
                              in_lte_id,                 -- in_lte_id              in lvs_lte.lte_id%type,
                              in_artikel,                -- in_artikel             in isi_artikel.artikel%type,
                              in_menge_basis,            -- in_menge_basis         in lvs_lam.menge_basis%type,
                              in_mengeneinheit_basis,    -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                              in_charge,                 -- in_charge              in lvs_charge.charge_bez%type,
                              in_menge,                  -- in_menge               in lvs_lam.menge%type,
                              v_lte_hoehe,               -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                              v_lte_breite,              -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                              v_lte_tiefe,               -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                              v_lte_name,                -- in_lte_name            in lvs_lte.lte_name%type,
                              in_lte_gew_kg,             -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                              in_prod_datum,             -- in_prod_datum          in lvs_lam.prod_datum%type,
                              in_zug_datum,              -- in_zug_datum           in lvs_lam.zug_datum%type,
                              in_mhd,                    -- in_mhd                 in lvs_lam.lam_mhd%type,
                              in_sep_nve,                -- in_sep_nve             in lvs_lte.nve_nr%type,
                              in_prod_nr,                -- in_prod_nr             in lvs_lam.leitzahl%type,
                              in_fa_ag,                  -- in_fa_ag               in lvs_lam.fa_ag%type,
                              in_fa_upos,                -- in_fa_upos             in lvs_lam.fa_upos%type,
                              in_wa_status,              -- in_wa_status           in lvs_lam.labor_status%type,
                              in_lief_auftragnr,         -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                              in_login_id,               -- in_login_id            in isi_user.login_id%type)
                              NULL);                     -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type

     lvs_einl.lvs_c_transp_einl_pruef_rid(in_lte_id,               -- in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                          in_lgr_platz,            -- in_lgr_platz            in varchar2,
                                          in_fahrzeuge_IDs,        -- in_fahrzeuge_IDs        in varchar2,
                                          in_modul_erzeuger,       -- in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                          in_modul_bearbeiter,     -- in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                          in_login_id,             -- in_login_id             in isi_user.login_id%TYPE,
                                          in_prio,                 -- in_prio                 in isi_transport.Prio%TYPE,
                                          in_progr_nr,             -- in_progr_nr             in isi_transport.progr_nr%TYPE,
                                          in_quelle_Leer_progr_nr, -- in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                          in_ziel_voll_Progr_nr,   -- in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                          in_lgr_platz_quelle,     -- in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                          in_aktuelle_position,    -- in_aktuelle_position    in lvs_lam.lam_text%type,
                                          out_lgr_platz,           -- out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                          out_transport_id,        -- out_transport_id        out number,
                                          out_res_id               -- out_res_id              out isi_resource.res_id%type
                                          );

    out_res_id := lvs_platz.v_fahrz_res_id;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LVS_C_LTE_ARTIKEL_ERZ_LGR_ORT(...)   mit COMMIT
 * Artikelnummer, Ziellagerort und Charge werden übergeben
 *******************************************************************************/
  procedure LVS_C_LTE_ARTIKEL_ERZ_LGR_ORT(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_lte_id              in lvs_lte.lte_id%type,
                                          in_artikel             in isi_artikel.artikel%type,
                                          in_menge_basis         in lvs_lam.menge_basis%type,
                                          in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                          in_charge              in lvs_charge.charge_bez%type,
                                          in_menge               in lvs_lam.menge%type,
                                          in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                          in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                          in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                          in_lte_name            in lvs_lte.lte_name%type,
                                          in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                          in_prod_datum          in lvs_lam.prod_datum%type,
                                          in_zug_datum           in lvs_lam.zug_datum%type,
                                          in_mhd                 in lvs_lam.lam_mhd%type,
                                          in_sep_nve             in lvs_lte.nve_nr%type,
                                          in_prod_nr             in lvs_lam.leitzahl%type,
                                          in_fa_ag               in lvs_lam.fa_ag%type,
                                          in_fa_upos             in lvs_lam.fa_upos%type,
                                          in_wa_status           in lvs_lam.labor_status%type,
                                          in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                          in_login_id            in isi_user.login_id%type,
                                          in_lgr_ort             in lvs_lgr_ort.lgr_ort%type)
                                          is
    v_lte_hoehe           lvs_lte.lte_vol_hoehe%type;
    v_lte_breite          lvs_lte.lte_vol_breite%type;
    v_lte_tiefe           lvs_lte.lte_vol_tiefe%type;
    v_lte_name            lvs_lte.lte_name%type;
    v_menge               number;
  begin
    begin
      v_menge := abs(in_menge);            -- Negative Mengen sind falsch
    exception
    -- Im Fehlerfall Menge übertragen
      when others then v_menge := in_menge;
    end;
    if in_lte_hoehe != 0
    then
      v_lte_hoehe      := in_lte_hoehe;
    else
      v_lte_hoehe      := NULL;
    end if;

    if in_lte_breite != 0
    then
      v_lte_breite     := in_lte_breite;
    else
      v_lte_breite     := NULL;
    end if;

    if in_lte_tiefe != 0
    then
      v_lte_tiefe      := in_lte_tiefe;
    else
      v_lte_tiefe      := NULL;
    end if;

    if in_lte_name is NULL
    or in_lte_name = ''
    then
      v_lte_name       := c.Euro;  --// ToDo Nach Aenderung im Team
    else
      v_lte_name       := in_lte_name;
    end if;

    LVS_LTE_ARTIKEL_ERZEUGEN_V3412(in_sid,         -- in_sid                 in isi_sid.sid%type,
                                   in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                                   in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                                   in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                                   in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                                   in_mengeneinheit_basis,
                                                   -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                   in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                                   v_menge,        -- in_menge               in lvs_lam.menge%type,
                                   v_lte_hoehe,    -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                   v_lte_breite,   -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                   v_lte_tiefe,    -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                   v_lte_name,     -- in_lte_name            in lvs_lte.lte_name%type,
                                   in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                   in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                                   in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                                   in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                                   in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                                   in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                                   in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                                   in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                                   in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                                   in_lief_auftragnr,
                                                   -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                    in_login_id,   -- in_login_id            in isi_user.login_id%type)
                                    in_lgr_ort,    -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                                    NULL);         -- in_lieferantennummer
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end LVS_C_LTE_ARTIKEL_ERZ_LGR_ORT;
/*******************************************************************************
 * procedure LVS_C_LTE_ARTIKEL_ERZEUGEN(...)   mit COMMIT
 * Artikelnummer und Charge werden übergeben
 *******************************************************************************/
  procedure LVS_C_LTE_ARTIKEL_ERZEUGEN (in_sid                 in isi_sid.sid%type,
                                        in_firma_nr            in isi_firma.firma_nr%type,
                                        in_lte_id              in lvs_lte.lte_id%type,
                                        in_artikel             in isi_artikel.artikel%type,
                                        in_menge_basis         in lvs_lam.menge_basis%type,
                                        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                        in_charge              in lvs_charge.charge_bez%type,
                                        in_menge               in lvs_lam.menge%type,
                                        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                        in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                        in_lte_name            in lvs_lte.lte_name%type,
                                        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                        in_prod_datum          in lvs_lam.prod_datum%type,
                                        in_zug_datum           in lvs_lam.zug_datum%type,
                                        in_mhd                 in lvs_lam.lam_mhd%type,
                                        in_sep_nve             in lvs_lte.nve_nr%type,
                                        in_prod_nr             in lvs_lam.leitzahl%type,
                                        in_fa_ag               in lvs_lam.fa_ag%type,
                                        in_fa_upos             in lvs_lam.fa_upos%type,
                                        in_wa_status           in lvs_lam.labor_status%type,
                                        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                        in_login_id            in isi_user.login_id%type)
                                        is
    v_lte_hoehe           lvs_lte.lte_vol_hoehe%type;
    v_lte_breite          lvs_lte.lte_vol_breite%type;
    v_lte_tiefe           lvs_lte.lte_vol_tiefe%type;
    v_lte_name            lvs_lte.lte_name%type;
  begin
    if in_lte_hoehe != 0
    then
      v_lte_hoehe      := in_lte_hoehe;
    else
      v_lte_hoehe      := NULL;
    end if;

    if in_lte_breite != 0
    then
      v_lte_breite     := in_lte_breite;
    else
      v_lte_breite     := NULL;
    end if;

    if in_lte_tiefe != 0
    then
      v_lte_tiefe      := in_lte_tiefe;
    else
      v_lte_tiefe      := NULL;
    end if;

    if in_lte_name is NULL
    or in_lte_name = ''
    then
      v_lte_name       := c.Euro;  --// ToDo Nach Aenderung im Team
    else
      v_lte_name       := in_lte_name;
    end if;

    lvs_lte_artikel_erzeugen_V3412(in_sid,         -- in_sid                 in isi_sid.sid%type,
                                   in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                                   in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                                   in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                                   in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                                   in_mengeneinheit_basis,
                                                   -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                   in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                                   in_menge,       -- in_menge               in lvs_lam.menge%type,
                                   v_lte_hoehe,    -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                   v_lte_breite,   -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                   v_lte_tiefe,    -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                   v_lte_name,     -- in_lte_name            in lvs_lte.lte_name%type,
                                   in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                   in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                                   in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                                   in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                                   in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                                   in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                                   in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                                   in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                                   in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                                   in_lief_auftragnr,
                                                   -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                    in_login_id,   -- in_login_id            in isi_user.login_id%type)
                                    NULL,          -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                                    NULL);         --                        in_lieferant_nr        in lvs_lam.lieferant_nr%type)

    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;
/*******************************************************************************
 * procedure LVS_LTE_ARTIKEL_ERZEUGEN(...)   ohne COMMIT
 * Artikelnummer und Charge werden übergeben
 *******************************************************************************/
  procedure LVS_LTE_ARTIKEL_ERZEUGEN (in_sid                 in isi_sid.sid%type,
                                      in_firma_nr            in isi_firma.firma_nr%type,
                                      in_lte_id              in lvs_lte.lte_id%type,
                                      in_artikel             in isi_artikel.artikel%type,
                                      in_menge_basis         in lvs_lam.menge_basis%type,
                                      in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                      in_charge              in lvs_charge.charge_bez%type,
                                      in_menge               in lvs_lam.menge%type,
                                      in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                      in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                      in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                      in_lte_name            in lvs_lte.lte_name%type,
                                      in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                      in_prod_datum          in lvs_lam.prod_datum%type,
                                      in_zug_datum           in lvs_lam.zug_datum%type,
                                      in_mhd                 in lvs_lam.lam_mhd%type,
                                      in_sep_nve             in lvs_lte.nve_nr%type,
                                      in_prod_nr             in lvs_lam.leitzahl%type,
                                      in_fa_ag               in lvs_lam.fa_ag%type,
                                      in_fa_upos             in lvs_lam.fa_upos%type,
                                      in_wa_status           in lvs_lam.labor_status%type,
                                      in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                      in_login_id            in isi_user.login_id%type,
                                      in_lgr_ort             in lvs_lgr_ort.lgr_ort%type)
                                      is
  begin
    lvs_lte_artikel_erzeugen_V3412(in_sid,         -- in_sid                 in isi_sid.sid%type,
                                   in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                                   in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                                   in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                                   in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                                   in_mengeneinheit_basis,
                                                   -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                   in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                                   in_menge,       -- in_menge               in lvs_lam.menge%type,
                                   in_lte_hoehe,   -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                   in_lte_breite,  -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                   in_lte_tiefe,   -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                   in_lte_name,    -- in_lte_name            in lvs_lte.lte_name%type,
                                   in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                   in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                                   in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                                   in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                                   in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                                   in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                                   in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                                   in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                                   in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                                   in_lief_auftragnr,
                                                   -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                    in_login_id,   -- in_login_id            in isi_user.login_id%type)
                                    NULL,          -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                                    NULL);         -- in_lieferant_nr        in lvs_lam.lieferant_nr%type)

  end;

/*******************************************************************************
 * procedure LVS_LTE_ARTIKEL_ERZEUGEN(...)   ohne COMMIT
 * Artikelnummer und Charge werden übergeben
 *******************************************************************************/
  procedure LVS_LTE_ARTIKEL_ERZEUGEN_V3412 (in_sid                 in isi_sid.sid%type,
                                            in_firma_nr            in isi_firma.firma_nr%type,
                                            in_lte_id              in lvs_lte.lte_id%type,
                                            in_artikel             in isi_artikel.artikel%type,
                                            in_menge_basis         in lvs_lam.menge_basis%type,
                                            in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                            in_charge              in lvs_charge.charge_bez%type,
                                            in_menge               in lvs_lam.menge%type,
                                            in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                            in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                            in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                            in_lte_name            in lvs_lte.lte_name%type,
                                            in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                            in_prod_datum          in lvs_lam.prod_datum%type,
                                            in_zug_datum           in lvs_lam.zug_datum%type,
                                            in_mhd                 in lvs_lam.lam_mhd%type,
                                            in_sep_nve             in lvs_lte.nve_nr%type,
                                            in_prod_nr             in lvs_lam.leitzahl%type,
                                            in_fa_ag               in lvs_lam.fa_ag%type,
                                            in_fa_upos             in lvs_lam.fa_upos%type,
                                            in_wa_status           in lvs_lam.labor_status%type,
                                            in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                            in_login_id            in isi_user.login_id%type,
                                            in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                            in_lieferant           in lvs_lam.lieferant_nr%type)
                                            is
begin
    lvs_lte_artikel_erz_V358(in_sid,         -- in_sid                 in isi_sid.sid%type,
                             in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                             in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                             in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                             in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                             in_mengeneinheit_basis,
                                             -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                             in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                             in_menge,       -- in_menge               in lvs_lam.menge%type,
                             in_lte_hoehe,   -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                             in_lte_breite,  -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                             in_lte_tiefe,   -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                             in_lte_name,    -- in_lte_name            in lvs_lte.lte_name%type,
                             null,           -- in_lhm_name            in lvs_lhm.lhm_name%type,
                             Null,           -- in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                             Null,           -- in_lhm_breite          in lvs_lhm.lte_vol_breite%type,
                             Null,           -- in_lhm_tiefe           in lvs_lhm.lte_vol_tiefe%type,
                             Null,           -- in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                             Null,           -- in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                             Null,           -- in_lhm_menge           in lvs_lam.menge%type,
                             in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                             in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                             in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                             in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                             in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                             in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                             in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                             in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                             in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                             in_lief_auftragnr,
                                             -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                             in_login_id,    -- in_login_id            in isi_user.login_id%type)
                             in_lgr_ort,     -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                             in_lieferant,   -- in_lieferant_nr        in lvs_lam.lieferant_nr%type)
                             Null,           -- in_auto_depal          in lvs_lte.auto_depal%type,
                             Null,           -- in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                             Null,           -- in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                             Null,           -- in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type
                             NULL,                       -- LAM_SEL1  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL2  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL3  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL4  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL5  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL6  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL7  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL8  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL,                       -- LAM_SEL9  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             NULL                       -- LAM_SEL10  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             );
end;

/*******************************************************************************
 * procedure LVS_LTE_ARTIKEL_ERZEUGEN(...)   ohne COMMIT
 * Artikelnummer und Charge werden übergeben
 *******************************************************************************/
  procedure LVS_C_LTE_ARTIKEL_ERZ_V358 (in_sid                 in isi_sid.sid%type,
                                        in_firma_nr            in isi_firma.firma_nr%type,
                                        in_lte_id              in lvs_lte.lte_id%type,
                                        in_artikel             in isi_artikel.artikel%type,
                                        in_menge_basis         in lvs_lam.menge_basis%type,
                                        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                        in_charge              in lvs_charge.charge_bez%type,
                                        in_menge               in lvs_lam.menge%type,
                                        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                        in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                        in_lte_name            in lvs_lte.lte_name%type,
                                        in_lhm_name            in lvs_lhm.lhm_name%type,
                                        in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                                        in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                                        in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                                        in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                                        in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                                        in_lhm_menge           in lvs_lam.menge%type,
                                        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                        in_prod_datum          in lvs_lam.prod_datum%type,
                                        in_zug_datum           in lvs_lam.zug_datum%type,
                                        in_mhd                 in lvs_lam.lam_mhd%type,
                                        in_sep_nve             in lvs_lte.nve_nr%type,
                                        in_prod_nr             in lvs_lam.leitzahl%type,
                                        in_fa_ag               in lvs_lam.fa_ag%type,
                                        in_fa_upos             in lvs_lam.fa_upos%type,
                                        in_wa_status           in lvs_lam.labor_status%type,
                                        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                        in_login_id            in isi_user.login_id%type,
                                        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                        in_lieferant           in lvs_lam.lieferant_nr%type,
                                        in_auto_depal          in lvs_lte.auto_depal%type,
                                        in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                                        in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                                        in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
                                        in_lam_sel1             in lvs_lam.lam_sel1%type,
                                        in_lam_sel2             in lvs_lam.lam_sel2%type,
                                        in_lam_sel3             in lvs_lam.lam_sel3%type,
                                        in_lam_sel4             in lvs_lam.lam_sel4%type,
                                        in_lam_sel5             in lvs_lam.lam_sel5%type,
                                        in_lam_sel6             in lvs_lam.lam_sel6%type,
                                        in_lam_sel7             in lvs_lam.lam_sel7%type,
                                        in_lam_sel8             in lvs_lam.lam_sel8%type,
                                        in_lam_sel9             in lvs_lam.lam_sel9%type,
                                        in_lam_sel10            in lvs_lam.lam_sel10%type
                                        )
                                        is
  begin
    lvs_lte_artikel_erz_V358(in_sid,         -- in_sid                 in isi_sid.sid%type,
                             in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                             in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                             in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                             in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                             in_mengeneinheit_basis,
                                             -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                             in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                             in_menge,       -- in_menge               in lvs_lam.menge%type,
                             in_lte_hoehe,   -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                             in_lte_breite,  -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                             in_lte_tiefe,   -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                             in_lte_name,    -- in_lte_name            in lvs_lte.lte_name%type,
                             in_lhm_name,    -- in_lhm_name            in lvs_lte.lhm_name%type,
                             in_lhm_hoehe,   -- in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                             in_lhm_breite,  -- in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                             in_lhm_tiefe,   -- in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                             in_lhm_lagen,   -- in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                             in_lhm_pro_lage,-- in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                             in_lhm_menge,   -- in_lhm_menge           in lvs_lam.menge%type,
                             in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                             in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                             in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                             in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                             in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                             in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                             in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                             in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                             in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                             in_lief_auftragnr,
                                             -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                             in_login_id,    -- in_login_id            in isi_user.login_id%type)
                             in_lgr_ort,     -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                             in_lieferant,   -- in_lieferant_nr        in lvs_lam.lieferant_nr%type)
                             in_auto_depal,  -- in_auto_depal          in lvs_lte.auto_depal%type,
                             in_packschema_kopf_id,   -- in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                             in_wickelprogramm,       -- in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                             in_wickelprogramm_einl,  -- in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type
                             in_lam_sel1,                       -- LAM_SEL1 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel2,                       -- LAM_SEL2 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel3,                       -- LAM_SEL3 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel4,                       -- LAM_SEL4 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel5,                       -- LAM_SEL5 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel6,                       -- LAM_SEL6 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel7,                       -- LAM_SEL7 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel8,                       -- LAM_SEL8 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel9,                       -- LAM_SEL9 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel10                      -- LAM_SEL10 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             );
    commit;
  end;
  procedure LVS_C_LTE_ARTIKEL_ERZ_V358_v2(in_sid                 in isi_sid.sid%type,
                                          in_firma_nr            in isi_firma.firma_nr%type,
                                          in_lte_id              in lvs_lte.lte_id%type,
                                          in_artikel             in isi_artikel.artikel%type,
                                          in_menge_basis         in lvs_lam.menge_basis%type,
                                          in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                          in_charge              in lvs_charge.charge_bez%type,
                                          in_menge               in lvs_lam.menge%type,
                                          in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                          in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                          in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                          in_lte_name            in lvs_lte.lte_name%type,
                                          in_lhm_name            in lvs_lhm.lhm_name%type,
                                          in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                                          in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                                          in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                                          in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                                          in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                                          in_lhm_menge           in lvs_lam.menge%type,
                                          in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                          in_prod_datum          in lvs_lam.prod_datum%type,
                                          in_zug_datum           in lvs_lam.zug_datum%type,
                                          in_mhd                 in lvs_lam.lam_mhd%type,
                                          in_sep_nve             in lvs_lte.nve_nr%type,
                                          in_prod_nr             in lvs_lam.leitzahl%type,
                                          in_fa_ag               in lvs_lam.fa_ag%type,
                                          in_fa_upos             in lvs_lam.fa_upos%type,
                                          in_wa_status           in lvs_lam.labor_status%type,
                                          in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                          in_login_id            in isi_user.login_id%type,
                                          in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                          in_lieferant           in lvs_lam.lieferant_nr%type,
                                          in_auto_depal          in lvs_lte.auto_depal%type,
                                          in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                                          in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                                          in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
                                          in_lam_sel1             in lvs_lam.lam_sel1%type,
                                          in_lam_sel2             in lvs_lam.lam_sel2%type,
                                          in_lam_sel3             in lvs_lam.lam_sel3%type,
                                          in_lam_sel4             in lvs_lam.lam_sel4%type,
                                          in_lam_sel5             in lvs_lam.lam_sel5%type,
                                          in_lam_sel6             in lvs_lam.lam_sel6%type,
                                          in_lam_sel7             in lvs_lam.lam_sel7%type,
                                          in_lam_sel8             in lvs_lam.lam_sel8%type,
                                          in_lam_sel9             in lvs_lam.lam_sel9%type,
                                          in_lam_sel10            in lvs_lam.lam_sel10%type,
                                          in_best_nr              in lvs_lam.best_nr%type,
                                          in_best_pos             in lvs_lam.best_pos%type,
                                          in_li_nr_lief           in lvs_lam.li_nr_lief%type
                                          )
                                          is
  begin
    lvs_lte_artikel_erz_V358_v2 (in_sid,         -- in_sid                 in isi_sid.sid%type,
                                 in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                                 in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                                 in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                                 in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                                 in_mengeneinheit_basis,
                                                 -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                 in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                                 in_menge,       -- in_menge               in lvs_lam.menge%type,
                                 in_lte_hoehe,   -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                 in_lte_breite,  -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                 in_lte_tiefe,   -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                 in_lte_name,    -- in_lte_name            in lvs_lte.lte_name%type,
                                 in_lhm_name,    -- in_lhm_name            in lvs_lte.lhm_name%type,
                                 in_lhm_hoehe,   -- in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                                 in_lhm_breite,  -- in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                                 in_lhm_tiefe,   -- in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                                 in_lhm_lagen,   -- in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                                 in_lhm_pro_lage,-- in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                                 in_lhm_menge,   -- in_lhm_menge           in lvs_lam.menge%type,
                                 in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                 in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                                 in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                                 in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                                 in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                                 in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                                 in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                                 in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                                 in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                                 in_lief_auftragnr,
                                                 -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                 in_login_id,    -- in_login_id            in isi_user.login_id%type)
                                 in_lgr_ort,     -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                                 in_lieferant,   -- in_lieferant_nr        in lvs_lam.lieferant_nr%type)
                                 in_auto_depal,  -- in_auto_depal          in lvs_lte.auto_depal%type,
                                 in_packschema_kopf_id,   -- in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                                 in_wickelprogramm,       -- in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                                 in_wickelprogramm_einl,  -- in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type
                                 in_lam_sel1,                       -- LAM_SEL1 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel2,                       -- LAM_SEL2 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel3,                       -- LAM_SEL3 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel4,                       -- LAM_SEL4 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel5,                       -- LAM_SEL5 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel6,                       -- LAM_SEL6 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel7,                       -- LAM_SEL7 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel8,                       -- LAM_SEL8 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel9,                       -- LAM_SEL9 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_lam_sel10,                      -- LAM_SEL10  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                 in_best_nr,
                                 in_best_pos,
                                 in_li_nr_lief);                    -- in lvs_lam.li_nr_lief%type
    commit;
  end;
  procedure LVS_LTE_ARTIKEL_ERZ_V358 (in_sid                 in isi_sid.sid%type,
                                      in_firma_nr            in isi_firma.firma_nr%type,
                                      in_lte_id              in lvs_lte.lte_id%type,
                                      in_artikel             in isi_artikel.artikel%type,
                                      in_menge_basis         in lvs_lam.menge_basis%type,
                                      in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                      in_charge              in lvs_charge.charge_bez%type,
                                      in_menge               in lvs_lam.menge%type,
                                      in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                      in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                      in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                      in_lte_name            in lvs_lte.lte_name%type,
                                      in_lhm_name            in lvs_lhm.lhm_name%type,
                                      in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                                      in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                                      in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                                      in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                                      in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                                      in_lhm_menge           in lvs_lam.menge%type,
                                      in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                      in_prod_datum          in lvs_lam.prod_datum%type,
                                      in_zug_datum           in lvs_lam.zug_datum%type,
                                      in_mhd                 in lvs_lam.lam_mhd%type,
                                      in_sep_nve             in lvs_lte.nve_nr%type,
                                      in_prod_nr             in lvs_lam.leitzahl%type,
                                      in_fa_ag               in lvs_lam.fa_ag%type,
                                      in_fa_upos             in lvs_lam.fa_upos%type,
                                      in_wa_status           in lvs_lam.labor_status%type,
                                      in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                      in_login_id            in isi_user.login_id%type,
                                      in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                      in_lieferant           in lvs_lam.lieferant_nr%type,
                                      in_auto_depal          in lvs_lte.auto_depal%type,
                                      in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                                      in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                                      in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
                                      in_lam_sel1             in lvs_lam.lam_sel1%type,
                                      in_lam_sel2             in lvs_lam.lam_sel2%type,
                                      in_lam_sel3             in lvs_lam.lam_sel3%type,
                                      in_lam_sel4             in lvs_lam.lam_sel4%type,
                                      in_lam_sel5             in lvs_lam.lam_sel5%type,
                                      in_lam_sel6             in lvs_lam.lam_sel6%type,
                                      in_lam_sel7             in lvs_lam.lam_sel7%type,
                                      in_lam_sel8             in lvs_lam.lam_sel8%type,
                                      in_lam_sel9             in lvs_lam.lam_sel9%type,
                                      in_lam_sel10            in lvs_lam.lam_sel10%type
                                      ) is
  begin
    lvs_lte_artikel_erz_V358_V2(in_sid,         -- in_sid                 in isi_sid.sid%type,
                               in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                               in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                               in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                               in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                               in_mengeneinheit_basis,
                                               -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                               in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                               in_menge,       -- in_menge               in lvs_lam.menge%type,
                               in_lte_hoehe,   -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                               in_lte_breite,  -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                               in_lte_tiefe,   -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                               in_lte_name,    -- in_lte_name            in lvs_lte.lte_name%type,
                               in_lhm_name,    -- in_lhm_name            in lvs_lte.lhm_name%type,
                               in_lhm_hoehe,   -- in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                               in_lhm_breite,  -- in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                               in_lhm_tiefe,   -- in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                               in_lhm_lagen,   -- in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                               in_lhm_pro_lage,-- in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                               in_lhm_menge,   -- in_lhm_menge           in lvs_lam.menge%type,
                               in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                               in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                               in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                               in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                               in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                               in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                               in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                               in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                               in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                               in_lief_auftragnr,
                                               -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                               in_login_id,    -- in_login_id            in isi_user.login_id%type)
                               in_lgr_ort,     -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                               in_lieferant,   -- in_lieferant_nr        in lvs_lam.lieferant_nr%type)
                               in_auto_depal,  -- in_auto_depal          in lvs_lte.auto_depal%type,
                               in_packschema_kopf_id,   -- in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                               in_wickelprogramm,       -- in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                               in_wickelprogramm_einl,  -- in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type
                               in_lam_sel1,                       -- LAM_SEL1 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel2,                       -- LAM_SEL2 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel3,                       -- LAM_SEL3 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel4,                       -- LAM_SEL4 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel5,                       -- LAM_SEL5 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel6,                       -- LAM_SEL6 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel7,                       -- LAM_SEL7 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel8,                       -- LAM_SEL8 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel9,                       -- LAM_SEL9 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               in_lam_sel10,                      -- LAM_SEL10  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                               NULL,
                               NULL,
                               NULL
                               );
  end;

  procedure LVS_LTE_ARTIKEL_ERZ_V358_v2(in_sid                 in isi_sid.sid%type,
                                        in_firma_nr            in isi_firma.firma_nr%type,
                                        in_lte_id              in lvs_lte.lte_id%type,
                                        in_artikel             in isi_artikel.artikel%type,
                                        in_menge_basis         in lvs_lam.menge_basis%type,
                                        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                        in_charge              in lvs_charge.charge_bez%type,
                                        in_menge               in lvs_lam.menge%type,
                                        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                        in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                        in_lte_name            in lvs_lte.lte_name%type,
                                        in_lhm_name            in lvs_lhm.lhm_name%type,
                                        in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                                        in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                                        in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                                        in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                                        in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                                        in_lhm_menge           in lvs_lam.menge%type,
                                        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                        in_prod_datum          in lvs_lam.prod_datum%type,
                                        in_zug_datum           in lvs_lam.zug_datum%type,
                                        in_mhd                 in lvs_lam.lam_mhd%type,
                                        in_sep_nve             in lvs_lte.nve_nr%type,
                                        in_prod_nr             in lvs_lam.leitzahl%type,
                                        in_fa_ag               in lvs_lam.fa_ag%type,
                                        in_fa_upos             in lvs_lam.fa_upos%type,
                                        in_wa_status           in lvs_lam.labor_status%type,
                                        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                        in_login_id            in isi_user.login_id%type,
                                        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                        in_lieferant           in lvs_lam.lieferant_nr%type,
                                        in_auto_depal          in lvs_lte.auto_depal%type,
                                        in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                                        in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                                        in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
                                        in_lam_sel1             in lvs_lam.lam_sel1%type,
                                        in_lam_sel2             in lvs_lam.lam_sel2%type,
                                        in_lam_sel3             in lvs_lam.lam_sel3%type,
                                        in_lam_sel4             in lvs_lam.lam_sel4%type,
                                        in_lam_sel5             in lvs_lam.lam_sel5%type,
                                        in_lam_sel6             in lvs_lam.lam_sel6%type,
                                        in_lam_sel7             in lvs_lam.lam_sel7%type,
                                        in_lam_sel8             in lvs_lam.lam_sel8%type,
                                        in_lam_sel9             in lvs_lam.lam_sel9%type,
                                        in_lam_sel10            in lvs_lam.lam_sel10%type,
                                        in_best_nr              in lvs_lam.best_nr%type,
                                        in_best_pos             in lvs_lam.best_pos%type,
                                        in_li_nr_lief           in lvs_lam.li_nr_lief%type
                                        ) is
  begin
    lvs_lte_artikel_erz_V359(in_sid,         -- in_sid                 in isi_sid.sid%type,
                             in_firma_nr,    -- in_firma_nr            in isi_firma.firma_nr%type,
                             in_lte_id,      -- in_lte_id              in lvs_lte.lte_id%type,
                             in_artikel,     -- in_artikel             in isi_artikel.artikel%type,
                             in_menge_basis, -- in_menge_basis         in lvs_lam.menge_basis%type,
                             in_mengeneinheit_basis,
                                             -- in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                             in_charge,      -- in_charge              in lvs_charge.charge_bez%type,
                             in_menge,       -- in_menge               in lvs_lam.menge%type,
                             in_lte_hoehe,   -- in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                             in_lte_breite,  -- in_lte_breite          in lvs_lte.lte_vol_breite%type,
                             in_lte_tiefe,   -- in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                             in_lte_name,    -- in_lte_name            in lvs_lte.lte_name%type,
                             in_lhm_name,    -- in_lhm_name            in lvs_lte.lhm_name%type,
                             in_lhm_hoehe,   -- in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                             in_lhm_breite,  -- in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                             in_lhm_tiefe,   -- in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                             in_lhm_lagen,   -- in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                             in_lhm_pro_lage,-- in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                             in_lhm_menge,   -- in_lhm_menge           in lvs_lam.menge%type,
                             in_lte_gew_kg,  -- in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                             in_prod_datum,  -- in_prod_datum          in lvs_lam.prod_datum%type,
                             in_zug_datum,   -- in_zug_datum           in lvs_lam.zug_datum%type,
                             in_mhd,         -- in_mhd                 in lvs_lam.lam_mhd%type,
                             in_sep_nve,     -- in_sep_nve             in lvs_lte.nve_nr%type,
                             in_prod_nr,     -- in_prod_nr             in lvs_lam.leitzahl%type,
                             in_fa_ag,       -- in_fa_ag               in lvs_lam.fa_ag%type,
                             in_fa_upos,     -- in_fa_upos             in lvs_lam.fa_upos%type,
                             in_wa_status,   -- in_wa_status           in lvs_lam.labor_status%type,
                             in_lief_auftragnr,
                                             -- in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                             in_login_id,    -- in_login_id            in isi_user.login_id%type)
                             in_lgr_ort,     -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
                             in_lieferant,   -- in_lieferant_nr        in lvs_lam.lieferant_nr%type)
                             in_auto_depal,  -- in_auto_depal          in lvs_lte.auto_depal%type,
                             in_packschema_kopf_id,   -- in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                             in_wickelprogramm,       -- in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                             in_wickelprogramm_einl,  -- in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type
                             in_lam_sel1,                       -- LAM_SEL1 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel2,                       -- LAM_SEL2 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel3,                       -- LAM_SEL3 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel4,                       -- LAM_SEL4 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel5,                       -- LAM_SEL5 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel6,                       -- LAM_SEL6 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel7,                       -- LAM_SEL7 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel8,                       -- LAM_SEL8 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel9,                       -- LAM_SEL9 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_lam_sel10,                      -- LAM_SEL10  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                             in_best_nr,                        -- in lvs_lam.best_nr%type,
                             in_best_pos,                       -- in lvs_lam.best_pos%type,
                             in_li_nr_lief,                     -- in lvs_lam.li_nr_lief%type
                             NULL                               -- in_hersteller_liste     in lvs_lam.hersteller_kuerzel_liste%type
                             );

  end;

  procedure LVS_LTE_ARTIKEL_ERZ_V359 (in_sid                 in isi_sid.sid%type,
                                      in_firma_nr            in isi_firma.firma_nr%type,
                                      in_lte_id              in lvs_lte.lte_id%type,
                                      in_artikel             in isi_artikel.artikel%type,
                                      in_menge_basis         in lvs_lam.menge_basis%type,
                                      in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
                                      in_charge              in lvs_charge.charge_bez%type,
                                      in_menge               in lvs_lam.menge%type,
                                      in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
                                      in_lte_breite          in lvs_lte.lte_vol_breite%type,
                                      in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
                                      in_lte_name            in lvs_lte.lte_name%type,
                                      in_lhm_name            in lvs_lhm.lhm_name%type,
                                      in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
                                      in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
                                      in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
                                      in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
                                      in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
                                      in_lhm_menge           in lvs_lam.menge%type,
                                      in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
                                      in_prod_datum          in lvs_lam.prod_datum%type,
                                      in_zug_datum           in lvs_lam.zug_datum%type,
                                      in_mhd                 in lvs_lam.lam_mhd%type,
                                      in_sep_nve             in lvs_lte.nve_nr%type,
                                      in_prod_nr             in lvs_lam.leitzahl%type,
                                      in_fa_ag               in lvs_lam.fa_ag%type,
                                      in_fa_upos             in lvs_lam.fa_upos%type,
                                      in_wa_status           in lvs_lam.labor_status%type,
                                      in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
                                      in_login_id            in isi_user.login_id%type,
                                      in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                      in_lieferant           in lvs_lam.lieferant_nr%type,
                                      in_auto_depal          in lvs_lte.auto_depal%type,
                                      in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
                                      in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                                      in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
                                      in_lam_sel1             in lvs_lam.lam_sel1%type,
                                      in_lam_sel2             in lvs_lam.lam_sel2%type,
                                      in_lam_sel3             in lvs_lam.lam_sel3%type,
                                      in_lam_sel4             in lvs_lam.lam_sel4%type,
                                      in_lam_sel5             in lvs_lam.lam_sel5%type,
                                      in_lam_sel6             in lvs_lam.lam_sel6%type,
                                      in_lam_sel7             in lvs_lam.lam_sel7%type,
                                      in_lam_sel8             in lvs_lam.lam_sel8%type,
                                      in_lam_sel9             in lvs_lam.lam_sel9%type,
                                      in_lam_sel10            in lvs_lam.lam_sel10%type,
                                      in_best_nr              in lvs_lam.best_nr%type,
                                      in_best_pos             in lvs_lam.best_pos%type,
                                      in_li_nr_lief           in lvs_lam.li_nr_lief%type,
                                      in_hersteller_liste     in lvs_lam.hersteller_kuerzel_liste%type
                                      ) is
    v_lte       lvs_lte%rowtype;
    v_artikel   isi_artikel%rowtype;
    v_bde_fa    bde_fa_auftrag%rowtype;
    v_found     boolean;
    v_lhm_id    lvs_lhm.lhm_id%type;
    v_charge_id lvs_charge.charge_id%type;
    v_menge     lvs_lam.menge%type;
    v_menge_ges lvs_lam.menge%type;
    -- -AG- 15.09.2008 Hier steht dann die lfdn fdes Kartons
    v_lhm_anz_ist number;
    v_lte_hoehe           lvs_lte.lte_vol_hoehe%type;
    v_lte_breite          lvs_lte.lte_vol_breite%type;
    v_lte_tiefe           lvs_lte.lte_vol_tiefe%type;

    CURSOR c_lte is
      select *
        from lvs_lte l
       where l.sid = in_sid
         and l.firma_nr = in_firma_nr
         and l.lte_id = in_lte_id;

    CURSOR c_artikel is
      select *
        from isi_artikel a
       where a.sid = sid
         and a.artikel = in_artikel;

    CURSOR c_artikel_0 is
      select *
        from isi_artikel a
       where a.sid = sid
         and a.artikel_id = 0;

  begin
    reset_isi_error();

    -- Init der Felder 0 nicht moeglich
    v_lte_hoehe  := in_lte_hoehe;
    v_lte_breite := in_lte_breite;
    v_lte_tiefe  := in_lte_tiefe;
    if v_lte_hoehe = 0
    then
      v_lte_hoehe := NULL;
    end if;
    if v_lte_breite = 0
    then
      v_lte_breite := NULL;
    end if;
    if v_lte_tiefe = 0
    then
      v_lte_tiefe := NULL;
    end if;

    v_lte.lte_id := NULL;                                    -- INIT keine LTE_ID
    v_lte.lte_status := c.LTE_KF_STAT;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if (v_lte.lte_akt_lhm = 0                                   -- LTE ist bereits bekannt aber leer, dann ausbuchen
    or  v_lte.waren_typ = c.LEERPAL)
    and v_lte.lgr_platz is not NULL
    then
      lvs_p_lte.LVS_KORR_TE_AUSBUCHEN(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, v_lte.lte_status,
                                      v_lte.sid, v_lte.firma_nr, v_lte.lgr_ort, v_lte.lgr_platz, in_login_id);
      v_lte.lgr_platz := NULL;
      v_lte.lte_status := c.LTE_KF_STAT;
    end if;

    if not v_found
    or v_lte.lte_status = c.LTE_PF_STAT
    or v_lte.lte_status = c.LTE_KF_STAT
    or v_lte.lte_status = c.LTE_AG_STAT
    or v_lte.waren_typ = c.LEERPAL
    or v_lte.lte_akt_lhm = 0
    then
      if v_found
      and v_lte.lgr_platz is NULL
      then
        -- -AG- 20150710 vor dem Anlegen erst mal alten Schrott löschen
        lvs_lte_delete(in_sid, v_lte.lte_id, in_login_id, v_lte.lte_status);
      end if;

      OPEN c_artikel;
      FETCH c_artikel into v_artikel;
      v_found := c_artikel%found;
      CLOSE c_artikel;
      if not v_found
      then
        OPEN c_artikel_0;
        FETCH c_artikel_0 into v_artikel;
        v_found := c_artikel_0%found;
        CLOSE c_artikel_0;
        if not v_found
        then
          raise_isi_error(c.FMID_Artikelnummer_Fehlt,
                          LC.ec_p1(LC.O_TP1_DEFAULT_U_ARTIKEL_FEHLT, to_char(in_artikel)));
        end if;
      end if;

      /*
      if in_lhm_lagen is not NULL
      and in_lhm_pro_lage is not NULL
      and in_lhm_menge != 0
      then
        if (in_lhm_lagen * in_lhm_pro_lage)
            != (in_menge / in_lhm_menge)
        then
          raise_isi_error(c.FMID_Zuggang_Buchen,
                          LC.ec(LC.O_TXT_MENGE_FEHLER));
        end if;
      end if;
      */

      v_charge_id := get_charge_id(in_sid,                     -- p_sid               in isi_sid.sid%type,
                                   in_firma_nr,                -- p_firma_nr
                                   NULL,                       -- p_lieferanten_id    in number,
                                   in_charge,                  -- p_charge            in lvs_charge.charge_bez%type,
                                   v_artikel.artikel_id);      -- p_artikel_id        in isi_artikel.artikel_id%type)

      if in_packschema_kopf_id is not NULL
      then
        v_bde_fa.packschema_kopf_id := in_packschema_kopf_id;
      else
        if not bde_p_base.get_fa_ag(in_sid, in_firma_nr, in_prod_nr, in_fa_ag, nvl(in_fa_upos, 0), v_bde_fa)
        then
          v_bde_fa.packschema_kopf_id := NULL;
        end if;
      end if;

      v_lte.lte_id := lvs_lte_insert_v358 (in_sid,                   -- SID
                                           in_firma_nr,              -- Firma
                                           nvl(in_lte_name,
                                               v_artikel.lte_name),  -- Palettemtype Bsp. 'EURO'
                                           in_lte_id,                -- ID der Transporteinheit
                                           in_login_id,              -- Login ID aktuelle User
                                           in_lgr_ort,               -- Lagerort
                                           NULL,                     -- Lagerplatz, NULL ist keiner
                                           C.LTE_PF_STAT,            -- Status Palletiert Fertig
                                           in_sep_nve,               -- Seperate NVE Nummer
                                           null,                     -- Druckstatus
                                           v_charge_id,              -- Charge ID
                                           in_charge,                -- Charge
                                           v_artikel.artikel_id,     -- Artikel ID
                                           v_bde_fa.packschema_kopf_id, -- packschema aus BDE-FA
                                           in_auto_depal,            -- Auto_Depal ist unbekannt
                                           in_wickelprogramm,        -- in lvs_lte.wickelprogramm%type,
                                           in_wickelprogramm_einl);  -- in lvs_lte.wickelprogramm_einl%type)

      v_menge := in_menge;
      v_menge_ges := 0;                  -- Noch nichts angelegt

      if in_lhm_menge = 0
      and in_auto_depal = c.C_TRUE
      then
        raise_isi_error(c.FMID_Zuggang_Buchen, LC.ec(LC.O_TXT_FEHLER_WARE_ANLEGEN_LTE));
      end if;

      while in_menge > v_menge_ges
      loop
        if in_lhm_menge = 0
        then
          v_menge := in_menge;
          v_menge_ges := in_menge;
        else
          if in_menge > in_lhm_menge
          then
            if v_menge_ges + in_lhm_menge > in_menge
            then
              v_menge := in_menge - v_menge_ges;
            else
              v_menge := in_lhm_menge;
            end if;
          end if;
        end if;
        v_menge_ges := v_menge_ges + v_menge;
        v_lhm_id := NULL;

        -- -AG- 15.09.2008 Naechsten Karton eintragen im FA
        v_lhm_anz_ist := NULL;
        update bde_fa_auftrag fa
           set fa.lhm_anz_ist = nvl(fa.lhm_anz_ist, 0) + 1
        where fa.sid = in_sid and
              fa.firma_nr = in_firma_nr and
              fa.leitzahl = in_prod_nr and
              fa.fa_ag    = in_fa_ag    and
              nvl(fa.fa_upos, 0)  = nvl(in_fa_upos, 0)
          returning fa.lhm_anz_ist into v_lhm_anz_ist;
        -- -AG- BugFix:  20.08.2009 Fehler beim Berechnen des MHD Datums
        if not lvs_einl.lvs_lam_zugang_owner_size
                                      (--in_sid, in_firma_nr,
                                       v_artikel.artikel_id, v_lte.lte_id, v_lhm_id,
                                       v_charge_id, null, in_prod_nr, in_fa_ag, in_fa_upos, NULL,
                                       in_best_nr, in_best_pos, NULL,
                                       nvl(in_prod_datum, sysdate), nvl(in_zug_datum, sysdate), in_login_id,
                                       v_menge, in_lhm_name, null, null,
                                       in_mhd,
                                       NULL, NULL, NULL,
                                       in_lieferant,
                                       in_li_nr_lief, NULL, NULL,
                                       in_menge_basis, in_mengeneinheit_basis, in_wa_status,
                                       NULL,     -- v_artikel.artikel_p1,
                                       NULL,     -- v_artikel.artikel_p2,
                                       NULL,     -- v_artikel.artikel_p3,
                                       NULL,     -- v_artikel.artikel_p4,
                                       NULL,     -- v_artikel.artikel_p5,
                                       NULL,     -- v_artikel.artikel_p6,
                                       NULL,     -- v_artikel.artikel_p7,
                                       NULL,     -- v_artikel.artikel_p8,
                                       NULL,     -- v_artikel.artikel_p9,
                                       NULL,     -- v_artikel.artikel_p10
                                       null,     -- ertmal kein Etikett erforderlich, da für ganze LTE nur 1 LHM
                                       null,
                                       null,
                                       v_lhm_id,
                                       null,
                                       null,
                                       null,
                                       nvl(v_lhm_anz_ist, 0),
                                       null,         -- in_owner_address_id     in lvs_lam.owner_address_id%type,
                                       in_lhm_hoehe, -- in_hoehe                in lvs_lhm.lhm_vol_hoehe%type,
                                       in_lhm_breite,-- in_breite               in lvs_lhm.lhm_vol_breite%type,
                                       in_lhm_tiefe, -- in_tiefe                in lvs_lhm.lhm_vol_tiefe%type
                                       in_lam_sel1,                       -- LAM_SEL1 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel2,                       -- LAM_SEL2 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel3,                       -- LAM_SEL3 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel4,                       -- LAM_SEL4 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel5,                       -- LAM_SEL5 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel6,                       -- LAM_SEL6 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel7,                       -- LAM_SEL7 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel8,                       -- LAM_SEL8 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel9,                       -- LAM_SEL9 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_lam_sel10,                      -- LAM_SEL10  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                       in_hersteller_liste                -- in lvs_lam.hersteller_kuerzel_liste%type
                                       )
                                             > 0 -- -AG- Hier bleibt die Nummer immer 0, da hier nicht das modul BDE greift
        then
          raise_isi_error(c.FMID_Zuggang_Buchen, LC.ec(LC.O_TXT_FEHLER_WARE_ANLEGEN_LTE));
        end if;
      end loop;
    elsif v_lte.lte_status != c.LTE_PF_STAT
      and v_lte.lte_status != c.LTE_KF_STAT
    then
      raise_isi_error(c.FMID_LTE_ID_SCHON_VORHANDEN, LC.ec(LC.O_TXT_LTE_ID_SCHON_VORHANDEN));
    end if;

    if v_lte.lte_status = c.LTE_PF_STAT
    or v_lte.lte_status = c.LTE_KF_STAT
    or v_lte.lte_status = c.LTE_AF_STAT
    or v_lte.lte_status = c.LTE_AG_STAT -- AG 23.06.2014 Auch im Status AG überschreiben wenn Werte gesetzt
    then
      if v_artikel.lte_menge > in_menge  -- -AG- 2020.12.04 Funktion verbesser - Wenn die Menge nicht die Vollmenge der LTE ist, dann Anteil berechnen
      and v_artikel.lte_gewicht_kg > 0
      and in_menge > 0
      then
        v_artikel.lte_gewicht_kg := v_artikel.lte_gewicht_kg / v_artikel.lte_menge * in_menge;
      end if;
      update lvs_lte l
         set l.lte_vol_hoehe = nvl(v_lte_hoehe, l.lte_vol_hoehe),
             l.lte_vol_breite = nvl(v_lte_breite, l.lte_vol_breite),
             l.lte_vol_tiefe = nvl(v_lte_tiefe, l.lte_vol_tiefe),
             l.lte_vol = nvl(v_lte_tiefe, l.lte_vol_tiefe) * nvl(v_lte_hoehe, l.lte_vol_hoehe) * nvl(v_lte_breite, l.lte_vol_breite) / 1000000000,
             l.lte_akt_kg = nvl(in_lte_gew_kg, v_artikel.lte_gewicht_kg),
             l.auto_depal = auto_depal,
             l.lte_voll = decode(in_menge, v_artikel.lte_menge, 'V', 'A'),             -- -AG- 20190719 FIX Kennzeichen muss auf Voll gesetzt werden, wenn Palette voll
             l.wickelprogramm = in_wickelprogramm,
             l.wickelprogramm_einl = in_wickelprogramm_einl
       where l.sid = in_sid
         and l.firma_nr = in_firma_nr
         and l.lte_id = in_lte_id;
    end if;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LVS_C_LTE_DUMMY_ERZEUGEN(...)   COMMIT

 Erzeugen eine Palette über Liniendaten Tabelle: LVS_PROD_LINIE,
                                                 LVS_PROD_LINIE WAREN
 *******************************************************************************/

  procedure LVS_C_LTE_DUMMY_ERZEUGEN (in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_lte_id      in lvs_lte.lte_id%type,
                                      in_lte_hoehe   in lvs_lte.lte_vol_hoehe%type,
                                      in_lte_breite  in lvs_lte.lte_vol_breite%type,
                                      in_lte_tiefe   in lvs_lte.lte_vol_tiefe%type,
                                      in_lte_name    in lvs_lte.lte_name%type,
                                      in_lte_gew_kg  in lvs_lte.lte_akt_kg%type,
                                      in_login_id    in isi_user.login_id%type,
                                      in_sep_nve     in lvs_lte.nve_nr%type)
                                      is
    v_lte       lvs_lte%rowtype;
    v_artikel   isi_artikel%rowtype;
    v_found     boolean;
    v_lhm_id    lvs_lhm.lhm_id%type;

    v_maske     varchar2(100);
    v_art_id    isi_artikel.artikel_id%type;

    CURSOR c_lte is
      select *
        from lvs_lte l
       where l.sid = in_sid
         and l.firma_nr = in_firma_nr
         and l.lte_id = in_lte_id;

    CURSOR c_artikel is
      select *
        from isi_artikel a
       where a.sid = sid
         and a.artikel_id = v_art_id;
    -------------------------------------------------------------------------------------------------------
  begin
    v_lte.lte_id := NULL;                                    -- INIT keine LTE_ID
    v_lte.lte_status := c.LTE_PF_STAT;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found
    or v_lte.lte_status = c.LTE_AG_STAT
    or v_lte.waren_typ = c.LEERPAL
    or v_lte.lte_akt_lhm = 0
    then

      v_art_id := 0;

      OPEN c_artikel;
      FETCH c_artikel into v_artikel;
      v_found := c_artikel%found;
      CLOSE c_artikel;
      if not v_found
      then
        raise_isi_error(20, LC.ec(LC.O_TXT_DEFAULT_ARTIKEL_FEHLT));
      end if;

      v_lte.lte_id := lvs_lte_insert_v358 (in_sid,                   -- SID
                                           in_firma_nr,              -- Firma
                                           in_lte_name,              -- Palettemtype Bsp. 'EURO'
                                           in_lte_id,                -- ID der Transporteinheit
                                           in_login_id,              -- Login ID aktuelle User
                                           NULL,                     -- Lagerort
                                           NULL,                     -- Lagerplatz, NULL ist keiner
                                           C.LTE_PF_STAT,            -- Status Palletiert Fertig
                                           in_sep_nve,
                                           null,
                                           null,
                                           null,
                                           null,
                                           NULL,
                                           NULL,                     -- Auto Depal ist unbekannt
                                           NULL,                     -- in_wickelprogramm      in lvs_lte.wickelprogramm%type,
                                           NULL);                    -- in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type)


      v_lhm_id := NULL;

      v_maske := isi_allg.c_get_firma_cfg_param (in_sid,
                                                 in_firma_nr,
                                                 'LTE_GET_DUMMY_ART',   -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                 NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                 'LVS_LTE_MASKE',       -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                 'DB',                  -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                 'CFG',
                                                 'Keine',               -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                 'STRING');             -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      if in_lte_id like v_maske                  -- Bsp Maske ist 115-9_________
      then
        v_art_id := isi_allg.c_get_firma_cfg_param (in_sid,
                                                    in_firma_nr,
                                                    'LTE_GET_DUMMY_ART',   -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                    NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                    'LVS_LTE_MASKE' || '_' ||
                                                    v_maske,               -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                    'DB',                  -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                    'CFG',
                                                    0,                     -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                    'INTEGER');            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
        OPEN c_artikel;
        FETCH c_artikel into v_artikel;
        v_found := c_artikel%found;
        CLOSE c_artikel;
        if not v_found
        then
          v_art_id := 0;
          OPEN c_artikel;
          FETCH c_artikel into v_artikel;
          v_found := c_artikel%found;
          CLOSE c_artikel;
        end if;

      end if;

      -- -AG- BugFix:  20.08.2009 Fehler beim Berechnen des MHD Datums
      if not lvs_einl.lvs_lam_zugang(in_sid, in_firma_nr, 0, in_lte_id, v_lhm_id,
                                     0, null, NULL, NULL, NULL, NULL,
                                     NULL, NULL, NULL,
                                     sysdate, sysdate, in_login_id,
                                     v_artikel.lte_menge, null, null, null, NULL,
                                     NULL, NULL, NULL,
                                     NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                                     NULL,     -- v_artikel.artikel_p1,
                                     NULL,     -- v_artikel.artikel_p2,
                                     NULL,     -- v_artikel.artikel_p3,
                                     NULL,     -- v_artikel.artikel_p4,
                                     NULL,     -- v_artikel.artikel_p5,
                                     NULL,     -- v_artikel.artikel_p6,
                                     NULL,     -- v_artikel.artikel_p7,
                                     NULL,     -- v_artikel.artikel_p8,
                                     NULL,     -- v_artikel.artikel_p9,
                                     NULL,     -- v_artikel.artikel_p10
                                     null,      -- ertmal kein Etikett erforderlich, da für ganze LTE nur 1 LHM
                                     null,
                                     null,
                                     v_lhm_id,      -- FAE ID nicht bekannt
                                     null,
                                     null,
                                     null,
                                     0)             -- -AG- Hier bleibt die Nummer immer 0, da hier nicht das modul BDE greift
                                            > 0
      then
        raise_isi_error(30, LC.ec(LC.O_TXT_FEHLER_WARE_ANLEGEN_LTE));
      end if;
    elsif v_lte.lte_status != c.LTE_PF_STAT
      and v_lte.lte_status != c.LTE_KF_STAT
      and v_lte.lte_status != c.LTE_AF_STAT
    then
      raise_isi_error(c.FMID_LTE_ID_SCHON_VORHANDEN, LC.ec(LC.O_TXT_LTE_ID_SCHON_VORHANDEN));
    end if;

    if v_lte.lte_status = c.LTE_PF_STAT
    or v_lte.lte_status = c.LTE_KF_STAT
    or v_lte.lte_status = c.LTE_AF_STAT
    or v_lte.lte_status = c.LTE_AG_STAT
    or v_lte.waren_typ = c.LEERPAL
    then
      update lvs_lte l
         set l.lte_vol_hoehe = in_lte_hoehe,
             l.lte_vol_breite = in_lte_breite,
             l.lte_vol_tiefe = in_lte_tiefe,
             l.lte_vol = in_lte_tiefe * in_lte_hoehe * in_lte_breite / 1000000000,
             l.lte_name = in_lte_name,
             l.lte_akt_kg = nvl(in_lte_gew_kg, v_artikel.lte_gewicht_kg)
       where l.sid = in_sid
         and l.firma_nr = in_firma_nr
         and l.lte_id = in_lte_id;
    end if;
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end LVS_C_LTE_DUMMY_ERZEUGEN;

/*******************************************************************************
 * procedure LVS_C_LTE_ERZEUGEN(...)   COMMIT

 Erzeugen eine Palette über Liniendaten Tabelle: LVS_PROD_LINIE,
                                                 LVS_PROD_LINIE WAREN
 *******************************************************************************/

  function LVS_C_LTE_ERZEUGEN (in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_linie       in lvs_prod_linie.linie_nr%type,
                               in_lgr_platz   in lvs_lgr.lgr_platz_gruppe%type,
                               in_login_id    in isi_user.login_id%type)
                               return varchar2 is
    v_Result lvs_lte.lte_id%type;
  begin
    v_Result := LVS_LTE_ERZEUGEN (in_sid, in_firma_nr, in_linie, in_lgr_platz, in_login_id, NULL, NULL);
    commit;
    return(v_Result);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LVS_LTE_ERZEUGEN(...)

 Erzeugen eine Palette über Liniendaten Tabelle: LVS_PROD_LINIE,
                                                 LVS_PROD_LINIE WAREN
 HJG Neue Variante mit Übergabe der LTE und/oder der LHM_ID aus z.B. AVIS
 *******************************************************************************/

  function LVS_LTE_ERZEUGEN (in_sid         in isi_sid.sid%type,
                             in_firma_nr    in isi_firma.firma_nr%type,
                             in_linie       in lvs_prod_linie.linie_nr%type,
                             in_lgr_platz   in lvs_lgr.lgr_platz_gruppe%type,
                             in_login_id    in isi_user.login_id%type,
                             in_drucker_name in pe_drucker_cfg.drucker_name%type,
                             in_et_drucker_name in pe_drucker_cfg.drucker_name%type)
                             return varchar2 is
    v_Result lvs_lte.lte_id%type;

    v_prod_linie                   lvs_prod_linie%rowtype;        -- Daten der Linie
    v_prod_linie_waren             lvs_prod_linie_waren%rowtype;  -- Ware auf der LTE
    v_order_pos                    isi_order_pos%rowtype;         -- Satz in der ISI-Order
    v_artikel                      isi_artikel%rowtype;           -- Artikeldaten
    v_art_ctrl                     isi_artikel_ctrl%rowtype;
    v_hersteller                   isi_hersteller%rowtype;
    v_charge                       lvs_charge.charge_bez%type;

    -- -AG- 15.09.2008 Hier steht dann die lfdn fdes Kartons
    v_lhm_anz_ist                  number;


    v_lte_id                       lvs_lte.lte_id%type;           -- Neue LTE_ID
    v_charge_id                    lvs_charge.charge_id%type;     -- Charge_id dieser Charge
    v_lhm_id                       lvs_lhm.lhm_id%type;           -- LHM_ID der neuen Ware
    v_vor_lhm_id                   lvs_lhm.lhm_id%type;           -- LHM_ID der neuen Ware
    v_fa_akt                       bde_fa_auftrag%rowtype;        --  Lesen FA mit Leitzahl Aktuell
    v_menge_erzeugt                lvs_prod_linie_waren.menge%type;
    v_typ                          varchar2(10);

    v_found                        boolean;                       -- Daten gefunden ?

    v_lte_eti_druck_status         lvs_lte.lte_eti_druck_status%type;
    v_lhm_eti_druck_status         lvs_lhm.lhm_eti_druck_status%type;

    v_lte_status                   lvs_lte.lte_status%type;
    v_gleiche_menge                lvs_lam.menge%type;
    v_charge_lieferant             lvs_charge.lieferanten_id%type;
    v_kunden_nr                    isi_adressen.adr_nr%type;
    v_h_tag                        isi_hersteller.tag%type;
  -- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
  CURSOR c_bde_fa_auftrag IS
    SELECT *
      FROM bde_fa_auftrag fa_a
      WHERE fa_a.sid = in_sid and
            fa_a.firma_nr = in_firma_nr and
            fa_a.leitzahl = v_order_pos.leitzahl and
            fa_a.fa_ag    = v_order_pos.fa_ag    and
            nvl(fa_a.fa_upos, 0)  = nvl(v_order_pos.fa_upos, 0);

    CURSOR c_linie is
      select *
        from lvs_prod_linie l
       where l.sid = in_sid
         and l.firma_nr = in_firma_nr
         and l.linie_nr = in_linie;

    CURSOR c_linie_waren is
      select *
        from lvs_prod_linie_waren lw
       where lw.sid = in_sid
         and lw.firma_nr = in_firma_nr
         and lw.linie_nr = in_linie
       order by lw.waren_nr;

    CURSOR c_order_pos is
      select *
        from isi_order_pos pos
       where pos.sid = in_sid
         and pos.firma_nr = in_firma_nr
         and pos.vorgang_typ = decode(v_prod_linie_waren.owner_address_id,
                                      NULL, 'WEE',  -- BUS = WE-Konsi-Lager dann ist in der ISI-Order Typ BK und Vorg_typ 'WEK'
                                      'KWE')
         and pos.vorgang_id = v_prod_linie_waren.best_nr
         and pos.vorgang_pos = v_prod_linie_waren.best_pos;
  begin

    OPEN c_linie;                                        -- Liniendaten holen
    FETCH c_linie into v_prod_linie;
    v_found := c_linie%FOUND;                            -- Daten gefunden ?;
    CLOSE c_linie;

    if not v_found
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LVS_PROD_LINIE_FEHLT, to_char(in_linie)));
    end if;

    OPEN c_linie_waren;                                  -- Waren für Liniendaten holen
    LOOP
      FETCH c_linie_waren into v_prod_linie_waren;

      EXIT when c_linie_waren%NOTFOUND;
      EXIT when v_prod_linie_waren.artikel_id is not NULL;
      -- nach dieser Schleife ist der letzte Datensatz noch in v_prod_linie_waren
      -- Damit wird die erste LHM angelegt
    end LOOP;

    if v_prod_linie_waren.artikel_id is NULL
    then        -- Alles gelesen und ungültige Daten vorhanden!!!
      v_err_nr := 10;
      v_err_text := LC.ec(LC.O_TXT_LVS_PROD_L_WARE_UNGUELT);
    end if;
    v_found := c_linie_waren%FOUND;                      -- Daten gefunden ?;

    if not v_found
    then
      CLOSE c_linie_waren;
      raise_isi_error(20, LC.ec_p1(LC.O_TP1_LVS_PROD_L_WARE_LEER, to_char(in_linie)));
    end if;

    -- 20180210 Die Charge wir aus dem sufix und der eigentlichen Charge zusammengebaut
    v_charge := v_prod_linie_waren.charge_suffix || v_prod_linie_waren.charge;

    v_lte_status := c.lte_pf_stat;
    if in_lgr_platz is not null
    then
      v_lte_status := c.lte_bf_stat;
    end if;

    if  v_prod_linie_waren.hersteller_kuerzel_liste is not NULL
    and v_prod_linie_waren.hersteller_kuerzel_liste != ';'
    and isi_p_base.get_artikel_ctrl_typ(in_sid,
                                        v_prod_linie_waren.artikel_id,
                                        substr(v_prod_linie_waren.hersteller_kuerzel_liste, 1, length(v_prod_linie_waren.hersteller_kuerzel_liste) -1),
                                        v_art_ctrl)
    then
      v_typ := v_art_ctrl.prod_params;
    else
      v_typ := '0000000000';
    end if;
    if  v_prod_linie_waren.hersteller_kuerzel_liste is not NULL
    and v_prod_linie_waren.hersteller_kuerzel_liste != ';'
    and isi_p_base.get_hersteller(substr(v_prod_linie_waren.hersteller_kuerzel_liste, 1, length(v_prod_linie_waren.hersteller_kuerzel_liste) -1),
                                  v_hersteller)
    then
      v_h_tag := v_hersteller.tag;
    else
      v_h_tag := rpad('0', 20, '0');
    end if;

    if v_prod_linie_waren.lte_id is NULL
    then
      v_lte_id := null;
      v_kunden_nr := null;                                    -- INIT keine LTE_ID
      if isi_p_base.get_isi_artikel(in_sid,
                                    v_prod_linie_waren.artikel_id,
                                    v_artikel)
      then
        v_kunden_nr := v_artikel.artikel_fuer_kunde_etikett;
        -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
        v_lte_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 (in_sid, in_firma_nr, c.BASIS_LTE,
                                                       v_charge,
                                                       v_prod_linie_waren.artikel_id,
                                                       v_kunden_nr,
                                                       v_typ,
                                                       v_h_tag);

      end if;
    else
      v_lte_id := v_prod_linie_waren.lte_id;
    end if;

    begin
      v_charge_lieferant := v_prod_linie_waren.lieferant_nr;
    exception
      when others then
        v_charge_lieferant := NULL;
    end;

    v_charge_id := get_charge_id(in_sid, in_firma_nr, v_charge_lieferant, v_charge, v_prod_linie_waren.artikel_id);

    v_lte_id := lvs_lte_insert_v358 (in_sid,                   -- SID
                                     in_firma_nr,              -- Firma
                                     v_prod_linie.lte_name,    -- Palettemtype Bsp. 'EURO'
                                     v_lte_id,                 -- ID der Transporteinheit
                                     in_login_id,              -- Login ID aktuelle User
                                     v_prod_linie.linie_lagerort,
                                     in_lgr_platz,             -- Lagerplatz, NULL ist keiner
                                     v_lte_status,             -- Status Palletiert Fertig
                                     null,
                                     v_prod_linie.lte_eti_druck_status,-- Druckstatus
                                     v_charge_id,                      -- Charge ID
                                     v_charge,        -- Charge
                                     v_prod_linie_waren.artikel_id,    -- Artikel ID
                                     v_prod_linie.packschema_kopf_id,  -- Packschema
                                     v_prod_linie.auto_depal,          -- Auto Depal aus Liniendaten
                                     v_prod_linie.wickelprogramm,      -- Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll
                                     v_prod_linie.wickelprogramm_einl);-- Wickel Programm Nr. wie die LTE eingelagert werden soll

    if v_prod_linie.res_string is not null
    then
      update lvs_lte lte                                          -- Eintrag ist bereits vorhanden
         set lte.res_string_statisch = v_prod_linie.res_string
       where lte.sid = in_sid
         and lte.firma_nr = in_firma_nr
         and lte.lte_id = v_lte_id;
    end if;

    -- Initialisierung durch Werte aus LinieWaren
    v_order_pos.leitzahl := v_prod_linie_waren.leitzahl;
    v_order_pos.fa_ag := v_prod_linie_waren.fa_pos;
    v_order_pos.fa_upos := v_prod_linie_waren.fa_upos;

    if  v_prod_linie_waren.best_nr > 0
        and v_prod_linie_waren.best_pos > 0
    then
      -- Holen der Order-Daten
      OPEN c_order_pos;
      FETCH c_order_pos into v_order_pos;
      v_found := c_order_pos%FOUND;
      CLOSE c_order_pos;

      if v_found
      then
        update isi_order_pos pos
           set pos.status = 'R'
         where pos.sid = in_sid
           and pos.firma_nr = in_firma_nr
           and pos.vorgang_typ = decode(v_prod_linie_waren.owner_address_id,
                                      NULL, 'WEE',  -- BUS = WE-Konsi-Lager dann ist in der ISI-Order Typ BK und Vorg_typ 'WEK'
                                      'KWE')
           and pos.vorgang_id = v_prod_linie_waren.best_nr
           and pos.vorgang_pos = v_prod_linie_waren.best_pos
           and pos.status = 'N';
      end if;
      --------------------------------------------------------------------------------------------------------------------
      -- Holen der Auftragsdaten fuer ABNR und Artikel ID
      --------------------------------------------------------------------------------------------------------------------
      OPEN c_bde_fa_auftrag;
      FETCH c_bde_fa_auftrag INTO v_fa_akt;
      v_found := c_bde_fa_auftrag%FOUND;
      CLOSE c_bde_fa_auftrag;
      if v_found
      then
        if v_fa_akt.kenz_letzt_ag = 1
        then
          v_order_pos.fa_ag := NULL;
          v_order_pos.fa_upos := NULL;
        end if;
      else
        v_order_pos.fa_ag := NULL;
        v_order_pos.fa_upos := NULL;
      end if;
    end if;

    if v_prod_linie_waren.lhm_id is NULL -- -AG- 2017.07.24 ID wurde übergeben
    then
      if v_prod_linie_waren.menge_je_karton is not NULL
      then
        -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
        v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 (in_sid, in_firma_nr, c.BASIS_LHM,
                                                       v_charge,
                                                       v_prod_linie_waren.artikel_id,
                                                       v_kunden_nr,
                                                       v_typ,
                                                       v_h_tag);
        v_vor_lhm_id := v_lhm_id;
      else
        -- nur 1 LHM mit der Gesamtmenge
        v_prod_linie_waren.menge_je_karton := v_prod_linie_waren.menge_je_karton;
        v_lhm_id := NULL;
        v_vor_lhm_id := NULL;
      end if;
    else
      --v_prod_linie_waren.menge_je_karton := v_prod_linie_waren.menge;
      v_lhm_id := v_prod_linie_waren.lhm_id;   -- -AG- 2017.07.24 ID wurde übergeben
      v_vor_lhm_id := NULL;
    end if;

    v_lhm_eti_druck_status := v_prod_linie_waren.lhm_eti_druck_status;
    if v_prod_linie_waren.lhm_eti_druck_status = 'RM'
    then
      v_lhm_eti_druck_status := null;
    end if;

    -- Erste menge merken, um Restmengen-Etidruck bei mehreren Positionen zu unterscheiden
    v_prod_linie_waren.menge_je_karton := nvl(v_prod_linie_waren.menge_je_karton, v_prod_linie_waren.menge);
    v_gleiche_menge := v_prod_linie_waren.menge_je_karton;

    -- erste LHM anlegen
    -- -AG- 15.09.2008 Naechsten Karton eintragen im FA
    v_lhm_anz_ist := NULL;
    update bde_fa_auftrag fa
         set fa.lhm_anz_ist = nvl(fa.lhm_anz_ist, 0) + 1
    WHERE fa.sid = in_sid and
          fa.firma_nr = in_firma_nr and
          fa.leitzahl = v_prod_linie_waren.leitzahl and
          fa.fa_ag    = v_prod_linie_waren.fa_pos    and
          nvl(fa.fa_upos, 0)  = nvl(v_prod_linie_waren.fa_upos, 0)
        returning fa.lhm_anz_ist into v_lhm_anz_ist;
    if lvs_einl.lvs_lam_zugang_owner_size(v_prod_linie_waren.artikel_id, v_lte_id, v_lhm_id,
                               v_charge_id, null, v_order_pos.leitzahl, v_order_pos.fa_ag, v_order_pos.fa_upos, v_prod_linie_waren.auftragsnr,
                               v_prod_linie_waren.best_nr, v_prod_linie_waren.best_pos, v_prod_linie.res_id,
                               v_prod_linie_waren.produktionsdatum, sysdate, in_login_id,
                               v_prod_linie_waren.menge_je_karton,
                               v_prod_linie_waren.lhm_name,
                               v_prod_linie_waren.kunden_nr,
                               v_prod_linie_waren.kd_art_nr, v_prod_linie_waren.mhd,
                               v_prod_linie_waren.zeichnung, v_prod_linie_waren.zeichnung_index, null,
                               v_prod_linie_waren.lieferant_nr, v_prod_linie_waren.li_nr_lief,
                               v_prod_linie_waren.lte_id_lieferant, v_prod_linie_waren.sonst_id_lieferant,
                               null, null, v_prod_linie_waren.labor_status,
                               v_prod_linie_waren.lam_p1,v_prod_linie_waren.lam_p2,v_prod_linie_waren.lam_p3,
                               v_prod_linie_waren.lam_p4,v_prod_linie_waren.lam_p5,v_prod_linie_waren.lam_p6,
                               v_prod_linie_waren.lam_p7,v_prod_linie_waren.lam_p8,v_prod_linie_waren.lam_p9,
                               v_prod_linie_waren.lam_p10,
                               v_lhm_eti_druck_status,
                               v_prod_linie_waren.lam_text,
                               v_prod_linie_waren.labor_text,
                               v_lhm_id,
                               NULL,
                               null,
                               v_prod_linie_waren.qs_status,
                               nvl(v_lhm_anz_ist, 0),
                               v_prod_linie_waren.owner_address_id,
                               null, null, null,
                               v_prod_linie_waren.lam_sel1,
                               v_prod_linie_waren.lam_sel2,
                               v_prod_linie_waren.lam_sel3,
                               v_prod_linie_waren.lam_sel4,
                               v_prod_linie_waren.lam_sel5,
                               v_prod_linie_waren.lam_sel6,
                               v_prod_linie_waren.lam_sel7,
                               v_prod_linie_waren.lam_sel8,
                               v_prod_linie_waren.lam_sel9,
                               v_prod_linie_waren.lam_sel10,
                               v_prod_linie_waren.hersteller_kuerzel_liste) > 0 -- -AG- Hier bleibt die Nummer immer 0, da hier nicht das modul BDE greift
    then
      v_menge_erzeugt := nvl(v_prod_linie_waren.menge_je_karton, v_prod_linie_waren.menge);
      if v_vor_lhm_id is not NULL
      then
        if in_et_drucker_name is not NULL
        then
          lvs_lhm_drucken(v_lhm_id,                                -- in_lhm_id       in lvs_lte.lte_id%type,
                          NULL,                                    -- in_kunden_nr    in isi_adressen.adr_nr%type,
                          in_et_drucker_name);                        -- in_drucker_name in pe_drucker_cfg.drucker_name%type
        end if;

        -- ggf. weitere LHMs für aktuelle LTE anlegen
        LOOP
          EXIT when v_menge_erzeugt >= v_prod_linie_waren.menge;
          -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
          v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 (in_sid, in_firma_nr,
                                                         c.BASIS_LHM,
                                                         v_charge,
                                                         v_prod_linie_waren.artikel_id,
                                                         v_prod_linie_waren.kunden_nr,
                                                         v_typ,
                                                         v_h_tag);
          v_vor_lhm_id := v_lhm_id;

          if v_prod_linie_waren.menge_je_karton + v_menge_erzeugt > v_prod_linie_waren.menge
          then
            -- Restmenge?
            v_prod_linie_waren.menge_je_karton := v_prod_linie_waren.menge - v_menge_erzeugt;
            if v_prod_linie_waren.lhm_eti_druck_status = 'RM'
            then
               v_lhm_eti_druck_status := 'SD';
            end if;
          end if;

          update bde_fa_auftrag fa
            set fa.lhm_anz_ist = nvl(fa.lhm_anz_ist, 0) + 1
          WHERE fa.sid = in_sid and
                fa.firma_nr = in_firma_nr and
                fa.leitzahl = v_prod_linie_waren.leitzahl and
                fa.fa_ag    = v_prod_linie_waren.fa_pos    and
                nvl(fa.fa_upos, 0)  = nvl(v_prod_linie_waren.fa_upos, 0)
              returning fa.lhm_anz_ist into v_lhm_anz_ist;
          if lvs_einl.lvs_lam_zugang_owner_size(v_prod_linie_waren.artikel_id, v_lte_id, v_lhm_id,
                                     v_charge_id, null, v_order_pos.leitzahl, v_order_pos.fa_ag, v_order_pos.fa_upos, v_prod_linie_waren.auftragsnr,
                                     v_prod_linie_waren.best_nr, v_prod_linie_waren.best_pos, v_prod_linie.res_id,
                                     v_prod_linie_waren.produktionsdatum, sysdate, in_login_id,
                                     v_prod_linie_waren.menge_je_karton,
                                     v_prod_linie_waren.lhm_name,
                                     v_prod_linie_waren.kunden_nr,
                                     v_prod_linie_waren.kd_art_nr, v_prod_linie_waren.mhd,
                                     v_prod_linie_waren.zeichnung, v_prod_linie_waren.zeichnung_index, null,
                                     v_prod_linie_waren.lieferant_nr, v_prod_linie_waren.li_nr_lief,
                                     v_prod_linie_waren.lte_id_lieferant, v_prod_linie_waren.sonst_id_lieferant,
                                     null, null, v_prod_linie_waren.labor_status,
                                     v_prod_linie_waren.lam_p1,v_prod_linie_waren.lam_p2,v_prod_linie_waren.lam_p3,
                                     v_prod_linie_waren.lam_p4,v_prod_linie_waren.lam_p5,v_prod_linie_waren.lam_p6,
                                     v_prod_linie_waren.lam_p7,v_prod_linie_waren.lam_p8,v_prod_linie_waren.lam_p9,
                                     v_prod_linie_waren.lam_p10,
                                     v_lhm_eti_druck_status,
                                     v_prod_linie_waren.lam_text,
                                     v_prod_linie_waren.labor_text,
                                     v_lhm_id,
                                     NULL,
                                     null,
                                     v_prod_linie_waren.qs_status,
                                     nvl(v_lhm_anz_ist, 0),
                                     v_prod_linie_waren.owner_address_id,
                                     null, null, null,
                                     v_prod_linie_waren.lam_sel1,
                                     v_prod_linie_waren.lam_sel2,
                                     v_prod_linie_waren.lam_sel3,
                                     v_prod_linie_waren.lam_sel4,
                                     v_prod_linie_waren.lam_sel5,
                                     v_prod_linie_waren.lam_sel6,
                                     v_prod_linie_waren.lam_sel7,
                                     v_prod_linie_waren.lam_sel8,
                                     v_prod_linie_waren.lam_sel9,
                                     v_prod_linie_waren.lam_sel10,
                                     v_prod_linie_waren.hersteller_kuerzel_liste) > 0 -- -AG- Hier bleibt die Nummer immer 0, da hier nicht das modul BDE greift
                   then
            v_menge_erzeugt := v_menge_erzeugt + v_prod_linie_waren.menge_je_karton;
            if in_et_drucker_name is not NULL
            then
              LVS_LHM_DRUCKEN(v_lhm_id,                                -- in_lhm_id       in lvs_lte.lte_id%type,
                              NULL,                                    -- in_kunden_nr    in isi_adressen.adr_nr%type,
                              in_et_drucker_name);                        -- in_drucker_name in pe_drucker_cfg.drucker_name%type
            end if;
          end if;
        end loop;
      end if;

      -- weitere Positionen auf der LTE (laut prod_linie_waren)
      LOOP
        FETCH c_linie_waren into v_prod_linie_waren;

        EXIT when c_linie_waren%NOTFOUND;

        v_charge := v_prod_linie_waren.charge_suffix || v_prod_linie_waren.charge;

        v_lhm_eti_druck_status := v_prod_linie_waren.lhm_eti_druck_status;
        if v_prod_linie_waren.lhm_eti_druck_status = 'RM'
        then
          if v_gleiche_menge != v_prod_linie_waren.menge_je_karton
          then
            -- Unterschiedlich zum ersten Eintrag, also andere Menge
            v_lhm_eti_druck_status := 'SD';
          else
            v_lhm_eti_druck_status := null;
          end if;
        end if;

        if v_prod_linie_waren.artikel_id is not NULL
        then -- Wenn keine Artikel_ID eingetragen dann übergehen !!!
          v_charge_id := get_charge_id(in_sid, in_firma_nr, v_prod_linie_waren.lieferant_nr, v_charge, v_prod_linie_waren.artikel_id);
          v_lhm_id := null;
          v_vor_lhm_id := NULL;
          v_order_pos.leitzahl := v_prod_linie_waren.leitzahl;
          v_order_pos.fa_ag := v_prod_linie_waren.fa_pos;
          v_order_pos.fa_upos := v_prod_linie_waren.fa_upos;

          if  v_prod_linie_waren.best_nr > 0
          and v_prod_linie_waren.best_pos > 0
          then
            OPEN c_order_pos;
            FETCH c_order_pos into v_order_pos;
            CLOSE c_order_pos;
          end if;

          if v_prod_linie_waren.lhm_id is NULL  -- -AG- 2017.07.24 ID wurde übergeben
          then
            if v_prod_linie_waren.menge_je_karton is not NULL
            then
              -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
              v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35 (in_sid, in_firma_nr, c.BASIS_LHM,
                                                             v_charge,
                                                             v_prod_linie_waren.artikel_id,
                                                             v_kunden_nr,
                                                             v_typ,
                                                             v_h_tag);
              v_vor_lhm_id := v_lhm_id;
            else
              v_prod_linie_waren.menge_je_karton := v_prod_linie_waren.menge;
              v_lhm_id := NULL;
              v_vor_lhm_id := NULL;
            end if;
          else
              v_prod_linie_waren.menge_je_karton := v_prod_linie_waren.menge;
              v_lhm_id := v_prod_linie_waren.lhm_id;  -- -AG- 2017.07.24 ID wurde übergeben
              v_vor_lhm_id := NULL;
          end if;

          update bde_fa_auftrag fa
             set fa.lhm_anz_ist = nvl(fa.lhm_anz_ist, 0) + 1
          WHERE fa.sid = in_sid and
                fa.firma_nr = in_firma_nr and
                fa.leitzahl = v_prod_linie_waren.leitzahl and
                fa.fa_ag    = v_prod_linie_waren.fa_pos    and
                nvl(fa.fa_upos, 0)  = nvl(v_prod_linie_waren.fa_upos, 0)
              returning fa.lhm_anz_ist into v_lhm_anz_ist;
          if lvs_einl.lvs_lam_zugang_owner_size(v_prod_linie_waren.artikel_id, v_lte_id, v_lhm_id, v_charge_id,
                                     null, v_order_pos.leitzahl, v_order_pos.fa_ag, v_order_pos.fa_upos,
                                     v_prod_linie_waren.auftragsnr,
                                     v_prod_linie_waren.best_nr, v_prod_linie_waren.best_pos, v_prod_linie.res_id,
                                     v_prod_linie_waren.produktionsdatum, sysdate, in_login_id,
                                     v_prod_linie_waren.menge_je_karton,
                                     v_prod_linie_waren.lhm_name,
                                     v_prod_linie_waren.kunden_nr,
                                     v_prod_linie_waren.kd_art_nr, v_prod_linie_waren.mhd,
                                     v_prod_linie_waren.zeichnung, v_prod_linie_waren.zeichnung_index, null,
                                     v_prod_linie_waren.lieferant_nr, v_prod_linie_waren.li_nr_lief,
                                     v_prod_linie_waren.lte_id_lieferant, v_prod_linie_waren.sonst_id_lieferant,
                                     null, null, v_prod_linie_waren.labor_status,
                                     v_prod_linie_waren.lam_p1,v_prod_linie_waren.lam_p2,v_prod_linie_waren.lam_p3,
                                     v_prod_linie_waren.lam_p4,v_prod_linie_waren.lam_p5,v_prod_linie_waren.lam_p6,
                                     v_prod_linie_waren.lam_p7,v_prod_linie_waren.lam_p8,v_prod_linie_waren.lam_p9,
                                     v_prod_linie_waren.lam_p10,
                                     v_lhm_eti_druck_status,
                                     v_prod_linie_waren.lam_text,
                                     v_prod_linie_waren.labor_text,
                                     v_lhm_id,
                                     null,
                                     null,
                                     v_prod_linie_waren.qs_status,
                                     v_lhm_anz_ist,
                                     v_prod_linie_waren.owner_address_id,
                                     null, null, null,
                                     v_prod_linie_waren.lam_sel1,
                                     v_prod_linie_waren.lam_sel2,
                                     v_prod_linie_waren.lam_sel3,
                                     v_prod_linie_waren.lam_sel4,
                                     v_prod_linie_waren.lam_sel5,
                                     v_prod_linie_waren.lam_sel6,
                                     v_prod_linie_waren.lam_sel7,
                                     v_prod_linie_waren.lam_sel8,
                                     v_prod_linie_waren.lam_sel9,
                                     v_prod_linie_waren.lam_sel10,
                                     v_prod_linie_waren.hersteller_kuerzel_liste) <= 0 -- -AG- 2010.01.13 BugFix
          then
            raise_isi_error(30, LC.ec(LC.O_TXT_FEHLER_WARE_ANLEGEN_LTE));
          else
            v_menge_erzeugt := nvl(v_prod_linie_waren.menge_je_karton, v_prod_linie_waren.menge);
            if v_vor_lhm_id is not NULL
            then
              if in_et_drucker_name is not NULL
              then
                LVS_LHM_DRUCKEN(v_lhm_id,                                -- in_lhm_id       in lvs_lte.lte_id%type,
                                NULL,                                    -- in_kunden_nr    in isi_adressen.adr_nr%type,
                                in_et_drucker_name);                        -- in_drucker_name in pe_drucker_cfg.drucker_name%type
              end if;
              LOOP
                EXIT when v_menge_erzeugt >= v_prod_linie_waren.menge;
                -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
                v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_V35 (in_sid, in_firma_nr, c.BASIS_LHM,
                                                               v_charge,
                                                               v_prod_linie_waren.artikel_id,
                                                               v_kunden_nr,
                                                               v_typ,
                                                               v_h_tag);
                v_vor_lhm_id := v_lhm_id;
                if v_prod_linie_waren.menge_je_karton + v_menge_erzeugt > v_prod_linie_waren.menge
                then
                  -- Restmenge?
                  v_prod_linie_waren.menge_je_karton := v_prod_linie_waren.menge - v_menge_erzeugt;
                  if v_prod_linie_waren.lhm_eti_druck_status = 'RM'
                  then
                     v_lhm_eti_druck_status := 'SD';
                  end if;
                end if;
                update bde_fa_auftrag fa
                  set fa.lhm_anz_ist = nvl(fa.lhm_anz_ist, 0) + 1
                WHERE fa.sid = in_sid and
                      fa.firma_nr = in_firma_nr and
                      fa.leitzahl = v_prod_linie_waren.leitzahl and
                      fa.fa_ag    = v_prod_linie_waren.fa_pos    and
                      nvl(fa.fa_upos, 0)  = nvl(v_prod_linie_waren.fa_upos, 0)
                    returning fa.lhm_anz_ist into v_lhm_anz_ist;
                if lvs_einl.lvs_lam_zugang_owner_size(v_prod_linie_waren.artikel_id, v_lte_id, v_lhm_id,
                                           v_charge_id, null, v_order_pos.leitzahl, v_order_pos.fa_ag, v_order_pos.fa_upos, v_prod_linie_waren.auftragsnr,
                                           v_prod_linie_waren.best_nr, v_prod_linie_waren.best_pos, v_prod_linie.res_id,
                                           v_prod_linie_waren.produktionsdatum, sysdate, in_login_id,
                                           v_prod_linie_waren.menge_je_karton,
                                           v_prod_linie_waren.lhm_name,
                                           v_prod_linie_waren.kunden_nr,
                                           v_prod_linie_waren.kd_art_nr, v_prod_linie_waren.mhd,
                                           v_prod_linie_waren.zeichnung, v_prod_linie_waren.zeichnung_index, null,
                                           v_prod_linie_waren.lieferant_nr, v_prod_linie_waren.li_nr_lief,
                                           v_prod_linie_waren.lte_id_lieferant, v_prod_linie_waren.sonst_id_lieferant,
                                           null, null, v_prod_linie_waren.labor_status,
                                           v_prod_linie_waren.lam_p1,v_prod_linie_waren.lam_p2,v_prod_linie_waren.lam_p3,
                                           v_prod_linie_waren.lam_p4,v_prod_linie_waren.lam_p5,v_prod_linie_waren.lam_p6,
                                           v_prod_linie_waren.lam_p7,v_prod_linie_waren.lam_p8,v_prod_linie_waren.lam_p9,
                                           v_prod_linie_waren.lam_p10,
                                           v_lhm_eti_druck_status,
                                           v_prod_linie_waren.lam_text,
                                           v_prod_linie_waren.labor_text,
                                           v_lhm_id,
                                           null,
                                           null,
                                           v_prod_linie_waren.qs_status,
                                           v_lhm_anz_ist,
                                           v_prod_linie_waren.owner_address_id,
                                           null, null, null,
                                           v_prod_linie_waren.lam_sel1,
                                           v_prod_linie_waren.lam_sel2,
                                           v_prod_linie_waren.lam_sel3,
                                           v_prod_linie_waren.lam_sel4,
                                           v_prod_linie_waren.lam_sel5,
                                           v_prod_linie_waren.lam_sel6,
                                           v_prod_linie_waren.lam_sel7,
                                           v_prod_linie_waren.lam_sel8,
                                           v_prod_linie_waren.lam_sel9,
                                           v_prod_linie_waren.lam_sel10,
                                           v_prod_linie_waren.hersteller_kuerzel_liste) > 0 -- -AG- Hier bleibt die Nummer immer 0, da hier nicht das modul BDE greift
                 then
                  v_menge_erzeugt := v_menge_erzeugt + v_prod_linie_waren.menge_je_karton;
                  if in_et_drucker_name is not NULL
                  then
                    LVS_LHM_DRUCKEN(v_lhm_id,                                -- in_lhm_id       in lvs_lte.lte_id%type,
                                    NULL,                                    -- in_kunden_nr    in isi_adressen.adr_nr%type,
                                    in_et_drucker_name);                        -- in_drucker_name in pe_drucker_cfg.drucker_name%type
                  end if;
                end if;
              end LOOP;
            end if;
          end if;
        end if;
      end LOOP;
    end if;

    CLOSE c_linie_waren;

    UPDATE lvs_lte
       SET lte_vol_hoehe  = v_prod_linie.lte_vol_hoehe,
           lte_vol_breite = v_prod_linie.lte_vol_breite,
           lte_vol_tiefe  = v_prod_linie.lte_vol_tiefe,
           lte_vol        = v_prod_linie.lte_vol_hoehe * v_prod_linie.lte_vol_breite *
                            v_prod_linie.lte_vol_tiefe / 1000000000
     WHERE lte_id = v_lte_id;

    v_result := v_lte_id;
    return(v_result);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_linie_waren%ISOPEN
      then
        CLOSE c_linie_waren;
      end if;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if c_linie_waren%ISOPEN
      then
        CLOSE c_linie_waren;
      end if;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LVS_C_LTE_INSERT(...)   COMMIT
 * (Kompatibilitaet zu ISIPlus 3.4 Aufrufen)
 * Erzeugen einer leeren Palette auf dem übergebenen Lagerplatz
 * wenn Lagerplatz = NULL dann ohne Lagerplatz
 *******************************************************************************/
  function lvs_c_lte_insert_v34(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_lte_name    in lvs_lhm_cfg.lhm_name%type,
                                in_lte_id      in lvs_lte.lte_id%type,
                                in_ls_login_id in isi_user.login_id%type,
                                in_lgr_ort     in lvs_lgr_ort.lgr_ort%type,
                                in_lgr_platz   in lvs_lgr.lgr_platz%type,
                                in_lte_status  in lvs_lte.lte_status%type,
                                in_sep_nve     in lvs_lte.nve_nr%type,
                                in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                                in_charge_id            in lvs_charge.charge_id%type,
                                in_charge               in lvs_charge.charge_bez%type,
                                in_artikel_id           in isi_artikel.artikel_id%type
                               ) return varchar2 is
  begin
    return lvs_c_lte_insert_v35(in_sid,
                                in_firma_nr,
                                in_lte_name,
                                in_lte_id,
                                in_ls_login_id,
                                in_lgr_ort,
                                in_lgr_platz,
                                in_lte_status,
                                in_sep_nve,
                                in_lte_eti_druck_status,
                                in_charge_id,
                                in_charge,
                                in_artikel_id,
                                null);                   --in_packschema_kopf_id

  end;

/*******************************************************************************
 * procedure LVS_C_LTE_INSERT(...)   COMMIT
 * (Kompatibilitaet zu ISIPlus 3.4 Aufrufen)
 * Erzeugen einer leeren Palette auf dem übergebenen Lagerplatz
 * wenn Lagerplatz = NULL dann ohne Lagerplatz
 *******************************************************************************/
  function lvs_c_lte_insert_v35(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_lte_name    in lvs_lhm_cfg.lhm_name%type,
                                in_lte_id      in lvs_lte.lte_id%type,
                                in_ls_login_id in isi_user.login_id%type,
                                in_lgr_ort     in lvs_lgr_ort.lgr_ort%type,
                                in_lgr_platz   in lvs_lgr.lgr_platz%type,
                                in_lte_status  in lvs_lte.lte_status%type,
                                in_sep_nve     in lvs_lte.nve_nr%type,
                                in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                                in_charge_id            in lvs_charge.charge_id%type,
                                in_charge               in lvs_charge.charge_bez%type,
                                in_artikel_id           in isi_artikel.artikel_id%type,
                                in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type
                               ) return varchar2 is
  begin
    return lvs_c_lte_insert_v358(in_sid,
                                 in_firma_nr,
                                 in_lte_name,
                                 in_lte_id,
                                 in_ls_login_id,
                                 in_lgr_ort,
                                 in_lgr_platz,
                                 in_lte_status,
                                 in_sep_nve,
                                 in_lte_eti_druck_status,
                                 in_charge_id,
                                 in_charge,
                                 in_artikel_id,
                                 in_packschema_kopf_id,   --in_packschema_kopf_id
                                 null,                    -- Auto Depal ist unbekannt
                                 null,                    -- wickelprogramm ist unbekannt,
                                 null);                   -- wickelprogramm_einl ist unbekannt

  end;

/*******************************************************************************
 * procedure LVS_C_LTE_INSERT(...)   COMMIT

 Erzeugen einer leeren Palette auf dem übergebenen Lagerplatz
          wenn Lagerplatz = NULL dann ohne Lagerplatz
 *******************************************************************************/
 function lvs_c_lte_insert_v358(in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_lte_name    in lvs_lhm_cfg.lhm_name%type,
                                in_lte_id      in lvs_lte.lte_id%type,
                                in_ls_login_id in isi_user.login_id%type,
                                in_lgr_ort     in lvs_lgr_ort.lgr_ort%type,
                                in_lgr_platz   in lvs_lgr.lgr_platz%type,
                                in_lte_status  in lvs_lte.lte_status%type,
                                in_sep_nve     in lvs_lte.nve_nr%type,
                                in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                                in_charge_id            in lvs_charge.charge_id%type,
                                in_charge               in lvs_charge.charge_bez%type,
                                in_artikel_id           in isi_artikel.artikel_id%type,
                                in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
                                in_auto_depal           in lvs_lte.auto_depal%type,
                                in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                                in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type
                               ) return varchar2 is

    v_lte_id    lvs_lte.lte_id%type;       -- ID des LTE
  begin
    v_lte_id := lvs_lte_insert_v358(in_sid, in_firma_nr, in_lte_name, in_lte_id,
                                    in_ls_login_id, in_lgr_ort, in_lgr_platz,
                                    in_lte_status,in_sep_nve, in_lte_eti_druck_status,
                                    in_charge_id, in_charge, in_artikel_id,
                                    in_packschema_kopf_id, in_auto_depal,
                                    in_wickelprogramm, in_wickelprogramm_einl);

    commit;
    return (v_lte_id);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end lvs_c_lte_insert_v358;


  function lvs_c_lte_insert_v359(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_lte_name    in lvs_lhm_cfg.lhm_name%type,
                               in_lte_id      in lvs_lte.lte_id%type,
                               in_ls_login_id in isi_user.login_id%type,
                               in_lgr_ort     in lvs_lgr_ort.lgr_ort%type,
                               in_lgr_platz   in lvs_lgr.lgr_platz%type,
                               in_lte_status  in lvs_lte.lte_status%type,
                               in_sep_nve     in lvs_lte.nve_nr%type,
                               in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                               in_charge_id            in lvs_charge.charge_id%type,
                               in_charge               in lvs_charge.charge_bez%type,
                               in_artikel_id           in isi_artikel.artikel_id%type,
                               in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
                               in_auto_depal           in lvs_lte.auto_depal%type,
                               in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                               in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type,
                               in_typ                  in varchar2,
                               in_h_tag                in isi_hersteller.tag%type
                               ) return varchar2 is

    v_lte_id    lvs_lte.lte_id%type;       -- ID des LTE
  begin
    v_lte_id := lvs_lte_insert_v359(in_sid, in_firma_nr, in_lte_name, in_lte_id,
                                    in_ls_login_id, in_lgr_ort, in_lgr_platz,
                                    in_lte_status,in_sep_nve, in_lte_eti_druck_status,
                                    in_charge_id, in_charge, in_artikel_id,
                                    in_packschema_kopf_id, in_auto_depal,
                                    in_wickelprogramm, in_wickelprogramm_einl,
                                    in_typ, in_h_tag);

    commit;
    return (v_lte_id);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end lvs_c_lte_insert_v359;

/*******************************************************************************
 * function LVS_LTE_INSERT(...)
 * (Kompatibilitaet zu ISIPlus 3.4 Aufrufen)
 * Erzeugen einer leeren Palette auf dem übergebenen Lagerplatz
 * wenn Lagerplatz = NULL dann ohne Lagerplatz
 *******************************************************************************/
  function lvs_lte_insert_v34 (in_sid                  in isi_sid.sid%type,
                               in_firma_nr             in isi_firma.firma_nr%type,
                               in_lte_name             in lvs_lhm_cfg.lhm_name%type,
                               in_lte_id               in lvs_lte.lte_id%type,
                               in_ls_login_id          in isi_user.login_id%type,
                               in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
                               in_lgr_platz            in lvs_lgr.lgr_platz%type,
                               in_lte_status           in lvs_lte.lte_status%type,
                               in_sep_nve              in lvs_lte.nve_nr%type,
                               in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                               in_charge_id            in lvs_charge.charge_id%type,
                               in_charge               in lvs_charge.charge_bez%type,
                               in_artikel_id           in isi_artikel.artikel_id%type
                              ) return varchar2 is
  begin
    return lvs_lte_insert_v35(in_sid,
                              in_firma_nr,
                              in_lte_name,
                              in_lte_id,
                              in_ls_login_id,
                              in_lgr_ort,
                              in_lgr_platz,
                              in_lte_status,
                              in_sep_nve,
                              in_lte_eti_druck_status,
                              in_charge_id,
                              in_charge,
                              in_artikel_id,
                              null);   --in_packschema_kopf_id
  end;

/*******************************************************************************
 * function LVS_LTE_INSERT(...)
 * (Kompatibilitaet zu ISIPlus 3.4 Aufrufen)
 * Erzeugen einer leeren Palette auf dem übergebenen Lagerplatz
 * wenn Lagerplatz = NULL dann ohne Lagerplatz
 *******************************************************************************/
  function lvs_lte_insert_v35 (in_sid                  in isi_sid.sid%type,
                               in_firma_nr             in isi_firma.firma_nr%type,
                               in_lte_name             in lvs_lhm_cfg.lhm_name%type,
                               in_lte_id               in lvs_lte.lte_id%type,
                               in_ls_login_id          in isi_user.login_id%type,
                               in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
                               in_lgr_platz            in lvs_lgr.lgr_platz%type,
                               in_lte_status           in lvs_lte.lte_status%type,
                               in_sep_nve              in lvs_lte.nve_nr%type,
                               in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                               in_charge_id            in lvs_charge.charge_id%type,
                               in_charge               in lvs_charge.charge_bez%type,
                               in_artikel_id           in isi_artikel.artikel_id%type,
                               in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type
                              ) return varchar2 is
  begin
    return lvs_lte_insert_v358(in_sid,
                               in_firma_nr,
                               in_lte_name,
                               in_lte_id,
                               in_ls_login_id,
                               in_lgr_ort,
                               in_lgr_platz,
                               in_lte_status,
                               in_sep_nve,
                               in_lte_eti_druck_status,
                               in_charge_id,
                               in_charge,
                               in_artikel_id,
                               in_packschema_kopf_id,     --in_packschema_kopf_id
                               'T',                       -- in_auto_depal           in lvs_lte.auto_depal%type,
                               0,                         -- in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                               0);                        -- in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type

  end;
/*******************************************************************************
 * function LVS_LTE_INSERT(...)

 Erzeugen einer leeren Palette auf dem übergebenen Lagerplatz
          wenn Lagerplatz = NULL dann ohne Lagerplatz
 *******************************************************************************/

  function lvs_lte_insert_v358(in_sid                  in isi_sid.sid%type,
                               in_firma_nr             in isi_firma.firma_nr%type,
                               in_lte_name             in lvs_lhm_cfg.lhm_name%type,
                               in_lte_id               in lvs_lte.lte_id%type,
                               in_ls_login_id          in isi_user.login_id%type,
                               in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
                               in_lgr_platz            in lvs_lgr.lgr_platz%type,
                               in_lte_status           in lvs_lte.lte_status%type,
                               in_sep_nve              in lvs_lte.nve_nr%type,
                               in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                               in_charge_id            in lvs_charge.charge_id%type,
                               in_charge               in lvs_charge.charge_bez%type,
                               in_artikel_id           in isi_artikel.artikel_id%type,
                               in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
                               in_auto_depal           in lvs_lte.auto_depal%type,
                               in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                               in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type
                              ) return varchar2 is
  begin
    return lvs_lte_insert_v359 (in_sid,                   -- SID
                                in_firma_nr,              -- Firma
                                in_lte_name,              -- Palettemtype Bsp. 'EURO'
                                in_lte_id,                -- ID der Transporteinheit
                                in_ls_login_id,           -- Login ID aktuelle User
                                in_lgr_ort,               -- Lagerort
                                in_lgr_platz,             -- Lagerplatz, NULL ist keiner
                                nvl(in_lte_status,
                                    C.LTE_PF_STAT),       -- Status Palletiert Fertig
                                in_sep_nve,               -- Seperate NVE Nummer
                                null,                     -- Druckstatus
                                in_charge_id,             -- Charge ID
                                in_charge,                -- Charge
                                in_artikel_id,            -- Artikel ID
                                in_packschema_kopf_id,    -- packschema aus BDE-FA
                                in_auto_depal,            -- Auto_Depal ist unbekannt
                                in_wickelprogramm,        -- in lvs_lte.wickelprogramm%type,
                                in_wickelprogramm_einl,   -- in lvs_lte.wickelprogramm_einl%type)
                                '0000000000',             -- Herstellertyp und TAG als Default 0000
                                '000');
  end;


  function lvs_lte_insert_v359(in_sid                  in isi_sid.sid%type,
                               in_firma_nr             in isi_firma.firma_nr%type,
                               in_lte_name             in lvs_lhm_cfg.lhm_name%type,
                               in_lte_id               in lvs_lte.lte_id%type,
                               in_ls_login_id          in isi_user.login_id%type,
                               in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
                               in_lgr_platz            in lvs_lgr.lgr_platz%type,
                               in_lte_status           in lvs_lte.lte_status%type,
                               in_sep_nve              in lvs_lte.nve_nr%type,
                               in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
                               in_charge_id            in lvs_charge.charge_id%type,
                               in_charge               in lvs_charge.charge_bez%type,
                               in_artikel_id           in isi_artikel.artikel_id%type,
                               in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
                               in_auto_depal           in lvs_lte.auto_depal%type,
                               in_wickelprogramm       in lvs_lte.wickelprogramm%type,
                               in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type,
                               in_typ                  in varchar2,
                               in_h_tag                in isi_hersteller.tag%type
                              ) return varchar2 is

    v_lte_cfg    lvs_lte_cfg%rowtype;       -- Configdaten der Palette
    v_lte        lvs_lte%rowtype;           -- Palettendaten
    v_lte_hist   lvs_lte%rowtype;           -- Palettendaten
    v_lgr        lvs_lgr%rowtype;           -- Lagerplatz
    v_lgr_v      lvs_lgr%rowtype;           -- Lagerplatz auf dem die LTE gewesen ist
    v_lgr_ort    lvs_lgr_ort.lgr_ort%type;
    v_firma      isi_firma%rowtype;
    v_sep_nve_nr number;
    v_sep_nve    varchar2(20);              -- NVE  ist immer 18 Stellen evtl mit 00 als Bezeichner



    v_lte_id    lvs_lte.lte_id%type;       -- ID des LTE
    v_lte_vol   number;                    -- Volumen in m3 für Transporteinheit
    v_lte_akt_kg number;
    v_lgr_platz lvs_lgr.lgr_platz%type;    -- Lagerplatz
    v_found     boolean;                   -- Gefunden (Cursor)
    v_barcode_id number;                   -- lfdn des Barcodes

    cursor c_lte is                        -- Lesen des Lagerhilfsmittel
      select *
      from lvs_lte lte
      where lte.lte_id = in_lte_id;

    cursor c_lte_hist is                        -- Lesen des Lagerhilfsmittel
      select *
      from lvs_lte lte
      where lte.lte_id = in_lte_id
        and lte.letzte_inventur_datum is not NULL
      order by lte.letzte_inventur_datum desc;

    cursor c_lte_cfg is                        -- Lesen des Lagerhilfsmittel Configuration
      select *
      from lvs_lte_cfg lte_cfg
      where lte_cfg.sid = in_sid and
            lte_cfg.firma_nr = in_firma_nr and
            lte_cfg.lte_name = in_lte_name;

    cursor c_lgr is                        -- Lesen des Lagerplatz
      select *
      from lvs_lgr lgr
      where lgr.lgr_platz = v_lgr_platz;

    cursor c_firma is                        -- Lesen Firmenstamm
      select *
      from isi_firma f
      where f.sid = in_sid
        and f.firma_nr = in_firma_nr;

  begin
    v_err_nr := NULL;
    v_err_text := NULL;

    v_lte_id := in_lte_id;                     -- Erst mal die Übergabe merken
    v_lgr_platz := in_lgr_platz;

    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;           -- Lesen der Config des neuen LTE
    v_found := c_lte_cfg%FOUND;
    CLOSE c_lte_cfg;

    if not v_found
    then
      raise_isi_error(c.FMID_PaletteTyp_Fehlt,  LC.ec_p1(LC.O_TP1_PALETTEN_TYP_FEHLT, to_char(nvl(in_lte_name, '????'))));
    end if;

    v_lgr_ort := in_lgr_ort;
    if v_lgr_platz is not NULL then
      OPEN c_lgr;                    --
      FETCH c_lgr into v_lgr;        -- Lesen den Eintrag des Lagerplatz
      v_found := c_lgr%FOUND;
      CLOSE c_lgr;

      if not v_found
      then
        raise_isi_error(c.FMID_Quelle_Existiert_Nicht, LC.ec_p2(LC.O_TP2_PLATZ_EXISTIERT_NICHT, v_lgr_platz, in_lte_id));
      else
        v_lgr_ort := v_lgr.lgr_ort;
        if v_lgr.akt_inventur_id is not null
        then     -- Fehler Lagerplatz ist in Inventur
          raise_isi_error(c.FMID_Lagerplatz_Gesperrt, LC.ec_p1(LC.O_TP1_LAGERPLATZ_IN_INVENTUR, v_lgr_platz));
        end if;
        if v_lgr.gesperrt <> C.LGR_GESPERRT_F
        then     -- Fehler Lagerplatz ist gesperrt
          raise_isi_error(c.FMID_Lagerplatz_Gesperrt, LC.ec_p2(LC.O_TP2_LAGERPLATZ_GESPERRT, v_lgr_platz, v_lgr.gesp_grund));
        end if;
      end if;
    end if;

    if v_lte_id is null
    then                   -- Keine Nummer Übergeben
      if nvl(v_lgr.lgr_verwendung, C.WE) <> C.WE
        and nvl(v_lgr.lgr_verwendung, C.WE) <> C.LGR_TYP_Puffer
      then     -- Fehler Lagerplatz ist kein WarenEingang
        raise_isi_error(c.FMID_Platz_kein_WE, LC.ec_p1(LC.O_TP1_PLATZ_KEIN_WE, v_lgr_platz));
      end if;
      -- Holen der neuen Nummer
      if v_lte_cfg.virtuell != 'L' -- Virtuell gleich nach Verarbeitung löschen
      then
        -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
        v_lte_id := lvs_lte_lhm_next_id_v35 (in_sid, in_firma_nr, C.BASIS_LTE,
                                             in_charge,
                                             in_artikel_id,
                                             NULL,
                                             in_typ,
                                             in_h_tag);
      else
        -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
        v_lte_id := lvs_lte_lhm_next_id_v35 (in_sid, in_firma_nr, C.BASIS_LTE_VL,
                                             in_charge,
                                             in_artikel_id,
                                             NULL,
                                             in_typ,
                                             in_h_tag);
      end if;
      OPEN c_firma;
      FETCH c_firma into v_firma;
      CLOSE c_firma;
      if v_firma.lte_barcode_type = c.LTE_BARCODE_SPEZ
      then
        isi_utils.spez_barcode_lfdn(in_sid,
                                    in_firma_nr,
                                    v_lte_id,
                                    c.BASIS_LTE,
                                    v_barcode_id);
        -- Z.Zt. Nur Charge 'CCC'
        update lvs_charge c
           set c.charge_lte_lfdn = nvl(v_barcode_id, nvl(c.charge_lte_lfdn, 0) + 1)
         where c.charge_id = in_charge_id
           and nvl(c.charge_lte_lfdn, 0) < nvl(v_barcode_id, nvl(c.charge_lte_lfdn, 0) + 1);
      end if;
    else
      OPEN c_firma;
      FETCH c_firma into v_firma;
      CLOSE c_firma;
      if v_firma.lte_barcode_type = c.LTE_BARCODE_SPEZ
      then
        isi_utils.spez_barcode_lfdn(in_sid,
                                    in_firma_nr,
                                    v_lte_id,
                                    c.BASIS_LTE,
                                    v_barcode_id);
        -- Z.Zt. Nur Charge 'CCC'
        update lvs_charge c
           set c.charge_lte_lfdn = nvl(v_barcode_id, nvl(c.charge_lte_lfdn, 0) + 1)
         where c.charge_id = in_charge_id
           and nvl(c.charge_lte_lfdn, 0) < nvl(v_barcode_id, nvl(c.charge_lte_lfdn, 0) + 1);
      end if;
    end if;

    OPEN c_lte;                    --
    FETCH c_lte into v_lte;        -- Lesen den Eintrag der Transporteinheit
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if v_lte.lte_akt_lhm = 0                                   -- LTE ist bereits bekannt aber leer, dann ausbuchen
    and v_lte.lgr_platz is not NULL                            -- Und ist auf einem Lagerplatz
    then
      lvs_p_lte.LVS_KORR_TE_AUSBUCHEN(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, v_lte.lte_status,
                                      v_lte.sid, v_lte.firma_nr, v_lte.lgr_ort, v_lte.lgr_platz, in_ls_login_id);
      v_lte.lte_status := c.LTE_KF_STAT;
    end if;

    if v_lte.lte_status in (c.LTE_PF_STAT, c.LTE_KF_STAT, c.LTE_AG_STAT) -- Dies sind nicht mehr in Lager / kein Bestand
    then
      lvs_lte_delete(in_sid, v_lte.lte_id, in_ls_login_id, v_lte.lte_status);
      v_found := False;
    end if;

    if not v_found then
      OPEN c_firma;
      FETCH c_firma into v_firma;
      CLOSE c_firma;

      v_lte_hist := NULL;

      OPEN c_lte_hist;                    --
      FETCH c_lte_hist into v_lte_hist;        -- Lesen den Eintrag der Transporteinheit
      v_found := c_lte_hist%FOUND;
      CLOSE c_lte_hist;


      v_sep_nve := NULL;
      if v_firma.sep_nve_kopf is not NULL
      then
        if in_sep_nve is NULL
        then
          v_err_nr := 22;
          v_err_text := LC.ec_p1(LC.O_TP1_SEQ_VORGANG, 'seq_sep_nve_id');
          select seq_sep_nve_nr.nextval into v_sep_nve_nr from dual;  -- Hole neue Nummer aus der Seq.LTE
          v_sep_nve := v_firma.sep_nve_kopf || lpad(to_char(v_sep_nve_nr), 17 - length(v_firma.sep_nve_kopf),'0');
          v_sep_nve := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_sep_nve);
        else
          v_sep_nve := in_sep_nve;
        end if;
      end if;

      if nvl(v_lgr.lgr_verwendung, C.WE) <> C.WE
         and nvl(v_lgr.lgr_verwendung, C.WE) <> C.LGR_TYP_Puffer
      then     -- Fehler Lagerplatz ist kein WarenEingang
        raise_isi_error(c.FMID_Platz_kein_WE, LC.ec_p1(LC.O_TP1_PLATZ_KEIN_WE, v_lgr_platz));
      end if;
      -- Volumen rechnen in m3
      v_lte_vol := v_lte_cfg.lte_vol_hoehe * v_lte_cfg.lte_vol_breite * v_lte_cfg.lte_vol_tiefe / 1000000000;
      v_lte_akt_kg := v_lte_cfg.lte_gew_kg;                        -- Gewicht der Palette
      v_err_nr := 40;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_NICHT_BUCHBAR, v_lte_id);
      insert into lvs_lte
          values
                (in_sid,
                 in_firma_nr,
                 v_lte_id,
                 in_lte_name,
                 v_lgr_ort,
                 in_lgr_platz,
                 v_lgr.lgr_platz_gruppe,
                 v_lte_cfg.lte_vol_hoehe,
                 v_lte_cfg.lte_vol_breite,
                 v_lte_cfg.lte_vol_tiefe,
                 v_lte_vol,
                 v_lte_akt_kg,
                 0,
                 in_ls_login_id,
                 sysdate,
                 in_lte_status,
                 C.LTE_VOLL_A,
                 null,
                 null,
                 v_sep_nve,
                 -300,
                 300,
                 1,
                 0,
                 0,
                 C.LEERPAL,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 null,
                 0,
                 in_lte_eti_druck_status,
                 null,
                 null,
                 in_packschema_kopf_id,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 NULL,
                 in_auto_depal,
                 in_wickelprogramm,
                 in_wickelprogramm_einl,
                 'N',                                        -- Neu, keine Mengenkontrolle am Kom-Platz
                 NULL,
                 v_lte_hist.letzte_inventur_id,
                 v_lte_hist.letzte_inventur_datum,
                 v_lte_hist.letzte_inventur_login_id
                 );
      v_err_nr := NULL;
      v_err_text := NULL;
      v_lte.lgr_platz := NULL;                                        -- Noch den Lagerplaztz Belasten
    else
      if v_lte.lgr_platz is not NULL and                              -- LTE bereits registriert und ist auf einem
         v_lte.lgr_platz <> in_lgr_platz then                         -- anderen Lagerplatz
        if nvl(v_lgr.lgr_verwendung, ' ') <> C.WE
        and nvl(v_lgr.lgr_verwendung, C.WE) <> C.LGR_TYP_Puffer
        then           -- Fehler Lagerplatz ist kein WarenEingang
          raise_isi_error(c.FMID_Platz_kein_WE, LC.ec_p1(LC.O_TP1_PLATZ_KEIN_WE, v_lgr_platz));
        end if;

        v_lgr_platz := v_lte.lgr_platz;                               -- Für Cursor setzen
        OPEN c_lgr;                                                   --
        FETCH c_lgr into v_lgr_v;                                     -- Lesen den Eintrag des Lagerplatz
        v_found := c_lgr%FOUND;
        CLOSE c_lgr;
        if v_found then
          lvs_lte_transport(v_lte_id, v_lgr_platz, in_lgr_platz, in_ls_login_id);     -- Transport Buchen
          if v_lte.lte_akt_lhm = 0 then                                  -- LTE ist bereits bekannt
            v_lte.res_string_statisch := NULL;
            v_lte.order_vorgang_id := NULL;
            v_lte.lte_voll := C.LTE_VOLL_A;
            v_lte.min_temp := -300;
            v_lte.max_temp := 300;
            v_lte.abc := 1;
            v_lte.wert_klasse := 0;
            v_lte.gefahren_klasse := 0;
            v_lte.waren_typ := C.LEERPAL;
            v_lte.res_string := null;
            v_lte.res_artikel_id := null;
            v_lte.res_mhd := null;
            v_lte.transport_gruppe := NULL;
            v_lte.packschema_kopf_id := in_packschema_kopf_id;
            v_lte.auto_depal := in_auto_depal;
            v_lte.wickelprogramm := in_wickelprogramm;
            v_lte.wickelprogramm_einl := in_wickelprogramm_einl;
            v_lte.komm_menge_kontrolle := 'N';                                        -- Neu, keine Mengenkontrolle am Kom-Platz
          end if;
          if v_lte.lte_akt_lhm <> 0 then                                  -- LTE ist bereits bekannt
            v_lte_cfg.lte_vol_hoehe := v_lte.lte_vol_hoehe;               -- Alle Werte in die Vorgabe
            v_lte_cfg.lte_vol_breite := v_lte.lte_vol_breite;
            v_lte_cfg.lte_vol_tiefe := v_lte.lte_vol_tiefe;
            v_lte_vol := v_lte.lte_vol;
            v_lte_akt_kg := v_lte.lte_akt_kg;
          end if;
          update lvs_lte lte                                          -- Eintrag ist bereits vorhanden
            set
              lte.lte_status = in_lte_status,
              lte.lte_vol_hoehe = v_lte_cfg.lte_vol_hoehe,
              lte.lte_vol_breite = v_lte_cfg.lte_vol_breite,
              lte.lte_vol_tiefe = v_lte_cfg.lte_vol_tiefe,
              lte.lte_voll = v_lte.lte_voll,
              lte.min_temp = v_lte.min_temp,
              lte.max_temp = v_lte.max_temp,
              lte.abc = v_lte.abc,
              lte.wert_klasse = v_lte.wert_klasse,
              lte.gefahren_klasse = v_lte.gefahren_klasse,
              lte.waren_typ = v_lte.waren_typ,
              lte.res_string = v_lte.res_string,
              lte.res_artikel_id = v_lte.res_artikel_id,
              lte.res_mhd = v_lte.res_mhd,
              lte.order_vorgang_id = v_lte.order_vorgang_id,
              lte.res_string_statisch = v_lte.res_string_statisch,
              lte.transport_gruppe = v_lte.transport_gruppe,
              lte.packschema_kopf_id = v_lte.packschema_kopf_id,
              lte.auto_depal = in_auto_depal,
              lte.wickelprogramm = in_wickelprogramm,
              lte.wickelprogramm_einl = in_wickelprogramm_einl,
              lte.komm_menge_kontrolle = v_lte.komm_menge_kontrolle                                        -- Neu, keine Mengenkontrolle am Kom-Platz
            where lte.sid = in_sid and
                  lte.firma_nr = in_firma_nr and
                  lte.lte_id = v_lte_id;
          v_err_nr := NULL;
          v_err_text := NULL;
          return (v_lte_id);
        end if;
      end if;
      if v_lte.lte_akt_lhm <> 0 then                                  -- LTE ist bereits bekannt
        v_lte_cfg.lte_vol_hoehe := v_lte.lte_vol_hoehe;               -- Alle Werte in die Vorgabe
        v_lte_cfg.lte_vol_breite := v_lte.lte_vol_breite;
        v_lte_cfg.lte_vol_tiefe := v_lte.lte_vol_tiefe;
        v_lte_vol := v_lte.lte_vol;
        v_lte_akt_kg := v_lte.lte_akt_kg;
      end if;
      v_err_nr := 50;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_UPDATE_ERR, v_lte_id);
      if v_lte.lte_akt_lhm = 0 then                                  -- LTE ist bereits bekannt
        v_lte.res_string_statisch := NULL;
        v_lte.order_vorgang_id := NULL;
        v_lte.lte_voll := C.LTE_VOLL_A;
        v_lte.min_temp := -300;
        v_lte.max_temp := 300;
        v_lte.abc := 1;
        v_lte.wert_klasse := 0;
        v_lte.gefahren_klasse := 0;
        v_lte.waren_typ := C.LEERPAL;
        v_lte.res_string := null;
        v_lte.res_artikel_id := null;
        v_lte.res_mhd := null;
        v_lte.transport_gruppe := NULL;
        v_lte.packschema_kopf_id := in_packschema_kopf_id;
        v_lte.auto_depal := in_auto_depal;
        v_lte.wickelprogramm := in_wickelprogramm;
        v_lte.wickelprogramm_einl := in_wickelprogramm_einl;
        v_lte.komm_menge_kontrolle := 'N';                                        -- Neu, keine Mengenkontrolle am Kom-Platz
      end if;

      update lvs_lte lte                               -- Eintrag ist bereits vorhanden
        set
          lte.lte_name = in_lte_name,
          lte.lgr_platz = in_lgr_platz,
          lte.lgr_ort = v_lgr_ort,
          lte.lte_vol_hoehe = v_lte_cfg.lte_vol_hoehe,
          lte.lte_vol_breite = v_lte_cfg.lte_vol_breite,
          lte.lte_vol_tiefe = v_lte_cfg.lte_vol_tiefe,
          lte.lte_vol = v_lte_vol,
          lte.lte_akt_kg = v_lte_akt_kg,
          lte.lte_letzte_buchung = systimestamp,
          lte.lte_status = in_lte_status,
          lte.lte_voll = v_lte.lte_voll,
          lte.min_temp = v_lte.min_temp,
          lte.max_temp = v_lte.max_temp,
          lte.abc = v_lte.abc,
          lte.wert_klasse = v_lte.wert_klasse,
          lte.gefahren_klasse = v_lte.gefahren_klasse,
          lte.waren_typ = v_lte.waren_typ,
          lte.res_string = v_lte.res_string,
          lte.res_artikel_id = v_lte.res_artikel_id,
          lte.res_mhd = v_lte.res_mhd,
          lte.order_vorgang_id = v_lte.order_vorgang_id,
          lte.res_string_statisch = v_lte.res_string_statisch,
          lte.auto_depal = in_auto_depal,
          lte.transport_gruppe = v_lte.transport_gruppe,
          lte.packschema_kopf_id = v_lte.packschema_kopf_id,
          lte.auto_depal = in_auto_depal,
          lte.wickelprogramm = in_wickelprogramm,
          lte.wickelprogramm_einl = in_wickelprogramm_einl,
          lte.komm_menge_kontrolle = v_lte.komm_menge_kontrolle                                        -- Neu, keine Mengenkontrolle am Kom-Platz
        where lte.sid = in_sid and
              lte.firma_nr = in_firma_nr and
              lte.lte_id = v_lte_id;
      v_err_nr := NULL;
      v_err_text := NULL;
    end if;

    if v_lgr_platz is not NULL then
      if v_lte.lgr_platz is NULL then                                    -- LTE ist noch nicht auf einem Lagerplatz registriert
        v_lgr.lgr_akt_kg := nvl(v_lgr.lgr_akt_kg, 0) + v_lte_akt_kg; -- Das Gewicht zubuchen auf den Lagerplatz
        v_lgr.lgr_akt_te := nvl(v_lgr.lgr_akt_te, 0) + 1;                -- Eine TE zubuchen
        v_err_nr := 50;
        v_err_text := LC.ec_p2(LC.O_TP2_LTE_BUCH_PLATZ_ERR, v_lte_id, in_lgr_platz);
      end if;
      if v_lgr.lgr_dat_erst_belegt is NULL then
        v_lgr.lgr_dat_erst_belegt := sysdate;                          -- Erste Belegung jetzt
      end if;
      UPDATE lvs_lgr
        SET lgr_akt_te = v_lgr.lgr_akt_te,
            lgr_akt_kg = v_lgr.lgr_akt_kg,
            lgr_dat_erst_belegt = v_lgr.lgr_dat_erst_belegt
      WHERE lgr_platz = in_lgr_platz;
    end if;

    v_err_nr := NULL;
    v_err_text := NULL;

    v_lvs_lte_id := v_lte_id;

    return (v_lte_id);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end lvs_lte_insert_v359;

/*******************************************************************************
 * procedure LVS_LTE_DELETE(...)

 Löscht eine Palette incl. LAM und LHM wenn die Palette den
 Status=PF Paletiert frei oder KS Korrekturstatus hat!
 *******************************************************************************/

 procedure lvs_lte_delete  (in_sid         in isi_sid.sid%type,
                            in_lte_id      in lvs_lte.lte_id%type,
                            in_ls_login_id in isi_user.login_id%type,
                            in_status      in lvs_lte.lte_status%type
                            ) is

    v_lte       lvs_lte%rowtype;           -- Palettendaten
    v_found     boolean;

    v_lam_id lvs_lam.lam_id%type;
    v_lhm_id lvs_lhm.lhm_id%type;

    cursor c_lte is                            -- Lesen der lte
      select *
        from lvs_lte lte
       where lte.lte_id = in_lte_id;

    CURSOR c_lam_del is
      select lam.lam_id,
             bh.lhm_id
        from lvs_lam lam,
             lvs_lam_bh bh
       where lam.lgr_platz is null
         and lam.lam_id = bh.lam_id
         and bh.lte_id = in_lte_id
         and bh.bus = 3;  -- nur Lagerabgänge mit dieser LTE
  begin
    reset_isi_error();
    -- erstmal LTE einlesen
    OPEN c_lte;                    --
    FETCH c_lte into v_lte;        -- Lesen den Eintrag der lte
    v_found := c_lte%FOUND;
    CLOSE c_lte;
    if not v_found then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(to_char(in_lte_id),'NULL')));
    end if;
    --  LTE status prüfen nur PF und KF paletten dürfen gelöscht werden
    if  ((v_lte.lte_status <> c.LTE_PF_STAT)   -- palettiert frei
    and  (v_lte.lte_status <> c.LTE_KF_STAT))  -- Korrekturstatus
    and  v_lte.lte_status <> nvl(in_status, '')
    then
      raise_isi_error(10, LC.ec_p2(LC.O_TP2_LTE_ID_ST_N_LOESCHBAR, nvl(in_lte_id,'NULL'), v_lte.lte_status));
    end if;
    --  hat die LTE einen Ziellagerplatz transport aktiv ?
    if (v_lte.ziel_lgr_platz is not null
        and v_lte.lte_status <> c.LTE_PF_STAT    -- palettiert frei
        and v_lte.lte_status <> c.LTE_KF_STAT)   -- Korrekturstatus
    then
      raise_isi_error(11, LC.ec_p2(LC.O_TP2_LTE_ID_TRANS_N_LOESCHBAR, nvl(in_lte_id,'NULL'), v_lte.ziel_lgr_platz));
    end if;
    -- der für das löschen verantwortliche user wird in der lte.ls_login_id festgehalten -BW-
    update LVS_lte lte
    set   lte.ls_login_id = in_ls_login_id
    where lte.lte_id = in_lte_id and
          lte.sid    = in_sid;
    -- LTE Loeschen
    delete LVS_lte lte
    where lte.lte_id = in_lte_id and
          lte.sid    = in_sid;
    -- Her werden KF und PF und Inventur LAMs und LHMs gelöscht
    -- LAM Loeschen
    delete lvs_lam lam
    where lam.lte_id = in_lte_id and
          lam.sid    = in_sid;
    -- LHM Loeschen
    delete lvs_lhm lhm
    where lhm.lte_id = in_lte_id and
          lhm.sid    = in_sid;

    open c_lam_del;
    loop
      fetch c_lam_del into v_lam_id, v_lhm_id;
      exit when c_lam_del%notfound;

      -- löschen von ausgelagerten LAMs und LHMs
      -- (Wenn die LTE gelöscht wird, müssen wegen konsistenz auch alle LAMs und LHMs dabei sein)
      delete lvs_lam lam
       where lam.sid = v_lte.sid
         and lam.firma_nr = v_lte.firma_nr
         and lam.lam_id = v_lam_id;

      delete lvs_lhm lhm
       where lhm.lhm_id = v_lhm_id;
    end loop;
    close c_lam_del;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam_del%isopen
      then
        close c_lam_del;
      end if;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if c_lam_del%isopen
      then
        close c_lam_del;
      end if;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LVS_C_LTE_DELETE(...)   COMMIT

 Löscht eine Palette incl. LAM und LHM wenn die Palette den
 Status=PF Palettiert frei oder KS Korrekturstatus hat!
 *******************************************************************************/
  procedure LVS_C_LTE_DELETE (in_sid         in isi_sid.sid%type,
                              in_lte_id      in lvs_lte.lte_id%type,
                              in_ls_login_id in isi_user.login_id%type
                             ) is
  begin
    lvs_lte_Delete(in_sid,in_lte_id,in_ls_login_id, NULL);
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  procedure LVS_C_LTE_DELETE_359 (in_sid         in isi_sid.sid%type,
                                  in_lte_id      in lvs_lte.lte_id%type,
                                  in_ls_login_id in isi_user.login_id%type,
                                  in_status      in lvs_lte.lte_status%type
                                 ) is
  begin
    lvs_lte_Delete(in_sid,in_lte_id,in_ls_login_id, in_status);
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure lvs_lte_lhm_next_id(...)

 Holt die nächste verfügbare ID für eine LTE oder LHM
 *******************************************************************************/
  function LVS_LTE_LHM_NEXT_ID (in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_barcode_ref in varchar2
                               ) return varchar2 is
  begin
    -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
    return(lvs_lte_lhm_next_id_v35 (in_sid,        -- in_sid         in isi_sid.sid%type,
                                    in_firma_nr,   -- in_firma_nr    in isi_firma.firma_nr%type,
                                    in_barcode_ref,-- in_barcode_ref in varchar2,
                                    NULL,          -- in_charge      in lvs_charge.charge_bez%type,
                                    NULL,          -- in_artikel_id  in isi_artikel.artikel_id%type
                                    NULL,          -- Kunde_nr
                                    '0000000000',  -- Hier ist nichts bekannt um eine Typ zu ermitteln
                                    '000'));
  end;
/*******************************************************************************
 * procedure lvs_lte_lhm_next_id(...)

 Holt die nächste verfügbare ID für eine LTE oder LHM
 *******************************************************************************/

  function lvs_lte_lhm_next_id_v34 (in_sid         in isi_sid.sid%type,
                                    in_firma_nr    in isi_firma.firma_nr%type,
                                    in_barcode_ref in varchar2,
                                    in_charge      in lvs_charge.charge_bez%type,
                                    in_artikel_id  in isi_artikel.artikel_id%type
                               ) return varchar2 is
  begin
    -- -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
    return(lvs_lte_lhm_next_id_v35 (in_sid,        -- in_sid         in isi_sid.sid%type,
                                    in_firma_nr,   -- in_firma_nr    in isi_firma.firma_nr%type,
                                    in_barcode_ref,-- in_barcode_ref in varchar2,
                                    in_charge,     -- lvs_charge.charge_bez%type,
                                    in_artikel_id, -- isi_artikel.artikel_id%type,
                                    NULL,          -- Kunde_nr
                                    '0000000000',  -- Hier ist nichts bekannt um eine Typ zu ermitteln
                                    '000'));
  end;


/*******************************************************************************
 * procedure lvs_lte_lhm_next_id_kd(...)

 Holt die nächste verfügbare ID für eine LTE oder LHM aus den Kundendaten
 *******************************************************************************/
  function lvs_lte_lhm_next_id_kd  (in_sid         in isi_sid.sid%type,
                                    in_firma_nr    in isi_firma.firma_nr%type,
                                    in_barcode_ref in varchar2,
                                    in_charge      in lvs_charge.charge_bez%type,
                                    in_artikel_id  in isi_artikel.artikel_id%type,
                                    in_adr         in isi_adressen%rowtype,
                                    in_typ         in varchar2,
                                    in_h_tag      in isi_hersteller.tag%type
                               ) return varchar2 is
    v_next_barcode       lvs_lte.lte_id%type;             -- Variable um neuen Barcode zu bilden
    v_next_nr            integer;                         -- Naechste Nummer

    v_isi_firma          isi_firma%rowtype;               -- Firmenstammdaten
    v_laenge_barcode     integer;                         -- Laenge des Barcode
    v_laenge_kopf        integer;                         -- Laenge des Kopfes (Barcode)
    v_kopf               isi_firma.lte_barcode_kopf%type; -- Kopf (Basisdaten) fuer den Barcode
    v_barcode_typ        isi_firma.lhm_barcode_type%type; -- Typ des Barcodes NVE, VDA, Standard (Mit ohne Pruefziffer)
    v_pruefziffer        boolean;                         -- Mit ohne Pruefziffer

    v_seq_barcode varchar2(3);

  begin
    if not isi_p_base.get_adress_next_lfdn_id(in_sid,
                                              in_adr.adress_id,
                                              v_next_nr)
    then
      raise_isi_error(10, LC.ec(LC.O_TXT_ID_LEANGENUEBERLAUF));
    end if;

    if in_barcode_ref = C.BASIS_LTE then
      v_laenge_barcode := in_adr.lte_barcode_laenge;
      v_laenge_kopf := length(in_adr.lte_barcode_kopf);
      v_kopf := in_adr.lte_barcode_kopf;
      v_barcode_typ := in_adr.lte_barcode_type;             -- Barcodetyp
    end if;

    if in_barcode_ref = C.BASIS_LHM then
      v_laenge_barcode := in_adr.lhm_barcode_laenge;
      v_laenge_kopf := length(in_adr.lhm_barcode_kopf);
      v_kopf := in_adr.lhm_barcode_kopf;
      v_barcode_typ := in_adr.lhm_barcode_type;             -- Barcodetyp
    end if;

    v_pruefziffer := false;                                     -- Std ist keine Prüfziffer
    if v_barcode_typ = C.LTE_BARCODE_NVE
    or v_barcode_typ = C.LTE_BARCODE_CCG then
      v_laenge_barcode := v_laenge_barcode -1;                  -- Laenge kleiner (Pruefziffer)
      v_pruefziffer := true;
    end if;

    reset_isi_error();

    v_next_barcode := format_barcode(in_sid, v_kopf, v_next_nr, v_laenge_barcode, v_seq_barcode, in_charge, in_artikel_id, in_barcode_ref, NULL, in_typ, in_h_tag);
    if v_pruefziffer then
      if v_barcode_typ = C.LTE_BARCODE_CCG
      or v_barcode_typ = C.LTE_BARCODE_NVE then
        v_next_barcode := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_next_barcode);
      else
        v_next_barcode := v_next_barcode || '?';
      end if;
    end if;
    return(v_next_barcode);
  end;

/*******************************************************************************
 * procedure lvs_lte_lhm_next_id_std(...)

 Holt die nächste verfügbare ID für eine LTE oder LHM aus dem Firmenstamm
 *******************************************************************************/
  function lvs_lte_lhm_next_id_std (in_sid         in isi_sid.sid%type,
                                    in_firma_nr    in isi_firma.firma_nr%type,
                                    in_barcode_ref in varchar2,
                                    in_charge      in lvs_charge.charge_bez%type,
                                    in_artikel_id  in isi_artikel.artikel_id%type,
                                    in_typ         in varchar2,
                                    in_h_tag      in isi_hersteller.tag%type
                               ) return varchar2 is

    v_next_barcode       lvs_lte.lte_id%type;             -- Variable um neuen Barcode zu bilden
    v_next_nr            integer;                         -- Naechste Nummer

    v_isi_firma          isi_firma%rowtype;               -- Firmenstammdaten
    v_laenge_barcode     integer;                         -- Laenge des Barcode
    v_laenge_kopf        integer;                         -- Laenge des Kopfes (Barcode)
    v_kopf               isi_firma.lte_barcode_kopf%type; -- Kopf (Basisdaten) fuer den Barcode
    v_barcode_typ        isi_firma.lhm_barcode_type%type; -- Typ des Barcodes NVE, VDA, Standard (Mit ohne Pruefziffer)
    v_pruefziffer        boolean;                         -- Mit ohne Pruefziffer

    v_seq_barcode varchar2(3);

    CURSOR c_isi_firma is
      select *
        from isi_firma f
       where f.sid = in_sid
         and f.firma_nr = in_firma_nr;
  begin
    -- Daten Firenstamm holen
    OPEN c_isi_firma;
    FETCH c_isi_firma into v_isi_firma;    -- Lesen
    CLOSE c_isi_firma;

    v_err_nr := 10;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);

    if in_barcode_ref = C.BASIS_LTE then
      if v_isi_firma.lte_barcode_basis = 'SEQ' then
        v_seq_barcode := 'SEQ';
        select seq_lam_lgr_id.nextval into v_next_nr from dual;  -- Hole neue Nummer aus der Seq. (Gilt auch für LTE)
      elsif v_isi_firma.lte_barcode_basis = C.BASIS_LTE then
        v_seq_barcode := 'LTE';
        select seq_lte_lgr_id.nextval into v_next_nr from dual;  -- Hole neue Nummer aus der Seq.LTE
      end if;
      v_laenge_barcode := v_isi_firma.lte_barcode_laenge;
      v_laenge_kopf := length(v_isi_firma.lte_barcode_kopf);
      v_kopf := v_isi_firma.lte_barcode_kopf;
      v_barcode_typ := v_isi_firma.lte_barcode_type;             -- Barcodetyp
    end if;

    if in_barcode_ref = C.BASIS_LHM then
      if v_isi_firma.lhm_barcode_basis = 'SEQ' then
        v_seq_barcode := 'SEQ';
        select seq_lam_lgr_id.nextval into v_next_nr from dual;  -- Hole neue Nummer aus der Seq. (Gilt auch für LTE)
      elsif v_isi_firma.lhm_barcode_basis = C.BASIS_LHM then
        v_seq_barcode := 'LHM';
        select seq_lhm_lgr_id.nextval into v_next_nr from dual;  -- Hole neue Nummer aus der Seq.LTE
      end if;
      v_laenge_barcode := v_isi_firma.lhm_barcode_laenge;
      v_laenge_kopf := length(v_isi_firma.lhm_barcode_kopf);
      v_kopf := v_isi_firma.lhm_barcode_kopf;
      v_barcode_typ := v_isi_firma.lhm_barcode_type;             -- Barcodetyp
    end if;

    if in_barcode_ref = C.BASIS_LTE_VL then
      if v_isi_firma.lhm_barcode_basis = 'SEQ' then
        v_seq_barcode := 'SEQ';
        select seq_lam_lgr_id.nextval into v_next_nr from dual;  -- Hole neue Nummer aus der Seq. (Gilt auch für LTE)
      elsif v_isi_firma.lhm_barcode_basis = C.BASIS_LHM then
        v_seq_barcode := 'LHM';
        select seq_lhm_lgr_id.nextval into v_next_nr from dual;  -- Hole neue Nummer aus der Seq.LTE
      end if;
      v_laenge_barcode := v_isi_firma.lhm_barcode_laenge + length(C.BASIS_LTE_VL) - nvl(length(v_isi_firma.lhm_barcode_kopf), 0);
      v_laenge_kopf := length(C.BASIS_LTE_VL);
      v_kopf := C.BASIS_LTE_VL;
      v_barcode_typ := c.LTE_BARCODE_STD;                        -- Barcodetyp
    end if;

    v_pruefziffer := false;                                     -- Std ist keine Prüfziffer
    if v_barcode_typ = C.LTE_BARCODE_NVE
    or v_barcode_typ = C.LTE_BARCODE_CCG then
      v_laenge_barcode := v_laenge_barcode -1;                  -- Laenge kleiner (Pruefziffer)
      v_pruefziffer := true;
    end if;

    reset_isi_error();

    v_next_barcode := format_barcode(in_sid, v_kopf, v_next_nr, v_laenge_barcode, v_seq_barcode, in_charge, in_artikel_id, in_barcode_ref, NULL, in_typ, in_h_tag);
    if v_pruefziffer then
      if v_barcode_typ = C.LTE_BARCODE_CCG
      or v_barcode_typ = C.LTE_BARCODE_NVE then
        v_next_barcode := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_next_barcode);
      else
        v_next_barcode := v_next_barcode || '?';
      end if;
    end if;
    return(v_next_barcode);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 -MM- Erweiterung 28.07.2014 Kundenspezifische LHM und LTE IDs
 * procedure lvs_lte_lhm_next_id(...)

 Holt die nächste verfügbare ID für eine LTE oder LHM
 *******************************************************************************/
  function lvs_lte_lhm_next_id_v35 (in_sid         in isi_sid.sid%type,
                                    in_firma_nr    in isi_firma.firma_nr%type,
                                    in_barcode_ref in varchar2,
                                    in_charge      in lvs_charge.charge_bez%type,
                                    in_artikel_id  in isi_artikel.artikel_id%type,
                                    in_adr_nr      in isi_adressen.adr_nr%type,
                                    in_typ         in varchar2,
                                    in_h_tag      in isi_hersteller.tag%type
                                   ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Barcode Ref sagt, wofuer dieser Barcode benutzt wird.
    -- LTE    --> Transporteinheit (Palette etc.)
    -- LHM    --> Ladehilfsmittel (Karton, Behälter etc.)
    -------------------------------------------------------------------------------------------------------

    v_next_barcode       lvs_lte.lte_id%type;             -- Variable um neuen Barcode zu bilden
    v_next_nr            integer;                         -- Naechste Nummer

    v_adr                isi_adressen%rowtype;            -- Kundenstammdaten
    v_laenge_barcode     integer;                         -- Laenge des Barcode
    v_laenge_kopf        integer;                         -- Laenge des Kopfes (Barcode)
    v_kopf               isi_firma.lte_barcode_kopf%type; -- Kopf (Basisdaten) fuer den Barcode
    v_barcode_typ        isi_firma.lhm_barcode_type%type; -- Typ des Barcodes NVE, VDA, Standard (Mit ohne Pruefziffer)
    v_pruefziffer        boolean;                         -- Mit ohne Pruefziffer

    v_seq_barcode varchar2(3);
  begin

    if in_adr_nr is not NULL
    then
      if isi_p_base.get_adresse(in_sid,
                                in_firma_nr,
                                'K',          -- Kunden
                                in_adr_nr,    -- Kundennummer
                                0,            -- 0 ist die Stammadresse (Haupteintrag für den Kunden)
                                v_adr)
      then
        if in_barcode_ref  = C.BASIS_LTE
        and nvl(v_adr.lte_eigener_nr_kreis, c.C_FALSE)  = c.C_FALSE
        then
          v_adr.adress_id := NULL;
        elsif in_barcode_ref  = C.BASIS_LHM
        and nvl(v_adr.lhm_eigener_nr_kreis, c.C_FALSE)  = c.C_FALSE
        then
          v_adr.adress_id := NULL;
        end if;
      else
        v_adr.adress_id := NULL;
      end if;
    else
      v_adr.adress_id := NULL;
    end if;

    if v_adr.adress_id is NULL
    or in_barcode_ref = C.BASIS_LTE_VL                -- Virtuelle ID (Zum Pallettieren)
    then
      return(lvs_lte_lhm_next_id_std (in_sid,         -- in_sid         in isi_sid.sid%type,
                                      in_firma_nr,    -- in_firma_nr    in isi_firma.firma_nr%type,
                                      in_barcode_ref, -- in_barcode_ref in varchar2,
                                      in_charge,      -- lvs_charge.charge_bez%type,
                                      in_artikel_id,  -- isi_artikel.artikel_id%type
                                      in_typ,
                                      in_h_tag));
    else
      return(lvs_lte_lhm_next_id_kd  (in_sid,        -- in_sid         in isi_sid.sid%type,
                                      in_firma_nr,   -- in_firma_nr    in isi_firma.firma_nr%type,
                                      in_barcode_ref,-- in_barcode_ref in varchar2,
                                      in_charge,     -- lvs_charge.charge_bez%type,
                                      in_artikel_id, -- isi_artikel.artikel_id%type
                                      v_adr,         -- Kundendaten
                                      in_typ,
                                      in_h_tag));
    end if;
    return(v_next_barcode);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * function LVS_C_LTE_DRUCKEN_BDE(...)   COMMIT

 Druckt die übergebene Palette für den Übergebenen Kunden wenn dieser ein eigenes
        Etikettenlayout hat. Der Kunde wird aus den LAM's ermittelt.
        Wenn der Kunde = NULL oder der Kunde kein eigenes Etikettenlayout hat dann
        Etikettenlayout aus dem Firmenstamm verwenden
 *******************************************************************************/
  function LVS_C_LTE_DRUCKEN_BDE (in_lte_id       in lvs_lte.lte_id%type,
                                  in_drucker_name in pe_drucker_cfg.drucker_name%type)
                                  return integer is

    v_kunde_nr  lvs_lam.kunden_nr%type;

    v_result number;
  begin
    v_kunde_nr := lvs_util.get_lam_kunde_by_lte_id(in_lte_id);

    v_result := LVS_LTE_DRUCKEN (in_lte_id, v_kunde_nr, in_drucker_name);

    commit;

    return(v_result);
    -------------------------------------------------------------------------------------------------------
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LVS_C_LTE_DRUCKEN_R4(...)   COMMIT

 Druckt die übergebene Palette für den Übergebenen Kunden wenn dieser ein eigenes
        Etikettenlayout hat. Wenn der Kunde = NULL oder der Kunde kein eigenes
        Etikettenlayout hat dann Etikettenlayout aus dem Firmenstamm verwenden
 *******************************************************************************/
  function LVS_C_LTE_DRUCKEN (in_lte_id       in lvs_lte.lte_id%type,
                              in_kunden_nr    in isi_adressen.adr_nr%type,
                              in_drucker_name in pe_drucker_cfg.drucker_name%type)
                              return integer is
    v_result number;
  begin
    v_result := LVS_LTE_DRUCKEN (in_lte_id, in_kunden_nr, in_drucker_name);
    commit;
    return(v_result);
    -------------------------------------------------------------------------------------------------------
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end LVS_C_LTE_drucken;

/*******************************************************************************
 * procedure LVS_LTE_GET_DRUCK_DATEN(...)

  Erzeugt Druckdaten für die übergebene Palette für den übergebenen Lieferanten
  oderKunden wenn dieser ein eigenes Etikettenlayout hat. Wenn der Kunde = NULL
  oder der Kunde kein eigenes Etikettenlayout hat dann Etikettenlayout aus dem
  Firmenstamm verwenden
 *******************************************************************************/
  procedure LVS_LTE_GET_DRUCK_DATEN (in_lte_id            in lvs_lte.lte_id%TYPE,
                                     in_kunden_nr         in isi_adressen.adr_nr%TYPE,
                                     out_lte_sid          out lvs_lte.sid%TYPE,
                                     out_lte_firma_nr     out lvs_lte.firma_nr%TYPE,
                                     out_rave_datei       out pe_jobs.rave_datei%TYPE,
                                     out_rave_report_name out pe_jobs.rave_report_name%TYPE,
                                     out_job_daten_typ    out pe_jobs.job_daten_typ%TYPE,
                                     out_job_daten        out pe_jobs.job_daten%TYPE,
                                     out_anz_drucke       out isi_artikel.anz_etikett_je_lte%type
                                     ) is
  begin
    lvs_get_druck_daten(in_lte_id, in_kunden_nr, null, out_lte_sid, out_lte_firma_nr, out_rave_datei, out_rave_report_name,
                        out_job_daten_typ, out_job_daten, out_anz_drucke);
  end;

  procedure lvs_get_druck_daten (in_id                in lvs_lte.lte_id%TYPE,
                                 in_kunden_nr         in isi_adressen.adr_nr%TYPE,
                                 in_fuer_artikel_id   in isi_artikel.artikel_id%type,
                                 out_lte_sid          out lvs_lte.sid%TYPE,
                                 out_lte_firma_nr     out lvs_lte.firma_nr%TYPE,
                                 out_rave_datei       out pe_jobs.rave_datei%TYPE,
                                 out_rave_report_name out pe_jobs.rave_report_name%TYPE,
                                 out_job_daten_typ    out pe_jobs.job_daten_typ%TYPE,
                                 out_job_daten        out pe_jobs.job_daten%TYPE,
                                 out_anz_drucke       out isi_artikel.anz_etikett_je_lte%type
                                 ) is

    -- -AG- BugFix kundenspez. Etiketten

    -------------------------------------------------------------------------------------------------------
    v_found             boolean;                        -- Daten gefunden ?

    v_firma             isi_firma%rowtype;              -- Firmenstamm
    v_lte               lvs_lte%rowtype;                -- Daten der transporteinheit
    v_lhm               lvs_lhm%rowtype;                -- Daten der LHM
    v_lam               lvs_lam%rowtype;                -- LagerArtikelMaterial (Lagerbestand)
    v_lam_bh            lvs_lam_bh%rowtype;             -- LagerArtikelMaterial (Lagerbuchung)
    v_art               isi_artikel%rowtype;            -- Artikeldaten
    v_kunde             isi_adressen%rowtype;           -- Daten vom Kunden
    v_etiketten         isi_etiketten%rowtype;          -- Daten vom Etikett
    v_adr_id            isi_adressen.adress_id%type;    -- Adress-ID
    v_etikett           isi_firma.lte_etikett_fw%type;  -- Welches Etikett wird gedruckt
    v_etikett_typ       isi_firma.lte_barcode_type%type;-- STD, VDA, CCG
    v_etikett_spezBC    isi_adressen.lte_etiketten_spez_barcode%type; -- Format für Spez_Barcode
    v_layout_nr         varchar2(20);                     -- (-AM-) 080826 OP: wo kommt das Layout her?
    v_lam_id_null       boolean;
    v_kunden_nr         varchar(1000);
    v_null              varchar(10);

    C_LAYOUT_NR_VORMONTAGE    constant varchar2(20) := 'vormontage';

    cursor c_lte is                        -- Lesen der Transporteinheit für den Lagerplatz
      select *
        from lvs_lte lte
       where lte.lte_id = in_id;

    cursor c_lhm is                        -- Lesen evtl. LHM
      select *
        from lvs_lhm lhm
       where lhm.lhm_id = in_id;

    cursor c_lam is                        -- Lesen evtl. Lam
      select *
        from lvs_lam lam
       where lam.lhm_id = in_id;

    cursor c_lam_get_all_adr_id_by_lte_id is          -- Lesen der Lam's für diese ID
      select max(nvl(lam.owner_address_id, 0))
        from lvs_lam lam
       where lam.lte_id = in_id;

    cursor c_lam_get_all_adr_id_by_lhm_id is          -- Lesen der Lam's für diese ID
      select max(nvl(lam.owner_address_id, 0))
        from lvs_lam lam
       where lam.lhm_id = in_id;

    cursor c_lam_get_kunden_nr_by_lte_id is          -- Lesen der Lam's für diese ID
      select stradd_distinct(a.artikel_fuer_kunde_etikett)
        from lvs_lam lam,
             isi_artikel a
       where lam.lte_id = in_id
         and lam.artikel_id = a.artikel_id;

    cursor c_lam_get_kunden_nr_by_lhm_id is          -- Lesen der Lam's für diese ID
      select stradd_distinct(a.artikel_fuer_kunde_etikett)
        from lvs_lam lam,
             isi_artikel a
       where lam.lhm_id = in_id
         and lam.artikel_id = a.artikel_id;

    cursor c_lam_bh is                        -- Lesen evtl. Lam Buchung
      select *
        from lvs_lam_bh bh
       where bh.lam_id = v_lam.lam_id
         and bh.bus = c.R_LAM_BH_BUS_ABG
       order by bh.lam_bh_id desc;

    cursor c_lam_lam_bh is                        -- Lesen evtl. Lam
      select *
        from lvs_lam lam
       where lam.lam_id = (select bh.lam_id
                             from lvs_lam_bh bh
                            where bh.lhm_id = in_id
                              and bh.bus = c.R_LAM_BH_BUS_ABG
                            group by bh.lam_id);

    cursor c_art is                        -- Lesen Artikel
      select *
        from isi_artikel art
       where art.sid = v_lam.sid
         and art.artikel_id = v_lam.artikel_id;

    cursor c_kunde is                        -- Lesen des Kunden
      select *
        from isi_adressen adr
       where adr.sid = nvl(v_lte.sid, v_lhm.sid)
         and adr.firma_nr = nvl(v_lte.firma_nr, v_lhm.firma_nr)
         and adr.adr_nr = v_kunden_nr
         and adr.adr_liefer = 0  -- Nur Hauptadresse eines Kunden
         and adr.adr_art = 'K';  -- Nur Kunden-Einträge

    cursor c_eigentuemer is                        -- Lesen des Eigentuemers adr KONSI
      select *
        from isi_adressen adr
       where adr.sid = nvl(v_lte.sid, v_lhm.sid)
         and adr.firma_nr = nvl(v_lte.firma_nr, v_lhm.firma_nr)
         and adr.adress_id = v_adr_id;

    cursor c_firma is                      -- Lesen der Firma
      select *
        from isi_firma firma
       where firma.sid = nvl(v_lte.sid, v_lhm.sid)
         and firma.firma_nr = nvl(v_lte.firma_nr, v_lhm.firma_nr);

    cursor c_etiketten is
      select *
        from isi_etiketten et
       where et.sid = nvl(v_lte.sid, v_lhm.sid)
         and et.firma_nr = nvl(v_lte.firma_nr, v_lhm.firma_nr)
         and et.etiketten_name = v_etikett;

  begin
    OPEN c_lte;                        -- Palettendaten
    FETCH c_lte into v_lte;            --
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found then               -- Ganz schlecht, weil es diese LTE nicht gibt
      OPEN c_lhm;                     -- LHM
      FETCH c_lhm into v_lhm;         --
      v_found := c_lhm%FOUND;
      CLOSE c_lhm;
      v_lte.lte_id := NULL;

      if not v_found
      then               -- Ganz schlecht, weil es auch diese LHM nicht gibt
        raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(to_char(in_id), 'NULL')));
      else
        out_lte_sid := v_lhm.sid;
        out_lte_firma_nr := v_lhm.firma_nr;
      end if;
      OPEN c_lam_get_all_adr_id_by_lhm_id;
      FETCH c_lam_get_all_adr_id_by_lhm_id into v_adr_id;
      CLOSE c_lam_get_all_adr_id_by_lhm_id;

      OPEN c_lam_get_kunden_nr_by_lhm_id;
      FETCH c_lam_get_kunden_nr_by_lhm_id into v_kunden_nr;
      CLOSE c_lam_get_kunden_nr_by_lhm_id;

      if v_adr_id is not NULL
      then
        OPEN c_eigentuemer;
        FETCH c_eigentuemer into v_kunde;
        CLOSE c_eigentuemer;

        if v_kunde.lhm_etiketten_name is NULL
        or v_kunde.lhm_etiketten_typ is NULL
        then
          v_adr_id := NULL;
        end if;
      end if;
    else
      out_lte_sid := v_lte.sid;
      out_lte_firma_nr := v_lte.firma_nr;
      OPEN c_lam_get_all_adr_id_by_lte_id;
      FETCH c_lam_get_all_adr_id_by_lte_id into v_adr_id;
      CLOSE c_lam_get_all_adr_id_by_lte_id;

      OPEN c_lam_get_kunden_nr_by_lte_id;
      FETCH c_lam_get_kunden_nr_by_lte_id into v_kunden_nr;
      CLOSE c_lam_get_kunden_nr_by_lte_id;

      if v_adr_id is not NULL
      then
        OPEN c_eigentuemer;
        FETCH c_eigentuemer into v_kunde;
        CLOSE c_eigentuemer;

        if v_kunde.lte_etiketten_name is NULL
        or v_kunde.lte_etiketten_typ is NULL
        then
          v_adr_id := NULL;
        end if;
      end if;
    end if;

    if v_adr_id is NULL
    or in_kunden_nr is not NULL
    then
      if in_kunden_nr is not NULL
      then
        v_kunden_nr := in_kunden_nr;
      end if;

      OPEN c_kunde;                      -- Kundenstamm holen
      FETCH c_kunde into v_kunde;        --
      v_found := c_kunde%FOUND;
      CLOSE c_kunde;
    else
      v_found := TRUE;
    end if;

    OPEN c_firma;                      -- Firmenstamm holen
    FETCH c_firma into v_firma;        --
    v_found := c_firma%FOUND;
    CLOSE c_firma;

    v_lam_id_null := False;

    if v_lte.lte_id is not NULL
    then
      -- -AG- BugFix: 15.12.2010 Artikeldaten müssen hier gelesen werden
      begin
        v_lam.sid := v_lte.sid;
        v_lam.artikel_id := v_lte.res_artikel_id;
      exception
        when others then
          v_lam.artikel_id := NULL;
      end;

      OPEN c_art;
      FETCH c_art into v_art;
      CLOSE c_art;
      out_anz_drucke := nvl(v_art.anz_etikett_je_lte, nvl(v_firma.anz_etikett_je_lte, 1));
      if not v_found
      or v_kunde.lte_etiketten_name is NULL
      or v_kunde.lte_etiketten_typ is NULL
      then

        if not v_found
        then
          raise_isi_error(10, LC.ec_p1(LC.O_TP1_FIRMENSTAMM_FEHLT, nvl(to_char(out_lte_firma_nr), 'NULL')));
        end if;

        v_etikett_typ := v_firma.lte_barcode_type;
        v_etikett_spezBC := NULL;

        if v_lte.waren_typ = C.HALBWARE then
          if v_lte.lte_voll = 'A'
          then
            v_etikett := nvl(v_firma.lte_etikett_anbruch, v_firma.lte_etikett_tf);
          else
            v_etikett := v_firma.lte_etikett_tf;
          end if;
        elsif v_lte.waren_typ = C.ROHWARE then
          v_etikett := v_firma.lte_etikett_roh;
        else
          if v_lte.lte_voll = 'A'
          then
            v_etikett := nvl(v_firma.lte_etikett_anbruch, v_firma.lte_etikett_fw);
          else
            v_etikett := v_firma.lte_etikett_fw;
          end if;
        end if;
      else
        v_etikett := v_kunde.lte_etiketten_name;
        v_etikett_typ := v_kunde.lte_etiketten_typ;
        v_etikett_spezBC := v_kunde.lte_etiketten_spez_barcode;
      end if;
    else
      if not v_found
      or v_kunde.lhm_etiketten_name is NULL
      or v_kunde.lhm_etiketten_typ is NULL
      then

        OPEN c_lam;
        FETCH c_lam into v_lam;
        v_found := c_lam%FOUND;
        CLOSE c_lam;

        if not v_found
        then
          OPEN c_lam_lam_bh;
          FETCH c_lam_lam_bh into v_lam;
          v_found := c_lam_lam_bh%FOUND;
          CLOSE c_lam_lam_bh;
          if v_found -- der Lam für den Druck die Nummer zurueck geben
          then
            v_lam_bh := NULL;
            OPEN c_lam_bh;
            FETCH c_lam_bh into v_lam_bh;
            CLOSE c_lam_bh;
            update lvs_lam t
               set t.lhm_id = in_id,
                   t.lte_id = v_lam_bh.lte_id
             where t.lam_id = v_lam.lam_id;
            v_lam_id_null := True;
          end if;
        end if;

        if not v_found
        then
          raise_isi_error(20, LC.ec_p1(LC.O_TP1_LHM_ID_OHNE_BESTAND, nvl(to_char(in_id), 'NULL')));
        end if;

        OPEN c_art;
        FETCH c_art into v_art;
        v_found := c_art%FOUND;
        CLOSE c_art;

        if not v_found
        then
          raise_isi_error(20, LC.ec_p1(LC.O_TP1_ARTIKEL_ID_FEHLT, nvl(to_char(v_lam.artikel_id), 'NULL')));
        end if;

        if not v_found
        then
          raise_isi_error(10, LC.ec_p1(LC.O_TP1_FIRMENSTAMM_FEHLT, nvl(to_char(out_lte_firma_nr), 'NULL')));
        end if;

        -- ????? Ist das hier nicht ein !LHM! Etikett??? Da kann man doch nicht die "anzahl_eti_je_!LTE!" nehmen?
        v_etikett_typ := v_firma.lhm_barcode_type;
        v_etikett_spezBC := NULL;

        if v_art.waren_typ = C.HALBWARE
           or v_lam.fa_ag is not NULL then
          v_etikett := v_firma.lhm_etikett_tf;
        elsif v_art.waren_typ = C.ROHWARE then
          v_etikett := v_firma.lhm_etikett_roh;
        else
          v_etikett := v_firma.lhm_etikett_fw;
        end if;
      else
        v_etikett := v_kunde.lhm_etiketten_name;
        v_etikett_typ := v_kunde.lhm_etiketten_typ;
        v_etikett_spezBC := v_kunde.lhm_etiketten_spez_barcode;
      end if;
      -- -AG- BugFix: 15.12.2010 Keine Vorgabe Anz Etiketten auf basis LHM
      -- out_anz_drucke := 1;
      out_anz_drucke := isi_allg.get_firma_cfg_param (
                                      v_lhm.sid,
                                      v_lhm.firma_nr,
                                      'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      v_etikett,                -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'ETIKETT_LHM_ANZ_DEFAULT',
                                                                -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'Allgemein',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                      '1',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'INTEGER');               -- in_default_param_typ
    end if;

    OPEN c_etiketten;                      -- Etiketdaten holen
    FETCH c_etiketten into v_etiketten;
    v_found := c_etiketten%FOUND;          -- Etiketten fehlen
    CLOSE c_etiketten;

    if not v_found
    then               -- Ganz schlecht, weil es kein Etikettenlayout gibt
      raise_isi_error(20, LC.ec_p1(LC.O_TP1_ETIKETTEN_LAYOUT_FEHLT, v_etikett));
    end if;

    out_rave_datei := v_etiketten.rave_datei;
    out_rave_report_name := v_etiketten.rave_report;

    if v_etiketten.rave_datei = 'etiketten_cerealia.rav' then
      if v_etiketten.rave_report = 'ccg_etikett' then
        out_job_daten := z_cerealia_druck.ccg_etikett(in_id, v_lte.res_artikel_id);
      else
        raise_isi_error(30, LC.ec_p1(LC.O_TP1_ETIKETTEN_LAYOUT_FEHLT, v_etikett));
      end if;
    -- (-AM-) 080826  Seaquist 4878, Karton-Versand-Etikett bzw. Vormontagelabel
    elsif v_etiketten.rave_datei = 'etiketten_seaquist_logopak_KrtVers.txt'
       or v_etiketten.rave_datei = 'etiketten_seaquist_KrtVers.rav'
       or v_etiketten.rave_datei = 'etiketten_seaquist_Krt.rav'
    then
      out_job_daten := z_seaquist_druck.vda_etikett_vers_krt(v_firma.sid, v_firma.firma_nr, in_id);
    elsif v_etiketten.rave_datei = 'etiketten_seaquist_LteVers.rav'
    then
      out_job_daten := z_seaquist_druck.ccg_etikett_vers_lte(v_firma.sid, v_firma.firma_nr, in_id);
    elsif v_etiketten.rave_datei = 'etiketten_euscher.rav' then
      out_job_daten := z_euscher_druck.vda_etikett(v_firma.sid, v_firma.firma_nr, in_id, v_lte.res_artikel_id);
    elsif v_etiketten.rave_datei = 'etiketten_oetker.rav' then
      out_job_daten := z_oetker_druck.ccg_etikett(in_id, v_lte.res_artikel_id);
    elsif v_etiketten.rave_datei = 'etiketten_huf.rav' then
      out_job_daten := z_huf_druck.vda_etikett(v_firma.sid, v_firma.firma_nr, in_id, v_lte.res_artikel_id, in_fuer_artikel_id);
    elsif v_etiketten.rave_datei = 'etiketten_smithuis.rav' then
      out_job_daten := z_smithuis_druck.ccg_etikett(in_id, v_lte.res_artikel_id);
    elsif v_etiketten.rave_datei = 'etiketten_sasol.rav'
       or v_etiketten.rave_datei = 'etiketten_sasol.txt' then
      out_job_daten := isi_print.std_etikett(v_firma.sid, v_firma.firma_nr, in_id, v_lte.res_artikel_id, v_etikett_spezBC);
    elsif v_etiketten.rave_datei = 'etiketten_Dirks.rav'
       or v_etiketten.rave_datei = 'DIRKS_Produktions_Lable.prn'
       or v_etiketten.rave_datei = 'DIRKS_Sequenz_Label.prn'
       or v_etiketten.rave_datei = 'DIRKS_Reifen_Label.prn' then
      out_job_daten := z_dir_druck.std_etikett(v_firma.sid, v_firma.firma_nr, in_id, v_lte.res_artikel_id, NULL);
    elsif v_etiketten.rave_datei = 'etiketten_HAG.rav' then
      out_job_daten := z_hag_druck.vda_etikett(v_firma.sid, v_firma.firma_nr, in_id, v_lte.res_artikel_id);
    elsif v_etiketten.rave_datei = 'Printlayout_Label_GTP.prn' then
      v_null := NULL;
      EXECUTE IMMEDIATE
        'BEGIN
            z_gtp_get_print_data ( :1, :2, :3, :4, :5, :6, :7, :8, :9, :10);
         END;'
      USING IN     v_firma.sid,                     -- :1 in isi_sid.sid%TYPE,
            IN     v_firma.firma_nr,                -- :2 in isi_firma.firma_nr%TYPE,
            IN     v_null,                          -- :3
            IN     v_null,                          -- :4
            IN     v_null,                          -- :5
            IN     in_id,                           -- :6 lte_id
            IN     v_null,                          -- :7 lte_id
            IN OUT v_etiketten.rave_datei,          -- :8 Racv-Datei-Name
            OUT    out_job_daten,                   -- :9 Out Parameter Job Daten
            IN     'T';                             -- :10 in_get_data_lte in varchar2
      -- out_job_daten := z_gtp_get_print_data(v_firma.sid, v_firma.firma_nr, null, null, null, in_id, v_etiketten.rave_datei);
      out_rave_datei := v_etiketten.rave_datei;
      out_rave_report_name := v_etiketten.rave_datei;
    elsif v_etiketten.rave_datei = 'etiketten_isi.rav'
       or v_etikett_typ is not NULL then
      if v_etikett_typ = 'CCG'
      then
        out_job_daten := isi_print.ccg_etikett(in_id, v_lte.res_artikel_id);
      elsif v_etikett_typ = 'VDA'
      then
        out_job_daten := isi_print.vda_etikett(v_firma.sid, v_firma.firma_nr, in_id, v_lte.res_artikel_id);
      else
        out_job_daten := isi_print.std_etikett(v_firma.sid, v_firma.firma_nr, in_id, v_lte.res_artikel_id, v_etikett_spezBC);
      end if;
    else
      raise_isi_error(20, LC.ec_p1(LC.O_TP1_ETI_DATEI_UNTERSTUETZT, v_etiketten.rave_datei));
    end if;

    if v_lam_id_null -- Falls nur für den Druck gefüllt, dann jetz wieder auf NULL
    then
      update lvs_lam t
         set t.lhm_id = null,
             t.lte_id = null
       where t.lam_id = v_lam.lam_id;
    end if;

    out_job_daten_typ := PRINT_ENGINE.JDT_PV_LISTE;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;


/*******************************************************************************
 * procedure LVS_LTE_DRUCKEN(...)

 Druckt die übergebene Palette für den Übergebenen Kunden wenn dieser ein eigenes
        Etikettenlayout hat. Wenn der Kunde = NULL oder der Kunde kein eigenes
        Etikettenlayout hat dann Etikettenlayout aus dem Firmenstamm verwenden
 *******************************************************************************/
  function LVS_LTE_DRUCKEN (in_lte_id       in lvs_lte.lte_id%type,
                            in_kunden_nr    in isi_adressen.adr_nr%type,
                            in_drucker_name in pe_drucker_cfg.drucker_name%type
                           ) return integer is
    v_lte_sid          lvs_lte.sid%TYPE;
    v_lte_firma_nr     lvs_lte.firma_nr%TYPE;
    v_rave_datei       pe_jobs.rave_datei%TYPE;
    v_rave_report_name pe_jobs.rave_report_name%TYPE;
    v_job_daten_typ    pe_jobs.job_daten_typ%TYPE;
    v_job_daten        pe_jobs.job_daten%TYPE;
    v_job_nr           pe_jobs.job_nr%TYPE;
    v_anzahl_drucke    isi_firma.anz_etikett_je_lte%type;
    v_lam              lvs_lam%rowtype;
    v_res              isi_resource%rowtype;
  begin
    LVS_LTE_GET_DRUCK_DATEN(in_lte_id,
                            in_kunden_nr,
                            v_lte_sid,
                            v_lte_firma_nr,
                            v_rave_datei,
                            v_rave_report_name,
                            v_job_daten_typ,
                            v_job_daten,
                            v_anzahl_drucke);

    if lvs_p_base.get_lam_by_lhm_id(v_lte_sid,
                                    v_lte_firma_nr,
                                    in_lte_id,
                                    v_lam)
    then
      if  v_lam.res_id is not null
      and isi_p_base.get_resource(v_lte_sid,
                                  v_lam.res_id,
                                  v_res)
      then
        if v_res.kategorie = 'PRMSD'
        and v_res.kategorie_typ is not NULL
        then
          v_rave_report_name := v_rave_report_name || '_' || v_res.kategorie_typ;
        end if;
      end if;
    end if;

    PRINT_ENGINE.INSERT_NEW_JOB(v_lte_sid,
                                v_lte_firma_nr,
                                v_rave_datei,
                                v_rave_report_name,
                                v_job_daten_typ,
                                v_job_daten,
                                in_drucker_name,
                                v_anzahl_drucke,
                                v_job_nr);

    update lvs_lte l
       set l.lte_eti_druck_status = 'D'
     where l.sid = v_lte_sid
       and l.firma_nr = v_lte_firma_nr
       and l.lte_id = in_lte_id;

    return(v_job_nr);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * function LVS_C_LTE_ERZEUGEN_DRUCKEN(...)

 Erzeugen und Drucken von Paletten über Liniendaten Tabelle: LVS_PROD_LINIE,
                                                             LVS_PROD_LINIE WAREN
 *******************************************************************************/
  function LVS_C_LTE_ERZEUGEN_DRUCKEN (in_sid         in isi_sid.sid%type,
                                       in_firma_nr    in isi_firma.firma_nr%type,
                                       in_linie       in lvs_prod_linie.linie_nr%type,
                                       in_lte_anzahl  in number,
                                       in_lgr_platz   in lvs_lgr.lgr_platz_gruppe%type,
                                       in_kunden_nr   in isi_adressen.adr_nr%type,
                                       in_drucker     in pe_drucker_cfg.drucker_name%type,
                                       in_et_drucker_name in pe_drucker_cfg.drucker_name%type default NULL,
                                       in_login_id    in isi_user.login_id%type
                                      ) return integer is
    Result integer;

    v_lte_id                       lvs_lte.lte_id%type;           -- Neue LTE_ID
    v_fuer_lte_id                  lvs_lte.lte_id%type;           -- Neue LTE_ID
    v_lte_anz                      integer;                       -- Anzahl der erzeugten LTE's
    -- -AG- Kundennummer in den Liniendaten berücksichtigen
    v_kunden_nr                    isi_adressen.adr_nr%type;

    CURSOR c_linie_waren is
      select decode(max(lw.kunden_nr), min(lw.kunden_nr), max(lw.kunden_nr), NULL),
             decode(max(lw.lte_id), min(lw.lte_id), max(lw.lte_id), NULL)
        from lvs_prod_linie_waren lw
       where lw.sid = in_sid
         and lw.firma_nr = in_firma_nr
         and lw.linie_nr = in_linie;
  begin
    Result := -1;

    v_lte_anz := 0;                                      -- Noch kein LTE erzeugt

    OPEN c_linie_waren;                                  -- Waren für Liniendaten holen
    FETCH c_linie_waren into v_kunden_nr, v_fuer_lte_id;
    CLOSE c_linie_waren;                                  -- Waren für Liniendaten holen

    loop
      if v_lte_anz = in_lte_anzahl then
        exit;
      end if;

      v_lte_id := LVS_LTE_ERZEUGEN (in_sid, in_firma_nr, in_linie, in_lgr_platz, in_login_id, in_drucker, in_et_drucker_name);
      if in_drucker is not NULL
      then
        Result := lvs_lte_drucken (v_lte_id, nvl(in_kunden_nr, v_kunden_nr), in_drucker);
        if v_fuer_lte_id is NOT NULL  -- Wenn LTE-ID aus Linie übergeben, dann icht drucken
        then
          update PE_JOBS t
             set t.status = 'OK'
           where t.job_nr = Result;
        end if;
      end if;

      v_lte_anz := v_lte_anz + 1;
    end loop;

    COMMIT;

    return(Result);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

/*******************************************************************************
 * procedure LV_CS_LTE_TRANSPORT (...)

  COMMIT

 Bucht einen Transport mit und ohne Transportauftrag
 *******************************************************************************/
procedure LVS_C_LTE_TRANSPORT(in_lte_id        in lvs_lte.lte_id%type,
                            in_von_lgr_platz in lvs_lgr.lgr_platz%type,
                            in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
                            in_user_id       in isi_user.login_id%type
                           ) is
begin

  lvs_lte_transport(in_lte_id, in_von_lgr_platz, in_zu_lgr_platz, in_user_id);
  commit;
  -------------------------------------------------------------------------------------------------------
/*
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
*/
end;

procedure lvs_lte_transport(in_lte_id        in lvs_lte.lte_id%type,
                            in_von_lgr_platz in lvs_lgr.lgr_platz%type,
                            in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
                            in_user_id       in isi_user.login_id%type
                           ) is

begin
  lvs_transport.lvs_lte_transport(in_lte_id,           -- in lvs_lte.lte_id%type,
                                  in_von_lgr_platz,    -- in lvs_lgr.lgr_platz%type,
                                  in_zu_lgr_platz,     -- in lvs_lgr.lgr_platz%type,
                                  in_user_id           -- in isi_user.login_id%type
                                 );
end;

/*******************************************************************************
 * procedure LVS_C_LTE_LIEF_LOESCHEN (...)

 Loescht den Lieferscheinauftrg für diese Palette
 *******************************************************************************/
procedure LVS_C_LTE_LIEF_LOESCHEN (in_lte_id    in     lvs_lte.lte_id%type
                                  ) is
begin
  delete isi_liefs l
    where l.lte_id = in_lte_id;
  commit;
end;

procedure LVS_C_LTE_LIEF_ERZEUGEN  (in_lte_id    in     lvs_lte.lte_id%type,
                                    in_liefers   in     isi_liefs.li_nr%type,
                                    in_kunde     in     isi_liefs.adress_nr%type
                                   ) is
begin
  LVS_LTE_LIEF_ERZEUGEN (
   in_lte_id,
   in_liefers,
   in_kunde);

   commit;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

procedure LVS_LTE_LIEF_ERZEUGEN (in_lte_id    in     lvs_lte.lte_id%type,
                                 in_liefers   in     isi_liefs.li_nr%type,
                                 in_kunde     in     isi_liefs.adress_nr%type
                                ) is

  v_lte               lvs_lte%rowtype;       -- Daten der transporteinheit (Für den Lagerplatz)
  v_lam               lvs_lam%rowtype;       -- Daten des Materials
  v_liefs             isi_liefs%rowtype;     -- Daten des Lieferschein (Bereits erstellt)
  v_order_pos         isi_order_pos%rowtype; -- ISI-Order Daten
  v_transport         isi_transport%rowtype;
  v_lhm               isi_liefs.v_lhm_id%type;    -- LHM-ID des Ersten Krtons auf dieser Palette

  v_found             boolean;

  CURSOR c_lte is                            -- Lesen der Transporteinheit für den Lagerplatz
    select *
    from lvs_lte lte
    where lte.lte_id = in_lte_id;

  CURSOR c_liefers is
    select *
      from isi_liefs l
     where l.sid        = v_lte.sid
       and l.firma_nr   = v_lte.firma_nr
       and l.li_nr      = in_liefers
       and l.artikel_id = v_lam.artikel_id
       and nvl(l.charge_id, nvl(v_lam.charge_id, -1))  = nvl(v_lam.charge_id, -1)
       and nvl(l.serie_id, nvl(v_lam.serie_id, -1)) = nvl(v_lam.serie_id, -1);

  CURSOR c_order_pos IS
    select ord.*
      from isi_order_pos ord
     where ord.sid                                       = v_lte.sid
       and ord.firma_nr                                  = v_lte.firma_nr
       and ord.li_nr                                     = in_liefers
       and ord.artikel_id                                = v_lam.artikel_id
       and nvl(ord.charge_id, nvl(v_lam.charge_id, -1))  = nvl(v_lam.charge_id, -1)
       and nvl(ord.seriennr_id, nvl(v_lam.serie_id, -1)) = nvl(v_lam.serie_id, -1);

  CURSOR c_lam is
    select *
      from lvs_lam lam
     where lam.sid = v_lte.sid
       and lam.firma_nr = v_lte.firma_nr
       and lam.lte_id = in_lte_id
     order by lam.zug_datum;

  CURSOR c_liefers_lte is
    select *
      from isi_liefs l
     where l.sid        = v_lte.sid
       and l.firma_nr   = v_lte.firma_nr
       and l.li_nr      = in_liefers
       and l.lte_id     = in_lte_id;

begin
  v_lhm := NULL;
  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;         -- LTE noch eingetragen ?
  CLOSE c_lte;

  if not v_found
  then
    raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(in_lte_id,'NULL')));
  end if;

  if v_lte.waren_typ = C.LEERPAL
  then
    raise_isi_error(11, LC.ec_p1(LC.O_TP1_LTE_ID_IST_LEER, nvl(in_lte_id,'NULL')));
  end if;

  OPEN c_liefers_lte;
  FETCH c_liefers_lte into v_liefs;
  v_found := c_liefers_lte%FOUND;
  CLOSE c_liefers_lte;

  if v_found
  then
    raise_isi_error(15, LC.ec_p3(LC.O_TP3_LTE_M_LIEFERS_VORHADEN,  nvl(in_lte_id,'NULL'), v_liefs.li_nr, v_liefs.li_pos_nr));
  end if;

  OPEN c_lam;
  LOOP
    FETCH c_lam into v_lam;                 -- LagerArtikelMaterial Eintrag lesen
    EXIT when c_lam%NOTFOUND;               -- Kein Eintrag mehr da

    if v_order_pos.sid                               = v_lte.sid and
       v_order_pos.firma_nr                          = v_lte.firma_nr and
       v_order_pos.li_nr                             = in_liefers and
       v_order_pos.artikel_id                        = v_lam.artikel_id and
       nvl(v_order_pos.charge_id, nvl(v_lam.charge_id, -1))  = nvl(v_lam.charge_id, -1) and
       nvl(v_order_pos.seriennr_id, nvl(v_lam.serie_id, -1)) = nvl(v_lam.serie_id, -1) then
      v_found := true;
    else
      OPEN c_order_pos;
      FETCH c_order_pos into v_order_pos;
      v_found := c_order_pos%FOUND;
      CLOSE c_order_pos;
    end if;

    if not v_found then
      OPEN c_liefers;
      FETCH c_liefers into v_liefs;
      v_found := c_liefers%FOUND;
      CLOSE c_liefers;
      v_order_pos.sid         := v_lam.sid;
      v_order_pos.firma_nr    := v_lam.firma_nr;
      v_order_pos.li_nr       := in_liefers;
      v_order_pos.vorgang_typ := 'WAE';
      v_order_pos.satzart     := 'LI';
      v_order_pos.artikel_id  := v_lam.artikel_id;
      v_order_pos.charge_id   := v_lam.charge_id;
      v_order_pos.seriennr_id := v_lam.serie_id;
      v_transport.kunden_nr   := in_kunde;
      v_transport.lte_id      := in_lte_id;
      v_transport.li_nr       := in_liefers;
      if v_found then
        v_transport.li_pos_nr   := v_liefs.li_pos_nr;
        v_order_pos.li_pos_nr   := v_liefs.li_pos_nr;
      else
        v_transport.li_pos_nr   := NULL;
        v_order_pos.li_pos_nr   := NULL;
      end if;
    end if;
    if v_lam.lhm_id is NULL then
      v_lam.lhm_id := 'fehlt';
    end if;
    v_err_nr := NULL;
    v_err_text := NULL;
    lvs_ausl.lvs_liefers_erzeuge_daten(v_transport, v_lam, v_order_pos, NULL, v_lte, v_lhm);
    if v_lhm is null then
      v_lhm := v_lam.lhm_id;
    end if;
  end LOOP;
  CLOSE c_lam;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    if c_lam%ISOPEN
    then
      CLOSE c_lam;
    end if;
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    if c_lam%ISOPEN
    then
      CLOSE c_lam;
    end if;
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

/*******************************************************************************
 * procedure LVS_LTE_TRANS_HIST_LIEF_KD (...)

 Liefert den Kundeneintrag und den Lieferschein (NR) des letzten Transports dieser
 Paltte. Achtung!!!!! Da der Transport abgeschlossen sein muss, werden die Transporte
 in der Historie gesucht
 *******************************************************************************/

procedure LVS_LTE_TRANS_H_GET_LIEF_KD (in_lte_id      in     lvs_lte.lte_id%type,
                                       out_liefers   out    isi_liefs.li_nr%type,
                                       out_kunde     out    isi_liefs.adress_nr%type
                                      ) is

  v_lte               lvs_lte%rowtype;       -- Daten der transporteinheit (Für den Lagerplatz)
  v_trh               isi_transport_hist%rowtype; -- Daten aus erledigten Transporten

  v_found             boolean;

  CURSOR c_lte is                            -- Lesen der Transporteinheit für den Lagerplatz
    select *
    from lvs_lte lte
    where lte.lte_id = in_lte_id;

  CURSOR c_trh is
    select *
      from isi_transport_hist trh
     where trh.sid = v_lte.sid
       and trh.firma_nr = v_lte.firma_nr
       and trh.lte_id = in_lte_id
       and trh.transp_id in (select max(trh2.transp_id)
                               from isi_transport_hist trh2
                              where trh2.sid = v_lte.sid
                                and trh2.firma_nr = v_lte.firma_nr
                                and trh2.lte_id = in_lte_id
                              group by trh2.lte_id);

begin
  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;         -- LTE noch eingetragen ?
  CLOSE c_lte;

  if not v_found
  then
    raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
  end if;

  OPEN c_trh;
  FETCH c_trh into v_trh;
  --v_found := c_trh%FOUND;
  CLOSE c_trh;

  out_kunde := v_trh.kunden_nr;
  out_liefers := v_trh.li_nr;

exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
       raise;
    end if;
end;

/*******************************************************************************
 * procedure LVS_C_LTE_LIEF_STATUS (...)

 Setzt den Status des Lieferscheineintrags für eine Palette auf
 aktive   =  NULL
 inaktive != NULL
 *******************************************************************************/
procedure LVS_C_LTE_LIEF_STATUS  (in_lte_id    in     lvs_lte.lte_id%type,
                                  in_lief_nr   in     isi_liefs.li_nr%type,
                                  in_grund     in     isi_liefs.inaktiv_grund%type
                                 ) is

    v_order_pos     isi_order_pos%ROWTYPE;
    v_lam           lvs_lam%rowtype; -- Lagerbestand Menge
    v_lte           lvs_lte%ROWTYPE; -- Daten einer Transporteinheit

    v_lte_kg        lvs_lte.lte_akt_kg%type;

    v_found         boolean;

    CURSOR c_lte IS
      select lte.*
        from lvs_lte lte
       where lte.lte_id = in_lte_id;

    CURSOR c_order_pos IS
      select ord.*
        from isi_order_pos ord
       where ord.sid = v_lte.sid
         and ord.firma_nr = v_lte.firma_nr
         and ord.auf_id = v_lam.order_pos_auf_id;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = v_lte.sid
         and lam.firma_nr = v_lte.firma_nr
         and lam.lte_id = in_lte_id;

begin
  reset_isi_error();

  OPEN c_lte;
  FETCH c_lte into v_lte; -- Lesen der Transporteinheit
  v_found := c_lte%FOUND;
  CLOSE c_lte;
  v_lte_kg := v_lte.lte_akt_kg;

  if v_found
  and v_lte.waren_typ != c.LEERPAL
  then

    OPEN c_lam;
    LOOP
      FETCH c_lam into v_lam;   -- LagerArtikelMaterial Eintrag lesen
      EXIT when c_lam%NOTFOUND; -- Kein Eintrag mehr da

      OPEN c_order_pos;
      FETCH c_order_pos into v_order_pos; -- Lesen der ISI_ORDER
      CLOSE c_order_pos;

      if v_order_pos.li_nr = in_lief_nr
      then

        if in_grund is not NULL
        then
          v_lam.menge := v_lam.menge * -1;
          v_lam.lam_kg := v_lam.lam_kg * -1;
          v_lte_kg := v_lte_kg * -1;
        end if;

        if v_order_pos.menge_basis = c.BASIS_LTE
        then
          v_order_pos.ist_menge := v_order_pos.ist_menge + 1;
        else
          v_order_pos.ist_menge := v_order_pos.ist_menge + v_lam.menge;
        end if;
        if v_lte.waren_typ = c.MISCHPAL then
          v_order_pos.brutto_kg := nvl(v_order_pos.brutto_kg, 0) + v_lam.lam_kg;
        end if;
        -- Wenn keine Mischpalette kann des Restgewicht auf die Position gebucht werden
        if v_lte.waren_typ != c.MISCHPAL then
          v_order_pos.brutto_kg := v_order_pos.brutto_kg + v_lte_kg;
          v_lte_kg := 0;
        end if;
        if v_order_pos.status = 'X' then
          v_order_pos.status := 'B';
          update isi_order_kopf k
             set k.status = 'B'
           where k.sid = v_order_pos.sid
             and k.firma_nr = v_order_pos.firma_nr
             and k.vorgang_typ = v_order_pos.vorgang_typ
             and k.vorgang_id = v_order_pos.vorgang_id;
        end if;
        update isi_order_pos pos
           set pos.ist_menge = v_order_pos.ist_menge,
               pos.brutto_kg = v_order_pos.brutto_kg,
               pos.status = v_order_pos.status
         where pos.sid = v_lte.sid
           and pos.auf_id = v_lam.order_pos_auf_id;
        -- Wenn Auftrag vom HOST dann melden
      else
        v_err_nr := 20;
        v_err_text := LC.ec_p1(LC.O_TP1_LTE_LIEFERS_DIFF, nvl(in_lte_id, 'NULL'));
      end if;
    end LOOP;
    if c_lam%ROWCOUNT = 0
    then
      v_err_nr := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_AUSGEL, nvl(in_lte_id, 'NULL'));
    end if;
    CLOSE c_lam;
  else
    -- -AG- 09.04.2014 Keinen Fehler melden wenn LTE ausgelagert. Kann auch auf dem LKW beschädigt worden sein
    --v_err_nr := 30;
    v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_AUSGEL, nvl(in_lte_id, 'NULL'));
    --raise v_error;
  end if;

  if v_err_nr is not NULL
  then
    raise v_error;
  end if;

  update isi_liefs l
      set l.inaktiv_grund = in_grund
    where l.li_nr = in_lief_nr
      and l.lte_id = in_lte_id;

  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    if c_lam%ISOPEN
    then
      CLOSE c_lam;
    end if;
    rollback;
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    if c_lam%ISOPEN
    then
      CLOSE c_lam;
    end if;
    rollback;
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

procedure LVS_LTE_TRANSP_GEN(in_sid            in isi_sid.sid%type,
                             in_firma_nr       in isi_firma.firma_nr%type,
                             in_modul_erzeuger in isi_transport.Modul_Erzeuger%TYPE,
                             in_lte_id         in lvs_lte.lte_id%type,
                             in_zu_lgr_platz   in lvs_lgr.lgr_platz%type,
                             in_prio           in number,
                             in_user_id        in isi_user.login_id%type,
                             in_fetig_bis      in date default NULL
                            ) is

  v_result          integer;
  v_transp_id       isi_transport.transp_id%type;
  v_transport_gruppe       isi_transport.transport_gruppe%type;
begin
  v_err_nr := NULL;
  v_err_text := NULL;

  v_transport_gruppe := 0;
  v_result := lvs_transport.lvs_transp_lte (in_sid,
                                            in_firma_nr,
                                            in_modul_erzeuger,
                                            NULL,
                                            C.C_FALSE,
                                            NULL,
                                            in_user_ID,
                                            NULL,
                                            NULL,
                                            in_prio,
                                            0,
                                            0,
                                            0,
                                            NULL,
                                            in_zu_lgr_platz,
                                            in_lte_id,
                                            NULL,
                                            C.C_FALSE,
                                            NULL,
                                            NULL,
                                            NULL,
                                            NULL,             -- in_fahrzeuge_IDs Transport soll in jedem Fall erzeugt werden, auch wenn das Fahrzeug gestört ist
                                            NULL,
                                            v_transport_gruppe,
                                            v_transp_id,
                                            NULL,
                                            in_fetig_bis);

  if v_result != 0
  then
    raise_isi_error(10, c.DECODE_FUNCTION_FEHLER(v_result));
  end if;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

procedure LVS_C_LTE_TRANSP_GEN(in_sid            in isi_sid.sid%type,
                               in_firma_nr       in isi_firma.firma_nr%type,
                               in_modul_erzeuger in isi_transport.Modul_Erzeuger%TYPE,
                               in_lte_id         in lvs_lte.lte_id%type,
                               in_zu_lgr_platz   in lvs_lgr.lgr_platz%type,
                               in_prio           in number,
                               in_user_id        in isi_user.login_id%type,
                               in_fetig_bis      in date default NULL
                              ) is
begin
  lvs_lte_transp_gen(in_sid, in_firma_nr, in_modul_erzeuger, in_lte_id, in_zu_lgr_platz, in_prio, in_user_id, in_fetig_bis);
  commit;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    rollback;
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

/*******************************************************************************
 * function LVS_LTE_PRUEFE_PLATZ (...)

 Prüft einen  Platz gegen für die Einlagerung einer Palette
 *******************************************************************************/
function LVS_LTE_PRUEFE_PLATZ(in_lte_id          in lvs_lte.lte_id%type,
                              in_lgr_platz       in lvs_lgr.lgr_platz%type
                              ) return varchar2 is

  v_lte      lvs_lte%rowtype;
  v_lgr      lvs_lgr%rowtype;

  v_lgr_text varchar2(255);

  v_found             boolean;

  v_lte_cfg            lvs_lte_cfg%rowtype;
  v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

  CURSOR c_lte_cfg is
    select t.*
      from lvs_lte_cfg t
     where t.sid = v_lte.sid
       and t.firma_nr = v_lte.firma_nr
       and t.lte_name = v_lte.lte_name;


  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = in_lte_id;

  CURSOR c_lgr is
    select *
      from lvs_lgr lgr
     where lgr.lgr_platz = in_lgr_platz;
begin
  OPEN c_lgr;
  FETCH c_lgr into v_lgr;
  v_found := c_lgr%FOUND;
  CLOSE c_lgr;

  if not v_found
  then
    raise_isi_error(10, LC.ec_p2(LC.O_TP2_PLATZ_EXISTIERT_NICHT, in_lgr_platz, in_lte_id));
  end if;

  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;
  CLOSE c_lte;
  if not v_found
  then
    raise_isi_error(20, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
  end if;

  OPEN c_lte_cfg;
  FETCH c_lte_cfg into v_lte_cfg;
  CLOSE c_lte_cfg;

  v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(v_lte,
                                                         v_basis_lte_name,
                                                         v_lte_cfg.flaechen_stellplatz_erf,
                                                         v_lgr,
                                                         'E',
                                                         NULL);

  return (nvl(v_lgr_text, 'OK'));

exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    if v_err_nr is not NULL then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

/*******************************************************************************
 * function lagert eine LTE mit Status AF aus (AG) (...)

 *******************************************************************************/
function LVS_C_LTE_AUSLAGERN(in_lte_id          in lvs_lte.lte_id%type,
                             in_tour_nr         in isi_order_pos.vorgang_id%type,
                             in_user_id         in isi_user.login_id%type
                            ) return varchar2 is
  v_result  varchar2(20);
begin
  v_result := LVS_LTE_AUSLAGERN(in_lte_id, in_tour_nr, in_user_id);
  commit;
  return(v_result);
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    rollback;
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    rollback;
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

function LVS_LTE_AUSLAGERN(in_lte_id          in lvs_lte.lte_id%type,
                           in_tour_nr         in isi_order_pos.vorgang_id%type,
                           in_user_id         in isi_user.login_id%type
                          ) return varchar2 is

  v_lte      lvs_lte%rowtype;
  v_lgr      lvs_lgr%rowtype;
  v_lam                lvs_lam%rowtype;           -- Lagerbestand Menge
  v_lam_anz                lvs_lam%rowtype;           -- Lagerbestand Menge
  v_order_pos               isi_order_pos%rowtype;
  v_anz_pos number; -- Anzahl der AUF_ID's diesen Vorgangs

  v_found             boolean;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = in_lte_id;

  CURSOR c_lgr is
    select *
      from lvs_lgr lgr
     where lgr.lgr_platz = v_lte.lgr_platz;

  CURSOR c_order_pos is
    select *
      from isi_order_pos pos
     where pos.sid = v_lte.sid
       and pos.firma_nr = v_lte.firma_nr
       and pos.auf_id = v_lam.order_pos_auf_id;

  -- Zum Lesen der Positionen die bereits fertig sind und auf 'E' gesetzt werden müssen
  CURSOR c_order_pos_x is
    select *
      from isi_order_pos pos
     where pos.sid = v_lte.sid
       and pos.firma_nr = v_lte.firma_nr
       and pos.vorgang_typ = 'WAE'
       and pos.status = 'x';

  CURSOR c_lam is
    select *
      from lvs_lam lam
     where lam.sid = v_lte.sid
       and lam.firma_nr = v_lte.firma_nr
       and lam.lte_id = v_lte.lte_id;

  CURSOR c_lam_ausl is
    select *
      from lvs_lam lam
     where lam.sid = v_order_pos.sid
       and lam.firma_nr = v_order_pos.firma_nr
       and lam.order_pos_auf_id = v_order_pos.auf_id
       and lam.lgr_platz is not NULL
       and lam.lte_id != v_lte.lte_id;

  cursor c_pos_anz is
    select count(auf_id)
      from isi_order_pos pos
     where pos.sid = v_order_pos.sid
       and pos.vorgang_typ = v_order_pos.vorgang_typ
       and pos.vorgang_id = v_order_pos.vorgang_id
       and pos.auf_id != v_order_pos.auf_id
       and pos.status != 'E'
     group by pos.vorgang_typ, pos.vorgang_id;

begin

  v_err_nr := NULL;
  v_err_text := NULL;

  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;
  CLOSE c_lte;
  if not v_found
  then
    raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
  end if;

  if nvl(v_lte.order_vorgang_id, 0) != in_tour_nr
  and nvl(in_tour_nr, 0) > 0 -- WK 2015-09-16: 0 wie NULL gleich behandeln
  then
    raise_isi_error(10, LC.ec_p2(LC.O_TP2_LTE_ID_RES_ERR, nvl(in_lte_id,'NULL'), to_char(in_tour_nr)));
  end if;

  if v_lte.lte_status = c.LTE_AF_STAT
  then
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if not v_found
    then
      raise_isi_error(30, LC.ec_p1(LC.O_TP1_LAGERPLATZ_FEHLT, nvl(v_lte.lgr_platz,'NULL')));
    end if;
    OPEN c_lam;
    LOOP
      FETCH c_lam into v_lam;                 -- LagerArtikelMaterial Eintrag lesen
      EXIT when c_lam%NOTFOUND;               -- Kein Eintrag mehr da
      OPEN c_order_pos;
      FETCH c_order_pos into v_order_pos;
      v_found := c_order_pos%FOUND;
      CLOSE c_order_pos;

      if not v_found
      then
        v_order_pos.besteller := NULL;
        v_order_pos.arbeitsplatz_id := NULL;
        v_order_pos.vorgang_typ := NULL;
        v_order_pos.auf_id_extern := NULL;
        v_order_pos.li_nr := NULL;
        v_order_pos.li_pos_nr := NULL;
        v_order_pos.status := 'N';
        v_order_pos := NULL;
      end if;

      -- 30.10.2008 -AG- Obsolate, Lieferscheine werden definiert im Dialog auf Fertig gesetzt
      --                 da Schnittstellen wie SAP mit Zweifachmeldungen einer Positionsendemeldung
      --                 nicht umgehen kann
      if  v_order_pos.status = 'X'
      and v_order_pos.auf_id_extern is NULL -- Diese Position ist intern erfasst und kann wie gehabt abgearbeitet werden
      then
        OPEN c_lam_ausl;
        FETCH c_lam_ausl
          into v_lam_anz;
        v_found := c_lam_ausl%FOUND;
        CLOSE c_lam_ausl;
        if not v_found then
          -- Wenn nichts offen dann Status auf 'x' um diesen dann nach dem Ausbuchen als fertig zu melden
          -- ist notwendig, da das Fertigmelden auch in die Schnittstelle gemeldet werden muss und dies in
          -- der richtigen Reihenfolge geschehen muss. Schnittstelle druckt Lieferschein mit allen Chargen
          -- die Ausgebucht sind.
          update isi_order_pos pos
             set pos.status = 'x'
           where pos.sid = v_lte.sid
             and pos.firma_nr = v_lte.firma_nr
             and pos.auf_id = v_lam.order_pos_auf_id;
        end if;
      end if;
    end LOOP;
    CLOSE c_lam;
    -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
    v_lam.lam_id := lvs_ausl.lvs_lam_abgang (v_lte.sid, v_lte.firma_nr, v_lam.artikel_id,
                                             v_lte.lte_id, NULL, v_order_pos.auftrag,
                                             NULL, sysdate, in_user_id, NULL, NULL, NULL, NULL, NULL, NULL, c.LAM_BH_BUS_ABG,
                                             v_order_pos.vorgang_id, v_order_pos.li_nr, v_order_pos.li_pos_nr);
    if v_lam.lam_id < 0
    then
      raise_isi_error(15, LC.ec_p1(LC.O_TP1_LTE_ID_GESP_WARE_AUSL, nvl(v_lte.lte_id, 'NULL')));
    end if;

    -- reservierung
    update lvs_lte lte
       set lte.lgr_platz = NULL,
           lte.lgr_platz_gruppe = NULL,
           lte.lgr_ort = NULL,
           lte.ziel_lgr_ort = NULL,
           lte.ziel_lgr_platz = NULL,
           lte.ziel_lgr_ort_n_freif = NULL,
           lte.ziel_lgr_platz_n_freif = null,
           -- WK 2015-09-16: Reservierung ebenfalls zurücksetzen bei AG (für Wiederverwendung)
           lte.order_vorgang_id = null,
           lte.order_auf_id = null
     where lte.sid = v_lte.sid
       and lte.lte_id = v_lte.lte_id;
  else
    raise_isi_error(20, LC.ec_p2(LC.O_TP2_LTE_ID_ST_N_AUSL_BAR, in_lte_id, v_lte.lte_status));
  end if;

  -- Jetzt alle fertigen noch auf 'E'nde setzen und dies in die Schnittstelle schreiben
  -- da jetzt alle Mengen und Chargen gebucht sind
  OPEN c_order_pos_x;
  LOOP
    FETCH c_order_pos_x into v_order_pos;
    EXIT when c_order_pos_x%NOTFOUND;

    -- Die Felder für das Schnittstelleschreiben verbiegen
    v_order_pos.status      := 'E';
    if v_order_pos.li_extern = 'B'
    then
      v_order_pos.vorgang_typ := 'BLF';
    --else
    --  v_order_pos.vorgang_typ := 'LIF';
    end if;
    v_lam.lte_id            := NULL;
    v_lam.artikel_id        := NULL;
    v_lam.charge_id         := NULL;
    v_lam.firma_nr          := v_order_pos.firma_nr;
    v_lam.sid               := v_order_pos.sid;

    OPEN c_pos_anz; -- Offene Positionen Lesen
    FETCH c_pos_anz
      into v_anz_pos;
    v_found := c_pos_anz%FOUND; -- Keine offenen Positionen mehr
    CLOSE c_pos_anz;

    update isi_order_pos pos
       set pos.status = v_order_pos.status
     where pos.sid = v_order_pos.sid
       and pos.auf_id = v_order_pos.auf_id;
    if not v_found
    or v_anz_pos = 0
    then
      update isi_order_kopf kopf
         set kopf.status = 'E'
       where kopf.sid = v_order_pos.sid
         and kopf.vorgang_typ = v_order_pos.vorgang_typ
         and kopf.vorgang_id = v_order_pos.vorgang_id;
    end if;

    s_schnittstelle.write_host_bew(v_order_pos, -- in_order_pos   in isi_order_pos%rowtype,
                                   v_lam, -- in_lam         in lvs_lam%rowtype,
                                   NULL, -- in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                                   NULL, -- in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                   NULL, -- in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                   'S_AUF', -- in_tabelle     in varchar2,
                                   'UE', -- in_status      in s_send_bew.status%type,
                                   NULL, -- in_quell_lgr   in lvs_lgr%rowtype,
                                   NULL, -- in_ziel_lgr    in lvs_lgr%rowtype,
                                   NULL,                   -- in_login_id    in isi_user.login_id%type,
                                   v_order_pos.ist_menge); -- in_menge       in number default NULL
  end LOOP;
  CLOSE c_order_pos_x;

  return ('OK');

exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
  when v_error then  -- Update 2011 show Exception Source Line
    if c_lam%ISOPEN
    then
      CLOSE c_lam;
    end if;
    if c_order_pos_x%ISOPEN
    then
      CLOSE c_order_pos_x;
    end if;
    v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
    RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
  when others then
    if c_lam%ISOPEN
    then
      CLOSE c_lam;
    end if;
    if c_order_pos_x%ISOPEN
    then
      CLOSE c_order_pos_x;
    end if;
    if v_err_nr is not null
    then
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    else
      v_err_text := DBMS_UTILITY.format_error_backtrace;
      if v_err_text not like 'ORA-%ORA-%'
      then
        v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
      end if;
      raise;
    end if;
end;

-- -AG- 14.09.2016 Neue Funktion für R$, mit Uebergabe der Transport-ID
function LVS_SUCHE_NEUE_LTE_TRANSP_ID(in_sid                 in isi_sid.sid%type,
                                      in_transport_id        in isi_transport.transp_id%type,
                                      in_user_id         in isi_user.login_id%type
                                     ) return varchar2 is
  v_result                           varchar2(255);
  v_transp                           isi_transport%rowtype;
begin
  v_err_nr := NULL;
  if lvs_p_base.get_transp_by_transp_id(in_sid,
                                        in_transport_id,
                                        v_transp)
  then
    v_result := lvs_p_lte.lvs_suche_neue_lte(v_transp,
                                             in_user_id);
  else
    raise_isi_error(40, lc.ec_p1(lc.O_TP1_TRANSP_DATA_NF, in_transport_id));
  end if;
  return(v_result);
exception
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

function lvs_suche_neue_lte(in_transport       in isi_transport%rowtype,
                            in_user_id         in isi_user.login_id%type
                           ) return varchar2 is
  v_result                           varchar2(255);
begin
  v_result := lvs_p_lte.lvs_suche_neue_lte_old_crtl(in_transport,
                                                    in_user_id,
                                                    'AUSB',
                                                    NULL);
  return(v_result);
end;




function lvs_suche_neue_lte_old_crtl(in_transport       in isi_transport%rowtype,
                                     in_user_id         in isi_user.login_id%type,
                                     in_lte_crtl        in varchar2,
                                     in_lte_id          in lvs_lte.lte_id%type
                                    ) return varchar2 is

  v_found                boolean;
  v_result               varchar2(255);
begin
  v_result := lvs_p_lte.lvs_suche_neue_lte_old_crtl_31(in_transport,
                                                       in_user_id,
                                                       in_lte_crtl,
                                                       in_lte_id);
  return(v_result);
end;

function lvs_neue_lte_res_nio_transp(in_transport_id    in isi_transport.transp_id%type,
                                     in_user_id         in isi_user.login_id%type,
                                     in_lte_id          in lvs_lte.lte_id%type
                                    ) return varchar2 is

  v_found                boolean;
  v_ret                  varchar2(100);
  v_res_id               isi_resource.res_id%type;

  v_lte_id               lvs_lte.lte_id%type;
  v_lte                  lvs_lte%rowtype;
  v_g_lam                lvs_lam%rowtype;
  v_e_lam                lvs_lam%rowtype;

  v_lgr_ziel             lvs_lgr%rowtype;
  v_lgr_quelle           lvs_lgr%rowtype;
  v_lgr_neue_quelle      lvs_lgr%rowtype;
  v_transport            isi_transport%rowtype;
  v_transp_richtung varchar2(3);
  v_neuer_status         lvs_lte.lte_status%type;

  v_lgr_platz            lvs_lgr.lgr_platz%type;

  v_lam_lte_id           lvs_lam.lte_id%type;
  v_lam_artikel_id       lvs_lam.artikel_id%type;
  v_menge                lvs_lam.menge%type;
  v_menge_sum            lvs_lam.menge%type;
  v_res_menge            lvs_lam.res_menge%type;
  v_lgr_ort              lvs_lgr_ort.lgr_ort%type;
  v_lgr_adresse          lvs_lgr_ort.adress_id%type;
  v_lgr_dim_platz        lvs_lgr.lgr_dim_platz%type;
  v_auf_id               lvs_lam.order_pos_auf_id%type;

  v_max_lam_charge_id    lvs_lam.charge_id%type;
  v_max_lam_leitzahl     lvs_lam.leitzahl%type;
  v_max_lam_fa_ag        lvs_lam.fa_ag%type;

  v_min_lam_charge_id    lvs_lam.charge_id%type;
  v_min_lam_leitzahl     lvs_lam.leitzahl%type;
  v_min_lam_fa_ag        lvs_lam.fa_ag%type;

  v_min_lam_sel1         lvs_lam.lam_sel1%type;
  v_min_lam_sel2         lvs_lam.lam_sel2%type;
  v_min_lam_sel3         lvs_lam.lam_sel3%type;
  v_min_lam_sel4         lvs_lam.lam_sel4%type;
  v_min_lam_sel5         lvs_lam.lam_sel5%type;
  v_min_lam_sel6         lvs_lam.lam_sel6%type;
  v_min_lam_sel7         lvs_lam.lam_sel7%type;
  v_min_lam_sel8         lvs_lam.lam_sel8%type;
  v_min_lam_sel9         lvs_lam.lam_sel9%type;
  v_min_lam_sel10        lvs_lam.lam_sel10%type;
  v_min_owner_address_id lvs_lam.owner_address_id%type;
  v_min_labor_status     lvs_lam.labor_status%type;

  v_max_lam_sel1         lvs_lam.lam_sel1%type;
  v_max_lam_sel2         lvs_lam.lam_sel2%type;
  v_max_lam_sel3         lvs_lam.lam_sel3%type;
  v_max_lam_sel4         lvs_lam.lam_sel4%type;
  v_max_lam_sel5         lvs_lam.lam_sel5%type;
  v_max_lam_sel6         lvs_lam.lam_sel6%type;
  v_max_lam_sel7         lvs_lam.lam_sel7%type;
  v_max_lam_sel8         lvs_lam.lam_sel8%type;
  v_max_lam_sel9         lvs_lam.lam_sel9%type;
  v_max_lam_sel10        lvs_lam.lam_sel10%type;
  v_max_owner_address_id lvs_lam.owner_address_id%type;
  v_max_labor_status     lvs_lam.labor_status%type;

  v_e_lam_charge_id      lvs_lam.charge_id%type;
  v_e_lam_leitzahl       lvs_lam.leitzahl%type;
  v_e_lam_fa_ag          lvs_lam.fa_ag%type;
  v_e_menge              lvs_lam.menge%type;

  v_e_lam_sel1           lvs_lam.lam_sel1%type;
  v_e_lam_sel2           lvs_lam.lam_sel2%type;
  v_e_lam_sel3           lvs_lam.lam_sel3%type;
  v_e_lam_sel4           lvs_lam.lam_sel4%type;
  v_e_lam_sel5           lvs_lam.lam_sel5%type;
  v_e_lam_sel6           lvs_lam.lam_sel6%type;
  v_e_lam_sel7           lvs_lam.lam_sel7%type;
  v_e_lam_sel8           lvs_lam.lam_sel8%type;
  v_e_lam_sel9           lvs_lam.lam_sel9%type;
  v_e_lam_sel10          lvs_lam.lam_sel10%type;
  v_e_owner_address_id   lvs_lam.owner_address_id%type;
  v_e_labor_status       lvs_lam.labor_status%type;

  v_lte_name             lvs_lte.lte_name%type;

  -- Tabelle für die Erzeugung von Staffeltransporten
  v_lvs_lgr_ort_ue_platz lvs_lgr_ort_ue_platz%rowtype;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = v_lte_id;

  CURSOR c_lam_g is
    select lam.lte_id,
           lam.artikel_id,
           min(lam.charge_id) nin_ch,
           max(lam.charge_id) nax_ch,
           min(lam.leitzahl) min_leitzahl,
           max(lam.leitzahl) max_leitzahl,
           min(lam.fa_ag) min_fa_ag,
           max(lam.fa_ag) max_fa_ag,
           sum(lam.menge),
           sum(nvl(lam.res_menge, 0)),
           min(lam.order_pos_auf_id),
           min(lam.lam_sel1),
           min(lam.lam_sel2),
           min(lam.lam_sel3),
           min(lam.lam_sel4),
           min(lam.lam_sel5),
           min(lam.lam_sel6),
           min(lam.lam_sel7),
           min(lam.lam_sel8),
           min(lam.lam_sel9),
           min(lam.lam_sel10),
           max(lam.lam_sel1),
           max(lam.lam_sel2),
           max(lam.lam_sel3),
           max(lam.lam_sel4),
           max(lam.lam_sel5),
           max(lam.lam_sel6),
           max(lam.lam_sel7),
           max(lam.lam_sel8),
           max(lam.lam_sel9),
           max(lam.lam_sel10),
           min(lam.owner_address_id),
           max(lam.owner_address_id),
           min(lam.labor_status),
           max(lam.labor_status),
           ort.lgr_ort,
           ort.adress_id,
           lgr.lgr_dim_platz
      from lvs_lam lam,
           lvs_lgr lgr,
           lvs_lgr_ort ort
     where lam.sid          = v_lte.sid
       and lam.firma_nr     = v_lte.firma_nr
       and lam.lte_id       = v_lte.lte_id
       and lam.lgr_platz    = lgr.lgr_platz(+)
       and lgr.lgr_ort      = ort.lgr_ort(+)
     group by lam.lte_id,
              lam.artikel_id,
              lam.lgr_platz,
              ort.lgr_ort,
              ort.adress_id,
              lgr.lgr_dim_platz;

  CURSOR c_lam_e is
    select lam.lte_id,
           lam.artikel_id,
           min(lam.charge_id) min_ch,
           max(lam.charge_id) max_ch,
           min(lam.leitzahl) min_leitzahl,
           max(lam.leitzahl) max_leitzahl,
           min(lam.fa_ag) min_fa_ag,
           max(lam.fa_ag) max_fa_ag,
           sum(lam.menge) sum_menge,
           ort.lgr_ort,
           ort.adress_id,
           lgr.lgr_dim_platz,
           lte.lgr_platz,
           lte.lte_name
      from lvs_lam lam,
           lvs_lte lte,
           lvs_lgr lgr,
           lvs_lgr_ort ort
     where lam.sid = v_lte.sid
       and lam.firma_nr = v_lte.firma_nr
       and lam.lte_id != v_lte.lte_id
       and lte.lte_id = lam.lte_id
       and lte.lte_status in (c.LTE_LF_STAT, c.LTE_BF_STAT)
       and not exists (select x.lte_id from lvs_lam x where x.lte_id = lam.lte_id and x.order_pos_auf_id is not NULL)
       and lam.artikel_id = v_lam_artikel_id
       and nvl(lam.fa_ag, -1) = nvl(v_e_lam_fa_ag, -1)
       and lte.lgr_platz = lgr.lgr_platz
       and lte.lgr_ort = ort.lgr_ort
       and lte.order_vorgang_id is NULL
       -- Korrigierte Variante. Wenn der FA_AG der übergebenen LTE nicht null ist, dann über Leitzahl prüfen
       -- 20190606 (W24210-368 Auslagerungen RBG_5 werden nicht substituiert)
       and (v_e_lam_fa_ag is null or
            nvl(lam.leitzahl, -1) = nvl(v_e_lam_leitzahl, nvl(lam.leitzahl, -1)))
       -- Alte Variante liefert falsche Ergebnis Menge CMe/DTs 20190606
       --and nvl(lam.leitzahl, -1) = nvl(v_e_lam_leitzahl, nvl(lam.leitzahl, -1)) -- Leitzahl beruecksichtigen
       and nvl(lam.fa_ag, -1) = nvl(v_e_lam_fa_ag, -1)-- Nur Ware die als Lagerware gilt !!!! AG <> NULL ist halbfertigware
       -- =====================================================================================================================
       and lam.menge > 0                                   -- Nur wenn Lagermengen vorhanden
       and lam.akt_inventur_id is null                      -- nur Ware reservieren die nicht in Inventur sind
       -- -AG- 2015.05.12 Geaenderte selektirungsparameter Begin
       and lam.labor_status = v_e_labor_status
       -- -AG- 2015.05.12 Geaenderte selektirungsparameter End
       -- -AG- 2015.05.12 Neue selektirungsparameter Begin
       and nvl(lam.lam_sel1, 'lam.lam_sel') = nvl(v_e_lam_sel1, 'lam.lam_sel')
       and nvl(lam.lam_sel2, 'lam.lam_sel') = nvl(v_e_lam_sel2, 'lam.lam_sel')
       and nvl(lam.lam_sel3, 'lam.lam_sel') = nvl(v_e_lam_sel3, 'lam.lam_sel')
       and nvl(lam.lam_sel4, 'lam.lam_sel') = nvl(v_e_lam_sel4, 'lam.lam_sel')
       and nvl(lam.lam_sel5, 'lam.lam_sel') = nvl(v_e_lam_sel5, 'lam.lam_sel')
       and nvl(lam.lam_sel6, 'lam.lam_sel') = nvl(v_e_lam_sel6, 'lam.lam_sel')
       and nvl(lam.lam_sel7, 'lam.lam_sel') = nvl(v_e_lam_sel7, 'lam.lam_sel')
       and nvl(lam.lam_sel8, 'lam.lam_sel') = nvl(v_e_lam_sel8, 'lam.lam_sel')
       and nvl(lam.lam_sel9, 'lam.lam_sel') = nvl(v_e_lam_sel9, 'lam.lam_sel')
       and nvl(lam.lam_sel10, 'lam.lam_sel') = nvl(v_e_lam_sel10, 'lam.lam_sel')
       -- -AG- 2015.05.12 Neue selektirungsparameter End
       and trunc(lam.lam_mhd) >= sysdate
       and lgr.gesperrt = C.LGR_GESPERRT_F
       and ort.lgr_ort = v_lgr_ort
       and (  lam.owner_address_id = v_e_owner_address_id  -- genau von diesem Kunden
            or lam.owner_address_id is NULL                -- oder kein Keine KONSI-Ware
           )
       and lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(lte.lte_id) = 'T'
       -- Berücksichtigen des Zeichnungsindex
      group by lam.lte_id,
              lam.artikel_id,
              ort.lgr_ort,
              ort.adress_id,
              lgr.lgr_dim_platz,
              lte.lgr_platz,
              lte.lte_name
        order by abs(sum_menge - v_menge),
                 abs(decode(min_ch, max_ch, max_ch, NULL) - v_e_lam_charge_id),
                 abs(decode(min_leitzahl, max_leitzahl, min_leitzahl, NULL) - v_e_lam_leitzahl),
                 abs(ort.lgr_ort - v_lgr_ort),
                 abs(lgr.lgr_dim_platz - v_lgr_dim_platz);

  CURSOR c_lvs_lgr is                             -- Lesen des Lagerplatz
   select *
     from lvs_lgr lgr
    where lgr.lgr_platz = v_lgr_platz;

  CURSOR c_lam_g_lte is
    select *
      from lvs_lam l
     where l.lte_id = v_lte.lte_id
       and l.order_pos_auf_id is not NULL;

  --CMe 20220811 MHD berücksichtigen
  CURSOR c_lam_e_lte is
    select *
      from lvs_lam l
     where l.lte_id = v_lam_lte_id
       and l.order_pos_auf_id is NULL
       and l.lam_mhd >= sysdate
     order by abs(l.menge - v_g_lam.res_menge),
              l.menge desc;

  CURSOR c_lvs_lgr_grp_fahrzeug is
    select decode (min(fg.res_id), max(fg.res_id), min(fg.res_id), NULL) Res_Id
      from lvs_lgr_grp_fahrzeug fg,
           lvs_fahrzeuge f
     where fg.lgr_gruppe_id = v_lgr_neue_quelle.lgr_gruppe_id
       and fg.lgr_ort = v_lgr_neue_quelle.lgr_ort
       and fg.res_id = f.res_id
       and v_transp_richtung like ('%' || f.transp_richtung || '%');

  pragma autonomous_transaction;
begin
  -- Erst mal die LTE_ID fuer den CURSOR uebertragen
  v_lte_id := in_lte_id;
  v_ret := LC.ec('O_TP1_NO_ACTION_TAKEN');
  SAVEPOINT keine_neue_lte_res_defekt;

  -- Erst mal die LTE-Daten lesen
  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;
  CLOSE c_lte;

  if lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(v_lte.lte_id) = 'T'
  then
    return (v_ret);
  end if;

  -- Schlimmer Fehler, konnte die LTE-Daten nicht lesen (Ist evtl. schon Ausgelagert und aus den Daten genommen?)
  if not v_found
  then
    raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_lte.lte_id, 'NULL')));
  end if;

  if not lvs_p_base.get_transport(v_lte.sid, in_transport_id, v_transport)
  then
    return (v_ret);
  end if;


  -- LTE ist nicht mehr am urspr. Platz
  if v_lte.lgr_platz != v_transport.lgr_platz_quelle
  then
    -- Wenn die Palette bereits am Ziel ist, dann ist alles OK
    if v_lte.lgr_platz = v_transport.lgr_platz_ziel
    then
      delete isi_transport t
       where t.sid = v_transport.sid
         and t.firma_nr = v_transport.firma_nr
         and t.transp_id = v_transport.transp_id;
      v_ret :=  LC.ec(LC.O_TXT_LTE_AM_ZIEL_TR_GELOESCHT);
      -- v_ret := 'LTE bereits am Ziel. Transport gelöscht.';
    end if;
  else
    OPEN c_lam_g;    -- Lesen der Materialien die auf der palette sind
    FETCH c_lam_g into v_lam_lte_id, v_lam_artikel_id, v_min_lam_charge_id, v_max_lam_charge_id,
                       v_min_lam_leitzahl, v_max_lam_leitzahl, v_min_lam_fa_ag, v_max_lam_fa_ag,
                       v_menge, v_res_menge, v_auf_id,
                       v_min_lam_sel1, v_min_lam_sel2, v_min_lam_sel3, v_min_lam_sel4, v_min_lam_sel5,
                       v_min_lam_sel6, v_min_lam_sel7, v_min_lam_sel8, v_min_lam_sel9, v_min_lam_sel10,
                       v_max_lam_sel1, v_max_lam_sel2, v_max_lam_sel3, v_max_lam_sel4, v_max_lam_sel5,
                       v_max_lam_sel6, v_max_lam_sel7, v_max_lam_sel8, v_max_lam_sel9, v_max_lam_sel10,
                       v_min_owner_address_id, v_max_owner_address_id,
                       v_min_labor_status, v_max_labor_status,
                       v_lgr_ort, v_lgr_adresse, v_lgr_dim_platz;
    CLOSE c_lam_g;

    -- Charge FA-Auftrag und Arbeitsgang der Palette ist relevant für die Sortierung zur findung der neuen Palette
    if v_min_lam_charge_id = v_max_lam_charge_id
    then
       v_e_lam_charge_id := v_min_lam_charge_id;      -- Nur wenn alles die gleiche Charge
    else
      v_e_lam_charge_id := NULL;
    end if;
    if v_min_lam_leitzahl =  v_max_lam_leitzahl
    then
      v_e_lam_leitzahl  := v_min_lam_leitzahl;      -- Nur wenn alles gleiche FA-Auftrag
    else
      v_e_lam_leitzahl  := NULL;
    end if;
    if v_min_lam_fa_ag =     v_max_lam_fa_ag
    then
      v_e_lam_fa_ag     := v_min_lam_fa_ag;      -- Nur wenn alles gleicher Arbeitsgang
    else
      v_e_lam_fa_ag     := NULL;
    end if;

    if v_max_lam_sel1 != v_min_lam_sel1
    then
      v_e_lam_sel1 := v_max_lam_sel1 || v_min_lam_sel1;
    else
      v_e_lam_sel1 := v_max_lam_sel1;
    end if;
    if v_max_lam_sel2 != v_min_lam_sel2
    then
      v_e_lam_sel2 := v_max_lam_sel2 || v_min_lam_sel2;
    else
      v_e_lam_sel2 := v_max_lam_sel2;
    end if;
    if v_max_lam_sel3 != v_min_lam_sel3
    then
      v_e_lam_sel3 := v_max_lam_sel3 || v_min_lam_sel3;
    else
      v_e_lam_sel3 := v_max_lam_sel3;
    end if;
    if v_max_lam_sel4 != v_min_lam_sel4
    then
      v_e_lam_sel4 := v_max_lam_sel4 || v_min_lam_sel4;
    else
      v_e_lam_sel4 := v_max_lam_sel4;
    end if;
    if v_max_lam_sel5 != v_min_lam_sel5
    then
      v_e_lam_sel5 := v_max_lam_sel5 || v_min_lam_sel5;
    else
      v_e_lam_sel5 := v_max_lam_sel5;
    end if;
    if v_max_lam_sel6 != v_min_lam_sel6
    then
      v_e_lam_sel6 := v_max_lam_sel6 || v_min_lam_sel6;
    else
      v_e_lam_sel6 := v_max_lam_sel6;
    end if;
    if v_max_lam_sel7 != v_min_lam_sel7
    then
      v_e_lam_sel7 := v_max_lam_sel7 || v_min_lam_sel7;
    else
      v_e_lam_sel7 := v_max_lam_sel7;
    end if;
    if v_max_lam_sel8 != v_min_lam_sel8
    then
      v_e_lam_sel8 := v_max_lam_sel8 || v_min_lam_sel8;
    else
      v_e_lam_sel8 := v_max_lam_sel8;
    end if;
    if v_max_lam_sel9 != v_min_lam_sel9
    then
      v_e_lam_sel9 := v_max_lam_sel9 || v_min_lam_sel9;
    else
      v_e_lam_sel9 := v_max_lam_sel9;
    end if;
    if v_max_lam_sel10 != v_min_lam_sel10
    then
      v_e_lam_sel10 := v_max_lam_sel10 || v_min_lam_sel10;
    else
      v_e_lam_sel10 := v_max_lam_sel10;
    end if;

    if v_max_owner_address_id != v_min_owner_address_id
    then
      v_e_owner_address_id := -1;
    else
      v_e_owner_address_id := v_max_owner_address_id;
    end if;
    if v_max_labor_status != v_min_labor_status
    then
      v_e_labor_status := v_max_labor_status || v_min_labor_status;
    else
      v_e_labor_status := v_max_labor_status;
    end if;

    v_lgr_platz := v_transport.lgr_platz_ziel;
    OPEN c_lvs_lgr;
    FETCH c_lvs_lgr into v_lgr_ziel;
    CLOSE c_lvs_lgr;

    if v_transport.lgr_platz_quelle is not null then
      v_lgr_platz := v_transport.lgr_platz_quelle;
    else
      v_lgr_platz := v_lte.lgr_platz;
    end if;
    OPEN c_lvs_lgr;
    FETCH c_lvs_lgr into v_lgr_quelle;
    v_found := c_lvs_lgr%FOUND;
    CLOSE c_lvs_lgr;
    if not v_found then
      raise_isi_error(30, LC.ec_p1(LC.O_TP1_Q_LGR_PLATZ_FEHLT, nvl(v_transport.lgr_platz_quelle, 'NULL')));
    end if;
    -- Wenn dispo auf einlagerung lagerplatz wieder um LTE Menge ,Gewicht .. Entlasten

    v_neuer_status := c.LTE_LF_STAT;

    if v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WA then
      v_neuer_status := c.Lte_Af_Stat;
    elsif v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WE then
      v_neuer_status := c.Lte_Bf_Stat;
    end if;

    lvs_platz.lvs_platz_einl_disp_ruecks(v_lte,v_lgr_ziel);
    if v_lgr_quelle.lgr_platz is not null
    then
      lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte,v_lgr_quelle);
    end if;
    update lvs_lte lte
       set lte.lte_status = v_neuer_status,
           lte.order_vorgang_id = NULL,
           lte.order_auf_id = NULL,
           lte.ziel_lgr_ort = NULL,
           lte.ziel_lgr_platz = NULL
     where lte.sid = v_transport.sid
       and lte.firma_nr = v_transport.firma_nr
       and lte.lte_id = v_lte.lte_id;

    -- Erst mal alle Daten Holen
    if v_lte.waren_typ != c.MISCHPAL  -- Nur wenn keien Mischpalette
    then
      if v_e_lam_fa_ag is not NULL
      or  (v_min_lam_fa_ag is NULL
       and v_max_lam_fa_ag is NULL)
      then
        OPEN c_lam_e;
        -- Nur Transporte ohne Staffeltransport möglich
        v_found := FALSE;
        LOOP
          FETCH c_lam_e into v_lam_lte_id, v_lam_artikel_id, v_min_lam_charge_id, v_max_lam_charge_id, v_min_lam_leitzahl, v_max_lam_leitzahl,
                             v_min_lam_fa_ag, v_max_lam_fa_ag, v_e_menge, v_lgr_ort, v_lgr_adresse, v_lgr_dim_platz, v_lgr_platz, v_lte_name;
          v_found := c_lam_e%FOUND;
          EXIT when not v_found;

          -- lesen bis Transport entstehen kann, der kein Staffeltransport ist
          -- AG 20170814 Übergabeplatz ggf. nur fuer bestimmte Palettentypen
          if not lvs_p_base.get_lvs_lgr_ort_ue_platz(v_transport.sid,                 -- in_sid                  in lvs_lam.sid%type,
                                                     v_transport.firma_nr,            -- in_firma_nr             in lvs_lam.firma_nr%type,
                                                     v_lgr_ort,                        -- in_lgr_ort_quelle       in lvs_lgr_ort_ue_platz.lgr_ort_quelle%type,
                                                     v_transport.lgr_ort_ziel,        -- in_lgr_ort_ziel         in lvs_lgr_ort_ue_platz.lgr_ort_ziel%type,
                                                     v_lgr_platz,                      -- in_lgr_platz            in lvs_lgr.lgr_platz%type,
                                                     v_lte_name,                       -- LTE-Name zur Suche
                                                     v_lvs_lgr_ort_ue_platz)           -- io_lvs_lgr_ort_ue_platz in out lvs_lgr_ort_ue_platz%rowtype)
          then
            -- Prüfen ob platz OK und Fahrzeug OK
            exit;
          end if;
        END LOOP;
        CLOSE c_lam_e;
        -- Irgend etwas passendes gefunden

        if v_found
        then
          -- Eine Palette aus ISIOrder (Wegen reservierungen müssen die Mengen passen)
          if v_transport.vorgang_id is NOT NULL
          and v_e_menge != v_menge
          then
            v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN);
            --v_ret := 'Keinen Ersatz mit gleicher Menge. In ISIOrder neu reservieren. Transport gelöscht.';
            --return(v_ret);
          else
            if v_res_menge > v_e_menge   -- Menge reicht nicht
            then
              ROLLBACK TO SAVEPOINT keine_neue_lte_res_defekt;
              v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN);
              --v_ret := 'Keinen Ersatz mit gleicher Menge. In ISIOrder neu reservieren. Transport gelöscht.';
              return(v_ret);
            end if;
            
            --CMe 20220808 auf der neuen Ziel LTE alles ohne Reservierung zusammenfassen
            lvs_p_lte_lhm.unite_lams_without_reservation(in_sid => v_transport.sid,
                                                         in_firma_nr => v_transport.firma_nr,
                                                         in_lte_id => v_lam_lte_id,
                                                         in_user_id => in_user_id,
                                                         in_consider_mhd => 'T',
                                                         in_min_mhd => sysdate);
                                                                      
            -- Palette an den Auftrag binden
            update lvs_lte lte
               set lte.order_vorgang_id = v_lte.order_vorgang_id,
                   lte.order_auf_id = v_auf_id,
                   lte.lte_status = v_lte.lte_status,
                   lte.ziel_lgr_ort = v_lte.ziel_lgr_ort,
                   lte.ziel_lgr_platz = v_lte.ziel_lgr_platz
             where lte.sid = v_transport.sid
               and lte.firma_nr = v_transport.firma_nr
               and lte.lte_id = v_lam_lte_id;
            -- Lagerbestand an den Auftrag binden
            if v_res_menge > 0
            then
              OPEN c_lam_g_lte;
              FETCH c_lam_g_lte into v_g_lam;
              LOOP
                EXIT when c_lam_g_lte%NOTFOUND;
                OPEN c_lam_e_lte;
                FETCH c_lam_e_lte into v_e_lam;
                v_found := c_lam_e_lte%FOUND;
                CLOSE c_lam_e_lte;
                EXIT when not v_found;

                if v_e_lam.menge < v_g_lam.menge
                then
                  v_e_lam.res_menge := v_e_lam.menge;
                else
                  v_e_lam.res_menge := v_g_lam.res_menge;
                end if;

                update lvs_lam lam
                   set lam.order_pos_auf_id = v_g_lam.order_pos_auf_id,
                       lam.res_menge = v_e_lam.res_menge,
                       lam.res_ziel_lte_id = v_g_lam.res_ziel_lte_id,
                       lam.res_login_id = v_g_lam.res_login_id
                 where lam.sid = v_transport.sid
                   and lam.firma_nr = v_transport.firma_nr
                   and lam.lam_id = v_e_lam.lam_id;
                v_e_lam.order_pos_auf_id := v_g_lam.order_pos_auf_id;

                if v_e_lam.menge >= v_g_lam.res_menge
                then
                  if v_e_lam.menge > v_g_lam.res_menge
                  then
                    --CMe 20220808 Nur Splitten
                    pps_p_bde.create_new_lam_f_rest(in_sid => v_transport.sid,
                                                    in_firma_nr => v_transport.firma_nr,
                                                    in_lam => v_e_lam,
                                                    in_user_id => in_user_id);
                  end if;
                  update lvs_lam lam
                     set lam.order_pos_auf_id = NULL,
                         lam.res_menge = NULL,
                         lam.res_ziel_lte_id = NULL,
                         lam.res_login_id = NULL
                   where lam.sid = v_transport.sid
                     and lam.firma_nr = v_transport.firma_nr
                     and lam.lam_id = v_g_lam.lam_id;
                  FETCH c_lam_g_lte into v_g_lam;
                else
                  v_g_lam.res_menge := v_g_lam.res_menge - v_e_lam.res_menge;
                end if;
              end LOOP;
              CLOSE c_lam_g_lte;
            else
              update lvs_lam lam
                 set lam.order_pos_auf_id = NULL
               where lam.sid = v_transport.sid
                 and lam.firma_nr = v_transport.firma_nr
                 and lam.lte_id = v_lte.lte_id;
              update lvs_lam lam
                 set lam.order_pos_auf_id = v_auf_id
               where lam.sid = v_transport.sid
                 and lam.firma_nr = v_transport.firma_nr
                 and lam.lte_id = v_lam_lte_id;
            end if;
            
            --CMe 20220808: Jetzt alles reservierte Zusammenfassen, falls es sich um eine nachträgliche Reservierung
            --              auf Grund von Mangel handelt und sich auf der LTE bereits reserviertes Material befindet
            lvs_p_lte_lhm.add_amount_to_reservation(in_sid =>  v_transport.sid,
                                                    in_firma_nr => v_transport.firma_nr,
                                                    in_lte_id => v_lam_lte_id,
                                                    in_auf_id => v_auf_id,
                                                    in_user_id => in_user_id,
                                                    in_consider_mhd => 'T',
                                                    in_min_mhd => sysdate);
            v_res_id := NULL;
            if v_transport.res_id is not NULL
            then
              OPEN c_lvs_lgr;
              FETCH c_lvs_lgr into v_lgr_neue_quelle;
              CLOSE c_lvs_lgr;
              if v_transport.transp_typ = 'E'
              then
                v_transp_richtung := 'EB';
              elsif v_transport.transp_typ = 'A'
              then
                v_transp_richtung := 'AB';
              else
                v_transp_richtung := 'AB';
              end if;

              OPEN c_lvs_lgr_grp_fahrzeug;
              FETCH c_lvs_lgr_grp_fahrzeug into v_res_id;
              CLOSE c_lvs_lgr_grp_fahrzeug;
            end if;

            update isi_transport t
               set t.lgr_ort_quelle = v_lgr_ort,
                   t.lgr_platz_quelle = v_lgr_platz,
                   t.lte_id = v_lam_lte_id,
                   t.status = 'F',
                   t.res_id = v_res_id
             where t.sid = v_transport.sid
               and t.firma_nr = v_transport.firma_nr
               and t.transp_id = v_transport.transp_id;
            v_ret := NULL;
            -- v_ret := 'LTE gewechselt. Bitte neuen Lagerplatz anfahren. <' || nvl(v_lgr_platz, 'NULL') || '>';
            -- return v_ret;       -- Kein Hinweis allse OK
          end if;

          if lvs_p_base.get_lte(v_lam_lte_id, v_lte)
          then
            if lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr_quelle)
            then
              lvs_platz.lvs_platz_ausl_disp_setzen(v_lte, v_lgr_quelle);
            end if;
            if lvs_p_base.get_lgr_platz(v_transport.lgr_platz_ziel, v_lgr_ziel)
            then
              lvs_platz.lvs_platz_einl_disp_setzen(v_lte, v_lgr_ziel);
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;

  -- AG erst hier die Reservirung ras, damit die Vorlage für die Tauschpalette vorhandne ist
  -- Material vom Auftrag lösen
  update lvs_lam lam
     set lam.order_pos_auf_id = NULL,
         lam.res_menge = NULL,
         lam.res_ziel_lte_id = NULL,
         lam.res_login_id = NULL
   where lam.sid = v_transport.sid
     and lam.firma_nr = v_transport.firma_nr
     and lam.lte_id = in_lte_id;
  -- AG sicherheitshalber hier mit original LTE_ID nochmal
  update lvs_lte lte
     set lte.order_vorgang_id = NULL,
         lte.order_auf_id = NULL,
         lte.ziel_lgr_ort = NULL,
         lte.ziel_lgr_platz = NULL
   where lte.lte_id = in_lte_id;

  if v_ret is not NULL
  then
    ROLLBACK TO SAVEPOINT keine_neue_lte_res_defekt;
  end if;

  commit;  --    pragma autonomous_transaction;
  return(v_ret);
exception
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

function lvs_neue_lte_res_nio_dispo(in_user_id         in isi_user.login_id%type,
                                    in_lte_id          in lvs_lte.lte_id%type
                                   ) return varchar2 is

  v_found                boolean;
  v_ret                  varchar2(100);
  v_res_id              isi_resource.res_id%type;

  v_lte_id               lvs_lte.lte_id%type;
  v_lte                  lvs_lte%rowtype;
  v_g_lam                lvs_lam%rowtype;
  v_e_lam                lvs_lam%rowtype;

  v_lgr_ziel             lvs_lgr%rowtype;
  v_lgr_quelle           lvs_lgr%rowtype;
  v_lgr_neue_quelle      lvs_lgr%rowtype;

  v_lgr_platz            lvs_lgr.lgr_platz%type;

  v_lam_lte_id           lvs_lam.lte_id%type;
  v_lam_artikel_id       lvs_lam.artikel_id%type;
  v_menge                lvs_lam.menge%type;
  v_menge_sum            lvs_lam.menge%type;
  v_res_menge            lvs_lam.res_menge%type;
  v_lgr_ort              lvs_lgr_ort.lgr_ort%type;
  v_lgr_adresse          lvs_lgr_ort.adress_id%type;
  v_lgr_dim_platz        lvs_lgr.lgr_dim_platz%type;
  v_auf_id               lvs_lam.order_pos_auf_id%type;

  v_max_lam_charge_id    lvs_lam.charge_id%type;
  v_max_lam_leitzahl     lvs_lam.leitzahl%type;
  v_max_lam_fa_ag        lvs_lam.fa_ag%type;

  v_min_lam_charge_id    lvs_lam.charge_id%type;
  v_min_lam_leitzahl     lvs_lam.leitzahl%type;
  v_min_lam_fa_ag        lvs_lam.fa_ag%type;

  v_min_lam_sel1         lvs_lam.lam_sel1%type;
  v_min_lam_sel2         lvs_lam.lam_sel2%type;
  v_min_lam_sel3         lvs_lam.lam_sel3%type;
  v_min_lam_sel4         lvs_lam.lam_sel4%type;
  v_min_lam_sel5         lvs_lam.lam_sel5%type;
  v_min_lam_sel6         lvs_lam.lam_sel6%type;
  v_min_lam_sel7         lvs_lam.lam_sel7%type;
  v_min_lam_sel8         lvs_lam.lam_sel8%type;
  v_min_lam_sel9         lvs_lam.lam_sel9%type;
  v_min_lam_sel10        lvs_lam.lam_sel10%type;
  v_min_owner_address_id lvs_lam.owner_address_id%type;
  v_min_labor_status     lvs_lam.labor_status%type;

  v_max_lam_sel1         lvs_lam.lam_sel1%type;
  v_max_lam_sel2         lvs_lam.lam_sel2%type;
  v_max_lam_sel3         lvs_lam.lam_sel3%type;
  v_max_lam_sel4         lvs_lam.lam_sel4%type;
  v_max_lam_sel5         lvs_lam.lam_sel5%type;
  v_max_lam_sel6         lvs_lam.lam_sel6%type;
  v_max_lam_sel7         lvs_lam.lam_sel7%type;
  v_max_lam_sel8         lvs_lam.lam_sel8%type;
  v_max_lam_sel9         lvs_lam.lam_sel9%type;
  v_max_lam_sel10        lvs_lam.lam_sel10%type;
  v_max_owner_address_id lvs_lam.owner_address_id%type;
  v_max_labor_status     lvs_lam.labor_status%type;

  v_e_lam_charge_id      lvs_lam.charge_id%type;
  v_e_lam_leitzahl       lvs_lam.leitzahl%type;
  v_e_lam_fa_ag          lvs_lam.fa_ag%type;
  v_e_menge              lvs_lam.menge%type;

  v_e_lam_sel1           lvs_lam.lam_sel1%type;
  v_e_lam_sel2           lvs_lam.lam_sel2%type;
  v_e_lam_sel3           lvs_lam.lam_sel3%type;
  v_e_lam_sel4           lvs_lam.lam_sel4%type;
  v_e_lam_sel5           lvs_lam.lam_sel5%type;
  v_e_lam_sel6           lvs_lam.lam_sel6%type;
  v_e_lam_sel7           lvs_lam.lam_sel7%type;
  v_e_lam_sel8           lvs_lam.lam_sel8%type;
  v_e_lam_sel9           lvs_lam.lam_sel9%type;
  v_e_lam_sel10          lvs_lam.lam_sel10%type;
  v_e_owner_address_id   lvs_lam.owner_address_id%type;
  v_e_labor_status       lvs_lam.labor_status%type;

  v_lte_name             lvs_lte.lte_name%type;

  -- Tabelle für die Erzeugung von Staffeltransporten
  v_lvs_lgr_ort_ue_platz lvs_lgr_ort_ue_platz%rowtype;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = v_lte_id;

  CURSOR c_lam_g is
    select lam.lte_id,
           lam.artikel_id,
           min(lam.charge_id) nin_ch,
           max(lam.charge_id) nax_ch,
           min(lam.leitzahl) min_leitzahl,
           max(lam.leitzahl) max_leitzahl,
           min(lam.fa_ag) min_fa_ag,
           max(lam.fa_ag) max_fa_ag,
           sum(lam.menge),
           sum(nvl(lam.res_menge, 0)),
           min(lam.order_pos_auf_id),
           min(lam.lam_sel1),
           min(lam.lam_sel2),
           min(lam.lam_sel3),
           min(lam.lam_sel4),
           min(lam.lam_sel5),
           min(lam.lam_sel6),
           min(lam.lam_sel7),
           min(lam.lam_sel8),
           min(lam.lam_sel9),
           min(lam.lam_sel10),
           max(lam.lam_sel1),
           max(lam.lam_sel2),
           max(lam.lam_sel3),
           max(lam.lam_sel4),
           max(lam.lam_sel5),
           max(lam.lam_sel6),
           max(lam.lam_sel7),
           max(lam.lam_sel8),
           max(lam.lam_sel9),
           max(lam.lam_sel10),
           min(lam.owner_address_id),
           max(lam.owner_address_id),
           min(lam.labor_status),
           max(lam.labor_status),
           ort.lgr_ort,
           ort.adress_id,
           lgr.lgr_dim_platz
      from lvs_lam lam,
           lvs_lgr lgr,
           lvs_lgr_ort ort
     where lam.sid          = v_lte.sid
       and lam.firma_nr     = v_lte.firma_nr
       and lam.lte_id       = v_lte.lte_id
       and lam.lgr_platz    = lgr.lgr_platz(+)
       and lgr.lgr_ort      = ort.lgr_ort(+)
     group by lam.lte_id,
              lam.artikel_id,
              lam.lgr_platz,
              ort.lgr_ort,
              ort.adress_id,
              lgr.lgr_dim_platz;

  CURSOR c_lam_e is
    select lam.lte_id,
           lam.artikel_id,
           min(lam.charge_id) min_ch,
           max(lam.charge_id) max_ch,
           min(lam.leitzahl) min_leitzahl,
           max(lam.leitzahl) max_leitzahl,
           min(lam.fa_ag) min_fa_ag,
           max(lam.fa_ag) max_fa_ag,
           sum(lam.menge) sum_menge,
           ort.lgr_ort,
           ort.adress_id,
           lgr.lgr_dim_platz,
           lte.lgr_platz,
           lte.lte_name
      from lvs_lam lam,
           lvs_lte lte,
           lvs_lgr lgr,
           lvs_lgr_ort ort
     where lam.sid = v_lte.sid
       and lam.firma_nr = v_lte.firma_nr
       and lam.lte_id != v_lte.lte_id
       and lte.lte_id = lam.lte_id
       and lte.lte_status in (c.LTE_LF_STAT, c.LTE_BF_STAT)
       and not exists (select x.lte_id from lvs_lam x where x.lte_id = lam.lte_id and x.order_pos_auf_id is not NULL)
       and lam.artikel_id = v_lam_artikel_id
       and nvl(lam.fa_ag, -1) = nvl(v_e_lam_fa_ag, -1)
       and lte.lgr_platz = lgr.lgr_platz
       and lte.lgr_ort = ort.lgr_ort
       and lte.order_vorgang_id is NULL
       and nvl(lam.leitzahl, -1) = nvl(v_e_lam_leitzahl, nvl(lam.leitzahl, -1)) -- Leitzahl beruecksichtigen
       and nvl(lam.fa_ag, -1) = nvl(v_e_lam_fa_ag, -1)-- Nur Ware die als Lagerware gilt !!!! AG <> NULL ist halbfertigware
       and lam.menge > 0                                   -- Nur wenn Lagermengen vorhanden
       and lam.akt_inventur_id is null                      -- nur Ware reservieren die nicht in Inventur sind
       -- -AG- 2015.05.12 Geaenderte selektirungsparameter Begin
       and lam.labor_status = v_e_labor_status
       -- -AG- 2015.05.12 Geaenderte selektirungsparameter End
       -- -AG- 2015.05.12 Neue selektirungsparameter Begin
       and nvl(lam.lam_sel1, 'lam.lam_sel') = nvl(v_e_lam_sel1, 'lam.lam_sel')
       and nvl(lam.lam_sel2, 'lam.lam_sel') = nvl(v_e_lam_sel2, 'lam.lam_sel')
       and nvl(lam.lam_sel3, 'lam.lam_sel') = nvl(v_e_lam_sel3, 'lam.lam_sel')
       and nvl(lam.lam_sel4, 'lam.lam_sel') = nvl(v_e_lam_sel4, 'lam.lam_sel')
       and nvl(lam.lam_sel5, 'lam.lam_sel') = nvl(v_e_lam_sel5, 'lam.lam_sel')
       and nvl(lam.lam_sel6, 'lam.lam_sel') = nvl(v_e_lam_sel6, 'lam.lam_sel')
       and nvl(lam.lam_sel7, 'lam.lam_sel') = nvl(v_e_lam_sel7, 'lam.lam_sel')
       and nvl(lam.lam_sel8, 'lam.lam_sel') = nvl(v_e_lam_sel8, 'lam.lam_sel')
       and nvl(lam.lam_sel9, 'lam.lam_sel') = nvl(v_e_lam_sel9, 'lam.lam_sel')
       and nvl(lam.lam_sel10, 'lam.lam_sel') = nvl(v_e_lam_sel10, 'lam.lam_sel')
       -- -AG- 2015.05.12 Neue selektirungsparameter End
       and trunc(lam.lam_mhd) >= sysdate
       and lgr.gesperrt = C.LGR_GESPERRT_F
       and ort.lgr_ort = v_lgr_ort
       and (  lam.owner_address_id = v_e_owner_address_id  -- genau von diesem Kunden
            or lam.owner_address_id is NULL                -- oder kein Keine KONSI-Ware
           )
       and lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(lte.lte_id) = 'T'
       -- Berücksichtigen des Zeichnungsindex
      group by lam.lte_id,
              lam.artikel_id,
              ort.lgr_ort,
              ort.adress_id,
              lgr.lgr_dim_platz,
              lte.lgr_platz,
              lte.lte_name
        order by abs(sum_menge - v_menge),
                 abs(decode(min_ch, max_ch, max_ch, NULL) - v_e_lam_charge_id),
                 abs(decode(min_leitzahl, max_leitzahl, min_leitzahl, NULL) - v_e_lam_leitzahl),
                 abs(ort.lgr_ort - v_lgr_ort),
                 abs(lgr.lgr_dim_platz - v_lgr_dim_platz);

  CURSOR c_lvs_lgr is                             -- Lesen des Lagerplatz
   select *
     from lvs_lgr lgr
    where lgr.lgr_platz = v_lte.lgr_platz;

  CURSOR c_lam_g_lte is
    select *
      from lvs_lam l
     where l.lte_id = v_lte.lte_id
       and l.order_pos_auf_id is not NULL;

  --CMe 20220811 MHD berücksichtigen
  CURSOR c_lam_e_lte is
    select *
      from lvs_lam l
     where l.lte_id = v_lam_lte_id
       and l.order_pos_auf_id is NULL
       and l.lam_mhd >= sysdate
     order by abs(l.menge - v_g_lam.res_menge),
              l.menge desc;

  pragma autonomous_transaction;
begin
  -- Erst mal die LTE_ID fuer den CURSOR uebertragen
  v_lte_id := in_lte_id;
  v_ret := LC.ec('O_TP1_NO_ACTION_TAKEN');
  SAVEPOINT keine_neue_lte_res_defekt;

  -- Erst mal die LTE-Daten lesen
  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;
  CLOSE c_lte;

  if lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(v_lte.lte_id) = 'T'
  then
    return (v_ret);
  end if;

  -- Schlimmer Fehler, konnte die LTE-Daten nicht lesen (Ist evtl. schon Ausgelagert und aus den Daten genommen?)
  if not v_found
  then
    raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(v_lte.lte_id, 'NULL')));
  end if;


  OPEN c_lam_g;    -- Lesen der Materialien die auf der palette sind
  FETCH c_lam_g into v_lam_lte_id, v_lam_artikel_id, v_min_lam_charge_id, v_max_lam_charge_id,
                     v_min_lam_leitzahl, v_max_lam_leitzahl, v_min_lam_fa_ag, v_max_lam_fa_ag,
                     v_menge, v_res_menge, v_auf_id,
                     v_min_lam_sel1, v_min_lam_sel2, v_min_lam_sel3, v_min_lam_sel4, v_min_lam_sel5,
                     v_min_lam_sel6, v_min_lam_sel7, v_min_lam_sel8, v_min_lam_sel9, v_min_lam_sel10,
                     v_max_lam_sel1, v_max_lam_sel2, v_max_lam_sel3, v_max_lam_sel4, v_max_lam_sel5,
                     v_max_lam_sel6, v_max_lam_sel7, v_max_lam_sel8, v_max_lam_sel9, v_max_lam_sel10,
                     v_min_owner_address_id, v_max_owner_address_id,
                     v_min_labor_status, v_max_labor_status,
                     v_lgr_ort, v_lgr_adresse, v_lgr_dim_platz;
  CLOSE c_lam_g;

  -- Charge FA-Auftrag und Arbeitsgang der Palette ist relevant für die Sortierung zur findung der neuen Palette
  if v_min_lam_charge_id = v_max_lam_charge_id
  then
     v_e_lam_charge_id := v_min_lam_charge_id;      -- Nur wenn alles die gleiche Charge
  else
    v_e_lam_charge_id := NULL;
  end if;
  if v_min_lam_leitzahl =  v_max_lam_leitzahl
  then
    v_e_lam_leitzahl  := v_min_lam_leitzahl;      -- Nur wenn alles gleiche FA-Auftrag
  else
    v_e_lam_leitzahl  := NULL;
  end if;
  if v_min_lam_fa_ag =     v_max_lam_fa_ag
  then
    v_e_lam_fa_ag     := v_min_lam_fa_ag;      -- Nur wenn alles gleicher Arbeitsgang
  else
    v_e_lam_fa_ag     := NULL;
  end if;

  if v_max_lam_sel1 != v_min_lam_sel1
  then
    v_e_lam_sel1 := v_max_lam_sel1 || v_min_lam_sel1;
  else
    v_e_lam_sel1 := v_max_lam_sel1;
  end if;
  if v_max_lam_sel2 != v_min_lam_sel2
  then
    v_e_lam_sel2 := v_max_lam_sel2 || v_min_lam_sel2;
  else
    v_e_lam_sel2 := v_max_lam_sel2;
  end if;
  if v_max_lam_sel3 != v_min_lam_sel3
  then
    v_e_lam_sel3 := v_max_lam_sel3 || v_min_lam_sel3;
  else
    v_e_lam_sel3 := v_max_lam_sel3;
  end if;
  if v_max_lam_sel4 != v_min_lam_sel4
  then
    v_e_lam_sel4 := v_max_lam_sel4 || v_min_lam_sel4;
  else
    v_e_lam_sel4 := v_max_lam_sel4;
  end if;
  if v_max_lam_sel5 != v_min_lam_sel5
  then
    v_e_lam_sel5 := v_max_lam_sel5 || v_min_lam_sel5;
  else
    v_e_lam_sel5 := v_max_lam_sel5;
  end if;
  if v_max_lam_sel6 != v_min_lam_sel6
  then
    v_e_lam_sel6 := v_max_lam_sel6 || v_min_lam_sel6;
  else
    v_e_lam_sel6 := v_max_lam_sel6;
  end if;
  if v_max_lam_sel7 != v_min_lam_sel7
  then
    v_e_lam_sel7 := v_max_lam_sel7 || v_min_lam_sel7;
  else
    v_e_lam_sel7 := v_max_lam_sel7;
  end if;
  if v_max_lam_sel8 != v_min_lam_sel8
  then
    v_e_lam_sel8 := v_max_lam_sel8 || v_min_lam_sel8;
  else
    v_e_lam_sel8 := v_max_lam_sel8;
  end if;
  if v_max_lam_sel9 != v_min_lam_sel9
  then
    v_e_lam_sel9 := v_max_lam_sel9 || v_min_lam_sel9;
  else
    v_e_lam_sel9 := v_max_lam_sel9;
  end if;
  if v_max_lam_sel10 != v_min_lam_sel10
  then
    v_e_lam_sel10 := v_max_lam_sel10 || v_min_lam_sel10;
  else
    v_e_lam_sel10 := v_max_lam_sel10;
  end if;

  if v_max_owner_address_id != v_min_owner_address_id
  then
    v_e_owner_address_id := -1;
  else
    v_e_owner_address_id := v_max_owner_address_id;
  end if;
  if v_max_labor_status != v_min_labor_status
  then
    v_e_labor_status := v_max_labor_status || v_min_labor_status;
  else
    v_e_labor_status := v_max_labor_status;
  end if;

  OPEN c_lvs_lgr;
  FETCH c_lvs_lgr into v_lgr_quelle;
  v_found := c_lvs_lgr%FOUND;
  CLOSE c_lvs_lgr;
  if not v_found then
    raise_isi_error(30, LC.ec_p1(LC.O_TP1_Q_LGR_PLATZ_FEHLT, nvl(v_lte.lgr_platz, 'NULL')));
  end if;
  -- Wenn dispo auf einlagerung lagerplatz wieder um LTE Menge ,Gewicht .. Entlasten
  if v_lgr_quelle.lgr_platz is not null
  then
    lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte,v_lgr_quelle);
  end if;

  update lvs_lte t
     set t.lte_status = nvl((select x.lte_status  from lvs_lte x where x.lte_id = t.lte_id), 'LF')
  where t.lte_id = v_lte.lte_id;
  -- Palettendaten von allen Auftragsdatten lösen
  update lvs_lte lte
     set lte.order_vorgang_id = NULL,
         lte.order_auf_id = NULL,
         lte.ziel_lgr_ort = NULL,
         lte.ziel_lgr_platz = NULL
   where lte.sid = v_lte.sid
     and lte.firma_nr = v_lte.firma_nr
     and lte.lte_id = v_lte.lte_id;

  -- Erst mal alle Daten Holen
  if v_lte.waren_typ != c.MISCHPAL  -- Nur wenn keien Mischpalette
  then
    if v_e_lam_fa_ag is not NULL
    or  (v_min_lam_fa_ag is NULL
     and v_max_lam_fa_ag is NULL)
    then
      OPEN c_lam_e;
      -- Nur Transporte ohne Staffeltransport möglich
      v_found := FALSE;
      FETCH c_lam_e into v_lam_lte_id, v_lam_artikel_id, v_min_lam_charge_id, v_max_lam_charge_id, v_min_lam_leitzahl, v_max_lam_leitzahl,
                           v_min_lam_fa_ag, v_max_lam_fa_ag, v_e_menge, v_lgr_ort, v_lgr_adresse, v_lgr_dim_platz, v_lgr_platz, v_lte_name;
      v_found := c_lam_e%FOUND;
      CLOSE c_lam_e;

      -- Irgend etwas passendes gefunden
      if v_found
      then
        -- EWegen Reservierungen müssen die Mengen ausreichen
        if v_res_menge > v_e_menge   -- Menge reicht nicht
        then
          ROLLBACK TO SAVEPOINT keine_neue_lte_res_defekt;
          v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN);
          --v_ret := 'Keinen Ersatz mit gleicher Menge. In ISIOrder neu reservieren. Transport gelöscht.';
          return(v_ret);
        end if;
        
        --CMe 20220808 auf der neuen Ziel LTE alles ohne Reservierung zusammenfassen
        lvs_p_lte_lhm.unite_lams_without_reservation(in_sid => v_lte.sid,
                                                     in_firma_nr => v_lte.firma_nr,
                                                     in_lte_id => v_lam_lte_id,
                                                     in_user_id => in_user_id,
                                                     in_consider_mhd => 'T',
                                                     in_min_mhd => sysdate);
                                                         
        -- Palette an den Auftrag binden
        update lvs_lte lte
           set lte.order_vorgang_id = v_lte.order_vorgang_id,
               lte.order_auf_id = v_auf_id,
               lte.lte_status = v_lte.lte_status,
               lte.ziel_lgr_ort = v_lte.ziel_lgr_ort,
               lte.ziel_lgr_platz = v_lte.ziel_lgr_platz
         where lte.sid = v_lte.sid
           and lte.firma_nr = v_lte.firma_nr
           and lte.lte_id = v_lam_lte_id;
        -- Lagerbestand an den Auftrag binden
        if v_res_menge > 0
        then
          OPEN c_lam_g_lte;
          FETCH c_lam_g_lte into v_g_lam;
          LOOP
            EXIT when c_lam_g_lte%NOTFOUND;
            OPEN c_lam_e_lte;
            FETCH c_lam_e_lte into v_e_lam;
            v_found := c_lam_e_lte%FOUND;
            CLOSE c_lam_e_lte;
            EXIT when not v_found;

            if v_e_lam.menge < v_g_lam.menge
            then
              v_e_lam.res_menge := v_e_lam.menge;
            else
              v_e_lam.res_menge := v_g_lam.res_menge;
            end if;

            update lvs_lam lam
               set lam.order_pos_auf_id = v_g_lam.order_pos_auf_id,
                   lam.res_menge = v_e_lam.res_menge,
                   lam.res_ziel_lte_id = v_g_lam.res_ziel_lte_id,
                   lam.res_login_id = v_g_lam.res_login_id
             where lam.sid = v_lte.sid
               and lam.firma_nr = v_lte.firma_nr
               and lam.lam_id = v_e_lam.lam_id;
            v_e_lam.order_pos_auf_id := v_g_lam.order_pos_auf_id;

            if v_e_lam.menge >= v_g_lam.res_menge
            then
              if v_e_lam.menge > v_g_lam.res_menge
              then
                --CMe 20220808 Nur auf Splitten
                pps_p_bde.create_new_lam_f_rest(in_sid => v_lte.sid,
                                                in_firma_nr => v_lte.firma_nr,
                                                in_lam => v_e_lam,
                                                in_user_id => in_user_id);

              end if;
              update lvs_lam lam
                 set lam.order_pos_auf_id = NULL,
                     lam.res_menge = NULL,
                     lam.res_ziel_lte_id = NULL,
                     lam.res_login_id = NULL
               where lam.sid = v_lte.sid
                 and lam.firma_nr = v_lte.firma_nr
                 and lam.lam_id = v_g_lam.lam_id;
              FETCH c_lam_g_lte into v_g_lam;
            else
              v_g_lam.res_menge := v_g_lam.res_menge - v_e_lam.res_menge;
            end if;
          end LOOP;
          CLOSE c_lam_g_lte;
        else
          update lvs_lam lam
             set lam.order_pos_auf_id = NULL
           where lam.sid = v_lte.sid
             and lam.firma_nr = v_lte.firma_nr
             and lam.lte_id = v_lte.lte_id;
          update lvs_lam lam
             set lam.order_pos_auf_id = v_auf_id
           where lam.sid = v_lte.sid
             and lam.firma_nr = v_lte.firma_nr
             and lam.lte_id = v_lam_lte_id;
        end if;
        
        --CMe 20220808: Jetzt alles reservierte Zusammenfassen, falls es sich um eine nachträgliche Reservierung
        --              auf Grund von Mangel handelt und sich auf der LTE bereits reserviertes Material befindet
        lvs_p_lte_lhm.add_amount_to_reservation(in_sid =>  v_lte.sid,
                                                in_firma_nr => v_lte.firma_nr,
                                                in_lte_id => v_lam_lte_id,
                                                in_auf_id => v_auf_id,
                                                in_user_id => in_user_id,
                                                in_consider_mhd => 'T',
                                                in_min_mhd => sysdate);
                                                
        v_res_id := NULL;
        v_ret := NULL;

        if lvs_p_base.get_lte(v_lam_lte_id, v_lte)
        then
          if lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr_quelle)
          then
            lvs_platz.lvs_platz_ausl_disp_setzen(v_lte, v_lgr_quelle);
          end if;
        end if;
      end if;
    end if;
  end if;

  -- Ist Ersatz gefunden?
  if v_ret is NULL
  then
    -- AG erst hier die Reservirung ras, damit die Vorlage für die Tauschpalette vorhandne ist
    -- Material vom Auftrag lösen
    update lvs_lam lam
       set lam.order_pos_auf_id = NULL,
           lam.res_menge = NULL,
           lam.res_ziel_lte_id = NULL,
           lam.res_login_id = NULL
     where lam.sid = v_lte.sid
       and lam.firma_nr = v_lte.firma_nr
       and lam.lte_id = in_lte_id;
  -- AG sicherheitshalber hier mit original LTE_ID nochmal
  update lvs_lte lte
     set lte.order_vorgang_id = NULL,
         lte.order_auf_id = NULL,
         lte.ziel_lgr_ort = NULL,
         lte.ziel_lgr_platz = NULL
   where lte.lte_id = in_lte_id;
  else
    ROLLBACK TO SAVEPOINT keine_neue_lte_res_defekt;
  end if;

  commit;  --    pragma autonomous_transaction;
  return(v_ret);
exception
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

function LVS_SUCHE_NEUEN_PLATZ_V349 (in_transport        in isi_transport%rowtype,
                                     in_user_id         in isi_user.login_id%type,
                                     in_prorgamm_nr     in isi_transport.quelle_leer_progr_nr%type
                                    ) return varchar2 is

  v_lte                 lvs_lte%rowtype;
  v_lgr_ziel_neu        lvs_lgr%rowtype;
  v_lgr_ziel            lvs_lgr%rowtype;

  v_found               boolean;
  v_ret                 varchar2(100);
  v_fahrzeuge_IDs       varchar2(20);

  v_lte_cfg            lvs_lte_cfg%rowtype;
  v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;
  v_lagerplatz_sperren  varchar2(100);  -- 'T', 'F'

  CURSOR c_lte_cfg is
    select t.*
      from lvs_lte_cfg t
     where t.sid = v_lte.sid
       and t.firma_nr = v_lte.firma_nr
       and t.lte_name = v_lte.lte_name;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = in_transport.lte_id;

  CURSOR c_lvs_lgr is                             -- Lesen des Lagerplatz
   select *
     from lvs_lgr lgr
    where lgr.lgr_platz = in_transport.lgr_platz_ziel;
begin
  if nvl(in_prorgamm_nr, 0) = 0
  then
    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    -- Schlimmer Fehler, konnte die LTE-Daten nicht lesen (Ist evtl. schon Ausgelagert und aus den Daten genommen?)
    if not v_found
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_transport.lte_id));
    end if;

    OPEN c_lvs_lgr;
    FETCH c_lvs_lgr into v_lgr_ziel;
    CLOSE c_lvs_lgr;

    -- Ziel ist ein WE
    if v_lgr_ziel.lgr_verwendung = c.LGR_TYP_WE
    or v_lgr_ziel.lgr_verwendung = c.LGR_TYP_WA
    or v_lgr_ziel.lgr_verwendung = c.LGR_TYP_EP
    then
      raise_isi_error(11, LC.ec(LC.O_TXT_EP_WE_WA_VOLL_N_MOEGLICH));
    end if;
    v_fahrzeuge_IDs := ';' || to_char(in_transport.res_id) || ';';

    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    lvs_platz.v_ignor_einl_suche_uml := 1;
    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
    lvs_platz.lvs_suche_um_platz(v_lte,
                                 v_basis_lte_name,
                                 v_lte_cfg.flaechen_stellplatz_erf,
                                 v_lgr_ziel,
                                 v_fahrzeuge_IDs,
                                 v_lgr_ziel_neu);
    lvs_platz.v_ignor_einl_suche_uml := 0;
    lvs_platz.lvs_platz_einl_disp_ruecks(v_lte,v_lgr_ziel);
    lvs_platz.lvs_platz_einl_disp_setzen(v_lte, v_lgr_ziel_neu);

    update isi_transport t
       set t.lgr_platz_ziel = v_lgr_ziel_neu.lgr_platz,
           t.user_id = in_user_id
     where t.lte_id = v_lte.lte_id
       and t.lgr_platz_ziel = v_lgr_ziel.lgr_platz;
    update lvs_lte lte
       set lte.ziel_lgr_platz = v_lgr_ziel_neu.lgr_platz
     where lte.lte_id = in_transport.lte_id;
    -- Abhängig von Firma_CFG "ZIEL_VOLL_SPERRE_AKTIV" den ursprünglichen Lagerplatz sperren !!!
    v_lagerplatz_sperren := isi_allg.get_firma_cfg_param (
                                     in_transport.sid,
                                     in_transport.firma_nr,
                                     'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                      in_transport.modul_bearbeiter,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                      'LVS_ZIEL_VOLL_SPERRE_AKTIV',
                                                                -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'LVS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                      'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                      'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                      'BOOLEAN');               -- in_default_param_typ

    if  v_lgr_ziel.lgr_typ != c.BKL1
    and v_lgr_ziel.gesperrt != c.LGR_GESPERRT_G
    and v_lagerplatz_sperren = c.C_TRUE
    then
      lvs_platz.LVS_C_SET_LGR_SPERR_STATUS(C.LGR_GESPERRT_G, v_lgr_ziel.lgr_platz, in_transport.modul_bearbeiter ||' '|| to_char(sysdate, 'yyyy.mm.dd'));
    else
      if v_lagerplatz_sperren = c.C_FALSE
      then
        -- damit die leeren  Plätze nicht wieder verwendet werden, Reservierungsstring ändern !
        if v_lgr_ziel.lgr_typ = c.Sat1 or
           v_lgr_ziel.lgr_typ = c.KANAL1 or
           v_lgr_ziel.lgr_typ = c.DURCHL1
        then
          lvs_platz.LVS_C_SET_LGR_VOLL_RES_STRING(v_lgr_ziel.lgr_platz);
        end if;
      end if;
    end if;
    v_ret := v_lgr_ziel_neu.lgr_platz;
  else
    raise_isi_error(999, LC.ec_p1(LC.O_TP1_FEHERABHANDLUNG_FEHLT, nvl(to_char(in_prorgamm_nr), 'NULL')));
  end if;
  return v_ret;
exception
  -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      lvs_platz.v_ignor_einl_suche_uml := 0;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      lvs_platz.v_ignor_einl_suche_uml := 0;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

function LVS_C_SUCHE_NEUEN_PLATZ(in_transport        in isi_transport%rowtype,
                                 in_user_id         in isi_user.login_id%type,
                                 in_prorgamm_nr     in isi_transport.quelle_leer_progr_nr%type
                                ) return varchar2 is
  v_ret                 varchar2(100);
begin
    v_ret :=  LC.ec_p1(LC.O_TP1_NEUEN_PLATZ_ANFAHERN, nvl(lvs_suche_neuen_platz_v349(in_transport,
                                                                    in_user_id,
                                                                    in_prorgamm_nr),
                                                       'Fehlt'));
  commit;
  return v_ret;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

function LVS_C_SUCHE_NEUEN_PLATZ_V349 (in_transport        in isi_transport%rowtype,
                                       in_user_id         in isi_user.login_id%type,
                                       in_prorgamm_nr     in isi_transport.quelle_leer_progr_nr%type
                                      ) return varchar2 is
  v_ret                 varchar2(100);
begin
  v_ret := lvs_suche_neuen_platz_v349(in_transport,
                                      in_user_id,
                                      in_prorgamm_nr);
  commit;
  return v_ret;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;


/*******************************************************************************
 * Gibt die Anzahl der ausgelagerten Paletten eine Tour zurück

 *******************************************************************************/
function LVS_LTE_LHM_MG (in_vorgang_nr     in isi_order_pos.vorgang_id%type
                        ) return varchar2 is
-------------------------------------------------------------------------------------------------------
  v_result  number;
begin
  select count (bh.lte_id) into v_result
    from (select bh2.lte_id, bh2.vorgang_id
            from lvs_v_lam_bh bh2
           where bh2.vorgang_id = in_vorgang_nr
             and bh2.bus = 3
           group by bh2.lte_id, bh2.vorgang_id) bh
   where bh.vorgang_id = in_vorgang_nr
   group by bh.vorgang_id;

  return(v_result);
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
  when others then
    return(v_result);
end LVS_LTE_LHM_MG;

/*******************************************************************************
 * Löschen von leeren Paletten

 *******************************************************************************/
procedure LVS_C_LTE_DEL_LEER (in_login_id   in  isi_user.login_id%type
                             ) is
-------------------------------------------------------------------------------------------------------
  v_lte          lvs_lte%rowtype;
  v_lte_cfg      lvs_lte_cfg%rowtype;
  v_lhm_cfg      lvs_lhm_cfg%rowtype;

  v_lam_sid      lvs_lam.sid%type;
  v_lam_firma_nr lvs_lam.firma_nr%type;
  v_lam_id       lvs_lam.lam_id%type;
  v_uncommit     number;

  CURSOR c_lte_leer is
    select *
      from lvs_lte lte
      where lte.lte_akt_lhm = 0
        and lte.lgr_platz is not NULL
        and lte.lte_status != 'B';

  CURSOR c_lte_o_lgr is
    select *
      from lvs_lte lte
     where lte.lgr_platz is NULL
       and lte.lte_status not like '%T'
       and lte.lte_letzte_buchung < sysdate - c.LTE_KF_PF_GUELTIG;

  CURSOR c_lam_del is
    select lam.sid,
           lam.firma_nr,
           lam.lam_id
      from lvs_lam lam,
           lvs_lam_bh bh
     where lam.lte_id is NULL
       and lam.lgr_platz is NULL
       and lam.menge = 0
       and lam.lam_id = bh.lam_id
       and bh.buch_datum < trunc(sysdate - c.LAM_ID_GUELTIG_TAGE)
       and bh.lam_bh_id = (select max(bh2.lam_bh_id)
                             from lvs_lam_bh bh2
                            where bh2.lam_id = lam.lam_id);

  CURSOR c_lte_cfg is
    select *
      from lvs_lte_cfg c
     where c.sid = v_lte.sid
       and c.firma_nr = v_lte.firma_nr
       and c.lte_name = v_lte.lte_name;

  CURSOR c_lhm_cfg is
    select t.*
      from lvs_lhm_cfg t;

begin
  v_uncommit := 0;
  OPEN c_lte_leer;
  LOOP
    FETCH c_lte_leer into v_lte;
    EXIT When c_lte_leer%NOTFOUND;
    if nvl(v_lte_cfg.lte_name, 'ISI_Fehlt') != v_lte.lte_name
    then
      v_lte_cfg := NULL;
      OPEN c_lte_cfg;
      FETCH c_lte_cfg into v_lte_cfg;
      CLOSE c_lte_cfg;
      v_lte_cfg.lte_id_gueltig_tage := nvl(v_lte_cfg.lte_id_gueltig_tage, c.lte_id_gueltig_tage);
    end if;

    if v_lte.lte_letzte_buchung < sysdate - v_lte_cfg.lte_id_gueltig_tage
    then
      begin
        lvs_p_lte.LVS_KORR_TE_AUSBUCHEN(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, v_lte.lte_status, v_lte.sid, v_lte.firma_nr,
                                        v_lte.lgr_ort, v_lte.lgr_platz, in_login_id);    v_uncommit := v_uncommit + 1;
      exception
        when others then
          NULL;
      end;
      lvs_lte_delete (v_lte.sid, v_lte.lte_id, in_login_id, v_lte.lte_status);

      v_uncommit := v_uncommit + 1;
      if v_uncommit >= 100
      then
        commit;
        v_uncommit := 0;
      end if;
    end if;
  END LOOP;
  CLOSE c_lte_leer;

  OPEN c_lte_o_lgr;
  LOOP
    FETCH c_lte_o_lgr into v_lte;
    EXIT when c_lte_o_lgr%NOTFOUND;
    if nvl(v_lte_cfg.lte_name, 'ISI_Fehlt') != v_lte.lte_name
    then
      v_lte_cfg := NULL;
      OPEN c_lte_cfg;
      FETCH c_lte_cfg into v_lte_cfg;
      CLOSE c_lte_cfg;
      v_lte_cfg.lte_id_gueltig_tage := nvl(v_lte_cfg.lte_id_gueltig_tage, c.lte_id_gueltig_tage);
    end if;

    if v_lte.lte_letzte_buchung < sysdate - v_lte_cfg.lte_id_gueltig_tage
    then
      lvs_lte_delete (v_lte.sid, v_lte.lte_id, in_login_id, v_lte.lte_status);
      v_uncommit := v_uncommit + 1;
      if v_uncommit >= 100
      then
        commit;
        v_uncommit := 0;
      end if;
    end if;
  end LOOP;
  CLOSE c_lte_o_lgr;

  OPEN c_lam_del;
  FETCH c_lam_del into v_lam_sid, v_lam_firma_nr, v_lam_id;
  LOOP
    EXIT when c_lam_del%NOTFOUND;
    delete lvs_lam lam
     where lam.sid = v_lam_sid
       and lam.firma_nr = v_lam_firma_nr
       and lam.lam_id = v_lam_id;
    v_uncommit := v_uncommit + 1;
    if v_uncommit >= 100
    then
      commit;
      v_uncommit := 0;
    end if;
    FETCH c_lam_del into v_lam_sid, v_lam_firma_nr, v_lam_id;
  end LOOP;
  CLOSE c_lam_del;

  OPEN c_lhm_cfg;
  FETCH c_lhm_cfg into v_lhm_cfg;
  LOOP
    EXIT when c_lhm_cfg%NOTFOUND;
    delete lvs_lhm t
     where t.sid = v_lhm_cfg.sid
       and t.firma_nr = v_lhm_cfg.firma_nr
       and t.lhm_name = v_lhm_cfg.lhm_name
       and t.lhm_letzte_buchung < trunc(sysdate) - nvl(v_lhm_cfg.lhm_id_gueltig_tage, c.lhm_id_gueltig_tage)
       and t.lte_id is NULL
       and t.lgr_platz is NULL
       and t.lhm_id != (select nvl(min(l.lhm_id), -1)
                          from lvs_lam l
                         where l.lhm_id = t.lhm_id);
    commit;
    FETCH c_lhm_cfg into v_lhm_cfg;
  end LOOP;
  CLOSE c_lhm_cfg;
  commit;
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
  when others then
    if c_lte_leer%ISOPEN
    then
      CLOSE c_lte_leer;
    end if;
    if c_lte_o_lgr%ISOPEN
    then
      CLOSE c_lte_o_lgr;
    end if;
    if c_lhm_cfg%ISOPEN
    then
      CLOSE c_lhm_cfg;
    end if;
    if c_lam_del%ISOPEN
    then
      CLOSE c_lam_del;
    end if;
    rollback;
    raise;
end LVS_C_LTE_DEL_LEER;

/*******************************************************************************
 * Löschen von leeren Paletten

 *******************************************************************************/
function LVS_CHECK_LTE_NAME_FORMAT  (in_lte_id          in lvs_lte.lte_id%type,
                                     in_chk_lte_name    in lvs_lte.lte_name%type,
                                     in_chk_hoehe       in lvs_lte.lte_vol_hoehe%type,
                                     in_chk_breite      in lvs_lte.lte_vol_breite%type,
                                     in_chk_tiefe       in lvs_lte.lte_vol_tiefe%type
                             ) return boolean is

  v_found boolean;
  v_lte   lvs_lte%rowtype;

  CURSOR c_lte is
    select t.*
      from lvs_lte t
     where t.lte_id = in_lte_id;

begin
  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;
  CLOSE c_lte;

  if not v_found
  then
    raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
  end if;

  if v_lte.lte_vol_hoehe  < nvl(in_chk_hoehe, v_lte.lte_vol_hoehe)
  or v_lte.lte_vol_breite < nvl(in_chk_breite, v_lte.lte_vol_breite)
  or v_lte.lte_vol_tiefe  < nvl(in_chk_tiefe, v_lte.lte_vol_tiefe)
  or v_lte.lte_name      != nvl(in_chk_lte_name, v_lte.lte_name)
  then
    return FALSE;
  end if;
  return TRUE;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

/*******************************************************************************
 * Löschen von leeren Paletten

 *******************************************************************************/
procedure LVS_SET_LTE_NAME_FORMAT  (in_lte_id          in lvs_lte.lte_id%type,
                                    in_chk_lte_name    in lvs_lte.lte_name%type,
                                    in_chk_hoehe       in lvs_lte.lte_vol_hoehe%type,
                                    in_chk_breite      in lvs_lte.lte_vol_breite%type,
                                    in_chk_tiefe       in lvs_lte.lte_vol_tiefe%type
                              ) is

    v_found                            boolean;
    v_lte                              lvs_lte%rowtype;

  CURSOR c_lte is
    select t.*
      from lvs_lte t
     where t.lte_id = in_lte_id;

begin
  OPEN c_lte;
  FETCH c_lte into v_lte;
  v_found := c_lte%FOUND;
  CLOSE c_lte;

  if not v_found
  then
    raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
  end if;

  UPDATE lvs_lte t
    set t.lte_vol_hoehe  = nvl(in_chk_hoehe, v_lte.lte_vol_hoehe),
        t.lte_vol_breite = nvl(in_chk_breite, v_lte.lte_vol_breite),
        t.lte_vol_tiefe  = nvl(in_chk_tiefe, v_lte.lte_vol_tiefe),
        t.lte_name       = nvl(in_chk_lte_name, v_lte.lte_name)
    where t.lte_id = in_lte_id;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end;

  ---------------------------------------------------------------------------------------------------
  -- -AG- ab 3.5.2 wird in der LTE auch die Transportgruppe und die LKW_NR in der LTE mitgeschrieben
  -- Die Transportgruppe wird dann zu RES_STRING bei Auslagerungen für Verladevorbereitungen im PUFFER
  ---------------------------------------------------------------------------------------------------
  procedure lvs_te_lagerziel_umbuchen_353(in_sid                    in isi_sid.sid%TYPE,
                                          in_firma_nr               in isi_firma.firma_nr%TYPE,
                                          in_lte_id                 in lvs_lte.lte_id%TYPE,
                                          in_ist_lgr_platz          in lvs_lgr.lgr_platz%TYPE,
                                          in_ist_lgr_ort            in lvs_lgr.lgr_ort%TYPE,
                                          in_ist_lgr_platz_gruppe   in lvs_lgr.lgr_platz_gruppe%TYPE,
                                          in_soll_lgr_platz         in lvs_lgr.lgr_platz%TYPE,
                                          in_soll_lgr_ort           in lvs_lgr.lgr_ort%TYPE,
                                          in_lte_status             in lvs_lte.lte_status%TYPE,
                                          in_lte_ist_Status         in lvs_lte.lte_status%TYPE,
                                          in_ziel_lgr_platz_n_freif in lvs_lte.ziel_lgr_platz_n_freif%type,
                                          in_ziel_lgr_ort_n_freif   in lvs_lte.ziel_lgr_ort_n_freif%type,
                                          in_l_buchung              in lvs_lte.lte_letzte_buchung%type,
                                          in_auf_id                 in isi_order_pos.auf_id%type,
                                          in_vorgang_id             in isi_order_pos.vorgang_id%type,
                                          in_artikel_id             in isi_artikel.artikel_id%type,
                                          in_transport_gruppe       in lvs_lte.transport_gruppe%type,
                                          in_lkw_nr                 in lvs_lte.lkw_nr%type,
                                          in_offset_x               in lvs_lte.lte_offset_x%type,
                                          in_offset_y               in lvs_lte.lte_offset_y%type,
                                          in_offset_z                  in lvs_lte.lte_offset_z%type) is
  begin
    -- LTE auf neuen lagerplatz buchen !
    update lvs_lte lte
       set lgr_platz              = in_ist_lgr_platz,
           lgr_ort                = in_ist_lgr_ort,
           lgr_platz_gruppe       = in_ist_lgr_platz_gruppe,
           ziel_lgr_platz         = in_soll_lgr_platz,
           ziel_lgr_ort           = in_soll_lgr_ort,
           lte_status             = in_lte_Status,
           ziel_lgr_ort_n_freif   = in_ziel_lgr_ort_n_freif,
           ziel_lgr_platz_n_freif = in_ziel_lgr_platz_n_freif,
           lte_letzte_buchung     = in_l_buchung,
           lte.order_vorgang_id   = in_vorgang_id,
           lte.order_auf_id       = in_auf_id,
           lte.transport_gruppe   = in_transport_gruppe,
           lte.lkw_nr             = in_lkw_nr,
           lte.lte_offset_x          = in_offset_x,
           lte.lte_offset_y          = in_offset_y,
           lte.lte_offset_z          = in_offset_z
     where lte_id = in_lte_id;

    update lvs_lam lam
       set lam.lgr_platz = in_ist_lgr_platz
     where lam.lte_id = in_lte_id;
     /* LHa - 20220318 - P71141-125 - Bedingung wurde auskommentiert. Es führt ansonsten dazu, 
                                      dass der lgr_platz in der LVS_LTE anders ist als in der
                                      LVS_LAM und LVS_LHM */
     --  and (lam.lgr_platz != in_ist_lgr_platz or lam.lgr_platz is null);

    update lvs_lhm lhm
       set lhm.lgr_platz = in_ist_lgr_platz
     where lhm.lte_id = in_lte_id;
     /* LHa - 20220318 - P71141-125 - Bedingung wurde auskommentiert. Es führt ansonsten dazu, 
                                      dass der lgr_platz in der LVS_LTE anders ist als in der
                                      LVS_LAM und LVS_LHM */
     --  and (lhm.lgr_platz != in_ist_lgr_platz or lhm.lgr_platz is null);

    /* WK 2015-09-03: dies verfälscht die bereits vorher erfolgte Reservierung!
       wenn die Reservierung nicht eingetragen ist, dann wird die LAM für die Order auch
       nicht gebraucht. Und wenn in_auf_id NULL wäre würde die Reservierung zurückgesetzt werden.
    if in_artikel_id is not NULL
    then
      update lvs_lam lam
         set lam.order_pos_auf_id = in_auf_id
       where lam.lte_id = in_lte_id
         and lam.artikel_id = in_artikel_id;
    end if;
    */

  end;

  -------------------------------------------------------------------------
  procedure lvs_c_korr_te_einbuchen(in_te_sid              in lvs_lte.sid%TYPE,
                                    in_te_firma_nr         in lvs_lte.firma_nr%TYPE,
                                    in_lte_id              in LVS_LTE.LTE_ID%TYPE,
                                    in_lte_status          in lvs_lte.lte_status%TYPE,
                                    in_lgr_sid             in lvs_lgr.sid%TYPE,
                                    in_lgr_firma_nr        in lvs_lgr.firma_nr%TYPE,
                                    in_lgr_einl_ort        in lvs_lgr.lgr_ort%TYPE,
                                    in_lgr_einl_lagerplatz in LVS_LTE.LGR_PLATZ%TYPE,
                                    in_ls_login_id         in isi_user.login_id%TYPE,
                                    in_lgr_platz_pruefen   in boolean default true) is
  begin
    lvs_korr_te_einbuchen(in_te_sid, in_te_firma_nr, in_lte_id, in_lte_status, in_lgr_sid, in_lgr_firma_nr,
                          in_lgr_einl_ort, in_lgr_einl_lagerplatz, in_ls_login_id, in_lgr_platz_pruefen);
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  -------------------------------------------------------------------------
  procedure lvs_korr_te_einbuchen(in_te_sid              in lvs_lte.sid%TYPE,
                                  in_te_firma_nr         in lvs_lte.firma_nr%TYPE,
                                  in_lte_id              in lvs_lte.lte_id%type,
                                  in_lte_status          in lvs_lte.lte_status%TYPE,
                                  in_lgr_sid             in lvs_lgr.sid%TYPE,
                                  in_lgr_firma_nr        in lvs_lgr.firma_nr%TYPE,
                                  in_lgr_einl_ort        in lvs_lgr.lgr_ort%TYPE,
                                  in_lgr_einl_lagerplatz in lvs_lte.lgr_platz%type,
                                  in_ls_login_id         in isi_user.login_id%TYPE,
                                  in_lgr_platz_pruefen   in boolean default true) is

    v_found           boolean;
    v_neuer_Status    lvs_lte.lte_status%TYPE; -- neuer status der LTE
    v_lgr             lvs_lgr%ROWTYPE; -- Lagerplatz auf den die lte soll
    v_lte             lvs_lte%ROWTYPE; -- Lagerplatz auf den die lte soll
    v_lam             lvs_lam%rowtype;
    v_lam_bh_id       lvs_lam_bh.lam_bh_id%type;
    v_vorg_id         lvs_lam_bh.vorg_id%TYPE; -- Neu VORGang_ID aus Sequenz
    v_lte_status      lvs_lte.lte_status%type;
    v_transport       isi_transport%rowtype;

    v_lgr_platz lvs_lgr.lgr_platz%type; -- Lagerplatz für CURSOR

    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = v_lte.sid
         and t.firma_nr = v_lte.firma_nr
         and t.lte_name = v_lte.lte_name;

    CURSOR c_lvs_lte is -- Lesen des Lagerhilfsmittel
      select * from lvs_lte lte where lte.lte_id = in_LTE_ID;

    CURSOR c_lgr is -- Lesen des Lagerplatz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = v_lgr_platz
         and lgr.sid = in_lgr_sid;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = in_te_sid
         and lam.firma_nr = in_te_firma_nr
         and lam.lte_id = in_lte_id
         and lam.menge > 0;

  begin
    v_err_nr   := NULL;
    v_err_text := NULL;

    v_lgr_platz := in_lgr_einl_lagerplatz;
    if v_lgr_platz is null
    then
      raise_isi_error(c.FMID_LTE_ID_Null, LC.ec_p2(LC.O_TP2_LTE_BUCH_PLATZ_ERR, in_lte_id, 'NULL'));
    end if;

    -- LTE Einlesen
    OPEN c_lvs_lte;
    FETCH c_lvs_lte
      into v_lte;
    v_found := c_lvs_lte%FOUND;
    CLOSE c_lvs_lte;
    if not v_found
    then
      raise_isi_error(c.FMID_LTE_ID_Fehlt, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
    end if;

    if v_lte.lgr_platz is not NULL
    then
      return;
    end if;

    -- lagerplatz aus lvs_lgr lesen
    OPEN c_lgr; --
    FETCH c_lgr
      into v_lgr; -- Lesen den Eintrag des Lagerplatz
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if not v_found
    then
      raise_isi_error(c.FMID_Lager_Platz_fehlt, LC.ec_p2(LC.O_TP2_PLATZ_EXISTIERT_NICHT, v_lgr_platz, in_lte_id));
    end if;

    lvs_platz.v_ignor_inventur := True;
    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
    if v_lgr.lte_namen = 'Keine'
    then
      v_lgr.lte_namen := v_lgr.lte_namen_cfg;
    end if;
    v_err_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(v_lte,
                                                           v_basis_lte_name,
                                                           v_lte_cfg.flaechen_stellplatz_erf,
                                                           v_lgr,
                                                           'K',
                                                           NULL);
    if  v_err_text is not NULL
    and in_lgr_platz_pruefen = true
    then
      v_err_nr := lvs_platz.v_lgr_platz_fehler;
      raise v_error;
    end if;
    lvs_platz.v_ignor_inventur := False;
    lvs_platz.lvs_platz_einl_buchen(v_lte, v_lgr);
    v_lgr.lgr_akt_te := v_lgr.lgr_akt_te + 1;
    lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);

    if v_lgr.lgr_verwendung = C.LGR_TYP_WE then
      v_neuer_Status := c.LTE_BF_STAT;
    elsif v_lgr.lgr_verwendung = C.LGR_TYP_LagerP then
      v_neuer_Status := c.LTE_BF_STAT;
    elsif v_lgr.lgr_verwendung = C.LGR_TYP_WA then
      v_neuer_Status := c.LTE_AF_STAT;
    elsif v_lgr.lgr_verwendung = C.LGR_TYP_EP then
      v_neuer_Status := c.LTE_ET_STAT;
    else
      v_neuer_Status := c.LTE_LF_STAT;
    end if;

    if v_lte.lte_status = c.LTE_FF_STAT then
      delete isi_transport tra
       where tra.sid = in_te_sid
         and tra.firma_nr = in_te_firma_nr
         and tra.lgr_platz_ziel = v_lte.ziel_lgr_platz
         and tra.lte_id = v_lte.lte_id;

      v_lgr_platz := v_lte.ziel_lgr_platz;
      -- lagerplatz aus lvs_lgr lesen
      OPEN c_lgr; --
      FETCH c_lgr
        into v_lgr; -- Lesen den Eintrag des Lagerplatz
      v_found := c_lgr%FOUND;
      CLOSE c_lgr;

      lvs_platz.lvs_platz_einl_disp_ruecks(v_lte, v_lgr);
      lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);

      v_lte.ziel_lgr_ort   := v_lte.ziel_lgr_ort_n_freif;
      v_lte.ziel_lgr_platz := v_lte.ziel_lgr_platz_n_freif;

    end if;

    -- -AG- 29.04.2009 BugFix: LTE mit Menge 0 hat hier den Staus LF
    if v_lte.lgr_platz is NULL
      and (v_lte.lte_status = c.LTE_PF_STAT
        or v_lte.lte_status = c.LTE_LF_STAT
        or v_lte.lte_status = c.LTE_ED_STAT) -- AG Keine Inventur sonder einfach Zugan in der Schnittstelle
    then
      v_lte.lgr_platz  := v_lgr.lgr_platz;
      v_lte.lgr_ort    := v_lgr.lgr_ort;
      v_lte.lte_status := v_neuer_Status;

      s_schnittstelle.write_host_platz_lte_update(v_lte);
    else
      v_err_nr   := 30;
      v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
      select seq_vorg_id.nextval into v_vorg_id from dual;
      OPEN c_lam;
      LOOP
        fetch c_lam into v_lam;
        exit when c_lam%NOTFOUND;

         v_err_nr := 40;
         v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
         select seq_lam_bh.nextval into v_lam_bh_id from dual;
         v_err_nr := 50;
         v_err_text := LC.ec_p1(LC.O_TP1_BUCH_ERR, '(Korr TE Eienbuchen)');
         -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
         insert into lvs_lam_bh
           values(v_lam.sid,
                  v_lam.firma_nr,
                  v_vorg_id,
                  C.LAM_BH_INV,
                  v_lam_bh_id,
                  v_lam.lam_id,
                  v_lam.artikel_id,
                  c.LAM_BH_BUS_INV,
                  sysdate,
                  in_ls_login_id,
                  in_lgr_einl_lagerplatz,
                  v_lam.lte_id,
                  v_lam.lhm_id,
                  v_lam.charge_id,
                  v_lam.serie_id,
                  NULL,
                  v_lam.menge,
                  v_lam.lam_kg,
                  v_lam.lam_kg / decode(v_lam.menge, 0, 1, v_lam.menge),
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  sysdate,                     -- CREATED_DATE  N DATE  Y     creation date+time of this dataset
                  in_ls_login_id,              -- CREATED_LOGIN_ID  N NUMBER  Y     login id of the user creating this dataset
                  sysdate,                     -- LAST_CHANGE_DATE  N DATE  Y     change date+time of this dataset
                  in_ls_login_id,              -- LAST_CHANGE_LOGIN_ID  N NUMBER  Y     login id of the user changing this dataset
                  null,                        -- CHANGE_MENGE  N NUMBER  Y     Menge die geändert wurde
                  v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                  null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
        update lvs_lam t
           set t.lte_id = v_lam.lte_id
         where t.lam_id = v_lam.lam_id;
      end LOOP;
      CLOSE c_lam;
    end if;

    v_lte_status := nvl(in_lte_status, v_lte.lte_status);

    -- CMe 20210419 Anfang
    -- Wenn ein Transport noch offen ist und die Palette auf einen Platz umgebucht wurde, muss
    -- der Status richtig gesetzt werden Abhängig von Transport Ziel. Ticket: E70397-603
    if not lvs_p_base.get_transport_by_lte_id(in_lte_id,
                                              v_transport)
    then
      v_transport := NULL;
      v_lte.ziel_lgr_ort := NULL;
      v_lte.ziel_lgr_platz := NULL;
      v_lte.ziel_lgr_ort_n_freif := NULL;
      v_lte.ziel_lgr_platz_n_freif := NULL;
      v_lte.transport_gruppe := NULL;
      v_lte.lkw_nr := NULL;
    else
      if (v_transport.transp_typ = 'E') and
         (v_lgr.lgr_verwendung = c.LGR_TYP_Lager) and
         (v_transport.status = c.TRANS_FREI)
      then
        v_neuer_Status := c.LTE_UD_STAT;
      end if;

      if (v_transport.transp_typ = 'E') and
         (v_lgr.lgr_verwendung = c.LGR_TYP_Lager) and
         ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
      then
        v_neuer_Status := c.LTE_UT_STAT;
      end if;

      if (v_transport.transp_typ = 'E') and
         (v_lgr.lgr_verwendung <> c.LGR_TYP_Lager) and
         (v_transport.status = c.TRANS_FREI)
      then
        v_neuer_Status := c.LTE_ED_STAT;
      end if;

      if (v_transport.transp_typ = 'E') and
         (v_lgr.lgr_verwendung <> c.LGR_TYP_Lager) and
         ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
      then
        v_neuer_Status := c.LTE_ET_STAT;
      end if;

      if (v_transport.transp_typ = 'A') and
         (v_transport.status = c.TRANS_FREI)
      then
        v_neuer_Status := c.LTE_AD_STAT;
      end if;

      if (v_transport.transp_typ = 'A') and
         ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
      then
        v_neuer_Status := c.LTE_AT_STAT;
      end if;

      if (v_transport.transp_typ = 'U') and
         (v_transport.status = c.TRANS_FREI)
      then
        v_neuer_Status := c.LTE_UD_STAT;
      end if;

      if (v_transport.transp_typ = 'U') and
         ((v_transport.status = c.TRANS_TRANSPORT) or (v_transport.status = c.TRANS_BEGIN))
      then
        v_neuer_Status := c.LTE_UT_STAT;
      end if;
    end if;
    -- CMe 20210419 Ende

    lvs_p_lte.lvs_te_lagerziel_umbuchen_353(in_te_sid,
                                            in_te_firma_nr,
                                            in_lte_id,
                                            in_lgr_einl_lagerplatz,
                                            v_lgr.lgr_ort,
                                            v_lgr.lgr_platz_gruppe,
                                            v_lte.ziel_lgr_platz,
                                            v_lte.ziel_lgr_ort,
                                            v_neuer_status,
                                            v_lte_status,
                                            v_lte.ziel_lgr_platz_n_freif,
                                            v_lte.ziel_lgr_ort_n_freif,
                                            systimestamp,
                                            v_lte.order_auf_id,
                                            v_lte.order_vorgang_id,
                                            NULL,
                                            v_lte.transport_gruppe,
                                            v_lte.lkw_nr,
                                            v_lte.lte_offset_x,
                                            v_lte.lte_offset_y,
                                            lvs_platz.lvs_get_lgr_offset_z(in_lgr_einl_lagerplatz) + v_lte.lte_vol_hoehe);
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  -------------------------------------------------------------------------
  procedure lvs_korr_te_ausbuchen(in_te_sid         in lvs_lte.sid%TYPE,
                                  in_te_firma_nr    in lvs_lte.firma_nr%TYPE,
                                  in_lte_id         in LVS_LTE.LTE_ID%TYPE,
                                  in_lte_status     in lvs_lte.lte_status%TYPE,
                                  in_lgr_sid        in lvs_lgr.sid%TYPE,
                                  in_lgr_firma_nr   in lvs_lgr.firma_nr%TYPE,
                                  in_lgr_ort        in lvs_lgr.lgr_ort%TYPE,
                                  in_lgr_lagerplatz in LVS_LTE.LGR_PLATZ%TYPE,
                                  in_ls_login_id    in isi_user.login_id%TYPE) is

    v_found        boolean;
    v_neuer_Status lvs_lte.lte_status%TYPE; -- neuer status der LTE
    v_lgr          lvs_lgr%ROWTYPE; -- Lagerplatz auf dem die LTE steht
    v_lte          lvs_lte%ROWTYPE; -- LTE
    v_transport    isi_transport%ROWTYPE;

    v_lam          lvs_lam%rowtype;
    v_lam_bh_id    lvs_lam_bh.lam_bh_id%type;
    v_vorg_id   lvs_lam_bh.vorg_id%TYPE; -- Neu VORGang_ID aus Sequenz

    CURSOR c_transport is
      select tra.*
        from isi_transport tra
       where tra.sid = v_lte.sid
         and tra.firma_nr = v_lte.firma_nr
         and tra.lte_id = v_lte.lte_id
         and tra.lgr_platz_quelle = v_lgr.lgr_platz;

    CURSOR c_lvs_lte is -- Lesen des Lagerhilfsmittel
      select * from lvs_lte lte where lte.lte_id = in_LTE_ID;

    CURSOR c_lgr is -- Lesen des Lagerplatz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = v_lte.lgr_platz
         and lgr.sid = in_lgr_sid;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = in_te_sid
         and lam.firma_nr = in_te_firma_nr
         and lam.lte_id = in_lte_id
         and lam.menge > 0
         and lam.lgr_platz is not null;

  begin
    reset_isi_error();

    -- LTE Einlesen
    OPEN c_lvs_lte;
    FETCH c_lvs_lte
      into v_lte;
    v_found := c_lvs_lte%FOUND;
    CLOSE c_lvs_lte;
    if not v_found
    then
      raise_isi_error(c.FMID_LTE_ID_Fehlt, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
    end if;

    -- lagerplatz aus lvs_lgr lesen
    OPEN c_lgr; --
    FETCH c_lgr into v_lgr; -- Lesen den Eintrag des Lagerplatz
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;

    if v_lte.lgr_platz is NULL
    then
      Return; -- Palette hat keinen Lagerplatz mehr. Ausbuchen nicht möglich
    end if;
    if not v_found
    then
      raise_isi_error(c.FMID_Lager_Platz_fehlt, LC.ec_p2(LC.O_TP2_PLATZ_EXISTIERT_NICHT, v_lte.lgr_platz, in_lte_id));
    end if;

    if v_lte.lte_akt_lhm = 0 -- Wegen rekursivem Aufruf, wenn Palette nicht leer aus LAM_BH Trigger
    then
      lvs_platz.LVS_PLATZ_AUSL_BUCHEN(v_lte, v_lgr);
    end if;
    v_neuer_status := c.LTE_KF_STAT;

    v_err_nr   := 30;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_vorg_id.nextval into v_vorg_id from dual;
    OPEN c_lam;
    LOOP
      fetch c_lam into v_lam;
      exit when c_lam%NOTFOUND;

       v_err_nr := 40;
       v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
       select seq_lam_bh.nextval into v_lam_bh_id from dual;
       v_err_nr := 50;
       v_err_text := LC.ec_p1(LC.O_TP1_BUCH_ERR, '(Korr. TE Einbuchen)');
       -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
       insert into lvs_lam_bh
         values(v_lam.sid,
                v_lam.firma_nr,
                v_vorg_id,
                C.LAM_BH_INV,
                v_lam_bh_id,
                v_lam.lam_id,
                v_lam.artikel_id,
                c.LAM_BH_BUS_INV,
                sysdate,
                in_ls_login_id,
                v_lam.lgr_platz,
                v_lam.lte_id,
                v_lam.lhm_id,
                v_lam.charge_id,
                v_lam.serie_id,
                NULL,
                v_lam.menge * -1,
                v_lam.lam_kg * -1,
                v_lam.lam_kg / decode(v_lam.menge, 0, 1, v_lam.menge),
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                sysdate,                     -- CREATED_DATE  N DATE  Y     creation date+time of this dataset
                in_ls_login_id,              -- CREATED_LOGIN_ID  N NUMBER  Y     login id of the user creating this dataset
                sysdate,                     -- LAST_CHANGE_DATE  N DATE  Y     change date+time of this dataset
                in_ls_login_id,              -- LAST_CHANGE_LOGIN_ID  N NUMBER  Y     login id of the user changing this dataset
                null,                        -- CHANGE_MENGE  N NUMBER  Y     Menge die geändert wurde
                v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
                null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
    end LOOP;
    CLOSE c_lam;

    if v_lte.lte_akt_lhm != 0 -- Sicherheitshalber Hier LTE_Ausbuchen
    then
      lvs_platz.LVS_PLATZ_AUSL_BUCHEN(v_lte, v_lgr);
      -- CMe 20210204 --> Wenn Eine Lte einen Transport hat und die LTe ausgebucht wird,
      -- muss die Disponierung zurückgesetzt werden
      open c_transport;
      fetch c_transport into v_transport;
      v_found := c_transport%found;
      close c_transport;
      if (v_found)
      then
        lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte, v_lgr);
      end if;
    end if;

    lvs_te_lagerziel_umbuchen_353(in_te_sid,
                                  in_te_firma_nr,
                                  in_lte_id,
                                  null,
                                  null,
                                  null,
                                  v_lte.ziel_lgr_platz,
                                  v_lte.ziel_lgr_ort,
                                  v_neuer_status,
                                  in_lte_status,
                                  v_lte.ziel_lgr_platz_n_freif,
                                  v_lte.ziel_lgr_ort_n_freif,
                                  systimestamp,
                                  v_lte.order_auf_id,
                                  v_lte.order_vorgang_id,
                                  NULL,
                                  v_lte.transport_gruppe,
                                  v_lte.lkw_nr,
                                  v_lte.lte_offset_x,
                                  v_lte.lte_offset_y,
                                  NULL);

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  -------------------------------------------------------------------------
  procedure lvs_c_korr_te_ausbuchen(in_te_sid         in lvs_lte.sid%TYPE,
                                    in_te_firma_nr    in lvs_lte.firma_nr%TYPE,
                                    in_lte_id         in LVS_LTE.LTE_ID%TYPE,
                                    in_lte_status     in lvs_lte.lte_status%TYPE,
                                    in_lgr_sid        in lvs_lgr.sid%TYPE,
                                    in_lgr_firma_nr   in lvs_lgr.firma_nr%TYPE,
                                    in_lgr_ort        in lvs_lgr.lgr_ort%TYPE,
                                    in_lgr_lagerplatz in LVS_LTE.LGR_PLATZ%TYPE,
                                    in_ls_login_id    in isi_user.login_id%TYPE) is
    -------------------------------------------------------------------------
  begin
    lvs_korr_te_ausbuchen(in_te_sid, -- in lvs_lte.sid%TYPE,
                          in_te_firma_nr, -- in lvs_lte.firma_nr%TYPE,
                          in_lte_id, -- in LVS_LTE.LTE_ID%TYPE,
                          in_lte_status, -- in lvs_lte.lte_status%TYPE,
                          in_lgr_sid, -- in lvs_lgr.sid%TYPE,
                          in_lgr_firma_nr, -- in lvs_lgr.firma_nr%TYPE,
                          in_lgr_ort, -- in lvs_lgr.lgr_ort%TYPE,
                          in_lgr_lagerplatz, -- in LVS_LTE.LGR_PLATZ%TYPE,
                          in_ls_login_id); -- in isi_user.login_id%TYPE)
    commit;

  end;

  function lvs_get_lte_id_by_ort_x_y(in_sid       in isi_sid.sid%type,
                                     in_firma_nr  in isi_firma.firma_nr%type,
                                     in_lgr_ort   in lvs_lgr_ort.lgr_ort%type,
                                     in_x_pos     in lvs_lgr.lgr_pos_x%type,
                                     in_y_pos     in lvs_lgr.lgr_pos_y%type)
                                     return varchar2 is

    v_lgr_platz               lvs_lgr.lgr_platz%type;
    v_lte_id                  lvs_lte.lte_id%type;
    v_x_pos     lvs_lgr.lgr_pos_x%type;
    v_y_pos     lvs_lgr.lgr_pos_y%type;
    v_lgr_vol_breite lvs_lgr.lgr_vol_breite%type;
    v_lgr_vol_tiefe lvs_lgr.lgr_vol_tiefe%type;

    CURSOR c_lte_id is
        select t.lte_id
          from lvs_lte t
         where t.lgr_platz = v_lgr_platz
           and t.lte_offset_z = (select max(x.lte_offset_z) from lvs_lte x where x.lgr_platz = v_lgr_platz);

  begin
    v_x_pos     := in_x_pos;
    v_y_pos     := in_y_pos;


    v_lgr_platz := lvs_platz.lvs_suche_flaechenplatz(in_sid,
                                                     in_firma_nr,
                                                     in_lgr_ort,
                                                     v_x_pos,
                                                     v_y_pos,
                                                     v_lgr_vol_breite,
                                                     v_lgr_vol_tiefe);
    OPEN c_lte_id;
    FETCH c_lte_id into v_lte_id;
    OPEN c_lte_id;
    return (v_lte_id);
  end;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Function ist zum wiedereinlagern einer Restmenge von LTE's (AG)
  -- -AG- Achtung, diese Funktion geht nicht bei Umlaufbehältern, wenn Daten in der Historie
  -- Nur für LTEs die nur einen LHM (Behälter) hatten
  -- return  0 Alles OK
  --        -1 Menge falsch Max-Menge dann in io_menge
  --        -2 Mehr als ein LHM auf der Palette
  -- Exception wenn LTE nicht im aktiven Bestand
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  function  lvs_c_lte_rest_einl(in_lte_id     in lvs_lte.lte_id%type,
                                io_menge      in out lvs_lam.menge%type)
                                return number is
    v_found    boolean;

    v_lam_bh_id                               lvs_lam_bh.lam_bh_id%TYPE; -- Neu LAM_BH_ID aus Sequenz
    v_vorg_id                                 lvs_lam_bh.vorg_id%type;
    v_lte                                     lvs_lte%rowtype;
    v_lhm                                     lvs_lhm%rowtype;
    v_lam_bh                                  lvs_lam_bh%rowtype;
    v_last_ag_dat                             date;
    v_last_ag_anz                             number;
    v_last_lhm_id                             lvs_lhm.lhm_id%TYPE;

    CURSOR c_lte is
      select t.*
        from lvs_lte t
       where t.lte_id = in_lte_id;

    CURSOR c_lam_bh_last_ag is
      select max(l.buch_datum),
             count(l.buch_datum)
        from lvs_lam_bh l
       where l.lte_id = in_lte_id
         and l.bus = c.LAM_BH_BUS_ABG
         and l.buch_datum = nvl(v_last_ag_dat, l.buch_datum);

    CURSOR c_lam_bh is
      select *
        from lvs_lam_bh l
       where l.lte_id = in_lte_id
         and l.bus = c.LAM_BH_BUS_ABG
         and l.buch_datum = v_last_ag_dat;

    CURSOR c_lhm is
     select *
       from lvs_lhm t
       where t.lhm_id = v_last_lhm_id;

  begin

    OPEN c_lte;
    FETCH c_lte into v_lte;

    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id));
    else

      if nvl(v_lte.lte_akt_lhm, 0) != 0
      then
        v_err_nr := 11;
        v_err_text := LC.ec_p2(LC.O_TP2_LTE_ERR_HAT_STATUS, in_lte_id, v_lte.lte_status);
        raise v_error;
      end if;

      v_last_ag_dat := NULL;
      OPEN c_lam_bh_last_ag;
      FETCH c_lam_bh_last_ag into v_last_ag_dat, v_last_ag_anz;
      CLOSE c_lam_bh_last_ag;
      -- Jetzt mit datum letzten Eintrag suchen und Zählen dass nur ein LAM auf Palette
      OPEN c_lam_bh_last_ag;
      FETCH c_lam_bh_last_ag into v_last_ag_dat, v_last_ag_anz;
      CLOSE c_lam_bh_last_ag;

      if (v_last_ag_anz != 1)
      then
        return (-2);
      end if;

      OPEN c_lam_bh;
      FETCH c_lam_bh into v_lam_bh;
      CLOSE c_lam_bh;

      if v_lam_bh.menge < io_menge
      then
        io_menge := v_lam_bh.menge;
        return (-1);
      end if;

      update lvs_lam_bh t
         set t.menge = v_lam_bh.menge - io_menge
       where t.lam_bh_id = v_lam_bh.lam_bh_id;
    end if;
    commit;
    return(0);

  exception
    when others then
      rollback;
      if v_err_nr is not NULL
      then
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        raise;
      end if;
  end lvs_c_lte_rest_einl;
  
  /*
  __________________________________________________
  Author    : CMe
  Created   : 10.03.2022
  __________________________________________________
  Description
  Abgeleitet Funktion von lvs_suche_neue_lte_old_crtl unterscheidet
  zwischen Transporten für die Fertigungsversorgung und Verladung.
  
  Wenn der Transport für keine der beiden Varianten ist wird die
  Abhandlung für Verladungen aufgerufen.
  
  Ticket: P71141-117
  __________________________________________________
  TODO
  none.
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  10.03.2022   DB31_1      (-CMe-)  Neue Logik erstellt  
  */
  function lvs_suche_neue_lte_old_crtl_31(in_transport       in isi_transport%rowtype,
                                          in_user_id         in isi_user.login_id%type,
                                          in_lte_crtl        in varchar2,
                                          in_lte_id          in lvs_lte.lte_id%type
                                         ) return varchar2 is
  v_ret                  varchar2(100);
  v_found                boolean;
  
  v_lte_id               lvs_lte.lte_id%type;
  v_lte_t                lvs_lte%rowtype;
  v_order_pos            isi_order_pos%rowtype;
  v_bde_fa                bde_fa_auftrag%rowtype;
  
  cursor c_check_is_order is
    select opos.*
      from isi_order_pos opos
     where opos.auf_id in (select min(lam.order_pos_auf_id) 
                            from lvs_lam lam
                           where lam.lte_id = v_lte_t.lte_id);
  
  cursor c_check_is_fa is
    select fa.*
      from bde_fa_auftrag fa
     where fa.auf_id in (select min(lam.order_pos_auf_id) 
                          from lvs_lam lam
                         where lam.lte_id = v_lte_t.lte_id);
  begin
    v_lte_id := in_transport.lte_id;
    v_ret := LC.ec('O_TP1_NO_ACTION_TAKEN');
    
    v_found := lvs_p_base.get_lte(v_lte_id,  -- in_lte_id in lvs_lte.lte_id%type,
                                  v_lte_t);  -- io_lte    in out lvs_lte%rowtype) return boolean is
                                  
    if not v_found
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(in_transport.lte_id, 'NULL')));
    end if;
    
    open c_check_is_order;
    fetch c_check_is_order into v_order_pos;
    v_found := c_check_is_order%found;
    close c_check_is_order;
    
    if (v_found)
    then
      v_ret := lvs_suche_neue_lte_old_crtl_or(in_transport,
                                              in_user_id,      
                                              in_lte_crtl,     
                                              in_lte_id);
    else
      open c_check_is_fa;
      fetch c_check_is_fa into v_bde_fa;
      v_found := c_check_is_fa%found;
      close c_check_is_fa;
      
      if (v_found)
      then
        v_ret := lvs_suche_neue_lte_old_crtl_fa(in_transport,
                                                in_user_id,      
                                                in_lte_crtl,     
                                                in_lte_id);
      else
        v_ret := lvs_suche_neue_lte_old_crtl_or(in_transport,
                                                in_user_id,      
                                                in_lte_crtl,     
                                                in_lte_id);
      end if;
    end if;
  return (v_ret);
  exception
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end lvs_suche_neue_lte_old_crtl_31;
  
  /*
  __________________________________________________
  Author    : CMe
  Created   : 10.03.2022
  __________________________________________________
  Description
  Die Funktion sucht nach Ersatz LTE's für eine LTE die Transportiert
  werden soll. Abgeleitet Funktion von lvs_suche_neue_lte_old_crtl spezialisert
  auf Transporte für Fertgigungsversorgung.
  
  Ticket: P71141-117
  __________________________________________________
  TODO
  none.
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  10.03.2022   DB31_1      (-CMe-)  Neue Logik erstellt
  25.04.2022   DB31_2      (-CMe-)  CMe 20220425 P71141-171 --> create_new_lam_f_rest durch add_amount_to_reservation ersetzt
                                    Verhindert Reservierung für einen Auftrag über mehrere LAMs, wenn
                                    auf der LTE bereits für die Order eine Reservierung vorhanden ist
  11.08.20222  DB31_3      (-CMe-)  MHD berücksichtigen bei suche nach neuer LAM
  */
  function lvs_suche_neue_lte_old_crtl_fa(in_transport       in isi_transport%rowtype,
                                          in_user_id         in isi_user.login_id%type,
                                          in_lte_crtl        in varchar2,
                                          in_lte_id          in lvs_lte.lte_id%type
                                         ) return varchar2 is
  v_ret                  varchar2(100);
  v_found                boolean;
  
  v_dispo_res_lte_chk    varchar2(1);
  
  v_menge_sum            number;
  v_res_menge            number;
  
  v_lgr_grp_trans_ziel   lvs_lgr.lgr_platz_gruppe%type;
  
  v_lte_id               lvs_lte.lte_id%type;
  v_lte_t                lvs_lte%rowtype;
  v_lte_n                lvs_lte%rowtype;
  v_lte_status_neu       lvs_lte.lte_status%type;
  v_c_lte_status_neu     lvs_lte.lte_status%type;
  
  v_min_lte_id           lvs_lte.lte_id%type;
  
  v_lams                 lvs_lam%rowtype;
  v_g_lams               lvs_lam%rowtype;
  
  v_lgr_ziel             lvs_lgr%rowtype;
  v_lgr_quelle           lvs_lgr%rowtype;
  v_lgr_quelle_e         lvs_lgr%rowtype;
  
  v_g_lam_id             lvs_lam.lam_id%type;
  v_g_lte_id             lvs_lam.lte_id%type;
  v_g_artikel_id         lvs_lam.artikel_id%type;
  v_g_menge              lvs_lam.menge%type;
  v_g_res_menge          lvs_lam.res_menge%type;
  v_g_lgr_ort            lvs_lgr_ort.lgr_ort%type;
  v_g_lgr_adresse        lvs_lgr_ort.adress_id%type;
  v_g_lgr_dim_platz      lvs_lgr.lgr_dim_platz%type;
  v_g_auf_id             lvs_lam.order_pos_auf_id%type;
  v_g_max_charge_id      lvs_lam.charge_id%type;
  v_g_max_leitzahl       lvs_lam.leitzahl%type;
  v_g_max_fa_ag          lvs_lam.fa_ag%type;
  v_g_min_charge_id      lvs_lam.charge_id%type;
  v_g_min_leitzahl       lvs_lam.leitzahl%type;
  v_g_min_fa_ag          lvs_lam.fa_ag%type;
  v_g_lte_name           lvs_lte.lte_name%type;
  v_g_owner_adr_id       lvs_lam.owner_address_id%type;

  v_g_lam_sel_1          varchar2(4096);
  v_g_lam_sel_2          varchar2(4096);
  v_g_lam_sel_3          varchar2(4096);
  v_g_lam_sel_4          varchar2(4096);
  v_g_lam_sel_5          varchar2(4096);
  v_g_lam_sel_6          varchar2(4096);
  v_g_lam_sel_7          varchar2(4096);
  v_g_lam_sel_8          varchar2(4096);
  v_g_lam_sel_9          varchar2(4096);
  v_g_lam_sel_10         varchar2(4096);
  v_g_hersteller_k_liste varchar2(4096);
  v_g_leitzahl           lvs_lam.leitzahl%type;
  v_g_fa_ag              lvs_lam.fa_ag%type;
  v_g_charge_id          lvs_lam.charge_id%type;
  v_g_res_ziel_lte_id    lvs_lam.res_ziel_lte_id%type;
  v_g_res_login_id       lvs_lam.res_login_id%type;
  
  v_e_lte_id             lvs_lte.lte_id%type;
  v_e_artikel_id         lvs_lam.artikel_id%type;
  v_e_lgr_dim_platz      lvs_lgr.lgr_dim_platz%type;
  v_e_lgr_platz          lvs_lgr.lgr_platz%type;
  v_e_lgr_ort            lvs_lgr_ort.lgr_ort%type;
  v_e_adress_id          lvs_lgr_ort.adress_id%type;
  v_e_sum_menge          number;
  v_e_min_leitzahl       lvs_lam.leitzahl%type;
  v_e_max_leitzahl       lvs_lam.leitzahl%type;
  v_e_min_ch             lvs_lam.charge_id%type;
  v_e_max_ch             lvs_lam.charge_id%type;
  
  v_min_auf_id           lvs_lam.order_pos_auf_id%type;
    
  CURSOR c_lam_g is
    select lam.lam_id,
           lam.lte_id,
           lam.artikel_id,
           lam.charge_id,
           lam.leitzahl,
           lam.fa_ag,
           lam.menge,
           nvl(lam.lam_sel1, 'NO_LAM_SEL'),
           nvl(lam.lam_sel2, 'NO_LAM_SEL'),
           nvl(lam.lam_sel3, 'NO_LAM_SEL'),
           nvl(lam.lam_sel4, 'NO_LAM_SEL'),
           nvl(lam.lam_sel5, 'NO_LAM_SEL'),
           nvl(lam.lam_sel6, 'NO_LAM_SEL'),
           nvl(lam.lam_sel7, 'NO_LAM_SEL'),
           nvl(lam.lam_sel8, 'NO_LAM_SEL'),
           nvl(lam.lam_sel9, 'NO_LAM_SEL'),
           nvl(lam.lam_sel10, 'NO_LAM_SEL'),
           nvl(lam.hersteller_kuerzel_liste, 'NO_HERS_LISTE'),
           nvl(lam.res_menge, 0),
           lam.order_pos_auf_id,
           ort.lgr_ort,
           ort.adress_id,
           lgr.lgr_dim_platz,
           lam.res_ziel_lte_id,
           lam.res_login_id,
           lam.owner_address_id
      from lvs_lam lam
      left join lvs_lgr lgr on lgr.lgr_platz = lam.lgr_platz
      left join lvs_lgr_ort ort on ort.lgr_ort = lgr.lgr_ort
     where lam.sid          = v_lte_t.sid
       and lam.firma_nr     = v_lte_t.firma_nr
       and lam.lte_id       = v_lte_t.lte_id
       and lam.order_pos_auf_id is not null
     order by lam.order_pos_auf_id asc;
  
  --CMe 20220811 MHD berücksichtigen
  --CMe 20220819 Erweiterung um weitere Abfragen, um zu verhindern, dass nicht zulässigen genommen wird
  CURSOR c_lam_e is
    select * 
      from (select lte.lte_id,
                   lam.artikel_id,
                   lgr.lgr_dim_platz,
                   lte.lgr_platz,
                   ort.lgr_ort,
                   ort.adress_id,
                   sum(lam.menge) sum_menge,
                   min(lam.leitzahl) min_leitzahl,
                   max(lam.leitzahl) max_leitzahl,
                   min(lam.charge_id) min_ch,
                   max(lam.charge_id) max_ch
              from lvs_lam lam
              join lvs_lte lte on lte.lte_id = lam.lte_id
              join lvs_lgr lgr on lgr.lgr_platz = lte.lgr_platz
              join lvs_lgr_ort ort on ort.lgr_ort = lte.lgr_ort
              where lam.sid = v_lte_t.sid
                and lam.firma_nr = v_lte_t.firma_nr
                and lam.lte_id != v_lte_t.lte_id
                and lte.lte_status in (c.LTE_LF_STAT, c.LTE_BF_STAT)
                and lam.artikel_id = v_g_artikel_id
                and nvl(lam.fa_ag, -1) = nvl(v_g_fa_ag, -1)
                and ort.adress_id = v_g_lgr_adresse
                and lam.order_pos_auf_id is null
                and (lte.lte_id = in_lte_id or in_lte_id is NULL)
                and nvl(lam.lam_sel1, 'NO_LAM_SEL') = nvl(v_g_lam_sel_1, 'NO_LAM_SEL')
                and nvl(lam.lam_sel2, 'NO_LAM_SEL') = nvl(v_g_lam_sel_2, 'NO_LAM_SEL')
                and nvl(lam.lam_sel3, 'NO_LAM_SEL') = nvl(v_g_lam_sel_3, 'NO_LAM_SEL')
                and nvl(lam.lam_sel4, 'NO_LAM_SEL') = nvl(v_g_lam_sel_4, 'NO_LAM_SEL')
                and nvl(lam.lam_sel5, 'NO_LAM_SEL') = nvl(v_g_lam_sel_5, 'NO_LAM_SEL')
                and nvl(lam.lam_sel6, 'NO_LAM_SEL') = nvl(v_g_lam_sel_6, 'NO_LAM_SEL')
                and nvl(lam.lam_sel7, 'NO_LAM_SEL') = nvl(v_g_lam_sel_7, 'NO_LAM_SEL')
                and nvl(lam.lam_sel8, 'NO_LAM_SEL') = nvl(v_g_lam_sel_8, 'NO_LAM_SEL')
                and nvl(lam.lam_sel9, 'NO_LAM_SEL') = nvl(v_g_lam_sel_9, 'NO_LAM_SEL')
                and nvl(lam.lam_sel10, 'NO_LAM_SEL') = nvl(v_g_lam_sel_10, 'NO_LAM_SEL')
                and nvl(lam.hersteller_kuerzel_liste, 'NO_HERS_LISTE') = nvl(v_g_hersteller_k_liste, 'NO_HERS_LISTE')
                and nvl(lam.owner_address_id, -1) = nvl(v_g_owner_adr_id, -1)
                and lgr.lgr_platz_gruppe != nvl(v_lgr_grp_trans_ziel, 'NO_LGR_GROUP')
                and lam.lam_mhd >= sysdate
                and lam.labor_status = 'F'
                and lgr.gesperrt = 'F'
                and (lgr.lgr_verwendung = C.R_Lgr_Typ_Lager or -- Lagertypen und Verwendungstypen erlaubt (Lager)
                     lgr.lgr_verwendung = C.R_Lgr_Typ_LagerP or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                     lgr.lgr_verwendung = C.R_LGR_TYP_Puffer or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                     (lgr.lgr_verwendung = C.R_LGR_TYP_WA and  -- Nur WA's wenn der WA_TYP BDEPUSH oder BDEICEPUSH
                      lgr.wa_typ in ('BDEPUSH', 'BDEICEPUSH')))
                and lte.lte_id not like 'V_R_LTE_%'
              group by lte.lte_id,
                   lam.artikel_id,
                   lgr.lgr_dim_platz,
                   lte.lgr_platz,
                   ort.lgr_ort,
                   ort.adress_id)
     order by abs(sum_menge - v_g_menge),
              abs(decode(min_ch, max_ch, max_ch, NULL) - v_g_charge_id),
              abs(decode(min_leitzahl, max_leitzahl, min_leitzahl, NULL) - v_g_leitzahl),
              abs(lgr_ort - v_g_lgr_ort),
              abs(lgr_dim_platz - v_g_lgr_dim_platz);
  
  --CMe 20220811 MHD berücksichtigen
  CURSOR c_get_lams is    
    select lam.*
      from lvs_lam lam
     where lam.lte_id = v_e_lte_id
       and lam.artikel_id = v_e_artikel_id
       and lam.order_pos_auf_id is null
       and nvl(lam.fa_ag, -1) = nvl(v_g_fa_ag, -1)
       and nvl(lam.lam_sel1, 'NO_LAM_SEL') = nvl(v_g_lam_sel_1, 'NO_LAM_SEL')
       and nvl(lam.lam_sel2, 'NO_LAM_SEL') = nvl(v_g_lam_sel_2, 'NO_LAM_SEL')
       and nvl(lam.lam_sel3, 'NO_LAM_SEL') = nvl(v_g_lam_sel_3, 'NO_LAM_SEL')
       and nvl(lam.lam_sel4, 'NO_LAM_SEL') = nvl(v_g_lam_sel_4, 'NO_LAM_SEL')
       and nvl(lam.lam_sel5, 'NO_LAM_SEL') = nvl(v_g_lam_sel_5, 'NO_LAM_SEL')
       and nvl(lam.lam_sel6, 'NO_LAM_SEL') = nvl(v_g_lam_sel_6, 'NO_LAM_SEL')
       and nvl(lam.lam_sel7, 'NO_LAM_SEL') = nvl(v_g_lam_sel_7, 'NO_LAM_SEL')
       and nvl(lam.lam_sel8, 'NO_LAM_SEL') = nvl(v_g_lam_sel_8, 'NO_LAM_SEL')
       and nvl(lam.lam_sel9, 'NO_LAM_SEL') = nvl(v_g_lam_sel_9, 'NO_LAM_SEL')
       and nvl(lam.lam_sel10, 'NO_LAM_SEL') = nvl(v_g_lam_sel_10, 'NO_LAM_SEL')
       and nvl(lam.hersteller_kuerzel_liste, 'NO_HERS_LISTE') = nvl(v_g_hersteller_k_liste, 'NO_HERS_LISTE')
       and nvl(lam.owner_address_id, -1) = nvl(v_g_owner_adr_id, -1)
       and lam.lam_mhd >= sysdate
     order by abs(lam.menge - v_g_menge);
  
  CURSOR c_get_lte_e is
    select lte.*
      from lvs_lte lte
      join lvs_lam lam on lam.lte_id = lte.lte_id
      join lvs_lgr lgr on lgr.lgr_platz = lte.lgr_platz
     where lam.order_pos_auf_id = v_min_auf_id
       and lte.lte_id = v_min_lte_id
     order by lte.lgr_ort,
              lgr.lgr_platz_gruppe,
              lgr.lgr_dim_fifo_nr
     offset 0 rows fetch next 1 rows only;
  
  CURSOR c_get_lgr_grp_trans_ziel is
    select lgr.lgr_platz_gruppe
      from lvs_lgr lgr
     where lgr.lgr_platz = in_transport.lgr_platz_ziel; 
  begin
                                                        
    -- Prüfen ob mehrfach Reservierung erlaubt ist
    -- F = NICHT PRUEFEN - Es dürfen Reservierungen auf der LTE sein
    -- T = PRUEFEN - Es dürfen KEINE Reservierungen auf der LTE sein
    v_dispo_res_lte_chk := isi_allg.get_firma_cfg_param(in_transport.sid,
                                                        in_transport.firma_nr,
                                                        'AUSL_BDE_PUSH',
                                                        'RES',
                                                        'BDE_AUSL_LTE_CHK_DISPO',
                                                        'BDE',
                                                        'CFG',
                                                        'F',
                                                        'BOOLEAN');
    
    v_min_lte_id := in_lte_id;
    v_lte_id := in_transport.lte_id;
    v_ret := LC.ec('O_TP1_NO_ACTION_TAKEN');
    
    -- Neue LTE darf nicht in der selben Lagerplatzgruppe stehen, wie das Transport Ziel
    open c_get_lgr_grp_trans_ziel;
    fetch c_get_lgr_grp_trans_ziel into v_lgr_grp_trans_ziel;
    close c_get_lgr_grp_trans_ziel;
    
    if (nvl(in_transport.quelle_leer_progr_nr, 0) = 0)
    then
      v_found := lvs_p_base.get_lte(v_lte_id,  -- in_lte_id in lvs_lte.lte_id%type,
                                    v_lte_t);  -- io_lte    in out lvs_lte%rowtype) return boolean is
                                    
      if not v_found
      then
        raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(in_transport.lte_id, 'NULL')));
      end if;
      
      -- LTE ist nicht mehr am urspr. Platz
      if v_lte_t.lgr_platz != in_transport.lgr_platz_quelle
      then
        -- Wenn die Palette bereits am Ziel ist, dann ist alles OK
        if v_lte_t.lgr_platz != in_transport.lgr_platz_ziel
        then
          delete isi_transport t
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          
          v_ret :=  LC.ec(LC.O_TXT_LTE_AM_ZIEL_TR_GELOESCHT);
        else
          -- Sonst die Quelle für den Transport ändern
          -- BugFix: Lagerort
          update isi_transport t
             set t.lgr_platz_quelle = v_lte_t.lgr_platz,
                 t.lgr_ort_quelle = v_lte_t.lgr_ort
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          
          v_ret :=  LC.ec_p1(LC.O_TP1_NEUEN_PLATZ_ANFAHERN, nvl(v_lte_t.lgr_platz, 'NULL'));
          return(v_ret);
        end if;
      else
        SAVEPOINT keine_neue_lte;
        if (in_lte_crtl = 'AUSB')
        then
          -- Quelle ist ein WA
          if (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WE)
          then
             delete isi_transport t
             where t.sid = in_transport.sid
               and t.firma_nr = in_transport.firma_nr
               and t.transp_id = in_transport.transp_id;
             if in_transport.vorgang_id is not NULL
             then
               v_ret :=  LC.ec(LC.O_TXT_LTE_NICHT_AM_WE_F_ORDER);
               return(v_ret);
             else
               v_ret :=  LC.ec(LC.O_TXT_LTE_NICHT_AM_WE_N_BUCH);
               return(v_ret);
             end if;
          end if;
          
          -- Quelle ist ein WA
          if v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WA
          then
            delete isi_transport t
             where t.sid = in_transport.sid
               and t.firma_nr = in_transport.firma_nr
               and t.transp_id = in_transport.transp_id;
            v_ret :=  LC.ec(LC.O_TXT_LTE_NICHT_AM_WE_N_BUCH);
          return(v_ret);
          end if;
        end if;
        -- Hole alle Reservierungen von der Transport LTE
        open c_lam_g;
        loop
          fetch c_lam_g into v_g_lam_id, v_g_lte_id, v_g_artikel_id, v_g_charge_id, v_g_leitzahl, 
                             v_g_fa_ag, v_g_menge, v_g_lam_sel_1, v_g_lam_sel_2, 
                             v_g_lam_sel_3, v_g_lam_sel_4, v_g_lam_sel_5, v_g_lam_sel_6, 
                             v_g_lam_sel_7, v_g_lam_sel_8, v_g_lam_sel_9, v_g_lam_sel_10, 
                             v_g_hersteller_k_liste, v_g_res_menge, v_g_auf_id, v_g_lgr_ort, 
                             v_g_lgr_adresse, v_g_lgr_dim_platz, v_g_res_ziel_lte_id, v_g_res_login_id,
                             v_g_owner_adr_id;
          exit when c_lam_g%notfound;
          v_menge_sum := 0;
          
          -- Erste Auf_Id ist immer die kleinste
          if (v_min_auf_id is null)
          then
            v_min_auf_id := v_g_auf_id;
          end if;
          
          -- Hole Ersatz LTE
          open c_lam_e;
          loop
            fetch c_lam_e into v_e_lte_id, v_e_artikel_id, v_e_lgr_dim_platz, v_e_lgr_platz,
                               v_e_lgr_ort, v_e_adress_id, v_e_sum_menge, v_e_min_leitzahl,
                               v_e_max_leitzahl, v_e_min_ch, v_e_max_ch;
            exit when c_lam_e%notfound;

            -- CMe 20220808: Erst zusammenfassen
            lvs_p_lte_lhm.unite_lams_without_reservation(in_sid => in_transport.sid,
                                                         in_firma_nr => in_transport.firma_nr,
                                                         in_lte_id => v_e_lte_id,
                                                         in_user_id => in_user_id,
                                                         in_consider_mhd => 'T',
                                                         in_min_mhd => sysdate);
                                               
            -- Ersetze soviel wie möglich (am besten vollständig) 
            open c_get_lams;
            loop
              v_res_menge := v_g_res_menge - v_menge_sum;
              fetch c_get_lams into v_lams;
              exit when c_get_lams%notfound;
              if (v_lams.menge < v_res_menge)
              then
                v_res_menge := v_lams.menge; 
              end if;
              if (v_res_menge > 0)
              then
                update lvs_lam lam
                   set lam.res_menge = v_res_menge,
                       lam.order_pos_auf_id = v_g_auf_id,
                       lam.res_login_id = v_g_res_login_id,
                       lam.res_ziel_lte_id = v_g_res_ziel_lte_id
                 where lam.lam_id = v_lams.lam_id;
                 
                 v_lams.order_pos_auf_id := v_g_auf_id;
                 v_lams.res_menge := v_res_menge;
                 v_lams.res_login_id := v_g_res_login_id;
                 v_lams.res_ziel_lte_id := v_g_res_ziel_lte_id;
                 
                if (v_lams.menge > v_res_menge)
                then
                  --CMe 20220808 Nur auf Splitten
                  pps_p_bde.create_new_lam_f_rest(in_sid => v_lams.sid,
                                                  in_firma_nr => v_lams.firma_nr,
                                                  in_lam => v_lams,
                                                  in_user_id => v_g_res_login_id);
                end if;
               end if;
               v_menge_sum := v_menge_sum + v_res_menge;
               -- Es wurde alles umgeschrieben Loop verlassen  
               exit when v_g_res_menge - v_menge_sum = 0;
            end loop;
            close c_get_lams;
            
            lvs_p_lte_lhm.add_amount_to_reservation(in_sid => in_transport.sid,
                                                    in_firma_nr => in_transport.firma_nr,
                                                    in_lte_id => v_e_lte_id,
                                                    in_auf_id => v_g_auf_id,
                                                    in_user_id => in_user_id,
                                                    in_consider_mhd => 'T',
                                                    in_min_mhd => sysdate);
            if (v_menge_sum > 0)
            then
              -- Wenn gewechselt wurde immer für die LTE die kleinste order_pos_auf_id eintragen
              update lvs_lte lte
                 set lte.order_auf_id = (select min(y.order_pos_auf_id) from lvs_lam y where y.lte_id = lte.lte_id)
               where lte.lte_id = v_e_lte_id;
               
               
               if (v_min_auf_id = v_g_auf_id) and
                  (v_min_lte_id is null)
               then
                 v_min_lte_id := v_e_lte_id;
               end if;
            end if;
            -- Es wurde alles umgeschrieben Loop verlassen 
            exit when v_g_res_menge - v_menge_sum = 0;
          end loop;
          close c_lam_e;
          
          -- Es wurde nicht getauscht für die LAM. Loop verlassen
          if (v_menge_sum = 0) 
          then
            exit;
          end if;
            
          v_found := lvs_p_base.get_lam(in_transport.sid,
                                        in_transport.firma_nr,
                                        v_g_lam_id,
                                        v_g_lams);
          
          --CMe 20220808 Am besten mit NVL arbeiten                      
          if (nvl(v_g_res_menge, 0) - nvl(v_menge_sum, 0) > 0)
          then
            update lvs_lam lam
               set lam.res_menge = nvl(lam.res_menge, 0) - nvl(v_menge_sum, 0)
             where lam.lam_id = v_g_lams.lam_id;
             
              --CMe 20220811 Nur auf Splitten
              pps_p_bde.create_new_lam_f_rest(in_sid => v_g_lams.sid,
                                              in_firma_nr => v_g_lams.firma_nr,
                                              in_lam => v_g_lams,
                                              in_user_id => v_g_res_login_id);
                                                  
             v_g_lams.res_menge := nvl(v_g_lams.res_menge, 0) - nvl(v_menge_sum, 0);
          else
            update lvs_lam lam
               set lam.order_pos_auf_id = null,
                   lam.res_menge = null,
                   lam.res_login_id = null,
                   lam.res_ziel_lte_id = null
             where lam.lam_id = v_g_lams.lam_id;
          end if;
        end loop;
        close c_lam_g;
        
        open c_get_lte_e;
        fetch c_get_lte_e into v_lte_n;
        v_found := c_get_lte_e%found;
        close c_get_lte_e;
        
        if (v_found)
        then
          -- Ok mind. die kleinste auf_id wurde ersetzt Transport umschreiben
          update isi_transport t
             set t.lgr_ort_quelle = v_lte_n.lgr_ort,
                 t.lgr_platz_quelle = v_lte_n.lgr_platz,
                 t.lte_id = v_lte_n.lte_id,
                 t.status = 'F'
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          
          if (in_transport.transp_typ = 'A')
          then
            v_c_lte_status_neu := c.LTE_AD_STAT;
          elsif (in_transport.transp_typ = 'E')
          then
            v_c_lte_status_neu := c.LTE_ED_STAT;
          else
            v_c_lte_status_neu := c.LTE_UD_STAT;
          end if;
          
          update lvs_lte lte
             set lte.lte_status = v_c_lte_status_neu
           where lte.lte_id = v_lte_n.lte_id;
           
          if (v_lte_t.lgr_platz is NULL)
          then
             v_lte_status_neu := c.LTE_KF_STAT;
          else
             v_lte_status_neu := c.LTE_LF_STAT;
          end if;
      
          v_found := lvs_p_base.get_lgr_platz(in_transport.lgr_platz_quelle,
                                              v_lgr_quelle);
          if (v_found)
          then
            lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte_t, v_lgr_quelle);
            
            if (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Lager) or
               (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Puffer) or
               (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_LagerP) or
               (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_EP) or
               (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Lager)
            then
              v_lte_status_neu := c.LTE_LF_STAT;
            elsif (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WA)
            then
              v_lte_status_neu := c.LTE_AF_STAT;
            elsif (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WE) or          
                  (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WEP)
            then
              v_lte_status_neu := c.LTE_BF_STAT;
            end if;
          end if;
          
          v_found := lvs_p_base.get_lgr_platz(v_lte_n.lgr_platz,
                                              v_lgr_quelle_e);
          
          if (v_found)
          then
            lvs_platz.lvs_platz_ausl_disp_setzen(v_lte_n, v_lgr_quelle_e);
          end if;
          
          v_found := lvs_p_base.get_lgr_platz(in_transport.lgr_platz_ziel,
                                              v_lgr_ziel);
             
          if (v_found)
          then
            lvs_platz.lvs_platz_einl_disp_ruecks(v_lte_t, v_lgr_ziel);
            lvs_platz.lvs_platz_einl_disp_setzen(v_lte_n, v_lgr_ziel);
          end if;
          
          update lvs_lte lte
             set lte.order_vorgang_id = null,
                 lte.order_auf_id = (select min(y.order_pos_auf_id) from lvs_lam y where y.lte_id = lte.lte_id),
                 lte.ziel_lgr_ort = null,
                 lte.ziel_lgr_platz = null,
                 lte.lte_status = v_lte_status_neu
           where lte.sid = v_lte_t.sid
             and lte.firma_nr = v_lte_t.firma_nr
             and lte.lte_id = v_lte_t.lte_id;
            
          if (in_lte_crtl = 'AUSB')
          then
            lvs_p_lte.LVS_KORR_TE_AUSBUCHEN(v_lte_t.sid, v_lte_t.firma_nr, v_lte_t.lte_id, v_lte_t.lte_status,
                                            v_lte_t.sid, v_lte_t.firma_nr, v_lte_t.lgr_ort, v_lte_t.lgr_platz, in_user_id);
                                        
            v_ret :=  LC.ec_p1(LC.O_TP1_LTE_GEWECHSELT_N_PLATZ, nvl(in_transport.lgr_platz_quelle, 'NULL'));
          else
            v_ret := NULL;
          end if;
        else
          -- Ok, kleinste Auf ID konnte nicht umgeschrieben werden, alles zurückschreiben
          ROLLBACK TO SAVEPOINT keine_neue_lte;
          --CMe 20220819: Nur zurücksetzen wenn auch ausgebucht wird. Hat zu Fehlern geführt
          if (in_lte_crtl = 'AUSB')
          then
            -- Im Anschluss den Transport löschen und die Reservierungen zurücksetzen
            delete isi_transport t
             where t.sid = in_transport.sid
               and t.firma_nr = in_transport.firma_nr
               and t.transp_id = in_transport.transp_id;
            
            v_found := lvs_p_base.get_lgr_platz(in_transport.lgr_platz_quelle,
                                                v_lgr_quelle);
                                                
            if (v_found)
            then
              lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte_t, v_lgr_quelle);
              
              if (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Lager) or
                 (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Puffer) or
                 (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_LagerP) or
                 (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_EP) or
                 (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Lager)
              then
                v_lte_status_neu := c.LTE_LF_STAT;
              elsif (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WA)
              then
                v_lte_status_neu := c.LTE_AF_STAT;
              elsif (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WE) or          
                    (v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WEP)
              then
                v_lte_status_neu := c.LTE_BF_STAT;
              end if;
            end if;
            
            v_found := lvs_p_base.get_lgr_platz(in_transport.lgr_platz_ziel,
                                                v_lgr_ziel);
               
            if (v_found)
            then
              lvs_platz.lvs_platz_einl_disp_ruecks(v_lte_t, v_lgr_ziel);
            end if;
          
            update lvs_lam lam
               set lam.res_menge = null,
                   lam.res_ziel_lte_id = null,
                   lam.order_pos_auf_id = null,
                   lam.res_login_id = null
             where lam.lte_id = v_lte_t.lte_id;
            
            update lvs_lte lte
               set lte.order_vorgang_id = null,
                   lte.order_auf_id = null,
                   lte.ziel_lgr_ort = null,
                   lte.ziel_lgr_platz = null,
                   lte.lte_status = v_lte_status_neu
             where lte.sid = v_lte_t.sid
               and lte.firma_nr = v_lte_t.firma_nr
               and lte.lte_id = v_lte_t.lte_id;
             
            lvs_p_lte.LVS_KORR_TE_AUSBUCHEN(v_lte_t.sid, v_lte_t.firma_nr, v_lte_t.lte_id, v_lte_t.lte_status,
                                            v_lte_t.sid, v_lte_t.firma_nr, v_lte_t.lgr_ort, v_lte_t.lgr_platz, in_user_id);
          end if;  
          v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN);                             
        end if;      
      end if;
    else
      raise_isi_error(990, LC.ec_p1(LC.O_TP1_FEHERABHANDLUNG_FEHLT, nvl(to_char(in_transport.quelle_leer_progr_nr), 'NULL')));
    end if; 
    return (v_ret);
    exception
      when v_error then
        if c_lam_g%isopen 
        then
          close c_lam_g;
        end if;
        
        if  c_lam_e%isopen
        then
          close c_lam_e;
        end if;
        
        if  c_get_lams%isopen
        then
          close c_get_lams;
        end if;
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      when others then
        if c_lam_g%isopen 
        then
          close c_lam_g;
        end if;
        
        if  c_lam_e%isopen
        then
          close c_lam_e;
        end if;
        
        if  c_get_lams%isopen
        then
          close c_get_lams;
        end if;
        
        rollback;
        if v_err_nr is not null
        then
          v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
        else
          v_err_text := DBMS_UTILITY.format_error_backtrace;
          if v_err_text not like 'ORA-%ORA-%'
          then
            v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
            RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
          end if;
          raise;
        end if;
  end lvs_suche_neue_lte_old_crtl_fa;
  
    /*
  __________________________________________________
  Author    : CMe
  Created   : 10.03.2022
  __________________________________________________
  Description
  Die Funktion sucht nach Ersatz LTE's für eine LTE die Transportiert
  werden soll. Abgeleitet Funktion von lvs_suche_neue_lte_old_crtl spezialisert
  auf Transporte für Verladungen.
  
  Entspricht der Original Fassung von lvs_suche_neue_lte_old_crtl
  
  Ticket: P71141-117
  __________________________________________________
  TODO
  none.
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  10.03.2022   DB31_1      (-CMe-)  Neue Logik erstellt
  25.04.2022   DB31_2      (-CMe-)  CMe 20220425 P71141-171 --> create_new_lam_f_rest durch add_amount_to_reservation ersetzt
                                    Verhindert Reservierung für einen Auftrag über mehrere LAMs, wenn
                                    auf der LTE bereits für die Order eine Reservierung vorhanden ist
  */
  function lvs_suche_neue_lte_old_crtl_or(in_transport       in isi_transport%rowtype,
                                          in_user_id         in isi_user.login_id%type,
                                          in_lte_crtl        in varchar2,
                                          in_lte_id          in lvs_lte.lte_id%type
                                         ) return varchar2 is
  v_found                boolean;
  v_ret                  varchar2(100);

  v_lte_id               lvs_lte.lte_id%type;
  v_lte                  lvs_lte%rowtype;
  v_lte_status_neu       lvs_lte.lte_status%type;
  v_g_lam                lvs_lam%rowtype;
  v_e_lam                lvs_lam%rowtype;

  v_lgr_ziel             lvs_lgr%rowtype;
  v_lgr_quelle           lvs_lgr%rowtype;

  v_lgr_platz            lvs_lgr.lgr_platz%type;

  v_lam_lte_id           lvs_lam.lte_id%type;
  v_lam_artikel_id       lvs_lam.artikel_id%type;
  v_menge                lvs_lam.menge%type;
  v_menge_sum            lvs_lam.menge%type;
  v_res_menge            lvs_lam.res_menge%type;
  v_lgr_ort              lvs_lgr_ort.lgr_ort%type;
  v_lgr_adresse          lvs_lgr_ort.adress_id%type;
  v_lgr_dim_platz        lvs_lgr.lgr_dim_platz%type;
  v_auf_id               lvs_lam.order_pos_auf_id%type;

  v_max_lam_charge_id    lvs_lam.charge_id%type;
  v_max_lam_leitzahl     lvs_lam.leitzahl%type;
  v_max_lam_fa_ag        lvs_lam.fa_ag%type;

  v_min_lam_charge_id    lvs_lam.charge_id%type;
  v_min_lam_leitzahl     lvs_lam.leitzahl%type;
  v_min_lam_fa_ag        lvs_lam.fa_ag%type;

  v_e_lam_charge_id      lvs_lam.charge_id%type;
  v_e_lam_leitzahl       lvs_lam.leitzahl%type;
  v_e_lam_fa_ag          lvs_lam.fa_ag%type;
  v_e_menge              lvs_lam.menge%type;

  v_lte_name             lvs_lte.lte_name%type;

  -- 20180519 AG BugFix, auch die SEL-Parameter und die herstellerliste muss gleich sein
  v_e_lam_sel_1          varchar2(4096);
  v_e_lam_sel_2          varchar2(4096);
  v_e_lam_sel_3          varchar2(4096);
  v_e_lam_sel_4          varchar2(4096);
  v_e_lam_sel_5          varchar2(4096);
  v_e_lam_sel_6          varchar2(4096);
  v_e_lam_sel_7          varchar2(4096);
  v_e_lam_sel_8          varchar2(4096);
  v_e_lam_sel_9          varchar2(4096);
  v_e_lam_sel_10         varchar2(4096);
  v_hersteller_k_liste   varchar2(4096);

  -- Tabelle für die Erzeugung von Staffeltransporten
  v_lvs_lgr_ort_ue_platz lvs_lgr_ort_ue_platz%rowtype;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = v_lte_id;

  CURSOR c_lam_g is
    select lam.lte_id,
           lam.artikel_id,
           min(lam.charge_id) nin_ch,
           max(lam.charge_id) nax_ch,
           min(lam.leitzahl) min_leitzahl,
           max(lam.leitzahl) max_leitzahl,
           min(lam.fa_ag) min_fa_ag,
           max(lam.fa_ag) max_fa_ag,
           sum(lam.menge),
           -- 20180519 AG BugFix, auch die SEL-Parameter und die herstellerliste muss gleich sein
           nvl(substr(stradd_distinct(lam.lam_sel1), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel2), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel3), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel4), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel5), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel6), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel7), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel8), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel9), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.lam_sel10), 1, 4096), 'NO_LAM_SEL'),
           nvl(substr(stradd_distinct(lam.hersteller_kuerzel_liste), 1, 4096), 'NO_HERS_LISTE'),
           sum(nvl(lam.res_menge, 0)),
           min(lam.order_pos_auf_id),
           ort.lgr_ort,
           ort.adress_id,
           lgr.lgr_dim_platz
      from lvs_lam lam,
           lvs_lgr lgr,
           lvs_lgr_ort ort
     where lam.sid          = v_lte.sid
       and lam.firma_nr     = v_lte.firma_nr
       and lam.lte_id       = v_lte.lte_id
       and lam.lgr_platz    = lgr.lgr_platz(+)
       and lgr.lgr_ort      = ort.lgr_ort(+)
     group by lam.lte_id,
              lam.artikel_id,
              lam.lgr_platz,
              ort.lgr_ort,
              ort.adress_id,
              lgr.lgr_dim_platz;

  CURSOR c_lam_e is
     select * from
        (select lam.lte_id,
               lam.artikel_id,
               min(lam.charge_id) min_ch,
               max(lam.charge_id) max_ch,
               min(lam.leitzahl) min_leitzahl,
               max(lam.leitzahl) max_leitzahl,
               min(lam.fa_ag) min_fa_ag,
               max(lam.fa_ag) max_fa_ag,
               sum(lam.menge) sum_menge,
               ort.lgr_ort,
               ort.adress_id,
               lgr.lgr_dim_platz,
               lte.lgr_platz,
               lte.lte_name
          from lvs_lam lam,
               lvs_lte lte,
               lvs_lgr lgr,
               lvs_lgr_ort ort
         where lam.sid = v_lte.sid
           and lam.firma_nr = v_lte.firma_nr
           and lam.lte_id != v_lte.lte_id
           and lte.lte_id = lam.lte_id
           and lte.lte_status in (c.LTE_LF_STAT, c.LTE_BF_STAT)
           and lam.artikel_id = v_lam_artikel_id
           and nvl(lam.fa_ag, -1) = nvl(v_e_lam_fa_ag, -1)
           and lte.lgr_platz = lgr.lgr_platz
           and lte.lgr_ort = ort.lgr_ort
           and ort.adress_id = v_lgr_adresse
           and lte.order_vorgang_id is NULL
           and (lte.lte_id = in_lte_id or in_lte_id is NULL)
           -- 20180519 AG BugFix, auch die SEL-Parameter und die herstellerliste muss gleich sein
           and nvl(lam.lam_sel1, 'NO_LAM_SEL') = nvl(v_e_lam_sel_1, 'NO_LAM_SEL')
           and nvl(lam.lam_sel2, 'NO_LAM_SEL') = nvl(v_e_lam_sel_2, 'NO_LAM_SEL')
           and nvl(lam.lam_sel3, 'NO_LAM_SEL') = nvl(v_e_lam_sel_3, 'NO_LAM_SEL')
           and nvl(lam.lam_sel4, 'NO_LAM_SEL') = nvl(v_e_lam_sel_4, 'NO_LAM_SEL')
           and nvl(lam.lam_sel5, 'NO_LAM_SEL') = nvl(v_e_lam_sel_5, 'NO_LAM_SEL')
           and nvl(lam.lam_sel6, 'NO_LAM_SEL') = nvl(v_e_lam_sel_6, 'NO_LAM_SEL')
           and nvl(lam.lam_sel7, 'NO_LAM_SEL') = nvl(v_e_lam_sel_7, 'NO_LAM_SEL')
           and nvl(lam.lam_sel8, 'NO_LAM_SEL') = nvl(v_e_lam_sel_8, 'NO_LAM_SEL')
           and nvl(lam.lam_sel9, 'NO_LAM_SEL') = nvl(v_e_lam_sel_9, 'NO_LAM_SEL')
           and nvl(lam.lam_sel10, 'NO_LAM_SEL') = nvl(v_e_lam_sel_10, 'NO_LAM_SEL')
           and nvl(lam.hersteller_kuerzel_liste, 'NO_HERS_LISTE') = nvl(v_hersteller_k_liste, 'NO_HERS_LISTE')
          group by lam.lte_id,
                  lam.artikel_id,
                  ort.lgr_ort,
                  ort.adress_id,
                  lgr.lgr_dim_platz,
                  lte.lgr_platz,
                  lte.lte_name)
     where sum_menge >= v_menge
        order by abs(sum_menge - v_menge),
                 abs(decode(min_ch, max_ch, max_ch, NULL) - v_e_lam_charge_id),
                 abs(decode(min_leitzahl, max_leitzahl, min_leitzahl, NULL) - v_e_lam_leitzahl),
                 abs(lgr_ort - v_lgr_ort),
                 abs(lgr_dim_platz - v_lgr_dim_platz);

  CURSOR c_lvs_lgr is                             -- Lesen des Lagerplatz
   select *
     from lvs_lgr lgr
    where lgr.lgr_platz = v_lgr_platz;

  CURSOR c_lam_g_lte is
    select *
      from lvs_lam l
     where l.lte_id = v_lte.lte_id
       and l.order_pos_auf_id is not NULL;

  -- CMe 20220811 MHD berücksichtigen
  CURSOR c_lam_e_lte is
    select *
      from lvs_lam l
     where l.lte_id = v_lam_lte_id
       and l.order_pos_auf_id is NULL
       and l.lam_mhd >= sysdate
     order by abs(l.menge - v_g_lam.res_menge),
              l.menge desc;

begin
  -- Erst mal die LTE_ID fuer den CURSOR uebertragen
  v_lte_id := in_transport.lte_id;
  v_ret := LC.ec('O_TP1_NO_ACTION_TAKEN');

  -- STD Ptrogramm fuer Platz ist leer und Palette soll geholt werden !!
  if nvl(in_transport.quelle_leer_progr_nr, 0) = 0
  then
    -- Erst mal die LTE-Daten lesen
    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    -- Schlimmer Fehler, konnte die LTE-Daten nicht lesen (Ist evtl. schon Ausgelagert und aus den Daten genommen?)
    if not v_found
    then
      raise_isi_error(10, LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, nvl(in_transport.lte_id, 'NULL')));
    end if;

    -- LTE ist nicht mehr am urspr. Platz
    if v_lte.lgr_platz != in_transport.lgr_platz_quelle
    then
      -- Wenn die Palette bereits am Ziel ist, dann ist alles OK
      if v_lte.lgr_platz = in_transport.lgr_platz_ziel
      then
        delete isi_transport t
         where t.sid = in_transport.sid
           and t.firma_nr = in_transport.firma_nr
           and t.transp_id = in_transport.transp_id;
        v_ret :=  LC.ec(LC.O_TXT_LTE_AM_ZIEL_TR_GELOESCHT);
        -- v_ret := 'LTE bereits am Ziel. Transport gelöscht.';

      else
        -- Sonst die Quelle für den Transport ändern
        -- BugFix: Lagerort
        update isi_transport t
           set t.lgr_platz_quelle = v_lte.lgr_platz,
               t.lgr_ort_quelle = v_lte.lgr_ort
         where t.sid = in_transport.sid
           and t.firma_nr = in_transport.firma_nr
           and t.transp_id = in_transport.transp_id;
        v_ret :=  LC.ec_p1(LC.O_TP1_NEUEN_PLATZ_ANFAHERN, nvl(v_lte.lgr_platz, 'NULL'));
        -- v_ret := 'Bitte neuen Lagerplatz anfahren. <' || nvl(v_lte.lgr_platz, 'NULL') || '>';
        return(v_ret);
      end if;
    else
      OPEN c_lam_g;    -- Lesen der Materialien die auf der palette sind
      FETCH c_lam_g into v_lam_lte_id, v_lam_artikel_id, v_min_lam_charge_id, v_max_lam_charge_id,
                         v_min_lam_leitzahl, v_max_lam_leitzahl, v_min_lam_fa_ag, v_max_lam_fa_ag, v_menge,
                         v_e_lam_sel_1, v_e_lam_sel_2, v_e_lam_sel_3, v_e_lam_sel_4, v_e_lam_sel_5,
                         v_e_lam_sel_6, v_e_lam_sel_7, v_e_lam_sel_8, v_e_lam_sel_9, v_e_lam_sel_10,
                         v_hersteller_k_liste, v_res_menge, v_auf_id, v_lgr_ort, v_lgr_adresse, v_lgr_dim_platz;
      CLOSE c_lam_g;

      -- Charge FA-Auftrag und Arbeitsgang der Palette ist relevant für die Sortierung zur findung der neuen Palette
      if v_min_lam_charge_id = v_max_lam_charge_id
      then
         v_e_lam_charge_id := v_min_lam_charge_id;      -- Nur wenn alles die gleiche Charge
      else
        v_e_lam_charge_id := NULL;
      end if;
      if v_min_lam_leitzahl =  v_max_lam_leitzahl
      then
        v_e_lam_leitzahl  := v_min_lam_leitzahl;      -- Nur wenn alles gleiche FA-Auftrag
      else
        v_e_lam_leitzahl  := NULL;
      end if;
      if v_min_lam_fa_ag =     v_max_lam_fa_ag
      then
        v_e_lam_fa_ag     := v_min_lam_fa_ag;      -- Nur wenn alles gleicher Arbeitsgang
      else
        v_e_lam_fa_ag     := NULL;
      end if;

      v_lgr_platz := in_transport.lgr_platz_ziel;
      OPEN c_lvs_lgr;
      FETCH c_lvs_lgr into v_lgr_ziel;
      CLOSE c_lvs_lgr;

      if in_transport.lgr_platz_quelle is not null then
        v_lgr_platz := in_transport.lgr_platz_quelle;
      else
        v_lgr_platz := v_lte.lgr_platz;
      end if;
      OPEN c_lvs_lgr;
      FETCH c_lvs_lgr into v_lgr_quelle;
      v_found := c_lvs_lgr%FOUND;
      CLOSE c_lvs_lgr;
      if not v_found then
        raise_isi_error(30, LC.ec_p1(LC.O_TP1_Q_LGR_PLATZ_FEHLT, nvl(in_transport.lgr_platz_quelle, 'NULL')));
      end if;
      -- Wenn dispo auf einlagerung lagerplatz wieder um LTE Menge ,Gewicht .. Entlasten

      SAVEPOINT keine_neue_lte;
      lvs_platz.lvs_platz_einl_disp_ruecks(v_lte,v_lgr_ziel);
      if v_lgr_quelle.lgr_platz is not null
      then
        lvs_platz.lvs_platz_ausl_disp_ruecks(v_lte,v_lgr_quelle);
      end if;
      if in_lte_crtl = 'AUSB'
      then
        lvs_p_lte.LVS_KORR_TE_AUSBUCHEN(v_lte.sid, v_lte.firma_nr, v_lte.lte_id, v_lte.lte_status,
                                        v_lte.sid, v_lte.firma_nr, v_lte.lgr_ort, v_lte.lgr_platz, in_user_id);
      else
        update lvs_lte t
           set t.lte_status = nvl((select x.lte_status  from lvs_lte x where x.lte_id = t.lte_id), 'LF')
        where t.lte_id = v_lte.lte_id;
      end if;

      -- 2018.01.19 Status muss noch gesetzt werden in der LTE
      -- Palettendaten von allen Auftragsdatten lösen und Status setzetn
      if v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Lager
      or v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Puffer
      or v_lgr_quelle.lgr_verwendung = c.LGR_TYP_LagerP
      or v_lgr_quelle.lgr_verwendung = c.LGR_TYP_EP
      or v_lgr_quelle.lgr_verwendung = c.LGR_TYP_Lager
      then
        v_lte_status_neu := c.LTE_LF_STAT;
      elsif v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WA
      then
        v_lte_status_neu := c.LTE_AF_STAT;
      elsif v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WE
      or v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WEP
      then
        v_lte_status_neu := c.LTE_BF_STAT;
      elsif v_lte.lgr_platz is NULL
      then
        v_lte_status_neu := c.LTE_KF_STAT;
      else
        v_lte_status_neu := c.LTE_LF_STAT;
      end if;

      update lvs_lte lte
         set lte.order_vorgang_id = NULL,
             lte.order_auf_id = NULL,
             lte.ziel_lgr_ort = NULL,
             lte.ziel_lgr_platz = NULL,
             lte.lte_status = v_lte_status_neu
       where lte.sid = in_transport.sid
         and lte.firma_nr = in_transport.firma_nr
         and lte.lte_id = v_lte.lte_id;
      /*
      -- Material vom Auftrag lösen
      update lvs_lam lam
         set lam.order_pos_auf_id = NULL
       where lam.sid = in_transport.sid
         and lam.firma_nr = in_transport.firma_nr
         and lam.lte_id = v_lte.lte_id;
      */
      -- Quelle ist ein WE
      if in_lte_crtl = 'AUSB'
      then
        if v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WE
        then
          delete isi_transport t
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          if in_transport.vorgang_id is not NULL
          then
            v_ret :=  LC.ec(LC.O_TXT_LTE_NICHT_AM_WE_F_ORDER);
            --v_ret := 'LTE fehlt am WE für ISIOrder (Prüfen und neu Reservieren). Transport gelöscht.';
            return(v_ret);
          else
            v_ret :=  LC.ec(LC.O_TXT_LTE_NICHT_AM_WE_N_BUCH);
            --v_ret := 'LTE fehlt am Wareneingang (Prüfen und neu Buchen). Transport gelöscht.';
            return(v_ret);
          end if;
        end if;
        -- Quelle ist ein WA
        if v_lgr_quelle.lgr_verwendung = c.LGR_TYP_WA
        then
          delete isi_transport t
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          v_ret :=  LC.ec(LC.O_TXT_LTE_NICHT_AM_WE_N_BUCH);
          -- v_ret := 'LTE fehlt am Warenausgang (Prüfen und neu Buchen). Transport gelöscht.';
          return(v_ret);
        end if;
      end if;

      -- Erst mal alle Daten Holen
      if v_lte.waren_typ != c.MISCHPAL  -- Nur wenn keien Mischpalette
      then
        if v_e_lam_fa_ag is not NULL
        or  (v_min_lam_fa_ag is NULL
         and v_max_lam_fa_ag is NULL)
        then
          OPEN c_lam_e;
          -- Nur Transporte ohne Staffeltransport möglich
          v_found := FALSE;
          LOOP
            FETCH c_lam_e into v_lam_lte_id, v_lam_artikel_id, v_min_lam_charge_id, v_max_lam_charge_id, v_min_lam_leitzahl, v_max_lam_leitzahl,
                               v_min_lam_fa_ag, v_max_lam_fa_ag, v_e_menge, v_lgr_ort, v_lgr_adresse, v_lgr_dim_platz, v_lgr_platz, v_lte_name;
            v_found := c_lam_e%FOUND;
            -- lesen bis Transport entstehen kann, der kein Staffeltransport ist
            -- AG 20170814 Übergabeplatz ggf. nur fuer bestimmte Palettentypen
            if not lvs_p_base.get_lvs_lgr_ort_ue_platz(in_transport.sid,                 -- in_sid                  in lvs_lam.sid%type,
                                                       in_transport.firma_nr,            -- in_firma_nr             in lvs_lam.firma_nr%type,
                                                       v_lgr_ort,                        -- in_lgr_ort_quelle       in lvs_lgr_ort_ue_platz.lgr_ort_quelle%type,
                                                       in_transport.lgr_ort_ziel,        -- in_lgr_ort_ziel         in lvs_lgr_ort_ue_platz.lgr_ort_ziel%type,
                                                       v_lgr_platz,                      -- in_lgr_platz            in lvs_lgr.lgr_platz%type,
                                                       v_lte_name,                       -- LTE-Name zur Suche
                                                       v_lvs_lgr_ort_ue_platz)           -- io_lvs_lgr_ort_ue_platz in out lvs_lgr_ort_ue_platz%rowtype)
              or not v_found
            then
              exit;
            end if;
          END LOOP;
          CLOSE c_lam_e;
          -- Irgend etwas passendes gefunden

          if v_found
          then
            -- Eine Palette aus ISIOrder (Wegen reservierungen müssen die Mengen passen)
            if in_transport.vorgang_id is NOT NULL
            and v_e_menge != v_menge
            then
              delete isi_transport t
               where t.sid = in_transport.sid
                 and t.firma_nr = in_transport.firma_nr
                 and t.transp_id = in_transport.transp_id;
              v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN);
              --v_ret := 'Keinen Ersatz mit gleicher Menge. In ISIOrder neu reservieren. Transport gelöscht.';
              --return(v_ret);
            else
              if v_res_menge > v_e_menge   -- Menge reicht nicht
              then
                ROLLBACK TO SAVEPOINT keine_neue_lte;
                v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_GEFUNDEN);
                --v_ret := 'Keinen Ersatz mit gleicher Menge. In ISIOrder neu reservieren. Transport gelöscht.';
                return(v_ret);
              end if;
              
              --CMe 20220808 auf der neuen Ziel LTE alles ohne Reservierung zusammenfassen
              lvs_p_lte_lhm.unite_lams_without_reservation(in_sid => in_transport.sid,
                                                           in_firma_nr => in_transport.firma_nr,
                                                           in_lte_id => v_lam_lte_id,
                                                           in_user_id => in_user_id,
                                                           in_consider_mhd => 'T',
                                                           in_min_mhd => sysdate);
                                                         
              -- Palette an den Auftrag binden
              update lvs_lte lte
                 set lte.order_vorgang_id = v_lte.order_vorgang_id,
                     lte.order_auf_id = v_auf_id,
                     lte.lte_status = v_lte.lte_status,
                     lte.ziel_lgr_ort = v_lte.ziel_lgr_ort,
                     lte.ziel_lgr_platz = v_lte.ziel_lgr_platz
               where lte.sid = in_transport.sid
                 and lte.firma_nr = in_transport.firma_nr
                 and lte.lte_id = v_lam_lte_id;
              -- Lagerbestand an den Auftrag binden
              if v_res_menge > 0
              then
                OPEN c_lam_g_lte;
                FETCH c_lam_g_lte into v_g_lam;
                LOOP
                  EXIT when c_lam_g_lte%NOTFOUND;
                  OPEN c_lam_e_lte;
                  FETCH c_lam_e_lte into v_e_lam;
                  v_found := c_lam_e_lte%FOUND;
                  CLOSE c_lam_e_lte;
                  EXIT when not v_found;

                  if v_e_lam.menge < v_g_lam.menge
                  then
                    v_e_lam.res_menge := v_e_lam.menge;
                  else
                    v_e_lam.res_menge := v_g_lam.res_menge;
                  end if;

                  update lvs_lam lam
                     set lam.order_pos_auf_id = v_g_lam.order_pos_auf_id,
                         lam.res_menge = v_e_lam.res_menge,
                         lam.res_ziel_lte_id = v_g_lam.res_ziel_lte_id,
                         lam.res_login_id = v_g_lam.res_login_id
                   where lam.sid = in_transport.sid
                     and lam.firma_nr = in_transport.firma_nr
                     and lam.lam_id = v_e_lam.lam_id;
                  v_e_lam.order_pos_auf_id := v_g_lam.order_pos_auf_id;

                  if v_e_lam.menge >= v_g_lam.res_menge
                  then
                    if v_e_lam.menge > v_g_lam.res_menge
                    then
                      --CMe 20220808 Nur auf Splitten
                      pps_p_bde.create_new_lam_f_rest(in_sid => in_transport.sid,
                                                      in_firma_nr => in_transport.firma_nr,
                                                      in_lam => v_e_lam,
                                                      in_user_id => in_user_id);

                    end if;
                    update lvs_lam lam
                       set lam.order_pos_auf_id = NULL,
                           lam.res_menge = NULL,
                           lam.res_ziel_lte_id = NULL,
                           lam.res_login_id = NULL
                     where lam.sid = in_transport.sid
                       and lam.firma_nr = in_transport.firma_nr
                       and lam.lam_id = v_g_lam.lam_id;
                    FETCH c_lam_g_lte into v_g_lam;
                  else
                    v_g_lam.res_menge := v_g_lam.res_menge - v_e_lam.res_menge;
                  end if;
                end LOOP;
                CLOSE c_lam_g_lte;
              else
                update lvs_lam lam
                   set lam.order_pos_auf_id = NULL
                 where lam.sid = in_transport.sid
                   and lam.firma_nr = in_transport.firma_nr
                   and lam.lte_id = v_lte.lte_id;
                update lvs_lam lam
                   set lam.order_pos_auf_id = v_auf_id
                 where lam.sid = in_transport.sid
                   and lam.firma_nr = in_transport.firma_nr
                   and lam.lte_id = v_lam_lte_id;
              end if;
              
              --CMe 20220808: Jetzt alles reservierte Zusammenfassen, falls es sich um eine nachträgliche Reservierung
              --              auf Grund von Mangel handelt und sich auf der LTE bereits reserviertes Material befindet
              lvs_p_lte_lhm.add_amount_to_reservation(in_sid =>  in_transport.sid,
                                                      in_firma_nr => in_transport.firma_nr,
                                                      in_lte_id => v_lam_lte_id,
                                                      in_auf_id => v_auf_id,
                                                      in_user_id => in_user_id,
                                                      in_consider_mhd => 'T',
                                                      in_min_mhd => sysdate);
              update isi_transport t
                 set t.lgr_ort_quelle = v_lgr_ort,
                     t.lgr_platz_quelle = v_lgr_platz,
                     t.lte_id = v_lam_lte_id,
                     t.status = 'F'
               where t.sid = in_transport.sid
                 and t.firma_nr = in_transport.firma_nr
                 and t.transp_id = in_transport.transp_id;

              if lvs_p_base.get_lte(v_lam_lte_id, v_lte)
              then
                if lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr_quelle)
                then
                  lvs_platz.lvs_platz_ausl_disp_setzen(v_lte, v_lgr_quelle);
                end if;
                if lvs_p_base.get_lgr_platz(in_transport.lgr_platz_ziel, v_lgr_ziel)
                then
                  lvs_platz.lvs_platz_einl_disp_setzen(v_lte, v_lgr_ziel);
                end if;
              end if;

              if in_lte_crtl = 'AUSB'
              then
                v_ret :=  LC.ec_p1(LC.O_TP1_LTE_GEWECHSELT_N_PLATZ, nvl(v_lgr_platz, 'NULL'));
              else
                v_ret := NULL;
              end if;
              -- v_ret := 'LTE gewechselt. Bitte neuen Lagerplatz anfahren. <' || nvl(v_lgr_platz, 'NULL') || '>';
              -- return v_ret;       -- Kein Hinweis allse OK
            end if;
          else
            delete isi_transport t
             where t.sid = in_transport.sid
               and t.firma_nr = in_transport.firma_nr
               and t.transp_id = in_transport.transp_id;
            v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_N_RES);
            -- v_ret := 'Kein Ersatz automatisch zu finden. Bitte um Ersatz kümmern. Transport gelöscht.';
          end if;
        else
          delete isi_transport t
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_N_RES);
          -- v_ret := 'Kein Ersatz automatisch zu finden. Bitte um Ersatz kümmern. Transport gelöscht.';
          -- return v_ret;
        end if;
      else
        if v_lte.order_vorgang_id is not NULL
        then
          delete isi_transport t
          --update isi_transport t
          --   set t.status = 'F',
          --       t.res_id = NULL
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_N_RES);
          -- v_ret := 'Ersatz Mischpaletten für ISIOrder neu reservieren. Transport gelöscht.';
          --return(v_ret);
        else
          delete isi_transport t
           where t.sid = in_transport.sid
             and t.firma_nr = in_transport.firma_nr
             and t.transp_id = in_transport.transp_id;
          v_ret :=  LC.ec(LC.O_TXT_LTE_KEIN_ERSATZ_N_RES);
          -- v_ret := 'Ersatz Für Mischpaletten nicht möglich. Transport gelöscht.';
          --return(v_ret);
        end if;
      end if;
    end if;

  else
    raise_isi_error(990, LC.ec_p1(LC.O_TP1_FEHERABHANDLUNG_FEHLT, nvl(to_char(in_transport.quelle_leer_progr_nr), 'NULL')));
  end if;
  -- AG erst hier die Reservirung ras, damit die Vorlage für die Tauschpalette vorhandne ist
  -- Material vom Auftrag lösen
  update lvs_lam lam
     set lam.order_pos_auf_id = NULL,
         lam.res_menge = NULL,
         lam.res_ziel_lte_id = NULL,
         lam.res_login_id = NULL
   where lam.sid = in_transport.sid
     and lam.firma_nr = in_transport.firma_nr
     and lam.lte_id = v_lte_id;

  if in_lte_crtl != 'AUSB'
  and v_ret is not NULL
  then
    ROLLBACK TO SAVEPOINT keine_neue_lte;
  end if;

  return(v_ret);
  exception
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;
      if v_err_nr is not null
      then
        v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || cr_lf() || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;                                  
  end lvs_suche_neue_lte_old_crtl_or;
end;
/



-- sqlcl_snapshot {"hash":"0c978fe3f478459ff74bfb10ff7c3d392c437ea2","type":"PACKAGE_BODY","name":"LVS_P_LTE","schemaName":"DIRKSPZM32","sxml":""}