create or replace 
PACKAGE BODY DIRKSPZM32.bde_util is

  PROCEDURE convert_human_to_steuerzeichen (
    in_str  IN  VARCHAR2,
    out_str OUT VARCHAR2) IS
  BEGIN
    out_str := human_to_steuerzeichen (in_str);
  END;

  --------------------------------------------------------------------------------
  -- FUNCTION human_to_steuerzeichen
  --------------------------------------------------------------------------------
  FUNCTION human_to_steuerzeichen (
    in_str IN VARCHAR2) RETURN VARCHAR2 IS

  BEGIN
    return(isi_utils.human_to_steuerzeichen(in_str));
  END;

  --------------------------------------------------------------------------------
  -- FUNCTION Format_EAN
  --------------------------------------------------------------------------------
  function Format_EAN (
    in_str IN VARCHAR2) RETURN VARCHAR2 IS
  begin
    return(isi_utils.Format_EAN(in_str));
  end;

  --------------------------------------------------------------------------------
  -- FUNCTION Format_NVE
  --
  -- 340274530000050083 -> 3 40 27453 000005008 3
  --------------------------------------------------------------------------------
  function Format_NVE (
    in_str IN VARCHAR2) RETURN VARCHAR2 IS

    str_out VARCHAR2(256) := NULL;
  begin
    str_out := isi_utils.Format_NVE(in_str);
    return(str_out);
  end;

  procedure c_bde_linie_fertig  (in_sid         in isi_sid.sid%type,
                                 in_res_id      in isi_resource.res_id%type)
                                 is

    v_res                        isi_resource%rowtype;

  begin
    if isi_p_base.get_resource(in_sid, in_res_id, v_res)
    then
      update isi_resource_zust_akt t
         set t.auftrag_status = 'F'
       where t.res_id in (select t2.res_id
                            from isi_resource t2
                           where t2.linie_res_id = v_res.linie_res_id);
    end if;
    commit;
  end;

/*
Erstellt einen Eintrag (Prozessdaten / QS-Daten) für eine Produktion mit FA

@see c_wr_bde_pd_prozess_d_o_fa Buchen Prozessdaten ohne Produktion un FA
@see bde_pd_prod_insert In dieser Procedure werden die Produktionsdaten geschrieben. Bei Fertigware müssen Alle Rohstoffe an die Maschine gebucht sein. Damit werden alle Rohstoffbezieungen für Fertigware automatisch gebucht.

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_name           in isi_resource.res_name%type   Name der Resource,
@param in_login_id       in isi_user.login_id%type       Login_ID des angemeldeten USER,
@param in_b_datum        in bde_pd_prozess_data.res_prozess_data_date%type datum der Buchung für zuordnung des Produktionssatz,
@param in_id             in lvs_lte.lte_id%type                            LTE-ID aus FAE-ID des gefertigten Produkt,
@param in_IO             in bde_pd_prozess_data.io%type                    Prozessdaten IO oder NIO,
@param in_qd_data        in varchar2                                       Prozessdaten als Parameterlist,
*/

  procedure c_wr_bde_pd_prozess_data (in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_name        in isi_resource.res_name%type,
                                      in_login_id    in isi_user.login_id%type,
                                      in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                      in_id          in lvs_lte.lte_id%type,
                                      in_IO          in bde_pd_prozess_data.io%type,
                                      in_qd_data     in varchar2)
                                      is
  begin
    bde_util.bde_wr_pd_prozess_data(in_sid,
                                    in_firma_nr,
                                    in_name,
                                    in_login_id,
                                    in_b_datum,
                                    in_id,
                                    in_io,
                                    in_qd_data);
    commit;
  end;

