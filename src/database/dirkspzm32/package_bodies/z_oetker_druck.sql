create or replace package body dirkspzm32.z_oetker_druck is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder fur Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);

  -- Function and procedure implementations
    function ccg_etikett (
        in_lte_id    in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2 is

        v_menge_basis         varchar2(3);
        v_menge               number;
        v_ccg_nve             varchar2(100);  --1
        v_ccg_arttext         varchar2(100);  --2
        v_ccg_ean_lhm_string  varchar2(100);  --3
        v_ccg_ean_lke_string  varchar2(100);  --4
        v_ccg_mhd_string      varchar2(100);  --5
        v_ccg_lhm_menge       number;         --6
        v_ccg_lke_menge       number;         --7
        v_ccg_arttext_kurz    varchar2(100);  --8
        v_ccg_lage_lagen      varchar2(100);  --9
        v_ccg_charge          varchar2(100);  --10
        v_ccg_gewicht_kg      varchar2(100);  --11
        v_ccg_artikel_nr      varchar2(100);  --14
        v_ccg_mhd_monat       varchar2(100);  --15
        v_ccg_menge_in_lhm    number;         --16
        v_ccg_lhm_pro_lage    number;         --17
        v_ccg_menge_pro_lage  number;         --18
        v_ccg_lagen           number;         --19
        v_ccg_pid             varchar2(100);  --20
        v_ccg_anz_becher      number;         --21
        v_ccg_anz_karton      number;         --22
        v_artikel_nr          varchar2(100);  --23
        v_ccg_lhm_l_lage      number;         --24
        v_ccg_kom_lagen       number;         --25

        v_ccg_barcodea_string varchar2(100);  --BC1_TEXT
        v_ccg_barcodeb_string varchar2(100);  --BC2_TEXT
        v_ccg_barcodec_string varchar2(100);  --BC3_TEXT
        v_ccg_barcoded_string varchar2(100);  --BC4_TEXT
        v_ccg_barcodee_string varchar2(100);  --BC5_TEXT
        v_ccg_barcodef_string varchar2(100);  --BC5_TEXT
        v_ccg_barcodea        varchar2(100);  --BC1
        v_ccg_barcodeb        varchar2(100);  --BC2
        v_ccg_barcodec        varchar2(100);  --BC2
        v_ccg_barcoded        varchar2(100);  --BC4
        v_ccg_barcodee        varchar2(100);  --BC5
        v_ccg_barcodef        varchar2(100);  --BC5

        v_print_daten         varchar2(2048);
        v_found               boolean;
        v_adresse             isi_adressen%rowtype;
        cursor c_firma is
        select
            a.*
        from
            isi_firma    t,
            isi_adressen a
        where
                t.sid = v_adresse.sid
            and t.firma_nr = v_adresse.firma_nr
            and a.sid = t.sid
            and a.adress_id = t.adress_id;

        cursor c_et_daten is
        select
            lte.sid,
            lte.firma_nr,
            lvs_p_lte_lhm.format_nve(nvl(lte.nve_nr, lte.lte_id)) as tf_1,
            nvl(art.bezeichnung3, art.bezeichnung1)               as tf_2,
            '0'
            || lvs_p_lte_lhm.format_ean(art.lhm_ean)              as tf_3,
            lvs_p_lte_lhm.format_ean(art.ean)                     as tf_4,
            to_char(lam.lam_mhd_ausgabe, 'DD.MM.YY')              as tf_5,
            to_char(lam.lam_mhd_ausgabe, 'MM.YYYY')               as tf_15,
            lam.menge                                             as tf_6,
            lam.menge_basis,
            art.lhm_menge                                         as tf_16,
            art.lte_lhm_pro_lage                                  as tf_17,
            art.lte_lhm_pro_lage * art.lhm_menge                  as tf_18,
            art.lte_lhm_lagen                                     as tf_19,
            art.lte_menge                                         as tf_21,
            art.lte_lhm_menge                                     as tf_22,
            nvl(art.artikel_kurz, art.artikel)                    as tf_8,
            art.artikel                                           as tf_14,
            '('
            || art.lte_lhm_pro_lage
            || 'x'
            || art.lte_lhm_lagen
            || ')'                                                as tf_9,
            cha.charge_bez                                        as tf_10,
            round(lte.lte_akt_kg, 2)                              as tf_11,
            lte.lte_id                                            as tf_20,
            '(93)'
            || lte.lte_id
            || '(37)'
            || lpad(lam.menge, 6, '0')
            || '(15)'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as "BC1_Text",
            '(02)'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '(10)'
            || cha.charge_bez                                     as "BC2_Text",
            '(00)'
            || nvl(lte.nve_nr, lte.lte_id)                        as "BC3_Text",
            '(37)'
            || lpad(lam.menge, 6, '0')
            || '(15)'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as "BC4_Text",
            '(02)'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '(37)'
            || lpad(lam.menge, 6, '0')
            || '(20)'
            || substr(art.artikel,
                      length(art.artikel) - 2 + 1)                          as "BC5_Text",
            '(15)'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )
            || '(10)'
            || cha.charge_bez                                     as "BC6_Text",
            '93'
            || lte.lte_id
            || chr(29)
            || '37'
            || lpad(lam.menge, 6, '0')
            || chr(29)
            || '15'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as bc1,
            '02'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '10'
            || cha.charge_bez                                     as bc2,
            '00'
            || nvl(lte.nve_nr, lte.lte_id)                        as bc3,
            '37'
            || lpad(lam.menge, 6, '0')
            || chr(29)
            || '15'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )                                                     as bc4,
            '02'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || chr(29)
            || '37'
            || lpad(lam.menge, 6, '0')
            || chr(29)
            || '20'
            || substr(art.artikel,
                      length(art.artikel) - 2 + 1)                          as bc5,
