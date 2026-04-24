create or replace editionable trigger dirkspzm32.tr_aps_plan_ergebnis_bui before
    insert or update on dirkspzm32.aps_plan_ergebnis
    for each row
declare
  -- local variables here
 begin
    if
        updating
        and :new.transfer_status = 'F' -- Ein Fehler beim Übertragen
        and :old.transfer_status != 'F'
    then
        update aps_order_materialrelation pm
        set
            pm.materialrelation_valide = 'F',
            pm.materialrelation_info = substr(to_char(:new.fehler_code)
                                              || ' '
                                              || :new.fehler_text
                                              || cr_lf()
                                              || pm.materialrelation_info,
                                              1,
                                              1000)
        where
                pm.aps_plan_status = :new.aps_plan_status
            and pm.child_id = :new.aps_plan_auftrag_nr;

    end if;
end tr_z_dir_aps_plan_matr_bui;
/

alter trigger dirkspzm32.tr_aps_plan_ergebnis_bui enable;


-- sqlcl_snapshot {"hash":"3d7fb0adbe95273cb08f5b1195bd28dafe6b514f","type":"TRIGGER","name":"TR_APS_PLAN_ERGEBNIS_BUI","schemaName":"DIRKSPZM32","sxml":""}