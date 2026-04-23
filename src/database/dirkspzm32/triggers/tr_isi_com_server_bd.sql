create or replace editionable trigger dirkspzm32.tr_isi_com_server_bd before
    delete on dirkspzm32.isi_com_server
    for each row
declare
  -- local variables here
 begin
    if :old.com_geraet_name is not null then
        raise_application_error(-20000,
                                'Eintrag nicht zu löschen. Eintrag noch noch im '
                                || :old.com_geraet_typ
                                || ' '
                                || :old.com_geraet_name
                                || ' eingetragen',
                                true);

    end if;
end tr_isi_com_server_bd;
/

alter trigger dirkspzm32.tr_isi_com_server_bd enable;


-- sqlcl_snapshot {"hash":"14e403baf44e786768ae42c936ee7489cf292230","type":"TRIGGER","name":"TR_ISI_COM_SERVER_BD","schemaName":"DIRKSPZM32","sxml":""}