--       '10' || cha.charge_bez  || CHR(29) || '15' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') as "BC6"
--       '15' || to_char(last_day(lam.lam_mhd_ausgabe), 'YYMMDD') || CHR(29) || '10' || cha.charge_bez as "BC6"
-- MMa: Projekt 70340-2017 Etikettenaenderung
            '15'
            || to_char(
                last_day(lam.lam_mhd_ausgabe),
                'YYMMDD'
            )
            || chr(29)
            || '10'
            || cha.charge_bez                                     as "BC6_Text"
        from
            lvs_lte     lte,
            lvs_lam     lam,
            isi_artikel art,
            lvs_charge  cha
        where
                lte.lte_id = in_lte_id
            and lam.lte_id = in_lte_id
            and lam.artikel_id = art.artikel_id (+)
            and lam.sid = art.sid (+)
            and cha.sid (+) = lam.sid
            and nvl(
                cha.charge_id(+),
                -1
            ) = nvl(lam.charge_id, -1);

    begin
        open c_et_daten;
        fetch c_et_daten into
            v_adresse.sid,
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
        close c_et_daten;
        open c_firma;
        fetch c_firma into v_adresse;
        close c_firma;
        v_ccg_artikel_nr := format_artikel(v_artikel_nr);
        if not v_found then
            v_err_nr := 10;
            v_err_text := 'Fehler beim lesen der Etikettendaten der Transporteinheit ' || in_lte_id;
            raise v_error;
        end if;

        if v_ccg_menge_in_lhm = 0 then
            v_ccg_menge_in_lhm := 1;
        end if;
        if v_menge_basis = 'LHM' then
            v_ccg_lhm_menge := v_menge;
            v_ccg_lke_menge := v_menge * v_ccg_menge_in_lhm;
            v_ccg_anz_karton := v_ccg_lhm_menge;
        elsif v_menge_basis = 'LKE' then
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
            v_print_daten := 'CCG_FIRMANAME='
                             || nvl(v_adresse.name_1, 'Name')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMASTRASSE='
                             || nvl(v_adresse.strasse, 'Str.')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMAPLZORT='
                             || nvl(v_adresse.plz, 'PLZ')
                             || ' '
                             || nvl(v_adresse.ort, 'Ort')
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR1='
                             || 'INTERPORTO S. PALOMBA S.R.L.'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR2='
                             || 'Interrporto Palomba'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR3='
                             || 'VIA ADREANTINA, KM 22.000'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR4='
                             || '00040 S. PALOMBA-POMEZIA RM'
                             || chr(13)
                             || chr(10)
                             || 'CCG_AUSLIEFERUNGSDATUM='
                             || '01.10.2003'
                             || chr(13)
                             || chr(10)
                             || 'CCG_NVE='
                             || v_ccg_nve
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTTEXT='
                             || v_ccg_arttext
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_KARTON='
                             || v_ccg_ean_lhm_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_BECHER='
                             || v_ccg_ean_lke_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD='
                             || v_ccg_mhd_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD_MONAT='
                             || v_ccg_mhd_monat
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_KARTON='
                             || lpad(v_ccg_lhm_menge, 5, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_BECHER='
                             || lpad(v_ccg_lke_menge, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_IN_KARTON='
                             || lpad(v_ccg_menge_in_lhm, 7, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_LAGEN='
                             || lpad(v_ccg_lagen, 7, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_KARTON='
                             || lpad(v_ccg_anz_karton, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_BECHER='
                             || lpad(v_ccg_anz_becher, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_KARTON_PRO_LAGE='
                             || lpad(v_ccg_lhm_pro_lage, 6, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_PRO_LAGE='
                             || lpad(v_ccg_menge_pro_lage, 4, ' ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL='
                             || v_ccg_arttext_kurz
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_ANZ_LAGEN='
                             || v_ccg_kom_lagen
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_KARTON_L_LAGE='
                             || v_ccg_lhm_l_lage
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL_NR='
                             || v_ccg_artikel_nr
                             || chr(13)
                             || chr(10)
                             || 'CCG_LAGE_LAGEN='
                             || v_ccg_lage_lagen
                             || chr(13)
                             || chr(10)
                             || 'CCG_CHARGE='
                             || v_ccg_charge
                             || chr(13)
                             || chr(10)
                             || 'CCG_GEWICHT_KG='
                             || v_ccg_gewicht_kg
                             || chr(13)
                             || chr(10)
                             || 'CCG_PID='
                             || v_ccg_pid
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEA='
                             || v_ccg_barcodea
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEA_STRING='
                             || v_ccg_barcodea_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB='
                             || v_ccg_barcodeb
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB_STRING='
                             || v_ccg_barcodeb_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC='
                             || v_ccg_barcodec
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC_STRING='
                             || v_ccg_barcodec_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED='
                             || v_ccg_barcoded
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED_STRING='
                             || v_ccg_barcoded_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE='
                             || v_ccg_barcodee
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE_STRING='
                             || v_ccg_barcodee_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF='
                             || v_ccg_barcodef
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF_STRING='
                             || v_ccg_barcodef_string;
        else
            v_print_daten := 'CCG_FIRMANAME ='
                             || nvl(v_adresse.name_1, 'Name')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMASTRASSE ='
                             || nvl(v_adresse.strasse, 'Str.')
                             || chr(13)
                             || chr(10)
                             || 'CCG_FIRMAPLZORT ='
                             || nvl(v_adresse.plz, 'PLZ')
                             || ' '
                             || nvl(v_adresse.ort, 'PLZ')
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR1 ='
                             || 'INTERPORTO S. PALOMBA S.R.L.'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR2 ='
                             || 'Interrporto Palomba'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR3 ='
                             || 'VIA ADREANTINA, KM 22.000'
                             || chr(13)
                             || chr(10)
                             || 'CCG_KADR4 ='
                             || '00040 S. PALOMBA-POMEZIA RM'
                             || chr(13)
                             || chr(10)
                             || 'CCG_NVE='
                             || v_ccg_nve
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTTEXT='
                             || 'Mischpalette'
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_EAN_BECHER='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD_MONAT='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MHD='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_BECHER='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_IN_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_LAGEN='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_KARTON='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ANZ_BECHER='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_PRO_LAGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_KARTON_PRO_LAGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL_NR='
                             || ''
                             || chr(13)
                             || chr(10)
                             || 'CCG_LAGE_LAGEN='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_ANZ_LAGEN='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_KOM_KARTON_L_LAGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_CHARGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_GEWICHT_KG='
                             || v_ccg_gewicht_kg
                             || chr(13)
                             || chr(10)
                             || 'CCG_PID='
                             || v_ccg_pid
                             || chr(13)
                             || chr(10)
                             ||
                     --'CCG_BARCODEA_STRING=' || v_ccg_barcodea_string || CHR(13) || CHR(10) ||
                     --'CCG_BARCODEA=' || v_ccg_barcodea || CHR(13) || CHR(10) ||
                              'CCG_BARCODEA='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEA_STRING='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB='
                             || v_ccg_barcodeb
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEB_STRING='
                             || v_ccg_barcodeb_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC='
                             || v_ccg_barcodec
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC_STRING='
                             || v_ccg_barcodec_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED='
                             || v_ccg_barcoded
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODED_STRING='
                             || v_ccg_barcoded_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE='
                             || v_ccg_barcodee
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEE_STRING='
                             || v_ccg_barcodee_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF='
                             || v_ccg_barcodef
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEF_STRING='
                             || v_ccg_barcodef_string;
        end if;

        return ( v_print_daten );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zuruckgegeben.
        when v_error then
            raise_application_error(-20000 - v_err_nr, v_err_text);
            raise;
        when others then
            if v_err_nr is not null then
                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                raise;
            end if;
    end ccg_etikett;

--------------------------------------------------------------------------------
-- function format_nve
--
-- 340274530000050083 -> 3 40 27453 000005008 3
--------------------------------------------------------------------------------
    function format_artikel (
        in_str in varchar2
    ) return varchar2 is
        str_code varchar2(18) := null;
        str_out  varchar2(23) := null;
    begin
        str_code := substr(in_str, 1, 18);
        str_out := substr(str_code, 1, 1);
        str_out := str_out
                   || '-'
                   || substr(str_code, 2, 2);
        str_out := str_out
                   || '-'
                   || substr(str_code, 4, 6);
        return ( str_out );
    end;

end;
/


-- sqlcl_snapshot {"hash":"3a3046298898243c8be111bed6bcdcdccd4ea6c6","type":"PACKAGE_BODY","name":"Z_OETKER_DRUCK","schemaName":"DIRKSPZM32","sxml":""}