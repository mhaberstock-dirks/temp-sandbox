create or replace package body dirkspzm32.z_cerealia_druck is
  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;                 --
    v_err_nr   number;
    v_err_text varchar2(255);

  -- Function and procedure implementations
    function ccg_etikett (
        in_lte_id    in lvs_lte.lte_id%type,
        in_waren_typ in lvs_lte.waren_typ%type
    ) return varchar2 is

        v_ccg_nve              varchar2(100);  --1
        v_ccg_arttext          varchar2(100);  --2
        v_ccg_ean_lhm_string   varchar2(100);  --3
        v_ccg_ean_lke_string   varchar2(100);  --4
        v_ccg_mhd_string       varchar2(100);  --5
        v_ccg_lhm_menge_string varchar2(100);  --6
        v_ccg_lke_menge_string varchar2(100);  --7
        v_ccg_arttext_kurz     varchar2(100);  --8
        v_ccg_lage_lagen       varchar2(100);  --9
        v_ccg_charge           varchar2(100);  --10
        v_ccg_gewicht_kg       varchar2(100);  --11
        v_ccg_barcodea_string  varchar2(100);  --12
        v_ccg_barcodeb_string  varchar2(100);  --13
        v_ccg_barcodec_string  varchar2(100);  --13
        v_ccg_barcodea         varchar2(100);  --BC1
        v_ccg_barcodeb         varchar2(100);  --BC2
        v_ccg_barcodec         varchar2(100);  --BC2

        v_ccg_unil_bc1_string  varchar2(100);  --UNILEVER 1 BC1
        v_ccg_unil_bc1_text    varchar2(100);  --UNILEVER 2
        v_ccg_unil_bc2_string  varchar2(100);  --UNILEVER 3 BC2
        v_ccg_unil_bc2_text    varchar2(100);  --UNILEVER 4
        v_ccg_unil_bc3_string  varchar2(100);  --UNILEVER 3 BC2
        v_ccg_unil_bc3_text    varchar2(100);  --UNILEVER 4
        v_ccg_unil_mhd         varchar2(100);  --UNILEVER 5
        v_ccg_unil_variant     varchar2(100);  --UNILEVER 6
        v_ccg_unil_artikel     varchar2(100);  --UNILEVER 7
        v_ccg_unil_menge       varchar2(100);  --UNILEVER 8
        v_ccg_unil_lage_lagen  varchar2(100);  --UNILEVER 9
--  v_ccg_unil_nve             varchar2(100);  --UNILEVER A
        v_ccg_unil_ean_karton  varchar2(100);  --UNILEVER B
--  v_ccg_unil_arttext         varchar2(100);  --UNILEVER C
        v_ccg_unil_charge      varchar2(100);  --UNILEVER D

        v_print_daten          varchar2(2048);
        v_found                boolean;
        cursor c_et_daten is
        select
            lvs_p_lte_lhm.format_nve(lam.lte_id)     as tf_1,
            nvl(art.bezeichnung3, art.bezeichnung1)  as tf_2,
       -- BW- Fehler bei Routine FORMAT_EAN
            isi_utils.format_ean(art.lhm_ean)        as tf_3,
       -- BW- Fehler bei Routine FORMAT_EAN

            isi_utils.format_ean(art.ean)            as tf_4,
            to_char(lam.lam_mhd_ausgabe, 'DD.MM.YY') as tf_5,
            lam.menge                                as tf_6,
            lam.menge * art.lhm_menge                as tf_7,
            nvl(art.artikel_kurz, art.artikel)       as tf_8,
            '('
            || art.lte_lhm_pro_lage
            || 'x'
            || art.lte_lhm_lagen
            || ')'                                   as tf_9,
            cha.charge_bez                           as tf_10,
            round(lte.lte_akt_kg, 2)                 as tf_11,
            '(02)'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '(15)'
            || to_char(lam.lam_mhd_ausgabe, 'YYMMDD')
            || '(37)'
            || lam.menge
            || '(10)'
            || cha.charge_bez                        as "BC1_Text",
            '(00)'
            || lam.lte_id
            || '(3302)'
            || round(lte.lte_akt_kg * 100)           as "BC2_Text",
            '02'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '15'
            || to_char(lam.lam_mhd_ausgabe, 'YYMMDD')
            || '37'
            || lpad(
                to_char(lam.menge),
                8,
                '0'
            )
            || chr(29)
            || '10'
            || cha.charge_bez                        as bc1,
            '00'
            || lam.lte_id
            || '3302'
            || lpad(
                to_char(round(lte.lte_akt_kg * 100)),
                6,
                '0'
            )                                        as bc2,
            '(02)'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '(15)'
            || to_char(lam.lam_mhd_ausgabe, 'YYMMDD')
            || '(37)'
            || to_char(lam.menge * art.lhm_menge)
            || '(10)'
            || cha.charge_bez                        as "BC3_Text",
            '02'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '15'
            || to_char(lam.lam_mhd_ausgabe, 'YYMMDD')
            || '37'
            || lpad(
                to_char(lam.menge * art.lhm_menge),
                8,
                '0'
            )
            || chr(29)
            || '10'
            || cha.charge_bez                        as bc3,
       -- Unilever-Etikett
            '(02)'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '(15)'
            || to_char(lam.lam_mhd_ausgabe, 'YYMMDD')
            || '(20)'
            || substr(
                nvl(art.artikel_kurz, art.artikel),
                -2,
                2
            )
            || '(37)'
            || lpad(lam.menge, 4, '0')               unil_bc1_text,
            '02'
            || lpad(
                nvl(art.lhm_ean, '0'),
                14,
                '0'
            )
            || '15'
            || to_char(lam.lam_mhd_ausgabe, 'YYMMDD')
            || '20'
            || substr(
                nvl(art.artikel_kurz, art.artikel),
                -2,
                2
            )
            || '37'
            || lam.menge                             unil_bc1_string,
            '(00)'
            || lam.lte_id
            || '(10)'
            || rpad(cha.charge_bez, 9, '0')          unil_bc2_text,
            '00'
            || lam.lte_id
            || '10'
            || rpad(cha.charge_bez, 9, '0')          unil_bc2_string,
            to_char(lam.lam_mhd_ausgabe, 'MM/YYYY')  unil_mhd,
            substr(
                nvl(art.artikel_kurz, art.artikel),
                -2,
                2
            )                                        unil_variant,
            nvl(art.artikel_kurz, art.artikel)       unil_artikel,
            lpad(
                to_char(lam.menge),
                4,
                '0'
            )                                        unil_menge,
            '('
            || art.lte_lhm_pro_lage
            || 'x'
            || art.lte_lhm_lagen
            || ')'                                   unil_lagen,
            rpad(cha.charge_bez, 9, '0')             unil_charge,
