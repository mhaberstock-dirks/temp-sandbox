create or replace package dirkspzm32.res_schicht is

  /*
  __________________________________________________
  Author
  B.Welling  (-BWe-)  31.03.2020
  __________________________________________________
  Description
  Ausprï¿½gen von Schichten fï¿½r Resourcen aus Schichtmodellen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  31.03.2020   R.31       (-BWe-)   Minor Release
  */

    procedure c_erzeuge_isi_res_schicht (
        in_start_date            in date,
        in_end_date              in date,
        in_isi_res_id            in isi_resource.res_id%type,
        in_schicht_modell_id     in isi_res_schicht_modell.schicht_modell_id%type,
        in_takt_zeit             in isi_res_schicht_modell.takt_zeit_sek%type,
        in_stk_pro_schicht       in isi_res_schicht_modell.stk_pro_schicht%type,
        in_takte_pro_schicht     in isi_res_schicht_modell.takte_pro_schicht%type,
        in_takt_modell_id        in isi_res_schicht_modell.prod_takt_id%type,
        in_schicht_ende_variabel in isi_res_schicht_modell.schicht_ende_variabel%type
    );

    procedure c_loesche_isi_res_schicht (
        in_schicht_id in isi_res_schicht.schicht_id%type
    );

    procedure c_setze_schicht_status (
        in_schicht_id in isi_res_schicht.schicht_id%type,
        in_status     in isi_res_schicht.status%type
    );

    function check_schicht_vorhanden (
        in_start_date in date,
        in_end_date   in date,
        in_isi_res_id in isi_resource.res_id%type
    ) return boolean;

    function differenz_nur_zeit_in_sekunden (
        in_start_zeit date,
        in_ende_zeit  date
    ) return integer;

    procedure schicht_modell_zeiten (
        in_schicht_modell_id        in isi_res_schicht_modell.schicht_modell_id%type,
        out_schichtzeit_sekunden    out integer,
        out_schicht_pausen_sekunden out integer
    );

end res_schicht;
/


-- sqlcl_snapshot {"hash":"c418d98fc17b9c98568ce542b8f14e65a6d55a60","type":"PACKAGE_SPEC","name":"RES_SCHICHT","schemaName":"DIRKSPZM32","sxml":""}