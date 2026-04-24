create or replace editionable trigger dirkspzm32.tr_isi_arbeitsplatz_bi before
    insert on dirkspzm32.isi_arbeitsplatz
    for each row
declare begin
    if :new.arbeitsplatz_id is null then
        select
            seq_isi_arbeitsplaz_id.nextval
        into :new.arbeitsplatz_id
        from
            dual;

    end if;

  -- BW Erst mal alle einzustellenden Parameter in Tabelle isi_arbeits_platz_cfg kopieren
    insert into isi_arbeitsplatz_cfg
        select
            null,
            :new.arbeitsplatz_id,
            modul_name,
            modul_funktion,
            modul_parameter,
            ''
        from
            isi_arbeitsplatz_param;

end tr_isi_arbeitsplatz_bi;
/

alter trigger dirkspzm32.tr_isi_arbeitsplatz_bi enable;


-- sqlcl_snapshot {"hash":"59390e79bf14767d2889b696b3d0df8cddf5daa8","type":"TRIGGER","name":"TR_ISI_ARBEITSPLATZ_BI","schemaName":"DIRKSPZM32","sxml":""}