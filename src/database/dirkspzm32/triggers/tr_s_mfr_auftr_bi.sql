
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_MFR_AUFTR_BI" 
  before insert or update on s_mfr_rcv_auftr
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
ALTER TRIGGER "TR_S_MFR_AUFTR_BI" ENABLE;


-- sqlcl_snapshot {"hash":"b6639e354e2017bdcf75fbdca2f7e3d857e65b28","type":"TRIGGER","name":"TR_S_MFR_AUFTR_BI","schemaName":"DIRKSPZM32","sxml":""}