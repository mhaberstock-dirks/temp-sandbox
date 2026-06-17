
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LGR_BIU" 
  before update or insert on DIRKSPZM32.LVS_LGR
  for each row
declare
  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  15.02.2017
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  16.02.2017   3.5.10.1    (-AG-)   Negativer Wert in lgr_order_res_te. Kommt aus BDE-Res nachres Umpacken und Löschen
  */

  v_version_str    constant  varchar2(30) := '3.5.10.1 / 16.02.2017';
  -- local variables here
  v_lgr_grp                           lvs_lgr_grp%rowtype;

  v_found                             boolean;
  v_max_lte                           lvs_lgr.lgr_max_te%type;
  v_res_id                            isi_resource.res_id%type;

  v_transport                         isi_transport%rowtype;

  CURSOR c_lgr_grp is
    select t.*
      from lvs_lgr_grp t
     where t.lgr_gruppe_id = :new.lgr_gruppe_id
       and t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.lgr_ort = :new.lgr_ort;

  v_diff_hoehe number;

  CURSOR c_lvs_lgr_grp_fahrzeug is
    select decode (min(fg.res_id), max(fg.res_id), min(fg.res_id), NULL) Res_Id
      from lvs_lgr_grp_fahrzeug fg,
           lvs_fahrzeuge f
     where fg.lgr_gruppe_id = :new.lgr_gruppe_id
       and fg.lgr_ort = :new.lgr_ort
       and fg.res_id = f.res_id
       and 'AB' like ('%' || f.transp_richtung || '%');

  CURSOR c_transport is
    select *
      from isi_transport t
     where t.lgr_platz_quelle = :new.lgr_platz
       and t.transp_typ = 'A';
