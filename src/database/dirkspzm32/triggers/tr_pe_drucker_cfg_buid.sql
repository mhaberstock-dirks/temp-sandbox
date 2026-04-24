create or replace editionable trigger dirkspzm32.tr_pe_drucker_cfg_buid before
    insert or update or delete on dirkspzm32.pe_drucker_cfg
    for each row
declare
    v_res         isi_resource%rowtype;
    v_res_zus_akt isi_resource_zust_akt%rowtype;
  -- local variables here
begin
    if inserting then
        if :new.com_name is not null then
            update isi_com_server
            set
                com_geraet_typ = 'DRUCKER',
                com_geraet_name = :new.drucker_name
            where
                com_name = :new.com_name;

        end if;

    elsif updating then
    --if NVL(:old.com_name, '') <> NVL(:new.com_name, '') then
        if :old.com_name is not null then
            update isi_com_server
            set
                com_geraet_typ = '',
                com_geraet_name = null
            where
                com_name = :old.com_name;

        end if;

        if :new.com_name is not null then
            update isi_com_server
            set
                com_geraet_typ = 'DRUCKER',
                com_geraet_name = :new.drucker_name
            where
                com_name = :new.com_name;

        end if;

        if isi_p_base.get_resource_by_ext_name(:new.drucker_name,
                                               v_res) then
            if isi_p_base.get_res_zust_akt(:new.sid,
                                           v_res.res_id,
                                           v_res_zus_akt) then
                if
                    v_res_zus_akt.status_id = 0 -- Kein Offline
                    and :new.status = 'OFF'
                then
                    res_status.res_status_beg(v_res.sid,
                                              v_res.firma_nr,
                                              v_res.res_id,
                                              0,
                                              -2,
                                              v_res.typ,
                                              null,
                                              nvl(v_res.fehler_schluessel, 0));
                end if;

                if
                    v_res_zus_akt.status_id <> 0 -- Kein Offline
                    and :new.status <> 'OFF'
                then
                    res_status.res_status_beg(v_res.sid,
                                              v_res.firma_nr,
                                              v_res.res_id,
                                              0,
                                              0,
                                              v_res.typ,
                                              null,
                                              nvl(v_res.fehler_schluessel, 0));

                end if;

            end if;
        end if;

    --end if;
    elsif deleting then
        if :old.com_name is not null then
            update isi_com_server
            set
                com_geraet_typ = '',
                com_geraet_name = null
            where
                com_name = :old.com_name;

        end if;
    end if;
end tr_pe_drucker_cfg_buid;
/

alter trigger dirkspzm32.tr_pe_drucker_cfg_buid enable;


-- sqlcl_snapshot {"hash":"b10e0ef0aa489c6a26abda4ed044b247d6e3f970","type":"TRIGGER","name":"TR_PE_DRUCKER_CFG_BUID","schemaName":"DIRKSPZM32","sxml":""}