create or replace 
function DIRKSPZM32.bde_pruefe_rohstoffe
/*
Es wird beim beschicken geprüft, ob die Materialien als Rohstoff im FA eingetragen sind.
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden erzeugt

@param in_lte_id         in lvs_lte.lte_id                     Barcode zum Prüfen -> Alle Einträge der LTE
@param in_lhm_id         in lvs_lhm.lhm_id                     Barcode zum Prüfen -> Artikel der LHM prüfen
@param in_fa_auftrag     in bde_fa_auftrag - row               Datensatz auf Arbeitsgang, für den geprüft werden soll
@return True = OK / false = Es wurde ein Rohstoff in der LHM oder LTE gefunden, der nicht in der Stückliste des Fertigungsauftrags eingetragen ist
*/
(in_lte_id      in lvs_lte.lte_id%type,
 in_lhm_id      in lvs_lhm.lhm_id%type,
 in_fa_auftrag  in bde_fa_auftrag%rowtype)
 return boolean is

  v_lam        lvs_lam%rowtype;
  v_artikel_id bde_fa_auftrag.ag_artikel_id%type;
  v_leitzahl   bde_fa_auftrag.leitzahl%type;
  v_fa_ag      bde_fa_auftrag.fa_ag%type;
  v_true       varchar2(1);

  v_found      boolean;
  ret_val      boolean;

  CURSOR c_lam_lte is
    select *
      from lvs_lam lam
     where lam.lte_id = in_lte_id
       -- and lam.lgr_platz is not NULL
       and lam.menge > 0;

  CURSOR c_lam_lhm is
    select *
      from lvs_lam lam
     where lam.lhm_id = in_lhm_id
       -- and lam.lgr_platz is not NULL
       and lam.menge > 0;

  CURSOR c_fa_artikel is
    select bde_fa_auftrag.ag_artikel_id,
           decode (bde_fa_auftrag.satzart, 'MA', NULL, bde_fa_auftrag.leitzahl) leitzahl,
           decode (bde_fa_auftrag.satzart, 'MA', NULL, bde_fa_auftrag.fa_ag) fa_ag
      from bde_fa_auftrag
     where bde_fa_auftrag.sid = in_fa_auftrag.sid
           and bde_fa_auftrag.firma_nr = in_fa_auftrag.firma_nr
           and bde_fa_auftrag.leitzahl = in_fa_auftrag.leitzahl
           and bde_fa_auftrag.satzart != 'VR'
           and ((   (bde_fa_auftrag.fa_ag < in_fa_auftrag.fa_ag
                 and bde_fa_auftrag.satzart = 'MA'
                 and 'MA' = (select satzart
                               from bde_fa_auftrag auf
                              where auf.sid = in_fa_auftrag.sid
                                and auf.firma_nr = in_fa_auftrag.firma_nr
                                and auf.leitzahl = in_fa_auftrag.leitzahl
                                and auf.fa_ag = (select max(auf.fa_ag)
                                                   from bde_fa_auftrag auf
                                                   where auf.sid = in_fa_auftrag.sid
                                                     and auf.firma_nr = in_fa_auftrag.firma_nr
                                                     and auf.leitzahl = in_fa_auftrag.leitzahl
                                                     and auf.fa_ag < in_fa_auftrag.fa_ag
                                                   group by auf.leitzahl))
                 and  (bde_fa_auftrag.fa_ag >= nvl((select max(auf.fa_ag)
                                                     from bde_fa_auftrag auf
                                                     where auf.sid = in_fa_auftrag.sid
                                                       and auf.firma_nr = in_fa_auftrag.firma_nr
                                                       and auf.leitzahl = in_fa_auftrag.leitzahl
                                                       and auf.fa_ag < in_fa_auftrag.fa_ag
                                                       and auf.satzart = 'V'
                                                     group by auf.leitzahl), 0))
                      )
               or   (bde_fa_auftrag.fa_ag = (select max(auf.fa_ag)
                                               from bde_fa_auftrag auf
                                               where auf.sid = in_fa_auftrag.sid
                                                 and auf.firma_nr = in_fa_auftrag.firma_nr
                                                 and auf.leitzahl = in_fa_auftrag.leitzahl
                                                 and auf.fa_ag < in_fa_auftrag.fa_ag
                                                 and auf.satzart = 'V'
                                               group by auf.leitzahl))
                )
                or
                (       bde_fa_auftrag.fa_ag = in_fa_auftrag.fa_ag
                    and bde_fa_auftrag.satzart = 'MA'
                )
               );
  CURSOR c_fa_is_meldepunkt is
    select -- min(r.res_name) res_name, fa.leitzahl, fa.fa_ag, fa.fa_upos, max(fa.ag_bez1) ag_bez1
           c.C_TRUE
      from BDE_FA_AUFTRAG fa,
           isi_resource r,
           isi_resource rg
     where fa.leitzahl = v_leitzahl
       and fa.fa_ag = v_fa_ag
       and fa.satzart = 'V'
       and (    r.res_id = fa.res_id
            and r.typ = 'MSMP' -- Meldepunkt
           )
        or (    rg.res_id = fa.res_id
            and rg.gruppe = r.gruppe
            and r.typ = 'MSMP' -- Meldepunkt
           )
       group by fa.leitzahl, fa.fa_ag, fa.fa_upos;