begin
  -- -AG- 2015.07.01 Gruppe für PROZ-Max Belegung im Regal für einen Platz in der vertikalen
  if :new.lgr_kg_gruppe is NULL
  and :new.lgr_verwendung in ('Lager', 'Puffer', 'LagerP')
  then
    :new.lgr_kg_gruppe := :new.lgr_ort || '.' || :new.lgr_dim_g || '.' || :new.lgr_dim_r || '.' || :new.lgr_dim_p;
  end if;

  -- -WK- 2007.11.16: Bei Höhenänderungen die freie Höhe automatisch mit verändern
  if inserting
  then
    :new.change_date := sysdate;
    if :new.lgr_typ = c.KANAL1
    then
      :new.gruppe := :new.lgr_ort || '.' || :new.lgr_dim_r || '.' || :new.lgr_dim_p || '.' || :new.lgr_dim_e;
    end if;
    :new.lgr_dim_platz := (((:new.lgr_dim_g * 10000 + :new.lgr_dim_r) * 10000 + :new.lgr_dim_p) * 10000 + :new.lgr_dim_e) * 10000 + :new.lgr_dim_t;
  end if;
  if updating
  then
    if :new.lgr_order_res_te < 0
    then
      :new.lgr_order_res_te := 0;
    end if;
    if :old.lgr_gruppe_id != :new.lgr_gruppe_id
    and isi_allg.c_get_firma_cfg_param (:new.sid,
                                        :new.firma_nr,
                                        'LVS_CHG_PLATZ_CFG',      -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'LVS_PLATZ_CHG_TO_GRP_SHOW_DISPO_ERR',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'LVS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                        'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_FALSE     -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    then
      OPEN c_transport;
      LOOP
        FETCH c_transport into v_transport;
        EXIT when c_transport%NOTFOUND;
        OPEN c_lvs_lgr_grp_fahrzeug;
        FETCH c_lvs_lgr_grp_fahrzeug into v_res_id;
        CLOSE c_lvs_lgr_grp_fahrzeug;
        update isi_transport t
           set t.res_id = v_res_id
         where v_transport.transp_id = t.transp_id
           and t.status in (c.TRANS_FREI, c.TRANS_GESPERRT, c.TRANS_ZUGEW, c.TRANS_BEGIN);
        update isi_transport t
           set t.status = c.TRANS_FREI
         where v_transport.transp_id = t.transp_id
           and t.status in (c.TRANS_ZUGEW, c.TRANS_BEGIN);
      end LOOP;
      CLOSE c_transport;
    end if;
    :new.change_date := sysdate;
    v_diff_hoehe := :new.lgr_vol_hoehe - :old.lgr_vol_hoehe;
    if v_diff_hoehe <> 0
    then
      :new.lgr_frei_hoehe := :old.lgr_frei_hoehe + v_diff_hoehe;
      if :new.lgr_frei_hoehe < 0
      then
        raise_application_error(-20000, 'Die freie Höhe ist nicht ausreichend um die Änderung durchzuführen.');
      end if;

      if :new.lgr_dispo_einl_frei_hoehe > 0
         and :new.lgr_frei_hoehe < :new.lgr_dispo_einl_frei_hoehe
      then
        raise_application_error(-20000, 'Die Höhe ist bereits für eine LTE reserviert/disponiert. Die Änderung ist nicht möglich.');
      end if;
    end if;
    if :new.lgr_dim_g != :old.lgr_dim_g
    or :new.lgr_dim_r != :old.lgr_dim_r
    or :new.lgr_dim_p != :old.lgr_dim_p
    or :new.lgr_dim_e != :old.lgr_dim_e
    or :new.lgr_dim_t != :old.lgr_dim_t
    or :new.lgr_ort   != :old.lgr_ort
    then
      :new.lgr_dim_platz := (((:new.lgr_dim_g * 10000 + :new.lgr_dim_r) * 10000 + :new.lgr_dim_p) * 10000 + :new.lgr_dim_e) * 10000 + :new.lgr_dim_t;
      if :new.lgr_typ = c.KANAL1
      then
        :new.gruppe := :new.lgr_ort || '.' || :new.lgr_dim_r || '.' || :new.lgr_dim_p || '.' || :new.lgr_dim_e;
      end if;
    end if;
  end if;

  v_max_lte := 0;
  if :new.lgr_gruppe_id is not NULL
  then
    OPEN c_lgr_grp;
    FETCH c_lgr_grp into v_lgr_grp;
    v_found := c_lgr_grp%FOUND;
    CLOSE c_lgr_grp;
    if inserting
    then
      if ( :new.lgr_typ != c.SEG1
       and :new.lgr_typ != c.SEG_DUEDO1)
      or :new.lte_namen_cfg = c.Euro || c.TE_TRENNER
      then
        v_max_lte := nvl(:new.lgr_max_te, 0);
      end if;
    elsif updating
    and :old.lgr_gruppe_id is not NULL
    and :old.lgr_gruppe_id != :new.lgr_gruppe_id
    then
      -- -AG- 17.04.2009 Sicherheithalber Prüfen, da bisher Fehler in der Verarbeitung
      -- Feld ist Relevant für die Einlagerplatzsuche
      if :new.lgr_order_res_te < 0
      then
        :new.lgr_order_res_te := 0;
      end if;
      if :new.lgr_order_res_te > :new.lgr_akt_te
      then
        :new.lgr_order_res_te := :new.lgr_akt_te;
      end if;
      -- Beim Update hat sich die Gruppe nicht veraendert
      if :new.lgr_gruppe_id = :old.lgr_gruppe_id
      then
        if ( :new.lgr_typ != c.SEG1
         and :new.lgr_typ != c.SEG_DUEDO1)
        or :new.lte_namen_cfg = c.Euro || c.TE_TRENNER
        then
          v_max_lte := nvl(:new.lgr_max_te, 0) - nvl(:old.lgr_max_te, 0);
        end if;
      else
        if :new.lgr_gruppe_id is not NULL
        and (( :new.lgr_typ != c.SEG1
           and :new.lgr_typ != c.SEG_DUEDO1)
          or :new.lte_namen_cfg = c.Euro || c.TE_TRENNER)
        then
          v_max_lte := nvl(:new.lgr_max_te, 0);
        end if;
        if :old.lgr_gruppe_id is not NULL
        then
          update lvs_lgr_grp grp
             set grp.lgr_gruppe_max_lte = grp.lgr_gruppe_max_lte - nvl(:old.lgr_max_te, 0)
           where grp.lgr_gruppe_id = :old.lgr_gruppe_id
             and grp.lgr_ort       = :old.lgr_ort
             and grp.firma_nr      = :old.firma_nr
             and grp.sid           = :old.sid;
        end if;
      end if;
    end if;
    if v_found
    then
      if nvl(v_max_lte, 0) != 0
      then
        v_lgr_grp.lgr_gruppe_max_lte := nvl(v_lgr_grp.lgr_gruppe_max_lte, 0) + v_max_lte;
        update lvs_lgr_grp grp
           set grp.lgr_gruppe_max_lte = v_lgr_grp.lgr_gruppe_max_lte
         where grp.lgr_ort = :new.lgr_ort
           and grp.lgr_gruppe_id = :new.lgr_gruppe_id;
      end if;
    else
      insert into lvs_lgr_grp
        values (
                :new.sid,                           -- SID                  VARCHAR2(2),
                :new.firma_nr,                      -- FIRMA_NR             NUMBER(2),
                :new.lgr_gruppe_id,                 -- LGR_GRUPPE_ID        NUMBER not null,
                                       ' Grp: '||
                       to_char(:new.lgr_gruppe_id), -- LGR_GRUPPE_NAME      VARCHAR2(30),
                :new.lgr_ort,                       -- LGR_ORT              NUMBER(5),
                v_max_lte,                          -- LGR_GRUPPE_MAX_LTE   NUMBER,
                NULL);                              -- LGR_GRUPPE_HAUPT_GRP NUMBER
    end if;
  end if;
end TR_LVS_LGR_Biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LGR_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"4fcf7fce300ace97b7aeb7ac1f8758f5af45b9f1","type":"TRIGGER","name":"TR_LVS_LGR_BIU","schemaName":"DIRKSPZM32","sxml":""}