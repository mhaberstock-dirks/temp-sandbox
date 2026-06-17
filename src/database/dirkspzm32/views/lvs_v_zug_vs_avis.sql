
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."LVS_V_ZUG_VS_AVIS" ("ADR_LIEFER", "NAME_1", "ARTIKEL", "BEZEICHNUNG1", "LIEFERANTEN_NR", "LIEFERANT", "LI_NR", "LI_POS", "MENGE_ZUG", "LTE_ID", "MENGE_AVIS", "BUCH_DATUM", "EINTREFF_DATUM_SOLL", "BUCH_BENUTZER") AS 
  select erg.adr_liefer,
       erg.name_1,
       erg.artikel,
       erg.bezeichnung1,
       erg.lieferanten_nr,
       erg.lieferant,
       erg.li_nr,
       erg.li_pos,
       erg.menge_zug,
       erg.lte_id,
       --(select sum(bhx.menge)
       --   from lvs_lam_bh bhx
       --  where bhx.artikel_id = erg.artikel_id
       --    and bhx.bus = 22
       --    and trunc(bhx.buch_datum) = erg.buch_datum) art_menge,
       erg.menge_avis,
       erg.buch_datum,
       erg.eintreff_datum_soll,
       erg.buch_benutzer
from (
select adr.adr_liefer,
       adr.name_1,
       a.artikel,
       a.bezeichnung1,
       a.artikel_id,
       ah.lieferanten_nr,
       adrli.name_1 lieferant,
       l.li_nr_lief li_nr,
       ap.lieferschein_pos li_pos,
       sum(bh.menge) menge_zug,
       max(ap.liefermenge_kunde) menge_avis,
       trunc(bh.buch_datum) buch_datum,
       trunc(ah.eintreff_datum_soll) eintreff_datum_soll,
       (u.vorname || ' ' || u.nachname) buch_benutzer,
       stradd_distinct(bh.lte_id) lte_id
  from LVS_LAM_BH   bh,
       lvs_lam      l,
       isi_artikel  a,
       isi_avis_pos ap,
       isi_avis_hdr ah,
       isi_adressen adr,
       isi_adressen adrli,
       isi_user     u
--  where bh.bus = 22 -- LHa 20182205 Ticket: W24210-61 backup
 where (bh.bus = 22 or (bh.bus = 2 and a.waren_gruppe = 'VE' and l.li_nr_lief is not NULL)) -- LHa 20182205 Ticket: W24210-61 changed: added (bh.bus = 2 and a.waren_gruppe = 'VE' and l.li_nr_lief is not NULL)
      --and bh.buch_datum >= trunc(sysdate) - 5
   and bh.lam_id = l.lam_id
   and l.li_nr_lief is not NULL
   and a.artikel_id = l.artikel_id
   and ap.lieferschein_nr(+) = l.li_nr_lief -- LHa 20182205 Ticket: W24210-61 changed: added outerjoin
   and ap.sach_nr_kunde(+) = a.artikel -- LHa 20182205 Ticket: W24210-61 changed: added outerjoin
   and ap.lieferschein_nr = ah.lieferschein_nr(+) -- LHa 20182205 Ticket: W24210-61 changed: added outerjoin
   and l.owner_address_id = adr.adress_id(+)
   and ah.lieferanten_nr = adrli.adr_nr(+)
   and u.login_id = bh.created_login_id
   and bh.menge > 0
   -- LHa 20182205 Ticket: W24210-61 added
   and (exists
        (select *
           from lvs_lam_bh xbh
          where xbh.lam_id = l.lam_id
            and xbh.bus = 4
            and xbh.lgr_platz is not NULL))
   -- LHa 20182205 Ticket: W24210-61 added
   and (      (a.materialart in ('RE', 'FE')
           and ap.sach_nr_kunde is not null and
               ap.lieferschein_nr is not null)
         or (a.materialart = 'VE' and l.li_nr_lief is not NULL))
 group by a.artikel_id,
          l.li_nr_lief,
          bh.artikel_id,
          a.artikel,
          a.bezeichnung1,
          trunc(bh.buch_datum),
          trunc(ah.eintreff_datum_soll),
          ah.lieferanten_nr,
          adrli.name_1,
          ap.lieferschein_nr,
          ap.lieferschein_pos,
          adr.adr_liefer,
          adr.name_1,
          (u.vorname || ' ' || u.nachname)
union all
select adr.adr_liefer,
       adr.name_1,
       a.artikel,
       a.bezeichnung1,
       a.artikel_id,
       l.lieferant_nr,
       adrli.name_1 lieferant,
       l.li_nr_lief li_nr,
       NULL li_pos,
       sum(bh.menge) menge_zug,
       NULL menge_avis,
       trunc(bh.buch_datum) buch_datum,
       NULL eintreff_datum_soll,
       (u.vorname || ' ' || u.nachname) buch_benutzer,
       stradd_distinct(bh.lte_id) lte_id
  from LVS_LAM_BH   bh,
       lvs_lam      l,
       isi_artikel  a,
       isi_adressen adr,
       isi_adressen adrli,
       isi_user     u
--  where bh.bus = 22 -- LHa 20182205 Ticket: W24210-61 backup
 where (bh.bus = 22 or (bh.bus = 2 and a.waren_gruppe = 'VE' and l.li_nr_lief is not NULL)) -- LHa 20182205 Ticket: W24210-61 changed: added (bh.bus = 2 and a.waren_gruppe = 'VE' and l.li_nr_lief is not NULL)
      -- and bh.buch_datum >= trunc(sysdate) - 5
   and bh.lam_id = l.lam_id
   and a.artikel_id = l.artikel_id
   and l.li_nr_lief is not NULL
   -- LHa 20182205 Ticket: W24210-61 added
   and (exists
        (select *
           from lvs_lam_bh xbh
          where xbh.lam_id = l.lam_id
            and xbh.bus = 4
            and xbh.lgr_platz is not NULL))
   and (not exists
        (select *
           from isi_avis_pos xa
          where xa.lieferschein_nr = l.li_nr_lief
            and xa.sach_nr_kunde = a.artikel) or l.li_nr_lief is NULL)
   and l.owner_address_id = adr.adress_id(+)
   and l.lieferant_nr = adrli.adr_nr(+)
   and u.login_id = bh.created_login_id
   and bh.menge > 0
 group by a.artikel_id,
          l.li_nr_lief,
          l.lieferant_nr,
          adrli.name_1,
          bh.artikel_id,
          a.artikel,
          a.bezeichnung1,
          trunc(bh.buch_datum),
          adr.adr_liefer,
          adr.name_1,
          (u.vorname || ' ' || u.nachname)
) erg
 order by erg.buch_datum desc, erg.li_nr, erg.artikel
;


-- sqlcl_snapshot {"hash":"f79d2867a6be36cae5b52392019eaed260e88422","type":"VIEW","name":"LVS_V_ZUG_VS_AVIS","schemaName":"DIRKSPZM32","sxml":""}