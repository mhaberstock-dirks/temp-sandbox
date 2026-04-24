create or replace package dirkspzm32.bde_p_pers_zeit_kst is

  -- Author  : HJGOEDEKE
  -- Created : 04.04.2011 13:55:40
  -- Purpose : Funktionen für die Zeitverteilung Presonal auf Resource

  -- Public function and procedure declarations
    procedure bde_c_pd_pers_zeit_berech (
        in_sid            in bde_pd_pers_zeit_kst.sid%type,
        in_firma_nr       in bde_pd_pers_zeit_kst.firma_nr%type,
        in_pd_pres_beginn in bde_pd_pers_zeit_kst.pd_pers_beginn%type,
        in_pd_pres_ende   in bde_pd_pers_zeit_kst.pd_pers_ende%type
    );

end bde_p_pers_zeit_kst;
/


-- sqlcl_snapshot {"hash":"efbcecaa7240bc40c9e969ab34e359892e9c7a38","type":"PACKAGE_SPEC","name":"BDE_P_PERS_ZEIT_KST","schemaName":"DIRKSPZM32","sxml":""}