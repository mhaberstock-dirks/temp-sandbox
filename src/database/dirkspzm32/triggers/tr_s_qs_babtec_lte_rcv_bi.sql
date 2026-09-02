
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_QS_BABTEC_LTE_RCV_BI" 
  before insert on S_QS_BABTEC_LTE_RCV
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
ALTER TRIGGER "TR_S_QS_BABTEC_LTE_RCV_BI" ENABLE;


-- sqlcl_snapshot {"hash":"17f31cd1b4012ae3d0e547c6b87a9f7c7864603a","type":"TRIGGER","name":"TR_S_QS_BABTEC_LTE_RCV_BI","schemaName":"DIRKSPZM32","sxml":""}