
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LGR_BD" 
  before delete on DIRKSPZM32.lvs_lgr
  for each row
declare
  -- local variables here
  v_lgr_grp                           lvs_lgr_grp%rowtype;
  v_found                             boolean;
  v_max_lte                           lvs_lgr.lgr_max_te%type;

  CURSOR c_lgr_grp is
    select t.*
      from lvs_lgr_grp t
     where t.lgr_gruppe_id = :old.lgr_gruppe_id
       and t.sid = :old.sid
       and t.firma_nr = :old.firma_nr
       and t.lgr_ort = :old.lgr_ort;
begin
  v_max_lte := 0;
  if :old.lgr_gruppe_id is not NULL
  then
    OPEN c_lgr_grp;
    FETCH c_lgr_grp into v_lgr_grp;
    v_found := c_lgr_grp%FOUND;
    CLOSE c_lgr_grp;
    if :old.lgr_typ != c.SEG1
    or :old.lte_namen_cfg like('%' || c.Euro || c.TE_TRENNER || '%')
    then
      v_max_lte := nvl(:old.lgr_max_te, 0);
    end if;
    if v_found
    then
      if nvl(v_max_lte, 0) != 0
      then
        v_lgr_grp.lgr_gruppe_max_lte := nvl(v_lgr_grp.lgr_gruppe_max_lte, 0) - v_max_lte;
        update lvs_lgr_grp grp
           set grp.lgr_gruppe_max_lte = v_lgr_grp.lgr_gruppe_max_lte
         where grp.lgr_gruppe_id = :old.lgr_gruppe_id;
      end if;
    end if;
  end if;
end TR_LVS_LGR_Bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LGR_BD" ENABLE;


-- sqlcl_snapshot {"hash":"92603efca03cdfcae8d028e5ec6088dffba1c4d7","type":"TRIGGER","name":"TR_LVS_LGR_BD","schemaName":"DIRKSPZM32","sxml":""}