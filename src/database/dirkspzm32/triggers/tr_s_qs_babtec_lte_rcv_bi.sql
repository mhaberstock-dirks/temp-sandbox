
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_QS_BABTEC_LTE_RCV_BI" 
  before insert on DIRKSPZM32.S_QS_BABTEC_LTE_RCV
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

  :new.erstell_datum := nvl(:new.erstell_datum, sysdate);
  :new.bearb_datum := sysdate;
  :new.status := 'ERR';
  LOOP
    FETCH c_lam into v_lam;
    EXIT when c_lam%notfound;

    lvs_p_lte_lhm.lvs_c_lam_status(v_lam.lam_id,
                                   0,
                                   v_vorg,
                                   :new.laborstatus,
                                   :new.labortext);

  end LOOP;

  CLOSE c_lam;
  :new.status := 'UE';

end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_QS_BABTEC_LTE_RCV_BI" ENABLE;


-- sqlcl_snapshot {"hash":"cd2909a08410cbac0f31e89d00418c52cf0d9fd2","type":"TRIGGER","name":"TR_S_QS_BABTEC_LTE_RCV_BI","schemaName":"DIRKSPZM32","sxml":""}