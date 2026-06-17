
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."BDE_V_GEN_BDE_FA_AUFTRAG_REL" ("SID", "FIRMA_NR", "LEITZAHL", "FA_AG", "FA_UPOS", "NFA_AG", "NFA_UPOS", "OVERLAP_TYPE", "OVERLAP_VALUE", "TIME_BUFFER_MIN", "MAXPUFFERBEACHTEN", "TIME_BUFFER_MAX") AS 
  select fa.sid,
       fa.firma_nr,
       fa.leitzahl /*kopfid*/ ,               -- eindeutige ID des Arbeitsplans
----------------------------------------------------
-- Glit für Split FAn
-- FA ist für Maschinengruppen und Maschinen
----------------------------------------------------
-- Relationen kommen nicht durch das ERP
-- Gen durch ISI
-- Splits durdch das APs im FA
       fa.fa_ag /*vonvorgangsid*/ ,                   -- ID des Vorgangs innerhalb des Arbeitsplans
       nvl(ep.favorgangssplittnr, fa.fa_upos) fa_upos /*vonsplitid*/ , -- Eindeutige ID des Ausgangsvorgangssplits
       fan.fa_ag nfa_ag /*nachvorgangsid*/ ,                 -- ID des Vorgangs innerhalb des Arbeitsplans
       nvl(epn.favorgangssplittnr, fan.fa_upos) nfa_upos /*nachsplitid*/ ,
                                                          -- Eindeutige ID des Ausgangsvorgangssplits
       1 overlap_type /*ueberlappungstyp*/ ,                                -- Überlappungstyp, falls Überlappungen zwischen Vorgängen geplant werden sollen  0=keine, 1=prozentual 2=Zeit in s 3=automatisch
       100 overlap_value /*wert*/ ,                                            -- Überlappungswert entsprechend dem eingestellten Überlappungstyp
       0 time_buffer_min /*minpuffer*/ ,                                       -- minimaler zeitlicher Abstand zum Nachfolger
       0 MaxPufferBeachten,                               -- aktiviert/deaktiviert maximalen Puffer 0=nein 1=ja
       1 time_buffer_max /*maxpuffer*/
  from bde_fa_auftrag fa,
       bde_fa_auftrag fan,
       aps_fa_vorgangs_position ep,
       aps_fa_vorgangs_position epn
 where not exists (select x.leitzahl from bde_fa_auftrag x where x.leitzahl = fa.leitzahl and x.kenz_letzt_ag = 1 and x.freig_status = 'F')
   and fa.leitzahl = fan.leitzahl
   and fa.fa_ag < fan.fa_ag
   and fa.fa_ag = (select max(x.fa_ag) from bde_fa_auftrag x where x.leitzahl = fan.leitzahl and x.satzart = 'V' and fan.fa_ag > x.fa_ag)
   and fa.satzart = 'V'
   and fan.satzart = 'V'
   and ep.fakopfnr(+) = 'FA' || to_char(fa.leitzahl)
   and ep.favorgangsnr(+) = fa.fa_ag
   and ep.favorgangspositionsnr(+) = 2
   and epn.fakopfnr(+) = 'FA' || to_char(fan.leitzahl)
   and epn.favorgangsnr(+) = fan.fa_ag
   and epn.favorgangssplittnr(+) = fan.fa_upos
   and epn.favorgangspositionsnr(+) = 2
   and isi_allg.c_get_firma_cfg_param(fa.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
                                    fa.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                    'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                    NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                    'BDE_APS_GEN_FA_REL',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                    'BDE',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                    'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                    c.R_C_TRUE,             -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                    'BOOLEAN') = c.R_C_TRUE  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
;


-- sqlcl_snapshot {"hash":"af3bb0b56e549e07515f339ac5e73d6879339988","type":"VIEW","name":"BDE_V_GEN_BDE_FA_AUFTRAG_REL","schemaName":"DIRKSPZM32","sxml":""}