-- BW- Fehler bei Routine FORMAT_EAN
            isi_utils.format_ean(art.lhm_ean)        unil_ean_karton
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
            v_ccg_nve,
            v_ccg_arttext,
            v_ccg_ean_lhm_string,
            v_ccg_ean_lke_string,
            v_ccg_mhd_string,
            v_ccg_lhm_menge_string,
            v_ccg_lke_menge_string,
            v_ccg_arttext_kurz,
            v_ccg_lage_lagen,
            v_ccg_charge,
            v_ccg_gewicht_kg,
            v_ccg_barcodea_string,
            v_ccg_barcodeb_string,
            v_ccg_barcodea,
            v_ccg_barcodeb,
            v_ccg_barcodec_string,
            v_ccg_barcodec,
            v_ccg_unil_bc1_text,
            v_ccg_unil_bc1_string,
            v_ccg_unil_bc2_text,
            v_ccg_unil_bc2_string,
            v_ccg_unil_mhd,
            v_ccg_unil_variant,
            v_ccg_unil_artikel,
            v_ccg_unil_menge,
            v_ccg_unil_lage_lagen,
            v_ccg_unil_charge,
            v_ccg_unil_ean_karton;

        v_found := c_et_daten%found;
        close c_et_daten;
        if not v_found then
            v_err_nr := 10;
            v_err_text := 'Fehler beim lesen der Etikettendaten der Transporteinheit ' || in_lte_id;
            raise v_error;
        end if;

        if in_waren_typ != 'MP' then
            v_print_daten := 'CCG_NVE='
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
                             || 'CCG_MENGE_KARTON='
                             || v_ccg_lhm_menge_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_MENGE_BECHER='
                             || v_ccg_lke_menge_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_ARTIKEL='
                             || v_ccg_arttext_kurz
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
                             ||
                     -- ab hier UNILEVER
                              'CCG_UNIL_BC1_STRING='
                             || v_ccg_unil_bc1_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_BC1_TEXT='
                             || v_ccg_unil_bc1_text
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_BC2_STRING='
                             || v_ccg_unil_bc2_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_BC2_TEXT='
                             || v_ccg_unil_bc2_text
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_MHD='
                             || v_ccg_unil_mhd
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_VARIANT='
                             || v_ccg_unil_variant
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_ARTIKEL='
                             || v_ccg_unil_artikel
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_MENGE='
                             || v_ccg_unil_menge
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_LAGE_LAGEN='
                             || v_ccg_unil_lage_lagen
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_CHARGE='
                             || v_ccg_unil_charge
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_EAN_KARTON='
                             || v_ccg_unil_ean_karton;
        else
            v_print_daten := 'CCG_NVE='
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
                             || 'CCG_ARTIKEL='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_LAGE_LAGEN='
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
                             ||
                     --'CCG_BARCODEA_STRING=' || v_ccg_barcodea_string      || CHR(13) || CHR(10) ||
                     --'CCG_BARCODEA='        || v_ccg_barcodea             || CHR(13) || CHR(10) ||
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
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_BARCODEC_STRING='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_BC1_STRING='
                             || v_ccg_unil_bc1_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_BC1_TEXT='
                             || v_ccg_unil_bc1_text
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_BC2_STRING='
                             || v_ccg_unil_bc2_string
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_BC2_TEXT='
                             || v_ccg_unil_bc2_text
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_MHD='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_VARIANT='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_ARTIKEL='
                             || 'Mischpalette'
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_MENGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_LAGE_LAGEN='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_CHARGE='
                             || ' '
                             || chr(13)
                             || chr(10)
                             || 'CCG_UNIL_EAN_KARTON='
                             || ' ';
        end if;

        return ( v_print_daten );
    exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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

end;
/


-- sqlcl_snapshot {"hash":"bf2eb9cdb661c2ebe9135dce5455de26b8f9237a","type":"PACKAGE_BODY","name":"Z_CEREALIA_DRUCK","schemaName":"DIRKSPZM32","sxml":""}