
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_QS_BABTEC_ART_RCV_BIU" 
  before insert or update on DIRKSPZM32.S_QS_BABTEC_ART_RCV
  for each row
declare

begin
  update s_rcv_artikel art
     set                                                       -- ARTIKEL              VARCHAR2(20) not null,
         art.artikel_p1   = :new.artikel_p1                    -- Prüftext aus QS
   where art.artikel = :new.artikel;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_QS_BABTEC_ART_RCV_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"96151b194167ce159f5ddcfa6f4956a8a515522c","type":"TRIGGER","name":"TR_S_QS_BABTEC_ART_RCV_BIU","schemaName":"DIRKSPZM32","sxml":""}