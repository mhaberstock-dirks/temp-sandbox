
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_QS_STATUS_BIU" 
  before insert or update
  on S_QS_STATUS
  for each row
declare
  v_lam         lvs_lam%rowtype;
  v_vorg        number;
  cursor c_lam is
    select *
      from lvs_lam t
     where t.lte_id = :new.lte_id;
begin
  OPEN c_lam;

  if inserting
  then
    :new.created_date := nvl(:new.created_date, sysdate);
    :new.last_change_date := sysdate;
    :new.created_login_id := nvl(:new.created_login_id, -1);
    :new.last_change_login_id := nvl(:new.last_change_login_id, :new.created_login_id);
  end if;

  if :new.status = 'N'
  then
    :new.status := 'ERR';
    LOOP
      FETCH c_lam into v_lam;
      EXIT when c_lam%notfound;

      lvs_p_lte_lhm.lvs_c_lam_status(v_lam.lam_id,
                                     :new.created_login_id,
                                     v_vorg,
                                     :new.laborstatus,
                                     :new.labortext);

    end LOOP;

    CLOSE c_lam;
    :new.status := 'UE';
  end if;

end TR_S_QS_STATUS_BI;


/
ALTER TRIGGER "TR_S_QS_STATUS_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"7cc53b804e43c8555a63e95ce714346d8cce5b7e","type":"TRIGGER","name":"TR_S_QS_STATUS_BIU","schemaName":"DIRKSPZM32","sxml":""}