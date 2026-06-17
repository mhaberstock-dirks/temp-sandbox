
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PE_DRUCKER_CFG_BUID" 
  before insert or update or delete on DIRKSPZM32.pe_drucker_cfg
  for each row
declare
  v_res                   isi_resource%rowtype;
  v_res_zus_akt           isi_resource_zust_akt%rowtype;
  -- local variables here
begin
  if INSERTING then
    if :new.com_name is not NULL then
      UPDATE isi_com_server
         SET com_geraet_typ = 'DRUCKER',
             com_geraet_name = :new.drucker_name
       WHERE com_name = :new.com_name;
    end if;
  elsif UPDATING then
    --if NVL(:old.com_name, '') <> NVL(:new.com_name, '') then
      if :old.com_name is not NULL then
        UPDATE isi_com_server
           SET com_geraet_typ = '',
               com_geraet_name = NULL
         WHERE com_name = :old.com_name;
      end if;
      if :new.com_name is not NULL then
        UPDATE isi_com_server
           SET com_geraet_typ = 'DRUCKER',
               com_geraet_name = :new.drucker_name
         WHERE com_name = :new.com_name;
      end if;

      if isi_p_base.get_resource_by_ext_name(:new.DRUCKER_name, v_res)
      then
        if isi_p_base.get_res_zust_akt(:new.sid, v_res.res_id, v_res_zus_akt)
        then
          if v_res_zus_akt.status_id = 0 -- Kein Offline
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
          if v_res_zus_akt.status_id <> 0 -- Kein Offline
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
  elsif DELETING then
    if :old.com_name is not NULL then
      UPDATE isi_com_server
         SET com_geraet_typ = '',
             com_geraet_name = NULL
       WHERE com_name = :old.com_name;
    end if;
  end if;
end tr_pe_drucker_cfg_buid;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PE_DRUCKER_CFG_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"4f478e73bab2549c8434391015ca477105b1ebb0","type":"TRIGGER","name":"TR_PE_DRUCKER_CFG_BUID","schemaName":"DIRKSPZM32","sxml":""}