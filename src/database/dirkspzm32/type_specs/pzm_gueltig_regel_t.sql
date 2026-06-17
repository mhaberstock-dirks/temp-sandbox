create or replace 
type DIRKSPZM32.pzm_gueltig_regel_t as object (
    schluessel varchar2(255),  -- generischer Schlüssel (z.B. tarif_name, sa_kurzname, kst_id als String)
    gueltig    number(1)       -- 1 = erlaubt (Allowlist), 0 = gesperrt (Blocklist)
);
/


-- sqlcl_snapshot {"hash":"345876124922d17f74c42cbd764ce56f6e1f45b8","type":"TYPE_SPEC","name":"PZM_GUELTIG_REGEL_T","schemaName":"DIRKSPZM32","sxml":""}