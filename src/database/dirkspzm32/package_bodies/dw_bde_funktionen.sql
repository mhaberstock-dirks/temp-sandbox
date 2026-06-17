create or replace 
package body DIRKSPZM32.dw_bde_funktionen is

  procedure dw_bde_kenz_tagesab(in_sid              in  isi_sid.sid%type,
                                in_firma_nr         in  isi_firma.firma_nr%type,
                                in_start            in  date,
                                in_ende             in  date,
                                in_raster_std       in  number)
                                is
    v_kenz                            isi_v_vdma_res%rowtype;

    v_start                           date;
    v_ende                            date;

    CURSOR c_isi_v_vdma_res is
      select r.res_ext_name,
             r.res_name,
             r.text,
             r.res_id,
             bde_funktionen.get_res_prod_std(r.res_id, v_start, v_ende)  prod_std,
             bde_funktionen.get_res_hnz_std hnz,
             bde_funktionen.get_res_hnz_std + bde_funktionen.get_res_ruest_std + bde_funktionen.get_res_su_std blz,
             bde_funktionen.get_res_hnz_std + bde_funktionen.get_res_ruest_std baz,
             bde_funktionen.get_anmelde_std(r.sid, r.firma_nr, v_start, v_ende, r.res_id) pbz,
             bde_funktionen.get_res_ruest_std trz,
             nvl((select sum(pdx.menge_a + nvl(pdx.menge_b, 0) + nvl(pdx.schrott, 0)) from bde_pd_prod pdx where r.res_id = pdx.res_id
                                                                                         and pdx.vorg_typ  = 'PP'
                                                                                         and pdx.prod_ende >= v_start
                                                                                         and pdx.prod_ende <=  v_ende), 0
                ) pm,
             nvl((select sum(nvl(lbh.menge, 0)                      )
                                                                      from bde_pd_prod pdx,
                                                                           lvs_lam l,
                                                                           lvs_lam_bh lbh
                                                                                           where r.res_id = pdx.res_id
                                                                                             and pdx.vorg_typ  = 'PP'
                                                                                             and pdx.prod_ende >= v_start
                                                                                             and pdx.prod_ende <=  v_ende
                                                                                             and pdx.lam_id = l.lam_id
                                                                                             and l.labor_status = 'F'
                                                                                             and l.lam_id = lbh.lam_id
                                                                                             and lbh.bus = 2), 0
                ) gm,
             nvl((select sum(lbh.menge                              ) from bde_pd_prod pdx,
                                                                           lvs_lam l,
                                                                           lvs_lam_bh lbh
                                                                                           where r.res_id = pdx.res_id
                                                                                             and pdx.vorg_typ  = 'PP'
                                                                                             and pdx.prod_ende >= v_start
                                                                                             and pdx.prod_ende <=  v_ende
                                                                                             and pdx.lam_id = l.lam_id
                                                                                             and l.labor_status != 'F'
                                                                                             and l.lam_id = lbh.lam_id
                                                                                             and lbh.bus = 2), 0
                ) am,

             max(rl_pez_sek.param_menge) / 3600 pez,
             bde_funktionen.get_res_ruest_std xx

        from isi_resource r,
             isi_res_leistung_cfg rl_pez_sek,
             bde_pd_prod pd
       where r.typ = 'MS'
         and r.res_id = pd.res_id(+)
         and r.res_id = rl_pez_sek.res_id(+)
         and rl_pez_sek.param_name(+) = 'PEZ_SEK'
         and pd.vorg_typ(+)  = 'PA'
         and pd.prod_ende(+) >= v_start
         and pd.prod_ende(+) <=  v_ende
         and pd.prod_beginn(+) <=  v_start
    group by r.res_ext_name,
             r.res_name,
             r.sid,
             r.firma_nr,
             r.text,
             r.res_id;
  begin
    v_start := in_start;
    v_ende := v_start + (in_raster_std / 24);
    isi_p_log.c_isi_system_meldung(in_sid,
                                   in_firma_nr,
                                   'BDE_DW_T-AB_JOB',
                                   'ORA-DB',
                                   'dw_bde_funktionen.dw_bde_kenz_tagesab',
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   'gestartet für ' || to_char(in_start, 'yyyy-mm-dd hh24') || ' bis ' || to_char(in_ende, 'yyyy-mm-dd hh24'),
                                   'IL');

    while v_ende <= in_ende
    LOOP
      OPEN c_isi_v_vdma_res;
      LOOP
        FETCH c_isi_v_vdma_res into v_kenz;
        EXIT when c_isi_v_vdma_res%notfound;
        begin
          insert into dw_bde_kennzahlen
            (sid,
             firma_nr,
             wert_datum,
             wert_datum_ende,
             res_id,
             res_ext_name,
             res_name,
             text,
             pbz,
             pez,
             hnz,
             blz,
             baz,
             trz,
             pm,
             gm,
             am)
          values
            (in_sid,
             in_firma_nr,
             v_start,
             v_ende,
             v_kenz.res_id,
             v_kenz.res_ext_name,
             v_kenz.res_name,
             v_kenz.text,
             v_kenz.pbz,
             v_kenz.pez,
             v_kenz.hnz,
             v_kenz.blz,
             v_kenz.baz,
             v_kenz.trz,
             nvl(v_kenz.pm, 0),
             nvl(v_kenz.gm, 0),
             nvl(v_kenz.am, 0));
        exception when others then
              isi_p_log.c_isi_system_meldung('01',
                                   1,
                                   'BDE_DW_T-AB_JOB',
                                   'ORA-DB',
                                   'dw_bde_funktionen.dw_bde_kenz_tagesab',
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   'Es wurden Bereits Daten für den ' || to_char(v_start) || ' für ' || v_kenz.res_ext_name || ' erfasst.',
                                   'WL');
        end;
      end LOOP;
      CLOSE c_isi_v_vdma_res;
      commit;

      v_start := v_ende;
      v_ende := v_start + (in_raster_std / 24);
    end LOOP;
    isi_p_log.c_isi_system_meldung(in_sid,
                                   in_firma_nr,
                                   'BDE_DW_T-AB_JOB',
                                   'ORA-DB',
                                   'dw_bde_funktionen.dw_bde_kenz_tagesab',
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   'fertig',
                                   'IL');
  end;

  -- Function and procedure implementations
  procedure dw_bde_tagesabschluss(in_datum            in date)
                                                    is
    -- Local variables here
    i integer;
    v_res              isi_resource%rowtype;
    v_dw_bde           dw_bde_prod_daten%rowtype;
    v_start            date;
    v_ende             date;

    CURSOR c_res is
      select *
        from isi_resource t
       where t.typ = 'MS';
  begin
    -- Test statements here
    OPEN c_res;
    FETCH c_res into v_res;
    LOOP
      EXIT when c_res%NOTFOUND;
      i := 0;
      LOOP
        EXIT when i = 24;
        v_start := in_datum + (i / 24);
        v_ende  := v_start + (1 / 24);
        v_dw_bde.dw_bde_auftragswechsel := bde_funktionen.get_res_auf_wechsel(v_res.res_id,
                                                                              v_start,
                                                                              v_ende);
        v_dw_bde.dw_bde_menge_gut       := bde_funktionen.get_bde_gut_mengen (v_res.res_id,
                                                                         NULL,
                                                                         v_start,
                                                                         v_ende);
        v_dw_bde.dw_bde_menge_b         := bde_funktionen.get_bde_b_mengen;
        v_dw_bde.dw_bde_menge_schrott   := bde_funktionen.get_bde_schrott_mengen;
        v_dw_bde.dw_bde_prod_minuten    := bde_funktionen.get_res_prod_std(v_res.res_id,
                                                                           v_start,
                                                                           v_ende) * 60;
        v_dw_bde.dw_bde_ruest_minuten   := bde_funktionen.get_res_ruest_std * 60;
        v_dw_bde.dw_bde_stoer_minuten   := bde_funktionen.get_res_unterbr_std * 60;
        v_dw_bde.dw_bde_anmelde_miniten := v_dw_bde.dw_bde_prod_minuten +
                                           v_dw_bde.dw_bde_ruest_minuten +
                                           v_dw_bde.dw_bde_stoer_minuten;

        begin
          insert into dw_bde_prod_daten t
               values (v_res.sid,                       -- SID                    VARCHAR2(2) not null,
                       v_res.firma_nr,                  -- FIRMA_NR               NUMBER(2) not null,
                       v_res.res_id,                    -- RES_ID                 NUMBER not null,
                       'TS', -- tageswert je Stunde     -- DW_BDE_TYP             VARCHAR2(2) not null,
                       v_start,                         -- DW_BDE_DATUM_START     DATE not null,
                       v_ende,                          -- DW_BDE_DATUM_ENDE      DATE not null,
                       v_dw_bde.dw_bde_auftragswechsel, -- DW_BDE_AUFTRAGSWECHSEL NUMBER,
                       v_dw_bde.dw_bde_menge_gut,       -- DW_BDE_MENGE_GUT       NUMBER,
                       v_dw_bde.dw_bde_menge_b,         -- DW_BDE_MENGE_B         NUMBER,
                       v_dw_bde.dw_bde_menge_schrott,   -- DW_BDE_MENGE_SCHROTT   NUMBER,
                       v_dw_bde.dw_bde_anmelde_miniten, -- DW_BDE_ANMELDE_MINITEN NUMBER,
                       v_dw_bde.dw_bde_prod_minuten,    -- DW_BDE_PROD_MINUTEN    NUMBER,
                       v_dw_bde.dw_bde_ruest_minuten,   -- DW_BDE_RUEST_MINUTEN   NUMBER,
                       v_dw_bde.dw_bde_stoer_minuten);  -- DW_BDE_STOER_MINUTEN   NUMBER
          exception
          when others then
            update dw_bde_prod_daten t
               set t.dw_bde_auftragswechsel = v_dw_bde.dw_bde_auftragswechsel, -- DW_BDE_AUFTRAGSWECHSEL NUMBER,
                   t.dw_bde_menge_gut       = v_dw_bde.dw_bde_menge_gut,       -- DW_BDE_MENGE_GUT       NUMBER,
                   t.dw_bde_menge_b         = v_dw_bde.dw_bde_menge_b,         -- DW_BDE_MENGE_B         NUMBER,
                   t.dw_bde_menge_schrott   = v_dw_bde.dw_bde_menge_schrott,   -- DW_BDE_MENGE_SCHROTT   NUMBER,
                   t.dw_bde_anmelde_miniten = v_dw_bde.dw_bde_anmelde_miniten, -- DW_BDE_ANMELDE_MINITEN NUMBER,
                   t.dw_bde_prod_minuten    = v_dw_bde.dw_bde_prod_minuten,    -- DW_BDE_PROD_MINUTEN    NUMBER,
                   t.dw_bde_ruest_minuten   = v_dw_bde.dw_bde_ruest_minuten,   -- DW_BDE_RUEST_MINUTEN   NUMBER,
                   t.dw_bde_stoer_minuten   = v_dw_bde.dw_bde_stoer_minuten    -- DW_BDE_STOER_MINUTEN   NUMBER
             where t.sid                    = v_res.sid                       -- SID                    VARCHAR2(2) not null,
               and t.firma_nr               = v_res.firma_nr                  -- FIRMA_NR               NUMBER(2) not null,
               and t.res_id                 = v_res.res_id                    -- RES_ID                 NUMBER not null,
               and t.dw_bde_typ             = 'TS' -- tageswert je Stunde     -- DW_BDE_TYP             VARCHAR2(2) not null,
               and t.dw_bde_datum_start     = v_start                         -- DW_BDE_DATUM_START     DATE not null,
               and t.dw_bde_datum_ende      = v_ende;                         -- DW_BDE_DATUM_ENDE      DATE not null,

        end;
        i := i + 1;
      end LOOP;
      FETCH c_res into v_res;
    end LOOP;
    CLOSE c_res;
  end dw_bde_tagesabschluss;

  procedure dw_bde_tagesabschluss_von_bis(in_datum_von        in date,
                                          in_datum_bis        in date)
                                                    is
    v_datum date;
  begin
    -- Call the procedure
    v_datum := in_datum_von;
    LOOP
      dw_bde_tagesabschluss(v_datum);

      commit;
      v_datum := v_datum + 1;
      exit when v_datum > trunc(in_datum_bis) - 1 + 6 / 24;
    end LOOP;
  end;

  procedure get_dw_bde_daten(in_sid          in  isi_sid.sid%type,
                             in_firma_nr     in  isi_firma.firma_nr%type,
                             in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                             in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                             in_res_id       in  isi_resource.res_id%type)
                             is
  v_dw_bde_daten             dw_bde_prod_daten%rowtype;
  CURSOR c_dw_bde_daten is
    select *
      from dw_bde_prod_daten dw
     where dw.sid = in_sid
       and dw.firma_nr = in_firma_nr
       and dw.res_id = in_res_id
       and dw.dw_bde_typ = 'TS'
       and dw.dw_bde_datum_start >= in_begin
       and dw.dw_bde_datum_ende <= in_ende;
  begin

    if  v_ausw_res_id          = in_res_id
    and v_ausw_begin           = in_begin
    and v_ausw_ende            = in_ende
    then
      return;
    end if;

    v_ausw_res_id          := in_res_id;
    v_ausw_begin           := in_begin;
    v_ausw_ende            := in_ende;

    v_bde_gut_mg := 0;
    v_bde_b_mg := 0;
    v_bde_schrott_mg := 0;
    v_bde_f_gut_mg := 0;
    v_bde_f_b_mg := 0;
    v_bde_f_schrott_mg := 0;
    v_bde_s_gut_mg := 0;
    v_bde_s_b_mg := 0;
    v_bde_s_schrott_mg := 0;
    v_bde_n_gut_mg := 0;
    v_bde_n_b_mg := 0;
    v_bde_n_schrott_mg := 0;

    v_unterb_std := 0;
    v_ruest_std := 0;
    v_prod_std := 0;

    v_f_unterb_std := 0;
    v_f_ruest_std := 0;
    v_f_prod_std := 0;
    v_s_unterb_std := 0;
    v_s_ruest_std := 0;
    v_s_prod_std := 0;
    v_n_unterb_std := 0;
    v_n_ruest_std := 0;
    v_n_prod_std := 0;

    v_auftr_wechsel := 0;
    v_anmeld_std := 0;

    OPEN c_dw_bde_daten;
    LOOP
      FETCH c_dw_bde_daten into v_dw_bde_daten;
      EXIT when c_dw_bde_daten%NOTFOUND;
      v_bde_gut_mg := v_bde_gut_mg + nvl(v_dw_bde_daten.dw_bde_menge_gut, 0);
      v_bde_b_mg := v_bde_b_mg + nvl(v_dw_bde_daten.dw_bde_menge_b, 0);
      v_bde_schrott_mg := v_bde_schrott_mg + nvl(v_dw_bde_daten.dw_bde_menge_schrott, 0);
      v_prod_std := v_prod_std + v_dw_bde_daten.dw_bde_prod_minuten / 60;
      v_ruest_std := v_ruest_std + v_dw_bde_daten.dw_bde_ruest_minuten / 60;
      v_unterb_std := v_unterb_std + v_dw_bde_daten.dw_bde_stoer_minuten / 60;

      v_auftr_wechsel := v_auftr_wechsel + v_dw_bde_daten.dw_bde_auftragswechsel;
      v_anmeld_std := v_anmeld_std + v_dw_bde_daten.dw_bde_anmelde_miniten / 60;


      if (v_dw_bde_daten.dw_bde_datum_start - trunc(v_dw_bde_daten.dw_bde_datum_ende) <= 14 / 24)
      and (v_dw_bde_daten.dw_bde_datum_ende - trunc(v_dw_bde_daten.dw_bde_datum_ende) > 6 / 24)
      then
        v_bde_f_gut_mg := v_bde_f_gut_mg + nvl(v_dw_bde_daten.dw_bde_menge_gut, 0);
        v_bde_f_b_mg := v_bde_f_b_mg + nvl(v_dw_bde_daten.dw_bde_menge_b, 0);
        v_bde_f_schrott_mg := v_bde_f_schrott_mg + nvl(v_dw_bde_daten.dw_bde_menge_schrott, 0);
        v_f_prod_std := v_f_prod_std + v_dw_bde_daten.dw_bde_prod_minuten / 60;
        v_f_ruest_std := v_f_ruest_std + v_dw_bde_daten.dw_bde_ruest_minuten / 60;
        v_f_unterb_std := v_f_unterb_std + v_dw_bde_daten.dw_bde_stoer_minuten / 60;

      elsif (v_dw_bde_daten.dw_bde_datum_start - trunc(v_dw_bde_daten.dw_bde_datum_ende) <= 22 / 24)
      and (v_dw_bde_daten.dw_bde_datum_ende - trunc(v_dw_bde_daten.dw_bde_datum_ende) > 14 / 24)
      then
        v_bde_s_gut_mg := v_bde_s_gut_mg + nvl(v_dw_bde_daten.dw_bde_menge_gut, 0);
        v_bde_s_b_mg := v_bde_s_b_mg + nvl(v_dw_bde_daten.dw_bde_menge_b, 0);
        v_bde_s_schrott_mg := v_bde_s_schrott_mg + nvl(v_dw_bde_daten.dw_bde_menge_schrott, 0);
        v_s_prod_std := v_s_prod_std + v_dw_bde_daten.dw_bde_prod_minuten / 60;
        v_s_ruest_std := v_s_ruest_std + v_dw_bde_daten.dw_bde_ruest_minuten / 60;
        v_s_unterb_std := v_s_unterb_std + v_dw_bde_daten.dw_bde_stoer_minuten / 60;

      else
        v_bde_n_gut_mg := v_bde_n_gut_mg + nvl(v_dw_bde_daten.dw_bde_menge_gut, 0);
        v_bde_n_b_mg := v_bde_n_b_mg + nvl(v_dw_bde_daten.dw_bde_menge_b, 0);
        v_bde_n_schrott_mg := v_bde_n_schrott_mg + nvl(v_dw_bde_daten.dw_bde_menge_schrott, 0);
        v_n_prod_std := v_n_prod_std + v_dw_bde_daten.dw_bde_prod_minuten / 60;
        v_n_ruest_std := v_n_ruest_std + v_dw_bde_daten.dw_bde_ruest_minuten / 60;
        v_n_unterb_std := v_n_unterb_std + v_dw_bde_daten.dw_bde_stoer_minuten / 60;
      end if;


    end LOOP;
    CLOSE c_dw_bde_daten;
  end;

  function get_bde_gut_mengen (in_sid                    in isi_resource.sid%type,
                               in_firma_nr               in isi_resource.firma_nr%type,
                               in_res_id                 in isi_resource.res_id%type,
                               in_von_datum              in date,
                               in_bis_datum              in date)
                               return number is

  begin
    if in_res_id is NULL
    then
      if v_bde_gut_mg = 0
      then
        if v_bde_schrott_mg = 0
        then
          return(1);
        else
          return(v_bde_schrott_mg);
        end if;
      else
        return(v_bde_gut_mg);
      end if;
    end if;

    get_dw_bde_daten(in_sid,               -- in_sid          in  isi_sid.sid%type,
                     in_firma_nr,          -- in_firma_nr     in  isi_firma.firma_nr%type,
                     in_von_datum,         -- in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                     in_bis_datum,         -- in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                     in_res_id);           -- in_res_id       in  isi_resource.res_id%type)

    return (v_bde_gut_mg);
  end get_bde_gut_mengen;

  function get_bde_b_mengen return number is
  begin
    return (v_bde_b_mg);
  end get_bde_b_mengen;

  function get_bde_schrott_mengen return number is
  begin
    return (v_bde_schrott_mg);
  end;

  function get_bde_f_gut_mengen return number is
  begin
    return (v_bde_f_gut_mg);
  end;

  function get_bde_f_b_mengen return number is
  begin
    return (v_bde_f_b_mg);
  end;

  function get_bde_f_schrott_mengen return number is
  begin
    return (v_bde_f_schrott_mg);
  end;

  function get_bde_s_gut_mengen return number is
  begin
    return (v_bde_s_gut_mg);
  end;

  function get_bde_s_b_mengen return number is
  begin
    return (v_bde_s_b_mg);
  end;

  function get_bde_s_schrott_mengen return number is
  begin
    return (v_bde_s_schrott_mg);
  end;

  function get_bde_n_gut_mengen return number is
  begin
    return (v_bde_n_gut_mg);
  end;

  function get_bde_n_b_mengen return number is
  begin
    return (v_bde_n_b_mg);
  end;

  function get_bde_n_schrott_mengen return number is
  begin
    return (v_bde_n_schrott_mg);
  end;

  function get_res_prod_std   (in_sid                    in isi_resource.sid%type,
                               in_firma_nr               in isi_resource.firma_nr%type,
                               in_res_id                 in isi_resource.res_id%type,
                               in_von_datum              in date,
                               in_bis_datum              in date)
                               return number is
  begin
    if in_res_id is NULL
    then
      return (v_prod_std);
    end if;

    get_dw_bde_daten(in_sid,               -- in_sid          in  isi_sid.sid%type,
                     in_firma_nr,          -- in_firma_nr     in  isi_firma.firma_nr%type,
                     in_von_datum,         -- in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                     in_bis_datum,         -- in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                     in_res_id);           -- in_res_id       in  isi_resource.res_id%type)
    return (v_prod_std);
  end;

  function get_res_ruest_std return number is
  begin
    return(v_ruest_std);
  end;

  function get_res_unterbr_std return number is
  begin
    return(v_unterb_std);
  end;

  function get_res_f_prod_std return number is
  begin
    return(v_f_prod_std);
  end;

  function get_res_f_ruest_std return number is
  begin
    return(v_f_ruest_std);
  end;

  function get_res_f_unterbr_std return number is
  begin
    return(v_f_unterb_std);
  end;

  function get_res_s_prod_std return number is
  begin
    return(v_s_prod_std);
  end;

  function get_res_s_ruest_std return number is
  begin
    return(v_s_ruest_std);
  end;

  function get_res_s_unterbr_std return number is
  begin
    return(v_s_unterb_std);
  end;

  function get_res_n_prod_std return number is
  begin
    return(v_n_prod_std);
  end;

  function get_res_n_ruest_std return number is
  begin
    return(v_n_ruest_std);
  end;

  function get_res_n_unterbr_std return number is
  begin
    return(v_n_unterb_std);
  end;

  function get_res_auf_wechsel return number is

  begin
    return (v_auftr_wechsel);
  end;

  function get_anmelde_std(in_sid          in  isi_sid.sid%type,
                           in_firma_nr     in  isi_firma.firma_nr%type,
                           in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                           in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                           in_res_id       in  isi_resource.res_id%type)
                           return number is
   begin
    get_dw_bde_daten(in_sid,               -- in_sid          in  isi_sid.sid%type,
                     in_firma_nr,          -- in_firma_nr     in  isi_firma.firma_nr%type,
                     in_begin,             -- in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                     in_ende,              -- in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                     in_res_id);           -- in_res_id       in  isi_resource.res_id%type)

     return(v_anmeld_std);
   end;

  function get_res_auf_wechsel(in_sid          in  isi_sid.sid%type,
                           in_firma_nr     in  isi_firma.firma_nr%type,
                           in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                           in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                           in_res_id       in  isi_resource.res_id%type)
                           return number is
  begin
    get_dw_bde_daten(in_sid,               -- in_sid          in  isi_sid.sid%type,
                     in_firma_nr,          -- in_firma_nr     in  isi_firma.firma_nr%type,
                     in_begin,             -- in_begin        in  bde_pd_kopf.pd_kopf_beginn%type,
                     in_ende,              -- in_ende         in  bde_pd_kopf.pd_kopf_ende%type,
                     in_res_id);           -- in_res_id       in  isi_resource.res_id%type)

     return(v_auftr_wechsel);
  end;

end dw_bde_funktionen;
/



-- sqlcl_snapshot {"hash":"ab6a8d25974656046baff322634355e632364493","type":"PACKAGE_BODY","name":"DW_BDE_FUNKTIONEN","schemaName":"DIRKSPZM32","sxml":""}