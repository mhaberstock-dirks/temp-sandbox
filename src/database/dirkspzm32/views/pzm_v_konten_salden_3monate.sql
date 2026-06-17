
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_KONTEN_SALDEN_3MONATE" ("PERS_NR", "NAME", "NAME_KURZ", "KONTO_NR", "MONAT_DATUM", "SALDO_MONAT_START", "SALDO_MONAT_ENDE", "AKT_SALDO", "INFO_WERT_MONAT_DIFF", "INFO_SALDO_MONAT_DIFF") AS 
  select t.pers_nr,
       t.name,
       t.name_kurz,
       t.konto_nr,
       t.monat_datum,
       (t.akt_saldo - t.saldo_monat_diff) saldo_monat_start,
       (t.akt_saldo - t.saldo_monat_diff + t.wert_monat_diff) saldo_monat_ende,
       t.akt_saldo,
       t.wert_monat_diff info_wert_monat_diff,
       t.saldo_monat_diff info_saldo_monat_diff
  from (select k.pers_nr,
               to_number(k.konto_nr) konto_nr,
               k.name,
               k.name_kurz,
               km.monat_datum,
               nvl(
               (select sum(decode(kbh.bus,
                             1, kbh.wert, -- Zugänge
                             -kbh.wert) -- Abgänge
                          ) wert_diff
                  from pzm_konten_bh kbh
                 where kbh.konto_nr = k.konto_nr
                   and kbh.typ != 'S' -- stornierte ausblenden
                   and trunc(nvl(kbh.zk_start, kbh.buch_datum), 'Month') = km.monat_datum
               ), 0) wert_monat_diff,
               nvl(
               (select sum(decode(kbh.bus,
                             1, kbh.wert, -- Zugänge
                             -kbh.wert) -- Abgänge
                          ) wert_diff
                  from pzm_konten_bh kbh
                 where kbh.konto_nr = k.konto_nr
                   and kbh.typ != 'S' -- stornierte ausblenden
                   and nvl(kbh.zk_start, kbh.buch_datum) >= km.monat_datum
               ), 0) saldo_monat_diff,
               k.saldo akt_saldo
          from pzm_konten k,
               (select add_months(trunc(sysdate, 'MM'), -LEVEL + 1) monat_datum
                  from dual
                connect by level <= 3 -- sicherstellen, dass mindestens für die letzten x Monate ein Datensatz vorhanden ist
               ) km
       ) t
;


-- sqlcl_snapshot {"hash":"b46024f0da4b0d9b943b60eab6b3604b03212a65","type":"VIEW","name":"PZM_V_KONTEN_SALDEN_3MONATE","schemaName":"DIRKSPZM32","sxml":""}