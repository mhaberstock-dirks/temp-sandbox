
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LAM_BU" 
  before update on DIRKSPZM32.lvs_lam
  for each row
declare
  v_lgr         lvs_lgr%rowtype;
  v_lgr_next    lvs_lgr%rowtype;
  v_lte         lvs_lte%rowtype;

  v_found       boolean;

  CURSOR c_lgr is
    select t.*
      from lvs_lgr t
     where t.lgr_platz = :new.lgr_platz;

  CURSOR c_lgr_next is
    select t.*
      from lvs_lgr t
     where t.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
       and t.lgr_dim_fifo_nr > v_lgr.lgr_dim_fifo_nr
       and t.lgr_dim_g = v_lgr.lgr_dim_g
       and t.lgr_dim_r = v_lgr.lgr_dim_r
       and t.lgr_dim_p = v_lgr.lgr_dim_p
       and t.lgr_dim_e = v_lgr.lgr_dim_e
     order by t.lgr_dim_fifo_nr;

  CURSOR c_lte is
    select t.*
      from lvs_lte t
     where t.lte_id = :old.lte_id;
begin
  if :old.labor_status != :new.labor_status
  then
    OPEN c_lte;
    FETCH c_lte into v_lte;
    CLOSE c_lte;

    v_lte.res_string := replace(v_lte.res_string, ';' || :old.labor_status || ';',  ';' || :new.labor_status || ';');

    if :new.lte_id is NULL
    and :new.menge = 0
    then
      :new.order_pos_auf_id := NULL;
    end if;

    -- war Reserviert und jetzt nicht mehr
    if :old.order_pos_auf_id is not NULL
    and :new.order_pos_auf_id is NULL
    then
      -- Dann auch die RES_Menge etc löschen
      :new.res_menge := NULL;
      :new.res_ziel_lte_id := NULL;
      :new.res_login_id := NULL;
    end if;

    update lvs_lte t
       set t.res_string = v_lte.res_string
      where t.lte_id = :old.lte_id;

    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    OPEN c_lgr_next;
    FETCH c_lgr_next into v_lgr_next;
    v_found := c_lgr_next%FOUND;
    CLOSE c_lgr_next;

    if  v_lgr_next.lgr_max_te = v_lgr_next.lgr_einl_te_verfueg
    and v_found
    then
      lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);
    else
      update lvs_lgr t
         set t.res_string = v_lte.res_string
        where t.lgr_platz = v_lte.lgr_platz;
    end if;
  end if;
end tr_lvs_lam_bu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LAM_BU" ENABLE;


-- sqlcl_snapshot {"hash":"7d254093354294018202fd9ec41bf23f6f12b7fb","type":"TRIGGER","name":"TR_LVS_LAM_BU","schemaName":"DIRKSPZM32","sxml":""}