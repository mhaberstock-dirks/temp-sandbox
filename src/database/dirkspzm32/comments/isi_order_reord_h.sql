comment on table ISI_ORDER_REORD_H is 'Historientabelle für Nachverfolgung von automatischen Nachbestellungen';
comment on column ISI_ORDER_REORD_H."AUF_ID" is 'new or existing auf_id from isi_order_pos (auto reorder updates/inserts here)';
comment on column ISI_ORDER_REORD_H."CREATED_DATE" is 'creation date for this data';
comment on column ISI_ORDER_REORD_H."CREATED_LOGIN_ID" is 'login_id from isi_user of user creating this data';
comment on column ISI_ORDER_REORD_H."LAM_BH_ID" is 'lam_bh_id from lvs_lam_bh history data to resolve the scanned id';
comment on column ISI_ORDER_REORD_H."LAM_ID" is 'lam_id from lvs_lam containing all data about the material';
comment on column ISI_ORDER_REORD_H."LHM_ID" is 'lhm_id fom lvs_lhm containing informations about "lhm" (box, etc.) where the material was inside';
comment on column ISI_ORDER_REORD_H."LTE_ID" is 'lte_id from lvs_lte containing informations about "lte" (pallet, etc.) where the material/lhm was transported with';
comment on column ISI_ORDER_REORD_H."MODIFIED_DATE" is 'last modified date for this data';
comment on column ISI_ORDER_REORD_H."MODIFIED_LOGIN_ID" is 'login_id from isi_user of user which last modified this data';
comment on column ISI_ORDER_REORD_H."ORDER_ACTION" is 'NA = no action, N = new order created, U = existing order updated';
comment on column ISI_ORDER_REORD_H."REORD_ID" is 'Unique sequence number';
comment on column ISI_ORDER_REORD_H."REORD_MENGE" is 'amount of material which is reordered in this step';
comment on column ISI_ORDER_REORD_H."SCAN_STRING" is 'scanner data ';
comment on column ISI_ORDER_REORD_H."VORGANG_ID" is 'new or existing vorgang_id from isi_order_kopf';



-- sqlcl_snapshot {"hash":"f66c5f92a0586a72794f342c2c2cbe44c27e1488","type":"COMMENT","name":"isi_order_reord_h","schemaName":"dirkspzm32","sxml":""}