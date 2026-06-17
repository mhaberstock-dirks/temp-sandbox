
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_MFR_AUFTR_BI" 
  before insert or update on DIRKSPZM32.s_mfr_rcv_auftr
  for each row
declare

begin

  if inserting then
    if :new.auf_id is NULL
    then
      select SEQ_S_AUFTR.NEXTVAL into :new.auf_id from dual;
    end if;
  end if;

end TR_S_DIAF_RCV_AUFTR_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_MFR_AUFTR_BI" ENABLE;


-- sqlcl_snapshot {"hash":"2aada75c14cb504a9030d21e464bd7fcbf94ccbd","type":"TRIGGER","name":"TR_S_MFR_AUFTR_BI","schemaName":"DIRKSPZM32","sxml":""}