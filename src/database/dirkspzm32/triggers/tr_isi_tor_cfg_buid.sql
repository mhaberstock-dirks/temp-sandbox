create or replace editionable trigger dirkspzm32.tr_isi_tor_cfg_buid before
    insert or update or delete on dirkspzm32.isi_tor_cfg
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.com_name is not null then
            update isi_com_server cs
            set
                cs.com_geraet_name = :new.tor_id_lesegeraet,
                cs.com_geraet_typ = 'TOR'
            where
                    cs.sid = :new.sid
                and cs.firma_nr = :new.firma_nr
                and cs.com_name = :new.com_name;

        end if;

    elsif updating then
        if :old.com_name is not null then
            update isi_com_server cs
            set
                cs.com_geraet_name = null,
                cs.com_geraet_typ = null
            where
                    cs.sid = :old.sid
                and cs.firma_nr = :old.firma_nr
                and cs.com_name = :old.com_name;

        end if;

        if :new.com_name is not null then
            update isi_com_server cs
            set
                cs.com_geraet_name = :new.tor_id_lesegeraet,
                cs.com_geraet_typ = 'TOR'
            where
                    cs.sid = :new.sid
                and cs.firma_nr = :new.firma_nr
                and cs.com_name = :new.com_name;

        end if;

    else
        if :old.com_name is not null then
            update isi_com_server cs
            set
                cs.com_geraet_name = null,
                cs.com_geraet_typ = null
            where
                    cs.sid = :old.sid
                and cs.firma_nr = :old.firma_nr
                and cs.com_name = :old.com_name;

        end if;
    end if;
end tr_isi_tor_cfg_buid;
/

alter trigger dirkspzm32.tr_isi_tor_cfg_buid enable;


-- sqlcl_snapshot {"hash":"78a73d7fffb8c599a23ee8775e84ab8c36c0c2e6","type":"TRIGGER","name":"TR_ISI_TOR_CFG_BUID","schemaName":"DIRKSPZM32","sxml":""}