create or replace editionable trigger dirkspzm32.tr_bde_pd_nio_daten_biu before
    insert or update on dirkspzm32.bde_pd_nio_daten
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.nio_daten_id is null then
            select
                seq_bde_pd_nio_daten.nextval
            into :new.nio_daten_id
            from
                dual;

        end if;

    end if;
end tr_bde_pd_lam_nio_biu;
/

alter trigger dirkspzm32.tr_bde_pd_nio_daten_biu enable;


-- sqlcl_snapshot {"hash":"5588af42be9a348d32ed8b20423c738de16e2778","type":"TRIGGER","name":"TR_BDE_PD_NIO_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}