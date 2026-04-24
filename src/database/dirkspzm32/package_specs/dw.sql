create or replace package dirkspzm32.dw is

  -- Author  : KGRIESSHAMMER
  -- Created : 29.01.2007 14:15:53
  -- Purpose : Data-Warehouse

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
    p_ausw_begin date;
    p_ausw_ende date;
    p_zins_proz number;
    function set_aus_begin (
        in_ausw_begin in date
    ) return date;

    function set_aus_ende (
        in_ausw_ende in date
    ) return date;

    function set_zins_proz (
        in_zins_proz in number
    ) return number;

    function get_ausw_begin return date;

    function get_ausw_ende return date;

    function get_zins_proz return number;

    procedure take_lvs_snapshot_lte_typ (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type default null
    );

    procedure c_take_lvs_snapshot_lte_typ (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type default null
    );

    procedure c_take_lvs_snapshot_lam_menge (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type default null
    );

    procedure c_set_lvs_lam_bh_abgangtag (
        in_sid        in dw_lvs_bestand.sid%type,
        in_firma_nr   in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort    in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum in dw_lvs_bestand.wert_datum%type
    );

    procedure c_set_lvs_lam_bh_abgtag_v_b (
        in_sid            in dw_lvs_bestand.sid%type,
        in_firma_nr       in dw_lvs_bestand.firma_nr%type,
        in_lgr_ort        in dw_lvs_bestand.lgr_ort%type,
        in_wert_datum_von in dw_lvs_bestand.wert_datum%type,
        in_wert_datum_bis in dw_lvs_bestand.wert_datum%type
    );

end dw;
/


-- sqlcl_snapshot {"hash":"f2e50928ab2b7a637fee35a969146205e685ed9c","type":"PACKAGE_SPEC","name":"DW","schemaName":"DIRKSPZM32","sxml":""}