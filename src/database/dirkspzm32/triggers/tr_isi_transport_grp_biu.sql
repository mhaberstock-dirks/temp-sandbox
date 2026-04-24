create or replace editionable trigger dirkspzm32.tr_isi_transport_grp_biu before
    update or insert on dirkspzm32.isi_transport_grp
    for each row
declare
  -- local variables here
 begin
    if updating then
        :new.last_change_date := sysdate;
    end if;
end tr_isi_transport_grp_biu;
/

alter trigger dirkspzm32.tr_isi_transport_grp_biu enable;


-- sqlcl_snapshot {"hash":"157c565d760739031ef511a90ffa40b67490a5cd","type":"TRIGGER","name":"TR_ISI_TRANSPORT_GRP_BIU","schemaName":"DIRKSPZM32","sxml":""}