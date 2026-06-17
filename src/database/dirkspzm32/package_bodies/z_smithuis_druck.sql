create or replace 
package body DIRKSPZM32.z_smithuis_druck is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;                 --
  v_err_nr    number;
  v_err_text  varchar2(255);

  -- Function and procedure implementations
function ccg_etikett(in_lte_id      in lvs_lte.lte_id%type,
                     in_waren_typ   in lvs_lte.waren_typ%type)
                                    return varchar2 is

  v_menge_basis               varchar2(3);
  v_menge                     number;

  v_ccg_nve                   varchar2(100);  --1
  v_ccg_arttext               varchar2(100);  --2
  v_ccg_ean_lhm_string        varchar2(100);  --3
  v_ccg_ean_lke_string        varchar2(100);  --4
  v_ccg_mhd_string            varchar2(100);  --5
  v_ccg_lhm_menge             number;         --6
  v_ccg_lke_menge             number;         --7
  v_ccg_arttext_kurz          varchar2(100);  --8
  v_ccg_lage_lagen            varchar2(100);  --9
  v_ccg_charge                varchar2(100);  --10
  v_ccg_gewicht_kg            varchar2(100);  --11
  v_ccg_artikel_nr            varchar2(100);  --14
  v_ccg_mhd_monat             varchar2(100);  --15
  v_ccg_menge_in_lhm          number;         --16
  v_ccg_lhm_pro_lage          number;         --17
  v_ccg_menge_pro_lage        number;         --18
  v_ccg_lagen                 number;         --19
  v_ccg_pid                   varchar2(100);  --20
  v_ccg_anz_becher            number;         --21
  v_ccg_anz_karton            number;         --22
  v_artikel_nr                varchar2(100);  --23
  v_ccg_lhm_l_lage            number;         --24
  v_ccg_kom_lagen             number;         --25

  v_ccg_barcodea_string       varchar2(100);  --BC1_TEXT
  v_ccg_barcodeb_string       varchar2(100);  --BC2_TEXT
  v_ccg_barcodec_string       varchar2(100);  --BC3_TEXT
  v_ccg_barcoded_string       varchar2(100);  --BC4_TEXT
  v_ccg_barcodee_string       varchar2(100);  --BC5_TEXT
  v_ccg_barcodef_string       varchar2(100);  --BC5_TEXT
  v_ccg_barcodea              varchar2(100);  --BC1
  v_ccg_barcodeb              varchar2(100);  --BC2
  v_ccg_barcodec              varchar2(100);  --BC2
  v_ccg_barcoded              varchar2(100);  --BC4
  v_ccg_barcodee              varchar2(100);  --BC5
  v_ccg_barcodef              varchar2(100);  --BC5

  v_print_daten     varchar2(2048);

  v_found           boolean;
  v_adresse         isi_adressen%rowtype;

  cursor c_firma is
    select a.*
     from isi_firma t,
          isi_adressen a
    where t.sid       = v_adresse.sid
      and t.firma_nr  = v_adresse.firma_nr
      and a.sid       = t.sid
      and a.adress_id = t.adress_id;


  cursor c_et_daten is
    select
       lte.sid,
       lte.firma_nr,
       lvs_p_lte_lhm.format_nve(nvl(lte.nve_nr, lte.lte_id)) as "TF_1" ,
       nvl(art.bezeichnung3, art.bezeichnung1) as "TF_2",
       '0' || lvs_p_lte_lhm.format_EAN(art.lhm_ean)      as "TF_3",
       lvs_p_lte_lhm.FORMAT_EAN(art.ean)      as "TF_4",
       to_char(lam.lam_mhd_ausgabe, 'DD.MM.YY') as "TF_5",
       to_char(lam.lam_mhd_ausgabe, 'MM.YYYY') as "TF_15",
       lam.menge        as "TF_6",
       lam.menge_basis,
       art.lhm_menge as "TF_16",
       art.lte_lhm_pro_lage as "TF_17",
       art.lte_lhm_pro_lage * art.lhm_menge as "TF_18",
       art.lte_lhm_lagen as "TF_19",
       art.lte_menge as "TF_21",
       art.lte_lhm_menge as "TF_22",
       nvl(art.Artikel_Kurz, art.artikel)    as "TF_8",
       art.artikel  as "TF_14",
       '(' || art.lte_lhm_pro_lage || 'x'||art.lte_LHM_lagen||')'  as "TF_9",
       cha.charge_bez  as "TF_10",
       round(lte.lte_akt_kg, 2)     as "TF_11",
       lte.lte_id                   as "TF_20",
       '(93)'|| lte.lte_id || '(37)'|| lpad(lam.menge, 6, '0') || '(15)' || to_char(lam.lam_mhd_ausgabe, 'YYMMDD') as "BC1_Text",
       '(02)' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '(10)' || cha.charge_bez as "BC2_Text",
       '(00)' || nvl(lte.nve_nr, lte.lte_id)  as "BC3_Text",
       '(37)'|| lpad(lam.menge, 6, '0') || '(15)' || to_char(lam.lam_mhd_ausgabe, 'YYMMDD') as "BC4_Text",
       '(02)' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '(37)' || lpad(lam.menge, 6, '0') as "BC5_Text",
       '(10)' || cha.charge_bez  || '(15)' || to_char(lam.lam_mhd_ausgabe, 'YYMMDD') as "BC6_Text",
       '93'|| lte.lte_id || CHR(29) || '37' || lpad(lam.menge, 6, '0') || CHR(29) || '15' || to_char(lam.lam_mhd_ausgabe, 'YYMMDD') as "BC1",
       '02' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '10' || cha.charge_bez as "BC2",
       '00' || nvl(lte.nve_nr, lte.lte_id)  as "BC3",
       '37' || lpad(lam.menge, 6, '0') || CHR(29) || '15' || to_char(lam.lam_mhd_ausgabe, 'YYMMDD') as "BC4",
       '02' || lpad(nvl(art.lhm_ean, '0'),14,'0') || '37' || lpad(lam.menge, 6, '0') as "BC5",
       '10' || cha.charge_bez  || CHR(29) || '15' || to_char(lam.lam_mhd_ausgabe, 'YYMMDD') as "BC6"
    from lvs_lte lte, LVS_LAM lam, isi_artikel art, lvs_charge cha

    where lte.lte_id = in_lte_id
      and lam.lte_id(+) = lte.lte_id
      and lam.artikel_id = art.artikel_id(+)
      and lam.sid = art.sid(+)
      and cha.sid(+) = lam.sid
      and nvl(cha.charge_id(+), -1) = nvl(lam.charge_id, -1);

