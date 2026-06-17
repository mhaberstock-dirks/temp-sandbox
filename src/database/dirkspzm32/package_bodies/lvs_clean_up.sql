create or replace 
package body DIRKSPZM32.LVS_CLEAN_UP is
  -- Functionsbibliothek um Fehler bei LVS_LGR Disponierungen, Beständen, Transporten zu bereinigen


  -- Korrektur Typen siehe auch View V_LVS_LGR_DISPO_FEHLER

  C_KOR_EINL_TE_CLEAN_UP_ID constant number      := 1;
  C_KOR_AUSL_TE_CLEAN_UP_ID constant number      := 3;
  C_KOR_AKT_TE_BIG_M_CLEAN_UP_ID number          := 4;
  C_KOR_AKT_TE_CLEAN_UP_ID  constant number      := 5;

  C_KOR_EINL_TE_VERF_CLEAN_UP_ID constant number := 6;
  C_KOR_RES_STRING_CLEAN_UP_ID constant number   := 7;
  C_KOR_TRANSPORT_CLEAN_UP_ID constant number    := 8;
  C_TRANSPORT_CLEAN_UP_ID constant number        := 9;

  -- Funktion Bereinigen von lgr_dispo_xxxx_te und lgr_einl_te_verfueg
  function lvs_lgr_dispo_clean (in_lgr_platz in lvs_lgr.lgr_platz%type,
                                out_text out varchar2) return varchar2 is
  v_einl_te number;
  v_einl_te_verfueg number;
  v_found boolean;
  v_lgr       lvs_lgr%rowtype;
  v_lte       lvs_lte%rowtype;

  CURSOR c_source_einl_te_in_transp IS
    SELECT count(*)
      FROM isi_transport t
      WHERE t.lgr_platz_ziel = in_lgr_platz;
  CURSOR c_lgr is
    select *
      from lvs_lgr lgr
     where lgr.lgr_platz = in_lgr_platz;
  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lgr_platz = in_lgr_platz
        or lte.ziel_lgr_platz = in_lgr_platz
     order by lte.lte_letzte_buchung desc;

  begin
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if not v_found then
      out_text := ' Storage Place ' || in_lgr_platz || ' not found!';
      return('F');
    end if;

    update lvs_lgr lgr
       set lgr.lgr_dispo_einl_te = (select count(*) FROM isi_transport t where t.lgr_platz_ziel = in_lgr_platz),
           lgr.lgr_dispo_ausl_te = (select count(*) FROM isi_transport t where t.lgr_platz_quelle = in_lgr_platz and t.status in ('F', 'B')),
           lgr.lgr_dispo_einl_kg = nvl((select sum(lte.lte_akt_kg)
                                          from isi_transport t,
                                               lvs_lte lte
                                         where t.lgr_platz_ziel = in_lgr_platz
                                           and t.lte_id = lte.lte_id), 0),
           lgr.lgr_dispo_ausl_kg = nvl((select sum(lte.lte_akt_kg)
                                          from isi_transport t,
                                               lvs_lte lte
                                         where t.lgr_platz_quelle = in_lgr_platz
                                           and t.lte_id = lte.lte_id
                                           and t.status in ('F', 'B')), 0)
     where lgr.lgr_platz = in_lgr_platz;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    lvs_lager_opt.LVS_KANAL_KONTROLLE(v_lte, v_lgr);
    out_text := ' Storage Place ' || in_lgr_platz || ' Dispo wrong, fixed!';
    commit;
    return('T');
  end lvs_lgr_dispo_clean;

  -- Funktion Bereinigen von res_String
  function lvs_lgr_res_string_clean (in_lgr_platz in lvs_lgr.lgr_platz%type,
                                out_text out varchar2) return varchar2 is
    v_found boolean;
    v_lgr lvs_lgr%rowtype;
    v_lte       lvs_lte%rowtype;

    CURSOR c_lgr is
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = in_lgr_platz;
    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lgr_platz = in_lgr_platz
          or lte.ziel_lgr_platz = in_lgr_platz
       order by lte.lte_letzte_buchung desc;


  begin
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if not v_found then
      out_text := ' Storage Place ' || in_lgr_platz || ' not found!';
      return('F');
    end if;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    lvs_lager_opt.LVS_KANAL_KONTROLLE(v_lte, v_lgr);

    out_text := ' Storage Place ' || in_lgr_platz || ' Res String wrong, fixed!';
    Commit;
    return('T');
  end lvs_lgr_res_string_clean;

  -- Funktion bereinigt die verfügbaren Mengen im Lagerplatz
  function lvs_lgr_verfuegbar_clean (in_lgr_platz in lvs_lgr.lgr_platz%type,
                                     out_text out varchar2) return varchar2 is
    v_found boolean;
    v_lgr lvs_lgr%rowtype;
    v_lte       lvs_lte%rowtype;

    CURSOR c_lgr is
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = in_lgr_platz;
    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lgr_platz = in_lgr_platz
          or lte.ziel_lgr_platz = in_lgr_platz
       order by lte.lte_letzte_buchung desc;


  begin
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if not v_found then
      out_text := ' Storage Place ' || in_lgr_platz || ' not found!';
      return('F');
    end if;

    -- hier werden te mengen gebucht
    if (v_lgr.lgr_typ = c.SAT1)
    or (v_lgr.lgr_typ = c.SAT_EPL1)
    or (v_lgr.lgr_typ = c.SAT_EPL2)
    or (v_lgr.lgr_typ = c.KANAL1)
    or (v_lgr.lgr_typ = c.KANAL_BKL1)
    or (v_lgr.lgr_typ = c.DURCHL1)
    or (v_lgr.lgr_typ = c.REG_FACH1)
    or (v_lgr.lgr_typ = c.EPL1)
    or (v_lgr.lgr_typ = c.BKL1)
    or (v_lgr.lgr_typ = c.SEG1)
    or (v_lgr.lgr_typ = c.SEG_DUEDO1)
    or (v_lgr.lgr_typ = c.PP_EPL1)
    then
      update lvs_lgr lgr
         set lgr_einl_te_verfueg = lgr.lgr_max_te - lgr.lgr_akt_te -
                                   lgr.lgr_dispo_einl_te
       where sid = v_lgr.sid
         and firma_nr = v_lgr.firma_nr
         and Lgr_platz = v_lgr.lgr_platz;
      update lvs_lgr lgr
         set lgr.lgr_einl_te_verfueg_gruppe = (select sum(lgr_g.lgr_einl_te_verfueg)
                                                 from lvs_lgr lgr_g
                                                where lgr_g.lgr_platz_gruppe = lgr.lgr_platz_gruppe
                                                  and   ((lgr.lgr_dim_g = lgr_g.lgr_dim_g
                                                     and lgr.lgr_dim_r = lgr_g.lgr_dim_r
                                                     and lgr.lgr_dim_p = lgr_g.lgr_dim_p
                                                     and lgr.lgr_dim_e = lgr_g.lgr_dim_e)
                                                   or  ( lgr_g.lgr_typ != c.SEG1
                                                     and lgr_g.lgr_typ != c.SEG_DUEDO1))
                                                group by lgr_g.lgr_platz_gruppe)
       where lgr.sid = v_lgr.sid
         and lgr.firma_nr = v_lgr.firma_nr
         and lgr.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
         and   ((lgr.lgr_dim_g = v_lgr.lgr_dim_g
            and lgr.lgr_dim_r = v_lgr.lgr_dim_r
            and lgr.lgr_dim_p = v_lgr.lgr_dim_p
            and lgr.lgr_dim_e = v_lgr.lgr_dim_e)
          or  ( lgr.lgr_typ != c.SEG1
            and lgr.lgr_typ != c.SEG_DUEDO1));
    end if;


    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    lvs_lager_opt.LVS_KANAL_KONTROLLE(v_lte, v_lgr);

    out_text := ' Storage Place ' || in_lgr_platz || ' Amount of free wrong, fixed!';
    Commit;
    return('T');
  end lvs_lgr_verfuegbar_clean;

  -- Funktion Bereinigen von lgr_dispo_einl_te und lgr_einl_te_verfueg
  function lvs_lgr_Akt_te_clean (in_lgr_platz in lvs_lgr.lgr_platz%type,
                                 out_text     out varchar2)
                                 return varchar2 is
    v_einl_te_verfueg number;
    v_found boolean;
    v_lgr lvs_lgr%rowtype;
    v_lte       lvs_lte%rowtype;

    CURSOR c_akt_te_on_storage_place IS
      select count(t.lte_id) anz,
             sum(t.lte_akt_kg) lte_akt_kg
        from lvs_lte t
       where t.lgr_platz = in_lgr_platz;
    v_akt_te c_akt_te_on_storage_place%rowtype;

    CURSOR c_lgr is
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = in_lgr_platz;

    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lgr_platz = in_lgr_platz
          or lte.ziel_lgr_platz = in_lgr_platz
       order by lte.lte_letzte_buchung desc;

  begin
    OPEN c_akt_te_on_storage_place;
    FETCH c_akt_te_on_storage_place into v_akt_te;
    v_found := c_akt_te_on_storage_place%FOUND;
    CLOSE c_akt_te_on_storage_place;
    if not v_found
    or v_akt_te.anz = 0
    then
      v_akt_te.anz := 0;
      v_akt_te.lte_akt_kg := 0;
    end if;
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if not v_found
    then
      out_text := ' Storage Place ' || in_lgr_platz || ' not found!';
      return('F');
    end if;
    if (v_lgr.lgr_akt_te <> v_akt_te.anz)
    or (v_lgr.lgr_akt_kg <> v_akt_te.lte_akt_kg)
    then
      update lvs_lgr lgr
         set lgr.lgr_akt_te = v_akt_te.anz,
             lgr.lgr_akt_kg = v_akt_te.lte_akt_kg
        where lgr.lgr_platz = in_lgr_platz;

      OPEN c_lte;
      FETCH c_lte into v_lte;
      v_found := c_lte%FOUND;
      CLOSE c_lte;
      lvs_lager_opt.LVS_KANAL_KONTROLLE(v_lte, v_lgr);

      commit;
      out_text := ' Storage Place ' || in_lgr_platz || ' Actual Lte wrong, fixed!';
      return('T');
    end if;
    return('F');
  end lvs_lgr_akt_te_clean;

  function lvs_lgr_transport_clean (in_transp_id in isi_transport.transp_id%type,
                                   out_text out varchar2) return varchar2 is

  v_found boolean;
  v_result varchar2(1000);

  v_transport                      isi_transport%rowtype;

  CURSOR c_transport IS
    SELECT *
      FROM isi_transport t
     WHERE t.transp_id = in_transp_id;

  begin
    OPEN c_transport;
    FETCH c_transport into v_transport;
    v_found := c_transport%FOUND;
    CLOSE c_transport;
    if not v_found then
      out_text := ' Transport ' || in_transp_id || ' not found!';
      return('F');
    end if;

    delete isi_transport t
      where t.transp_id = in_transp_id;

    if v_transport.lgr_verwendung_quelle is not NULL
    then
      v_result := lvs_lgr_akt_te_clean(v_transport.lgr_verwendung_quelle, out_text);
      v_result := lvs_lgr_dispo_clean(v_transport.lgr_verwendung_quelle, out_text);
      v_result := lvs_lgr_verfuegbar_clean(v_transport.lgr_verwendung_quelle, out_text);
    end if;

    if v_transport.lgr_verwendung_ziel is not NULL
    then
      v_result := lvs_lgr_akt_te_clean(v_transport.lgr_verwendung_ziel, out_text);
      v_result := lvs_lgr_dispo_clean(v_transport.lgr_verwendung_ziel, out_text);
      v_result := lvs_lgr_verfuegbar_clean(v_transport.lgr_verwendung_ziel, out_text);
    end if;

    out_text := ' Transport ' || in_transp_id || ' is fixed!';
    commit;
    return('T');
  end lvs_lgr_transport_clean;

  -- Funktion bereinigt Lagerplatz oder Transport nach Fehlerbild
  function lvs_lgr_clean (in_error_id in number,
                          in_lgr_platz in lvs_lgr.lgr_platz%type,
                          in_transp_id in isi_transport.transp_id%type,
                          out_text out varchar2)
    return varchar2 is
    v_result varchar2(1000);
  begin
    case in_error_id
      when C_KOR_EINL_TE_CLEAN_UP_ID then  -- 1
        v_result := lvs_lgr_akt_te_clean(in_lgr_platz, out_text);
        return(lvs_lgr_dispo_clean(in_lgr_platz, out_text));
      when C_KOR_AUSL_TE_CLEAN_UP_ID then  -- 3
        v_result := lvs_lgr_akt_te_clean(in_lgr_platz, out_text);
        return(lvs_lgr_dispo_clean(in_lgr_platz, out_text));
      when C_KOR_AKT_TE_BIG_M_CLEAN_UP_ID then  -- 4
        v_result := lvs_lgr_dispo_clean(in_lgr_platz, out_text);
        return(lvs_lgr_akt_te_clean(in_lgr_platz, out_text));
      when C_KOR_AKT_TE_CLEAN_UP_ID then  -- 5
        v_result := lvs_lgr_dispo_clean(in_lgr_platz, out_text);
        return(lvs_lgr_akt_te_clean(in_lgr_platz, out_text));
      when C_KOR_EINL_TE_VERF_CLEAN_UP_ID then -- 6
        v_result := lvs_lgr_akt_te_clean(in_lgr_platz, out_text);
        v_result := lvs_lgr_dispo_clean(in_lgr_platz, out_text);
        return(lvs_lgr_verfuegbar_clean(in_lgr_platz, out_text));
      when C_KOR_RES_STRING_CLEAN_UP_ID then -- 7
        v_result := lvs_lgr_akt_te_clean(in_lgr_platz, out_text);
        v_result := lvs_lgr_dispo_clean(in_lgr_platz, out_text);
        return(lvs_lgr_verfuegbar_clean(in_lgr_platz, out_text));
      when C_KOR_TRANSPORT_CLEAN_UP_ID then -- 8
        return(lvs_lgr_transport_clean(in_transp_id, out_text));
      when C_TRANSPORT_CLEAN_UP_ID then -- 9
        return(lvs_lgr_transport_clean(in_transp_id, out_text));
      else out_text := 'The Error ID ' || in_error_id ||  ' can not be handelt!. Try to handle manually';
        return('F');
    end case;
  end lvs_lgr_clean;

  function lvs_clean_all return varchar2 is

    CURSOR c_lgr_error IS
      select t.id,
             t.fehler,
             t.lgr_platz,
             t.transp_id
        from LVS_V_LGR_DISPO_FEHLER t
       order by t.lgr_platz, t.id;
    v_text varchar2(500);
    v_ok varchar2(1);
    v_lgr  lvs_lgr.lgr_platz%type;
    v_transp_id isi_transport.transp_id%type;
    v_id number;

  begin
    OPEN c_lgr_error;
    loop
      FETCH c_lgr_error into v_id, v_text, v_lgr, v_transp_id;
      exit when c_lgr_error%notfound;
      if v_id > 0 then
        v_ok := lvs_clean_up.lvs_lgr_clean(v_id, v_lgr, v_transp_id, v_text);
      end if;
    end loop;

    close c_lgr_error;
    return(v_text);
  end lvs_clean_all;

end LVS_CLEAN_UP;
/



-- sqlcl_snapshot {"hash":"9a74c548a2c79df9fd3dacbf78de0a3971f2dc83","type":"PACKAGE_BODY","name":"LVS_CLEAN_UP","schemaName":"DIRKSPZM32","sxml":""}