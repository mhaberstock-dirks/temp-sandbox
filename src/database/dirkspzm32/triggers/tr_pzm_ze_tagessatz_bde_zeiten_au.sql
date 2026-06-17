
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_TAGESSATZ_BDE_ZEITEN_AU" 
  after update
  on DIRKSPZM32.PZM_ZE_TAGESSATZ
  for each row
DECLARE v_result NUMBER;
begin
  if :new.ts_datum < trunc(sysdate)
  and :new.ts_day_wert_ende is not NULL
  then
    begin
      v_result := pzm_bde_utils.pzm_pers_nr_zeit_fa_buchen(in_pers_nr => :new.ts_pers_nr,
                                                 in_sa_kurz_name => :new.ts_sa_kurzname,
                                                 in_datum_beg => :new.ts_day_wert_start,
                                                 in_datum_ende => :new.ts_day_wert_ende - (:new.ts_day_abw_std / 24),
                                                 in_zeit_std => :new.ts_day_arb_std +
                                                                :new.ts_day_ueb_std +
                                                                :new.ts_day_flex_std,
                                                 in_datum => :new.ts_datum);
    exception when others then NULL;
    end;    
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_TAGESSATZ_BDE_ZEITEN_AU" ENABLE;


-- sqlcl_snapshot {"hash":"5fd34d6527ab47489402bc499ae0f438cfe60a7b","type":"TRIGGER","name":"TR_PZM_ZE_TAGESSATZ_BDE_ZEITEN_AU","schemaName":"DIRKSPZM32","sxml":""}