/*
Erstellt einen Eintrag (Prozessdaten / QS-Daten) für eine Produktion mit FA

@see c_wr_bde_pd_prozess_d_o_fa Buchen Prozessdaten ohne Produktion un FA
@see bde_pd_prod_insert In dieser Procedure werden die Produktionsdaten geschrieben. Bei Fertigware müssen Alle Rohstoffe an die Maschine gebucht sein. Damit werden alle Rohstoffbezieungen für Fertigware automatisch gebucht.

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_name           in isi_resource.res_name%type   Name der Resource,
@param in_login_id       in isi_user.login_id%type       Login_ID des angemeldeten USER,
@param in_b_datum        in bde_pd_prozess_data.res_prozess_data_date%type datum der Buchung für zuordnung des Produktionssatz,
@param in_id             in lvs_lte.lte_id%type                            LTE-ID aus FAE-ID des gefertigten Produkt,
@param in_IO             in bde_pd_prozess_data.io%type                    Prozessdaten IO oder NIO,
@param in_qd_data        in varchar2                                       Prozessdaten als Parameterlist,

__________________________________________________
Date         Ver.        AUTOR    Comment
-----------  ---------   ------   ---------------
24.08.2020   DB31_1      (-CMe-)  Bugfix: Ist der Parent eine Maschinen Gruppe muss die ResID aus
                                  der lvs_lam entnommen werden (Res Id an welcher der Artikel produziert wurde)
                                  Ticket: P70397-903
                                  Verweise CMe_20200824
*/
  procedure bde_wr_pd_prozess_data (in_sid         in isi_sid.sid%type,
                                    in_firma_nr    in isi_firma.firma_nr%type,
                                    in_name        in isi_resource.res_name%type,
                                    in_login_id    in isi_user.login_id%type,
                                    in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                    in_id          in lvs_lte.lte_id%type,
                                    in_IO          in bde_pd_prozess_data.io%type,
                                    in_qd_data     in varchar2)
                                    is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error          exception;
    v_err_nr         number;
    v_err_text       varchar2(2550);

    -------------------------------------------------------------------------------------------------------

    v_found                                   boolean;

    v_pd_prod                                 bde_pd_prod%rowtype;
    v_res                                     isi_resource%rowtype;
    v_in_name_res_id                          isi_resource.res_id%type;
    v_res_id                                  isi_resource.res_id%type;
    v_trenner                                 constant varchar2(1)  := ';';  -- Trennzeichen in QD-Daten
    v_bde_pd_prozess_data                     bde_pd_prozess_data%rowtype;

    v_qd_ix                                   number;
    v_qd_data                                 varchar2(255);
    v_start_pos                               number;
    v_ende_pos                                number;
    v_b_datum                                 timestamp(6);

    -- CMe_20200824
    CURSOR c_get_res_from_lam is
      select max(lam.res_id)
        from lvs_lam lam
       where lam.lte_id = in_id
          or lam.lhm_id = in_id;

    CURSOR c_lam_bh is
      select pd.*
        from lvs_lam_bh bh,
             bde_pd_prod pd
       where (bh.lte_id = in_id
           or bh.lhm_id = in_id)
         and bh.bus = c.LAM_BH_BUS_ZUG
         and bh.res_id = v_res_id
         and bh.lam_id = pd.lam_id
         and pd.prod_ende <= v_b_datum
         and pd.vorg_typ = 'PP'
       order by pd.prod_beginn;

    CURSOR c_lam_bh_hist is
      select pd.*
        from lvs_lam_bh_hist bh,
             bde_pd_prod pd
       where (bh.lte_id = in_id
           or bh.lhm_id = in_id)
         and bh.bus = c.LAM_BH_BUS_ZUG
         and bh.res_id = v_res_id
         and bh.lam_id = pd.lam_id
         and pd.prod_ende <= v_b_datum
         and pd.vorg_typ = 'PP'
       order by pd.prod_beginn;

  begin
    -- Finderen der Maschine für den AG und den Produktions-Satz
    if not isi_p_base.get_resource_by_name(in_name, v_res)
    or v_res.typ not in ('MS', 'MSMP')
    then
      v_err_nr := c.FMID_Resource_Fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_RESOURCE_FEHLT, in_name);
      raise v_error;
    end if;

    if in_b_datum is NULL
    then
      v_b_datum := sysdate;
    else
      v_b_datum := in_b_datum;
    end if;

    v_in_name_res_id := v_res.res_id;
    v_res_id := v_res.res_id;

    if v_res.typ = 'MSMP'
    then
      v_res_id := v_res.parent_res_id;

      -- CMe_20200824
      if not isi_p_base.get_resource(in_sid, v_res_id, v_res)
      or v_res.typ not in ('MS', 'MG', 'MSMP')
      then
        v_err_nr := c.FMID_Resource_Fehlt;
        v_err_text := LC.ec_p1(LC.O_TP1_RESOURCE_FEHLT, v_res_id);
        raise v_error;
      end if;
    end if;

    -- CMe_20200824
    if v_res.typ = 'MG'
    then
      open c_get_res_from_lam;
      fetch c_get_res_from_lam into v_res_id;
      close c_get_res_from_lam;
    end if;


    -- Finden der richtigen LAM
    OPEN c_lam_bh;
    FETCH c_lam_bh into v_pd_prod;
    v_found := c_lam_bh%FOUND;
    CLOSE c_lam_bh;

    if not v_found
    then
      OPEN c_lam_bh_hist;
      FETCH c_lam_bh_hist into v_pd_prod;
      v_found := c_lam_bh_hist%FOUND;
      CLOSE c_lam_bh_hist;
    end if;

    if not v_found
    then
      v_err_nr := c.FMID_LTE_ID_RES;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_NICHT_BUCHBAR, in_id);
      raise v_error;
    end if;

    v_start_pos := 1;
    v_ende_pos  := 1;
    v_qd_ix := 0;

    -- AG 2018.07.26 Wenn von der gleichen Resource nochmals QD-Daten kommen,
    --               dann werden die alten auf Nacharbeit gesetzt, wenn diese auf NIO stehen
    update bde_pd_prozess_data t
       set t.io = 'N'
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.res_id = v_res_id
         and t.res_prozess_data_res_id = v_in_name_res_id
         and t.fae_id = in_id
         and t.res_prozess_data_date < sysdate
         and t.io = 'F';
    -- Ende 2018.07.26
    while (v_ende_pos > 0)
    loop
      v_ende_pos := instr(in_qd_data, v_trenner, v_start_pos, 1);
      if (v_ende_pos > 0)
      then
        v_qd_ix    := v_qd_ix + 1;
        v_qd_data := substr(in_qd_data,
                         v_start_pos,
                         v_ende_pos - v_start_pos);

        if bde_p_base.get_bde_pd_prozess_data(in_sid,
                                              in_firma_nr,
                                              v_pd_prod.vorg_id,
                                              v_in_name_res_id,
                                              v_b_datum,
                                              v_qd_ix,
                                              v_bde_pd_prozess_data)
        then
          update bde_pd_prozess_data t
             set t.res_prozess_data_value = v_qd_data
           where t.id = v_bde_pd_prozess_data.id;
        else
          insert into bde_pd_prozess_data
          values
            (in_sid,
             in_firma_nr,
             v_pd_prod.vorg_id,
             v_pd_prod.leitzahl,
             v_pd_prod.fa_ag,
             v_pd_prod.fa_upos,
             v_res_id,
             v_pd_prod.fae_id,
             v_pd_prod.fae_id_position,
             v_in_name_res_id,
             v_b_datum,
             v_qd_ix,
             v_qd_data,
             sysdate,
             in_login_id,
             NULL,
             NULL,
             NULL,
             in_IO);
        end if;
      end if;
      v_start_pos := v_Ende_pos + 1;
    end loop;

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

  function bde_check_pd_prozess_data (in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_id          in lvs_lte.lte_id%type)
                                      return varchar2 is

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error          exception;
    v_err_nr         number;
    v_err_text       varchar2(2550);

    -------------------------------------------------------------------------------------------------------

    v_pd_prozess_data_nio              bde_pd_prozess_data%rowtype;
    v_found                      boolean;


    CURSOR c_pd_prozess_data_nio is
      select *
        from bde_pd_prozess_data t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.fae_id = in_id
         and t.io = c.C_FALSE;

  begin
    OPEN c_pd_prozess_data_nio;
    FETCH c_pd_prozess_data_nio into v_pd_prozess_data_nio;
    v_found := c_pd_prozess_data_nio%FOUND;
    CLOSE c_pd_prozess_data_nio;

    if v_found then
      return('IO');
    else
      return('NIO');
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



