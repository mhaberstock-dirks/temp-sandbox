
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_COM_SERVER_BD" 
  before delete on DIRKSPZM32.isi_com_server
  for each row
declare
  -- local variables here
begin
  if :old.com_geraet_name is not null then
   RAISE_APPLICATION_ERROR(-20000,'Eintrag nicht zu löschen. Eintrag noch noch im ' || :old.com_geraet_typ || ' ' || :old.com_geraet_name || ' eingetragen', true);
  end if;

end TR_ISI_COM_SERVER_BD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_COM_SERVER_BD" ENABLE;


-- sqlcl_snapshot {"hash":"15b69ff91ad28a1b2b070fb908dd44eadc3bc255","type":"TRIGGER","name":"TR_ISI_COM_SERVER_BD","schemaName":"DIRKSPZM32","sxml":""}