begin
  ret_val := false;
  if in_lhm_id is not NULL
  then
    OPEN c_lam_lhm;
    LOOP
      FETCH c_lam_lhm into v_lam;
      v_found := c_lam_lhm%FOUND;
      if v_found
      then
        OPEN c_fa_artikel;
        LOOP
          FETCH c_fa_artikel into v_artikel_id, v_leitzahl, v_fa_ag;
          v_found := c_fa_artikel%FOUND;
          if nvl(v_artikel_id, v_lam.artikel_id) -- Dummy MA im Auftrag, dann kann alles verwendet werden
                                                  = v_lam.artikel_id
          and (nvl(v_leitzahl, -1) = nvl(v_lam.leitzahl, -1)
           and (   nvl(v_fa_ag, -1) = nvl(v_lam.fa_ag, -1)
                or in_fa_auftrag.fa_ag = nvl(v_lam.fa_ag, -1))
           or  v_leitzahl is NULL)
          and v_found
          then
            ret_val := true;
          else
            if nvl(v_artikel_id, v_lam.artikel_id) = v_lam.artikel_id
            then
              open c_fa_is_meldepunkt;
              FETCH c_fa_is_meldepunkt into v_true;
              close c_fa_is_meldepunkt;
              if v_true = c.C_TRUE
              then
                ret_val := true;
              end if;
            end if;
          end if;
          exit when not v_found or ret_val;
        end LOOP;
        CLOSE c_fa_artikel;
      end if;
      exit when c_lam_lhm%NOTFOUND or ret_val;
    end LOOP;
    CLOSE c_lam_lhm;
  else
    OPEN c_lam_lte;
    LOOP
      FETCH c_lam_lte into v_lam;
      v_found := c_lam_lte%FOUND;
      if v_found
      then
        OPEN c_fa_artikel;
        LOOP
          FETCH c_fa_artikel into v_artikel_id, v_leitzahl, v_fa_ag;
          v_found := c_fa_artikel%FOUND;
          if nvl(v_artikel_id, v_lam.artikel_id) -- Dummy MA im Auftrag, dann kann alles verwendet werden
                                                  = v_lam.artikel_id
          and (nvl(v_leitzahl, -1) = nvl(v_lam.leitzahl, -1)
           and (   nvl(v_fa_ag, -1) = nvl(v_lam.fa_ag, -1)
                or in_fa_auftrag.fa_ag = nvl(v_lam.fa_ag, -1))
           or  v_leitzahl is NULL)
          and v_found
          then
            ret_val := true;
          else
            if nvl(v_artikel_id, v_lam.artikel_id) = v_lam.artikel_id
            then
              open c_fa_is_meldepunkt;
              FETCH c_fa_is_meldepunkt into v_true;
              close c_fa_is_meldepunkt;
              if v_true = c.C_TRUE
              then
                ret_val := true;
              end if;
            end if;
          end if;
          exit when not v_found or ret_val;
        end LOOP;
        CLOSE c_fa_artikel;
      end if;
      exit when c_lam_lte%NOTFOUND or ret_val;
    end LOOP;
    CLOSE c_lam_lte;
  end if;
  return (ret_val);
end bde_pruefe_rohstoffe;
/



-- sqlcl_snapshot {"hash":"b2673bcd0c6ce433c061b7538f1eb100e28694f7","type":"FUNCTION","name":"BDE_PRUEFE_ROHSTOFFE","schemaName":"DIRKSPZM32","sxml":""}