begin

  OPEN c_et_daten;
  FETCH c_et_daten into v_adresse.sid,
                        v_adresse.firma_nr,
                        v_ccg_nve,
                        v_ccg_arttext,
                        v_ccg_ean_lhm_string,
                        v_ccg_ean_lke_string,
                        v_ccg_mhd_string,
                        v_ccg_mhd_monat,
                        v_menge,
                        v_menge_basis,
                        v_ccg_menge_in_lhm,
                        v_ccg_lhm_pro_lage,
                        v_ccg_menge_pro_lage,
                        v_ccg_lagen,
                        v_ccg_anz_becher,
                        v_ccg_anz_karton,
                        v_ccg_arttext_kurz,
                        v_artikel_nr,
                        v_ccg_lage_lagen,
                        v_ccg_charge,
                        v_ccg_gewicht_kg,
                        v_ccg_pid,
                        v_ccg_barcodea_string,
                        v_ccg_barcodeb_string,
                        v_ccg_barcodec_string,
                        v_ccg_barcoded_string,
                        v_ccg_barcodee_string,
                        v_ccg_barcodef_string,
                        v_ccg_barcodea,
                        v_ccg_barcodeb,
                        v_ccg_barcodec,
                        v_ccg_barcoded,
                        v_ccg_barcodee,
                        v_ccg_barcodef;

  v_found := c_et_daten%found;
  CLOSE c_et_daten;

  OPEN c_firma;
  FETCH c_firma into v_adresse;
  CLOSE c_firma;

  v_ccg_artikel_nr := v_artikel_nr;

  if not v_found
  then
    v_err_nr := 10;
    --v_err_text := 'Fehler beim lesen der Etikettendaten der Transporteinheit ' || in_lte_id;
    v_err_text := lc.ec_p1('O_TP1_LABEL_DATA_MISSING', in_lte_id);
    raise v_error;
  end if;

  if v_ccg_menge_in_lhm = 0
  then
    v_ccg_menge_in_lhm := 1;
  end if;
  if v_menge_basis = 'LHM'
  then
    v_ccg_lhm_menge := v_menge;
    v_ccg_lke_menge := v_menge * v_ccg_menge_in_lhm;
    v_ccg_anz_karton := v_ccg_lhm_menge;
  elsif v_menge_basis = 'LKE'
  then
    v_ccg_lhm_menge := round((v_menge / v_ccg_menge_in_lhm) + 0.5, 0);
    v_ccg_lke_menge := v_menge;
  else
    v_ccg_lhm_menge := round(v_ccg_menge_pro_lage * v_ccg_lagen / v_ccg_menge_in_lhm + 0.5, 0);
    v_ccg_lke_menge := v_ccg_menge_pro_lage * v_ccg_lagen;
    v_ccg_anz_karton := v_ccg_lhm_menge;
  end if;

  begin
    v_ccg_lhm_l_lage := mod(v_ccg_anz_karton, v_ccg_lhm_pro_lage);
  exception
    when others then
      v_ccg_lhm_l_lage := 0;
  end;

  begin
    v_ccg_kom_lagen := round(((v_ccg_anz_karton - v_ccg_lhm_pro_lage / 2) / v_ccg_lhm_pro_lage), 0);
  exception
    when others then
      v_ccg_kom_lagen := 0;
  end;

  if in_waren_typ != 'MP' then
    v_print_daten :=
                     'CCG_FIRMANAME='|| nvl(v_adresse.name_1, 'Name') || CHR(13) || CHR(10) ||
                     'CCG_FIRMASTRASSE='|| nvl(v_adresse.strasse, 'Str.') || CHR(13) || CHR(10) ||
                     'CCG_FIRMAPLZORT='|| nvl(v_adresse.plz, 'PLZ') || ' ' || nvl(v_adresse.ort, 'Ort') || CHR(13) || CHR(10) ||
                     'CCG_KADR1='|| 'INTERPORTO S. PALOMBA S.R.L.' || CHR(13) || CHR(10) ||
                     'CCG_KADR2='|| 'Interrporto Palomba' || CHR(13) || CHR(10) ||
                     'CCG_KADR3='|| 'VIA ADREANTINA, KM 22.000' || CHR(13) || CHR(10) ||
                     'CCG_KADR4='|| '00040 S. PALOMBA-POMEZIA RM' || CHR(13) || CHR(10) ||
                     'CCG_AUSLIEFERUNGSDATUM='|| '01.10.2003' || CHR(13) || CHR(10) ||
                     'CCG_NVE='|| v_ccg_nve || CHR(13) || CHR(10) ||
                     'CCG_ARTTEXT='|| v_ccg_arttext || CHR(13) || CHR(10) ||
                     'CCG_EAN_KARTON='|| v_ccg_ean_lhm_string || CHR(13) || CHR(10) ||
                     'CCG_EAN_BECHER='|| v_ccg_ean_lke_string || CHR(13) || CHR(10) ||
                     'CCG_MHD='|| v_ccg_mhd_string || CHR(13) || CHR(10) ||
                     'CCG_MHD_MONAT='|| v_ccg_mhd_monat || CHR(13) || CHR(10) ||
                     'CCG_MENGE_KARTON='|| lpad(v_ccg_lhm_menge, 5, ' ') || CHR(13) || CHR(10) ||
                     'CCG_MENGE_BECHER='|| lpad(v_ccg_lke_menge, 4, ' ') || CHR(13) || CHR(10) ||
                     'CCG_MENGE_IN_KARTON='|| lpad(v_ccg_menge_in_lhm, 7, ' ') || CHR(13) || CHR(10) ||
                     'CCG_ANZ_LAGEN='|| lpad(v_ccg_lagen, 7, ' ') || CHR(13) || CHR(10) ||
                     'CCG_ANZ_KARTON='|| lpad(v_ccg_anz_karton, 4, ' ') || CHR(13) || CHR(10) ||
                     'CCG_ANZ_BECHER='|| lpad(v_ccg_anz_becher, 4, ' ') || CHR(13) || CHR(10) ||
                     'CCG_KARTON_PRO_LAGE='|| lpad(v_ccg_lhm_pro_lage, 6, ' ') || CHR(13) || CHR(10) ||
                     'CCG_MENGE_PRO_LAGE='|| lpad(v_ccg_menge_pro_lage, 4, ' ') || CHR(13) || CHR(10) ||
                     'CCG_ARTIKEL='|| v_ccg_arttext_kurz || CHR(13) || CHR(10) ||
                     'CCG_KOM_ANZ_LAGEN='|| v_ccg_kom_lagen || CHR(13) || CHR(10) ||
                     'CCG_KOM_KARTON_L_LAGE='|| v_ccg_lhm_l_lage || CHR(13) || CHR(10) ||
                     'CCG_ARTIKEL_NR='|| v_ccg_artikel_nr || CHR(13) || CHR(10) ||
                     'CCG_LAGE_LAGEN='|| v_ccg_lage_lagen || CHR(13) || CHR(10) ||
                     'CCG_CHARGE='|| v_ccg_charge || CHR(13) || CHR(10) ||
                     'CCG_GEWICHT_KG='|| v_ccg_gewicht_kg || CHR(13) || CHR(10) ||
                     'CCG_PID='|| v_ccg_pid || CHR(13) || CHR(10) ||
                     'CCG_BARCODEA=' || v_ccg_barcodea || CHR(13) || CHR(10) ||
                     'CCG_BARCODEA_STRING=' || v_ccg_barcodea_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODEB=' || v_ccg_barcodeb || CHR(13) || CHR(10) ||
                     'CCG_BARCODEB_STRING=' || v_ccg_barcodeb_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODEC=' || v_ccg_barcodec || CHR(13) || CHR(10) ||
                     'CCG_BARCODEC_STRING=' || v_ccg_barcodec_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODED=' || v_ccg_barcoded || CHR(13) || CHR(10) ||
                     'CCG_BARCODED_STRING=' || v_ccg_barcoded_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODEE=' || v_ccg_barcodee || CHR(13) || CHR(10) ||
                     'CCG_BARCODEE_STRING=' || v_ccg_barcodee_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODEF=' || v_ccg_barcodef || CHR(13) || CHR(10) ||
                     'CCG_BARCODEF_STRING=' || v_ccg_barcodef_string;
  else
    v_print_daten :=
                     'CCG_FIRMANAME ='|| nvl(v_adresse.name_1, 'Name') || CHR(13) || CHR(10) ||
                     'CCG_FIRMASTRASSE ='|| nvl(v_adresse.strasse, 'Str.') || CHR(13) || CHR(10) ||
                     'CCG_FIRMAPLZORT ='|| nvl(v_adresse.plz, 'PLZ') || ' ' || nvl(v_adresse.ort, 'PLZ') || CHR(13) || CHR(10) ||
                     'CCG_KADR1 ='|| 'INTERPORTO S. PALOMBA S.R.L.' || CHR(13) || CHR(10) ||
                     'CCG_KADR2 ='|| 'Interrporto Palomba' || CHR(13) || CHR(10) ||
                     'CCG_KADR3 ='|| 'VIA ADREANTINA, KM 22.000' || CHR(13) || CHR(10) ||
                     'CCG_KADR4 ='|| '00040 S. PALOMBA-POMEZIA RM' || CHR(13) || CHR(10) ||
                     'CCG_NVE='|| v_ccg_nve || CHR(13) || CHR(10) ||
                     'CCG_ARTTEXT='|| 'Mischpalette' || CHR(13) || CHR(10) ||
                     'CCG_EAN_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_EAN_BECHER='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_MHD_MONAT='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_MHD='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_MENGE_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_MENGE_BECHER='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_MENGE_IN_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_ANZ_LAGEN='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_ANZ_KARTON='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_ANZ_BECHER='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_MENGE_PRO_LAGE='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_KARTON_PRO_LAGE='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_ARTIKEL='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_ARTIKEL_NR='|| '' || CHR(13) || CHR(10) ||
                     'CCG_LAGE_LAGEN='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_KOM_ANZ_LAGEN='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_KOM_KARTON_L_LAGE='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_CHARGE='|| ' ' || CHR(13) || CHR(10) ||
                     'CCG_GEWICHT_KG='|| v_ccg_gewicht_kg || CHR(13) || CHR(10) ||
                     'CCG_PID='|| v_ccg_pid || CHR(13) || CHR(10) ||
                     --'CCG_BARCODEA_STRING=' || v_ccg_barcodea_string || CHR(13) || CHR(10) ||
                     --'CCG_BARCODEA=' || v_ccg_barcodea || CHR(13) || CHR(10) ||
                     'CCG_BARCODEA=' || ' ' || CHR(13) || CHR(10) ||
                     'CCG_BARCODEA_STRING=' || ' ' || CHR(13) || CHR(10) ||
                     'CCG_BARCODEB=' || v_ccg_barcodeb || CHR(13) || CHR(10) ||
                     'CCG_BARCODEB_STRING=' || v_ccg_barcodeb_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODEC=' || v_ccg_barcodec || CHR(13) || CHR(10) ||
                     'CCG_BARCODEC_STRING=' || v_ccg_barcodec_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODED=' || v_ccg_barcoded || CHR(13) || CHR(10) ||
                     'CCG_BARCODED_STRING=' || v_ccg_barcoded_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODEE=' || v_ccg_barcodee || CHR(13) || CHR(10) ||
                     'CCG_BARCODEE_STRING=' || v_ccg_barcodee_string || CHR(13) || CHR(10) ||
                     'CCG_BARCODEF=' || v_ccg_barcodef || CHR(13) || CHR(10) ||
                     'CCG_BARCODEF_STRING=' || v_ccg_barcodef_string;
  end if;
  return (v_print_daten);
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
  when v_error then
    RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text);
    raise;
  when others then
    if v_err_nr is not NULL then
       RAISE_APPLICATION_ERROR(-20000-v_err_nr,v_err_text, true);
    else
       raise;
    end if;
end ccg_etikett;

--------------------------------------------------------------------------------
-- function format_nve
--
-- 340274530000050083 -> 3 40 27453 000005008 3
--------------------------------------------------------------------------------
function FORMAT_ARTIKEL(in_str in varchar2) return varchar2 is

  str_code varchar2(18) := NULL;
  str_out  varchar2(23) := NULL;
begin
  str_code := substr(in_str, 1, 18);

  str_out := substr(str_code, 1, length(str_code) - 6);
  str_out := str_out || ' ' || substr(str_code, length(str_code) - 5, 4);
  str_out := str_out || ' ' || substr(str_code, length(str_code) - 1, 2);
  return(str_out);
end;

end;
/



-- sqlcl_snapshot {"hash":"f6dd745998157ed77e0d355ddebc0cd08c6de114","type":"PACKAGE_BODY","name":"Z_SMITHUIS_DRUCK","schemaName":"DIRKSPZM32","sxml":""}