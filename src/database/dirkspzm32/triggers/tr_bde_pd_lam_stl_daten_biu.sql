create or replace editionable trigger dirkspzm32.tr_bde_pd_lam_stl_daten_biu before
    insert or update on dirkspzm32.bde_pd_lam_stl_daten
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.pd_lam_stl_daten_id is null then
            select
                seq_lam_stl_daten_id.nextval
            into :new.pd_lam_stl_daten_id
            from
                dual;

        end if;

    end if;
end tr_bde_pd_lam_stl_daten_biu;
/

alter trigger dirkspzm32.tr_bde_pd_lam_stl_daten_biu enable;


-- sqlcl_snapshot {"hash":"e162bc1ffef6dd5c2bc210d146fb62907aaaedc1","type":"TRIGGER","name":"TR_BDE_PD_LAM_STL_DATEN_BIU","schemaName":"DIRKSPZM32","sxml":""}