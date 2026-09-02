create or replace 
TYPE "PZM_GUELTIG_REGEL_T" as object (
    schluessel varchar2(255),  -- generischer Schlüssel (z.B. tarif_name, sa_kurzname, kst_id als String)
    gueltig    number(1)       -- 1 = erlaubt (Allowlist), 0 = gesperrt (Blocklist)
);
/


-- sqlcl_snapshot {"hash":"7f41ef8739dcdc7178dd8b53de4187cfb28a2f70","type":"TYPE_SPEC","name":"PZM_GUELTIG_REGEL_T","schemaName":"DIRKSPZM32","sxml":""}