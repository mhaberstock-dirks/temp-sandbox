comment on table dirkspzm32.isi_order_reord_h is
    'Historientabelle für Nachverfolgung von automatischen Nachbestellungen';

comment on column dirkspzm32.isi_order_reord_h.auf_id is
    'new or existing auf_id from isi_order_pos (auto reorder updates/inserts here)';

comment on column dirkspzm32.isi_order_reord_h.created_date is
    'creation date for this data';

comment on column dirkspzm32.isi_order_reord_h.created_login_id is
    'login_id from isi_user of user creating this data';

comment on column dirkspzm32.isi_order_reord_h.lam_bh_id is
    'lam_bh_id from lvs_lam_bh history data to resolve the scanned id';

comment on column dirkspzm32.isi_order_reord_h.lam_id is
    'lam_id from lvs_lam containing all data about the material';

comment on column dirkspzm32.isi_order_reord_h.lhm_id is
    'lhm_id fom lvs_lhm containing informations about "lhm" (box, etc.) where the material was inside';

comment on column dirkspzm32.isi_order_reord_h.lte_id is
    'lte_id from lvs_lte containing informations about "lte" (pallet, etc.) where the material/lhm was transported with';

comment on column dirkspzm32.isi_order_reord_h.modified_date is
    'last modified date for this data';

comment on column dirkspzm32.isi_order_reord_h.modified_login_id is
    'login_id from isi_user of user which last modified this data';

comment on column dirkspzm32.isi_order_reord_h.order_action is
    'NA = no action, N = new order created, U = existing order updated';

comment on column dirkspzm32.isi_order_reord_h.reord_id is
    'Unique sequence number';

comment on column dirkspzm32.isi_order_reord_h.reord_menge is
    'amount of material which is reordered in this step';

comment on column dirkspzm32.isi_order_reord_h.scan_string is
    'scanner data ';

comment on column dirkspzm32.isi_order_reord_h.vorgang_id is
    'new or existing vorgang_id from isi_order_kopf';


-- sqlcl_snapshot {"hash":"49357c2dbaea18bd99ec59aeecbea75913d3da10","type":"COMMENT","name":"isi_order_reord_h","schemaName":"dirkspzm32","sxml":""}