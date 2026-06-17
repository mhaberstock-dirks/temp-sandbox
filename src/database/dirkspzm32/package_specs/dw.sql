create or replace 
package DIRKSPZM32.DW is

  -- Author  : KGRIESSHAMMER
  -- Created : 29.01.2007 14:15:53
  -- Purpose : Data-Warehouse

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  p_ausw_begin           date;
  p_ausw_ende            date;
  p_zins_proz            number;

  function set_aus_begin(in_ausw_begin in date) return date;
  function set_aus_ende(in_ausw_ende in date) return date;
  function set_zins_proz(in_zins_proz in number) return number;
  function get_ausw_begin return date;
  function get_ausw_ende return date;
  function get_zins_proz return number;

  procedure Take_LVS_Snapshot_LTE_Typ(in_sid        in dw_lvs_bestand.sid%type,
                                      in_firma_nr   in dw_lvs_bestand.firma_nr%type,
                                      in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
                                      in_wert_datum in dw_lvs_bestand.wert_datum%type default null);

  procedure C_Take_LVS_Snapshot_LTE_Typ(in_sid        in dw_lvs_bestand.sid%type,
                                        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
                                        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
                                        in_wert_datum in dw_lvs_bestand.wert_datum%type default null);

  procedure C_Take_LVS_Snapshot_LAM_Menge(in_sid        in dw_lvs_bestand.sid%type,
                                          in_firma_nr   in dw_lvs_bestand.firma_nr%type,
                                          in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
                                          in_wert_datum in dw_lvs_bestand.wert_datum%type default null);

  procedure C_Set_LVS_LAM_BH_AbgangTag(in_sid            in dw_lvs_bestand.sid%type,
                                       in_firma_nr       in dw_lvs_bestand.firma_nr%type,
                                       in_lgr_ort        in dw_lvs_bestand.lgr_ort%type,
                                       in_wert_datum     in dw_lvs_bestand.wert_datum%type);

  procedure C_Set_LVS_LAM_BH_AbgTag_v_b(in_sid            in dw_lvs_bestand.sid%type,
                                        in_firma_nr       in dw_lvs_bestand.firma_nr%type,
                                        in_lgr_ort        in dw_lvs_bestand.lgr_ort%type,
                                        in_wert_datum_von in dw_lvs_bestand.wert_datum%type,
                                        in_wert_datum_bis in dw_lvs_bestand.wert_datum%type);

end DW;
/



-- sqlcl_snapshot {"hash":"dde811d1f9b0a5424d5881bc7cb1ce8b2e83c8ab","type":"PACKAGE_SPEC","name":"DW","schemaName":"DIRKSPZM32","sxml":""}