/*
Erstellt einen Eintrag (Prozessdaten / QS-Daten) für eine Produktion ohne FA

@see c_wr_bde_pd_prozess_data Buchen Prozessdaten ohne Produktion un FA
@see bde_pd_prod_insert In dieser Procedure werden die Produktionsdaten geschrieben. Bei Fertigware müssen Alle Rohstoffe an die Maschine gebucht sein. Damit werden alle Rohstoffbezieungen für Fertigware automatisch gebucht.

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_name           in isi_resource.res_name%type   Name der Resource,
@param in_login_id       in isi_user.login_id%type       Login_ID des angemeldeten USER,
@param in_b_datum        in bde_pd_prozess_data.res_prozess_data_date%type datum der Buchung für zuordnung des Produktionssatz,
@param in_id             in lvs_lte.lte_id%type                            LTE-ID aus FAE-ID des gefertigten Produkt,
@param in_IO             in bde_pd_prozess_data.io%type                    Prozessdaten IO oder NIO,
@param in_qd_data        in varchar2                                       Prozessdaten als Parameterlist,
*/

  procedure c_wr_bde_pd_prozess_d_o_fa (in_sid         in isi_sid.sid%type,
                                        in_firma_nr    in isi_firma.firma_nr%type,
                                        in_name        in isi_resource.res_name%type,
                                        in_login_id    in isi_user.login_id%type,
                                        in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                        in_id          in lvs_lte.lte_id%type,
                                        in_IO          in bde_pd_prozess_data.io%type,
                                        in_qd_data     in varchar2)
                                        is
  begin
    bde_util.bde_wr_pd_prozess_d_o_fa(in_sid,
                                      in_firma_nr,
                                      in_name,
                                      in_login_id,
                                      in_b_datum,
                                      in_id,
                                      in_io,
                                      in_qd_data);
    commit;
  end;

