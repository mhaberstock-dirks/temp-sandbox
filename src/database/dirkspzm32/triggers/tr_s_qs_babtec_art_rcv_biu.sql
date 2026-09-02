
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_QS_BABTEC_ART_RCV_BIU" 
  before insert or update on S_QS_BABTEC_ART_RCV
  for each row
declare

begin
  update s_rcv_artikel art
     set                                                       -- ARTIKEL              VARCHAR2(20) not null,
         art.artikel_p1   = :new.artikel_p1                    -- Prüftext aus QS
   where art.artikel = :new.artikel;
end;


/
ALTER TRIGGER "TR_S_QS_BABTEC_ART_RCV_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"bd00081bae292d9b4852393ee37b4ed8a3a0cbb9","type":"TRIGGER","name":"TR_S_QS_BABTEC_ART_RCV_BIU","schemaName":"DIRKSPZM32","sxml":""}