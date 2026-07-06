
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."HM_V_ZE_REPORT" ("ZE_PERS_NR", "ZE_SCHICHT_TAG", "ZE_KST_ID", "ZE_IST_START", "ZE_IST_ENDE", "ZE_CALC_IST_START", "ZE_CALC_IST_ENDE", "PAUSE_STD", "ARB_STD", "BUCH_STD", "ZE_ABT_ID", "ZE_PB_ID", "ZE_AA_STATUS", "GRUPPE_NR") AS 
  WITH
  -- Schritt 1: Aktive KST_ID pro Zeile bestimmen (nur ZE_STATUS=2 ist relevant für Wechsel)
  -- Für ZE_STATUS=4 wird die letzte bekannte ZE_KST_ID mit ZE_STATUS=2 verwendet
  basis
  AS
    (SELECT ze.ze_id
           ,ze_pers_nr
           ,ze_schicht_tag
           ,ze.ze_ist_start
           ,ze.ze_ist_ende
           ,ze_calc_ist_start
           ,ze_calc_ist_ende
           ,ze_status
           ,ze_kst_id
           ,ze_std
           ,ze_abt_id
           ,ze_pb_id
           ,ze_aa_status
           ,-- Letzte ZE_KST_ID mit ZE_STATUS=2, die <= aktuellem Satz ist
            LAST_VALUE (CASE WHEN ze_status = 2 THEN ze_kst_id END IGNORE NULLS)
              OVER (PARTITION BY ze_pers_nr, ze_schicht_tag
                    ORDER BY ze_calc_ist_start
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS aktive_kst_id
       FROM pzm_zeiterfassung ze
      -- order by ze.ze_schicht_tag, ze.ZE_PERS_NR, ze.ze_calc_ist_start
    ),
  -- Schritt 2: Erkennen, wann ein neuer Block beginnt (Wechsel der aktiven KST_ID)
  block_erkennung
  AS
    (SELECT b.*
           ,-- Vorherige aktive_kst_id innerhalb Person+Tag
            LAG (aktive_kst_id) OVER (PARTITION BY ze_pers_nr, ze_schicht_tag ORDER BY ze_calc_ist_start)  AS prev_kst_id
           ,-- Neue Gruppe wenn aktive_kst_id sich geändert hat
            CASE
              WHEN LAG (aktive_kst_id) OVER (PARTITION BY ze_pers_nr, ze_schicht_tag ORDER BY ze_calc_ist_start) IS NULL
                OR LAG (aktive_kst_id) OVER (PARTITION BY ze_pers_nr, ze_schicht_tag ORDER BY ze_calc_ist_start) <> aktive_kst_id
              THEN
                1
              ELSE
                0
            END                                                                                            AS neuer_block
       FROM basis b),
  -- Schritt 3: Gruppenummer je Person+Tag berechnen
  gruppen
  AS
    (SELECT b.*
           ,SUM (neuer_block)
              OVER (PARTITION BY ze_pers_nr, ze_schicht_tag
                    ORDER BY ze_calc_ist_start
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS gruppe_nr
       FROM block_erkennung b)
       
  -- Schritt 4: Aggregation je Gruppe
  SELECT g.ze_pers_nr
        ,g.ze_schicht_tag
        ,g.aktive_kst_id                                                     AS ze_kst_id
        ,MIN (g.ze_ist_start)                                                AS ze_ist_start
        ,MAX (g.ze_ist_ende)                                                 AS ze_ist_ende
        ,MIN (g.ze_calc_ist_start)                                           AS ze_calc_ist_start
        ,MAX (g.ze_calc_ist_ende)                                            AS ze_calc_ist_ende
        ,ROUND (SUM (CASE WHEN g.ze_status = 4 THEN ze_std ELSE 0 END), 3)   AS pause_std
        ,ROUND (SUM (CASE WHEN g.ze_status = 2 THEN ze_std ELSE 0 END), 3)   AS arb_std
        , ROUND (SUM (CASE WHEN g.ze_status = 2 THEN ze_std ELSE 0 END), 3)
        - ROUND (SUM (CASE WHEN g.ze_status = 4 THEN ze_std ELSE 0 END), 3)  AS buch_std
        ,g.ze_abt_id
        ,g.ze_pb_id 
        ,g.ze_aa_status
        ,g.gruppe_nr
    FROM gruppen g
GROUP BY g.ze_pers_nr
        ,g.ze_schicht_tag
        ,g.aktive_kst_id
        ,g.ze_abt_id
        ,g.ze_pb_id
        ,g.ze_aa_status
        ,g.gruppe_nr
ORDER BY g.ze_pers_nr, g.ze_schicht_tag, ze_calc_ist_start;


-- sqlcl_snapshot {"hash":"082a0f8f16a5034c4bf8bce22a5679b737d7933f","type":"VIEW","name":"HM_V_ZE_REPORT","schemaName":"DIRKSPZM32","sxml":""}