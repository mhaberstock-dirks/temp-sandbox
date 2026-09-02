
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_COM_SERVER_BD" 
  before delete on isi_com_server
  for each row
declare
  -- local variables here
begin
  if :old.com_geraet_name is not null then
   RAISE_APPLICATION_ERROR(-20000,'Eintrag nicht zu löschen. Eintrag noch noch im ' || :old.com_geraet_typ || ' ' || :old.com_geraet_name || ' eingetragen', true);
  end if;

end TR_ISI_COM_SERVER_BD;


/
ALTER TRIGGER "TR_ISI_COM_SERVER_BD" ENABLE;


-- sqlcl_snapshot {"hash":"a92023ec17a2aa986f806a97fdff089234a44eee","type":"TRIGGER","name":"TR_ISI_COM_SERVER_BD","schemaName":"DIRKSPZM32","sxml":""}