/*
Erstellt einen Eintrag (Prozessdaten / QS-Daten) für eine Produktion ohne FA

@see c_wr_bde_pd_prozess_data Buchen Prozessdaten ohne Produktion un FA
@see bde_pd_prod_insert In dieser Procedure werden die Produktionsdaten geschrieben. Bei Fertigware müssen Alle Rohstoffe an die Maschine gebucht sein. Damit werden alle Rohstoffbezieungen für Fertigware automatisch gebucht.

@author -AG- Hans Joachim Gödeke
@param in_sid            in isi_sid.sid
@param in_firma          in isi_firma.firma_nr
@param in_name           in isi_resource.res_name%type   Name der Resource,
@param in_login_id       in isi_user.login_id%type       Login_ID des angemeldeten USER,
@param in_b_datum        in bde_pd_prozess_data.res_prozess_data_date%type datum der Buchung für zuordnung des Produktionssatz,
@param in_id             in lvs_lte.lte_id%type                            LTE-ID aus FAE-ID des gefertigten Produkt,
@param in_IO             in bde_pd_prozess_data.io%type                    Prozessdaten IO oder NIO,
@param in_qd_data        in varchar2                                       Prozessdaten als Parameterlist,
*/
  procedure bde_wr_pd_prozess_d_o_fa (in_sid         in isi_sid.sid%type,
                                    in_firma_nr    in isi_firma.firma_nr%type,
                                    in_name        in isi_resource.res_name%type,
                                    in_login_id    in isi_user.login_id%type,
                                    in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                    in_id          in lvs_lte.lte_id%type,
                                    in_IO          in bde_pd_prozess_data.io%type,
                                    in_qd_data     in varchar2)
                                    is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error          exception;
    v_err_nr         number;
    v_err_text       varchar2(2550);

    -------------------------------------------------------------------------------------------------------

    v_found                                   boolean;

    v_lam_bh                                  lvs_lam_bh%rowtype;
    v_res                                     isi_resource%rowtype;
    v_in_name_res_id                          isi_resource.res_id%type;
    v_res_id                                  isi_resource.res_id%type;
    v_trenner                                 constant varchar2(1)  := ';';  -- Trennzeichen in QD-Daten
    v_bde_pd_prozess_data                     bde_pd_prozess_data%rowtype;

    v_qd_ix                                   number;
    v_qd_data                                 varchar2(255);
    v_start_pos                               number;
    v_ende_pos                                number;
    v_b_datum                                 timestamp(6);



    CURSOR c_lam_bh is
      select bh.*
        from lvs_lam_bh bh
       where (bh.lte_id = in_id
           or bh.lhm_id = in_id)
         and bh.bus in (c.LAM_BH_BUS_ZUG, c.LAM_BH_BUS_ZUG_KOMM, c.LAM_BH_BUS_UP)
       order by bh.buch_datum;

    CURSOR c_lam_bh_hist is
     select bh.*
        from lvs_lam_bh_hist bh
       where (bh.lte_id = in_id
           or bh.lhm_id = in_id)
         and bh.bus in (c.LAM_BH_BUS_ZUG, c.LAM_BH_BUS_ZUG_KOMM, c.LAM_BH_BUS_UP)
       order by bh.buch_datum;

  begin
    -- Finderen der Maschine für den AG und den Produktions-Satz
    if not isi_p_base.get_resource_by_name(in_name, v_res)
    or v_res.typ not in ('MS', 'MSMP')
    then
      v_err_nr := c.FMID_Resource_Fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_RESOURCE_FEHLT, in_name);
      raise v_error;
    end if;

    if in_b_datum is NULL
    then
      v_b_datum := sysdate;
    else
      v_b_datum := in_b_datum;
    end if;

    v_in_name_res_id := v_res.res_id;
    v_res_id := NULL;

    -- Finden der richtigen LAM
    OPEN c_lam_bh;
    FETCH c_lam_bh into v_lam_bh;
    v_found := c_lam_bh%FOUND;
    CLOSE c_lam_bh;

    if not v_found
    then
      OPEN c_lam_bh_hist;
      FETCH c_lam_bh_hist into v_lam_bh;
      v_found := c_lam_bh_hist%FOUND;
      CLOSE c_lam_bh_hist;
    end if;

    if not v_found
    then
      v_lam_bh.lam_id := NULL;
      v_lam_bh := NULL;
    end if;

    v_start_pos := 1;
    v_ende_pos  := 1;
    v_qd_ix := 0;
    while (v_ende_pos > 0)
    loop
      v_ende_pos := instr(in_qd_data, v_trenner, v_start_pos, 1);
      if (v_ende_pos > 0)
      then
        v_qd_ix    := v_qd_ix + 1;
        v_qd_data := substr(in_qd_data,
                         v_start_pos,
                         v_ende_pos - v_start_pos);

        if bde_p_base.get_bde_pd_prozess_data(in_sid,
                                              in_firma_nr,
                                              0, -- Vorgang-ID 0 ==> Keine PROD-Vorgang
                                              v_in_name_res_id,
                                              v_b_datum,
                                              v_qd_ix,
                                              v_bde_pd_prozess_data)
        then
          update bde_pd_prozess_data t
             set t.res_prozess_data_value = v_qd_data
           where t.id = v_bde_pd_prozess_data.id;
        else
          insert into bde_pd_prozess_data
          values
            (in_sid,
             in_firma_nr,
             0, -- Vorgang-ID 0 ==> Keine PROD-Vorgang
             NULL,
             NULL,
             NULL,
             v_res_id,
             in_id,
             NULL,
             v_in_name_res_id,
             v_b_datum,
             v_qd_ix,
             v_qd_data,
             sysdate,
             in_login_id,
             NULL,
             NULL,
             NULL,
             in_IO);
        end if;
      end if;
      v_start_pos := v_Ende_pos + 1;
    end loop;
    update lvs_lam t
       set t.fae_id = in_id
     where t.lam_id = v_lam_bh.lam_id;
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



  procedure c_bde_pd_restart_on_res (in_sid         in isi_sid.sid%type,
                                   in_firma_nr    in isi_firma.firma_nr%type,
                                   in_lte_id      in lvs_lte.lte_id%type,
                                   in_rdk_id      in lvs_lte.lte_id%type,
                                   in_res_id      in isi_resource.res_id%type)
                                   is

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error          exception;
    v_err_nr         number;
    v_err_text       varchar2(2550);


    v_res                         isi_resource%rowtype;
    v_bde_fa_res                  bde_fa_auftrag%rowtype;
    v_bde_fa_restart              bde_fa_auftrag%rowtype;

    v_found                       boolean;

    CURSOR c_lam is
      select t.artikel_id,
             t.leitzahl,
             t.fa_ag,
             t.fa_upos
        from lvs_lam t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id
       group by t.lte_id, t.artikel_id, t.leitzahl, t.fa_ag, t.fa_upos;
    v_lam_grp                     c_lam%rowtype;
    v_lam_grp2                    c_lam%rowtype;

    CURSOR c_bde_fa_res is
      select *
        from bde_fa_auftrag t
       where t.leitzahl = v_lam_grp.leitzahl
         and t.res_id = in_res_id;

    CURSOR c_bde_fa is
      select *
        from bde_fa_auftrag t
       where t.leitzahl = v_bde_fa_res.leitzahl
         and t.fa_ag < v_bde_fa_res.fa_ag
         and (t.fa_upos = v_bde_fa_res.fa_upos or t.fa_upos = 0)
         and t.satzart = 'V'
       order by t.fa_ag desc, t.fa_upos;

  begin
    if isi_p_base.get_resource(in_sid, in_res_id, v_res)
    then
      OPEN c_lam;
      FETCH c_lam into v_lam_grp;
      v_found := c_lam%found;
      if v_found                       -- Einen gefunden ist OK
      then
        FETCH c_lam into v_lam_grp;
        v_found := c_lam%found;
      else  -- Sonst Fehler
        v_err_nr   := c.FMID_LTE_ID_Fehlt;
        v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
        raise v_error;
      end if;
      CLOSE c_lam;

      if v_found                                      -- Zwei gefunden Fehler
      then
        v_err_nr := c.FMID_Falscher_LTE_Type;
        v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_NICHT_BUCHBAR, in_lte_id);
        raise v_error;
      end if;

      OPEN c_bde_fa_res;
      FETCH c_bde_fa_res into v_bde_fa_res;
      v_found := c_bde_fa_res%found;
      CLOSE c_bde_fa_res;

      if not v_found
      then
        v_err_nr := c.FMID_Resource_Fehlt;
        v_err_text := LC.ec_p1(LC.O_TP1_ARB_PPS_AG_FEHLT, v_lam_grp.leitzahl);
        raise v_error;
      end if;

      OPEN c_bde_fa;
      FETCH c_bde_fa into v_bde_fa_restart;
      v_found := c_bde_fa%found;
      CLOSE c_bde_fa;

      if not v_found
      then
        v_err_nr := c.FMID_Resource_Fehlt;
        v_err_text := LC.ec_p3(LC.O_TP3_FA_AUFTRG_FEHLT, v_lam_grp.leitzahl, ' AG < ' || to_char(v_lam_grp.fa_ag), NULL);
        raise v_error;
      end if;

      update lvs_lam t
         set t.fa_ag = v_bde_fa_restart.fa_ag,
             t.fa_upos = v_bde_fa_restart.fa_upos,
             t.labor_status = c.LAB_STAT_F
       where t.lte_id = in_lte_id;

      if in_rdk_id is not NULL
      then
        update bde_pd_prozess_data t
           set t.res_prozess_data_value = 'RDK-ID-' || in_rdk_id,
               t.io = 'N'
         where t.fae_id = in_lte_id
           and t.res_prozess_data_value like 'RDK-ID-%';
      end if;
    else
      v_err_nr := c.FMID_Resource_Fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_RESOURCE_FEHLT, in_res_id);
      raise v_error;
    end if;
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

  procedure c_bde_pd_2nd_live (in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_lte_id      in lvs_lte.lte_id%type,
                               in_login_id    in isi_user.login_id%type,
                               in_lgr_platz   in lvs_lgr.lgr_platz%type,
                               in_drucker     in pe_drucker_cfg.drucker_name%type)
                               is
  begin
    bde_util.c_bde_pd_2nd_live_3511(in_sid,
                                    in_firma_nr,
                                    in_lte_id,
                                    in_login_id,
                                    in_lgr_platz,
                                    in_drucker,
                                    NULL); -- => :in_labor_status);

  end;

  procedure c_bde_pd_2nd_live_3511(in_sid          in isi_sid.sid%type,
                                   in_firma_nr     in isi_firma.firma_nr%type,
                                   in_lte_id       in lvs_lte.lte_id%type,
                                   in_login_id     in isi_user.login_id%type,
                                   in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                   in_drucker      in pe_drucker_cfg.drucker_name%type,
                                   in_labor_status in lvs_lam.labor_status%type)
                                   is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error          exception;
    v_err_nr         number;
    v_err_text       varchar2(2550);

    v_bde_fa_all_v                bde_pd_prod%rowtype;
    v_bde_fa_all_pb               bde_pd_prod%rowtype;
    v_bde_fa_count_pb             number;
    v_lam_bh                      lvs_lam_bh%rowtype;
    v_lam                         lvs_lam%rowtype;
    v_lte                         lvs_lte%rowtype;

    v_lam_bh_id                   lvs_lam_bh.lam_bh_id%type;
    v_vorg_id                     lvs_lam_bh.vorg_id%type;

    v_found                       boolean;
    v_result                      number;

    CURSOR c_lam_grp is
      select t.lam_id,
             t.zug_datum,
             t.artikel_id,
             t.leitzahl,
             t.fa_ag,
             t.fa_upos
        from lvs_lam t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = in_lte_id
       group by t.lam_id,
                t.zug_datum,
                t.lte_id,
                t.artikel_id,
                t.leitzahl,
                t.fa_ag,
                t.fa_upos;
    v_lam_grp                     c_lam_grp%rowtype;
    v_lam_grp2                    c_lam_grp%rowtype;

    cursor c_lam is               -- Lesen genau eine LAM
      select *
        from lvs_lam lam
       where lam.lam_id = v_lam_bh.lam_id;

    CURSOR c_lam_bh_zu is
      select t.*
        from lvs_lam_bh t
       where t.lam_id = v_lam_grp.lam_id
         and t.bus = c.LAM_BH_BUS_ZUG
         and t.buch_datum = v_lam_grp.zug_datum;

    CURSOR c_lam_bh is
      select *
        from lvs_lam_bh t
       where t.lam_id = v_bde_fa_all_pb.lam_id
         and t.bus = c.LAM_BH_BUS_ABG
         and t.buch_datum <= v_bde_fa_all_pb.prod_ende
         and t.menge > 0
       order by t.buch_datum desc;

    CURSOR c_bde_fa_all_v is
      select *
        from bde_pd_prod t
       where t.leitzahl = v_lam_grp.leitzahl
         and t.fae_id = in_lte_id
         and t.vorg_typ = 'PP'
     order by t.vorg_id desc;

    CURSOR c_bde_fa_all_pb is
      select t.*
        from bde_pd_prod t,
             lvs_lam l
       where t.leitzahl = v_bde_fa_all_v.leitzahl
         and t.vorg_id = v_bde_fa_all_v.vorg_id
         and t.vorg_typ = 'PB'
         and t.lam_id = l.lam_id
         and l.fa_ag is NULL
       order by t.prod_beginn desc;

    CURSOR c_bde_fa_all_count_pb is
      select count(t.vorg_id)
        from bde_pd_prod t
       where t.lam_id = v_bde_fa_all_pb.lam_id
         and t.vorg_typ = 'PB';

  begin
    OPEN c_lam_grp;                  -- Lesen der LAM ggf. 1-n wenn es mit einem Produktionssatz geschrieben wurde
    FETCH c_lam_grp into v_lam_grp;
    v_found := c_lam_grp%found;
    if v_found                       -- Einen gefunden ist OK
    then
      FETCH c_lam_grp into v_lam_grp;-- Versuch zweiten zu lesen
      v_found := c_lam_grp%found;    -- Zweiter ist vorhanden / Fehler
    else  -- Sonst Fehler
      v_err_nr   := c.FMID_LTE_ID_Fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    end if;
    CLOSE c_lam_grp;

    if v_found                                      -- Zwei gefunden Fehler
    then
      v_err_nr := c.FMID_Falscher_LTE_Type;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_NICHT_BUCHBAR, in_lte_id);
      raise v_error;
    end if;

    OPEN c_lam_bh_zu;                                 -- Buchung fuer den Zugang suchen
    FETCH c_lam_bh_zu into v_lam_bh;
    v_found := c_lam_bh_zu%FOUND;
    CLOSE c_lam_bh_zu;

    if v_found                                      -- Zwei gefunden Fehler
    and v_lam_bh.menge = 0                          -- Fehler, keinen Bestand mehr
    or not v_found                                  -- Buchung nicht gefunden
    then
      v_err_nr := c.FMID_Falscher_LTE_Type;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_NICHT_BUCHBAR, in_lte_id);
      raise v_error;
    end if;

    update lvs_lam_bh t
       set t.menge = 0
     where t.lam_bh_id = v_lam_bh.lam_bh_id;   -- Zugang rueckgaenig

    OPEN c_bde_fa_all_v;                         -- Suchen all V-Saetze mit dieser FAE-ID
    LOOP
      FETCH c_bde_fa_all_v into v_bde_fa_all_v;  -- Lesen der V-Saetze
      v_found := c_bde_fa_all_v%found;             -- Einen weiteren gefunden
      EXIT when not v_found;

      OPEN c_bde_fa_all_pb;                      -- Suchen aller Beschickungen für diese FAE-ID
      LOOP
        FETCH c_bde_fa_all_pb into v_bde_fa_all_pb;
        v_found := c_bde_fa_all_pb%found;        -- Beschicken gefunden ?
        EXIT when not v_found;                   -- Nicht gefunden, dann fuer diesen V-Satz fertig

        OPEN c_bde_fa_all_count_pb;              -- Zaehlen ob nur ein mal verwendet
        FETCH c_bde_fa_all_count_pb into v_bde_fa_count_pb;
        CLOSE c_bde_fa_all_count_pb;

        OPEN c_lam_bh;                           -- Die Buchung fuer diese Beschickung lesen
        FETCH c_lam_bh into v_lam_bh;
        v_found := c_lam_bh%found;
        CLOSE c_lam_bh;

        if v_bde_fa_count_pb > 1                 -- Fehler, der Rohstoff wurde mehr al ein mal in der Produktion verbucht
        then
          v_err_nr := c.FMID_Falscher_LTE_Type;
          v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_NICHT_BUCHBAR, v_lam_bh.lte_id);
          raise v_error;
        end if;

        if v_found                                      -- Zwei gefunden Fehler
        and v_lam_bh.menge > 0                          -- Noch nicht ausgebucht
        then
          update bde_pd_prod t
             set t.lam_id = NULL
           where t.lam_id = v_lam_bh.lam_id
             and t.vorg_typ = 'PB';
          update lvs_lam_bh t
             set t.menge = 0
           where t.lam_bh_id = v_lam_bh.lam_bh_id;   -- Zugang rueckgaenig machen
          update lvs_lam lam
             set lam.labor_text   = '2nd life',
                 lam.labor_status = nvl(in_labor_status, c.LAB_STAT_G),
                 lam.fae_id = in_lte_id              -- Merken der LTE_ID in was das teil verbaut war (Rohstoff nur eine mal gebucht)
           where lam.lam_id = v_lam_bh.lam_id;

          OPEN c_lam;                                -- Lesen der LAM um fuer das Sperren alle LAM Daten zu haben (Buchen Sperren)
          FETCH c_lam
            into v_lam;
          v_found := c_lam%FOUND;
          CLOSE c_lam;

          if not v_found
          then
            v_err_nr   := c.FMID_LTE_ID_Fehlt;
            v_err_text := LC.ec(LC.O_TXT_LAGERBEST_N_LESBAR) || ' <' || to_char(v_lam_bh.lam_id) || '>';
            raise v_error;
          end if;

          if nvl(in_labor_status, 'X') != c.LAB_STAT_F
          then
            v_err_nr   := c.FMID_SEQ_FEHLER;                   -- Setzen der Fehlervariabln
            v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
            select seq_lam_bh.nextval into v_lam_bh_id from dual;
            select seq_vorg_id.nextval into v_vorg_id from dual;
            v_err_nr   := c.FMID_BUCH_FEHLER;
            v_err_text := LC.ec_p2(LC.O_TP2_BUC_LAM_BH_ERR, v_lam_bh.lam_bh_id, v_lam_bh.lam_id);
            -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
            insert into lvs_lam_bh                             -- Sperren Buchen
            values
              (v_lam.sid,
               v_lam.firma_nr,
               v_vorg_id,
               c.LAM_BH_SPRERE,
               v_lam_bh_id,
               v_lam_bh.lam_id,
               v_lam.artikel_id,
               c.LAM_BH_BUS_SP,
               sysdate,
               in_login_id,
               v_lam.lgr_platz,
               v_lam.lte_id,
               v_lam.lhm_id,
               v_lam.charge_id,
               v_lam.serie_id,
               null,
               v_lam.menge,
               v_lam.lam_kg,
               v_lam.lam_kg / v_lam.menge,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               null,
               sysdate,                     -- CREATED_DATE N DATE  Y     creation date+time of this dataset
               in_login_id,                  -- CREATED_LOGIN_ID  N NUMBER  Y     login id of the user creating this dataset
               sysdate,                     -- LAST_CHANGE_DATE N DATE  Y     change date+time of this dataset
               in_login_id,                 -- LAST_CHANGE_LOGIN_ID N NUMBER  Y     login id of the user changing this dataset
               null,                        -- CHANGE_MENGE N NUMBER  Y     Menge die geändert wurde
               v_lam.owner_address_id,      -- OWNER_ADDRESS_ID      Aktueller Eigentümer
               null);                       -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
          end if;
          v_err_nr   := NULL;
          v_err_text := NULL;
          v_result := lvs_ausl.lvs_lte_res_rueck(v_lam.sid,
                                                 v_lam.firma_nr,
                                                 v_bde_fa_all_pb.leitzahl,
                                                 v_lam.order_pos_auf_id,
                                                 v_lam.lte_id,
                                                 NULL,
                                                 NULL,
                                                 c.c_true);
          if lvs_p_base.get_lte(v_lam.lte_id, v_lte)
          and v_lte.lte_status = c.LTE_BS_STAT
          then
            update lvs_lte t
               set t.lte_status = c.LTE_BF_STAT
             where t.lte_id = v_lam.lte_id;
          end if;
          lvs_transport.lvs_lte_transport(v_lam.lte_id,
                                          NULL,
                                          in_lgr_platz,
                                          in_login_id);

          if in_drucker is not NULL
          then
            v_result := lvs_p_lte.lvs_lte_drucken(v_lam_bh.lte_id,  -- Neues Etiket drucken
                                                  NULL,
                                                  in_drucker);
          end if;
        end if;
      end LOOP;
      CLOSE c_bde_fa_all_pb;
    end LOOP;

    CLOSE c_bde_fa_all_v;

    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;

      if c_lam%isopen
      then
        CLOSE c_lam;
      end if;
      if c_lam_bh_zu%isopen
      then
        CLOSE c_lam_bh_zu;
      end if;
      if  c_lam_bh%isopen
      then
        CLOSE c_lam_bh;
      end if;
      if  c_bde_fa_all_v%isopen
      then
        CLOSE c_bde_fa_all_v;
      end if;
      if  c_bde_fa_all_pb%isopen
      then
        CLOSE c_bde_fa_all_pb;
      end if;
      if  c_bde_fa_all_count_pb%isopen
      then
        CLOSE c_bde_fa_all_count_pb;
      end if;

      v_err_text := v_err_text  || cr_lf() || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
    when others then
      rollback;

      if c_lam%isopen
      then
        CLOSE c_lam;
      end if;
      if c_lam_bh_zu%isopen
      then
        CLOSE c_lam_bh_zu;
      end if;
      if  c_lam_bh%isopen
      then
        CLOSE c_lam_bh;
      end if;
      if  c_bde_fa_all_v%isopen
      then
        CLOSE c_bde_fa_all_v;
      end if;
      if  c_bde_fa_all_pb%isopen
      then
        CLOSE c_bde_fa_all_pb;
      end if;
      if  c_bde_fa_all_count_pb%isopen
      then
        CLOSE c_bde_fa_all_count_pb;
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


END bde_util;
/



-- sqlcl_snapshot {"hash":"25f70a7e23c55e677cef9dfc2b17a56b0b2c7cbf","type":"PACKAGE_BODY","name":"BDE_UTIL","schemaName":"DIRKSPZM32","sxml":""}