create or replace 
package body DIRKSPZM32.BDE_P_PERS_ZEIT_KST is
/*
Funktionen für die Zeitverteilung Presonal auf Resource
Diese weden für die Stundenverteilung auf Kostenstelle je Mitarbeiter genutzt

@author -AG- Hans Joachim Gödeke

*/

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  procedure raise_isi_error(in_err_nr in number, in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;
  -------------------------------------------------------------------------------------------------------

/*
Die Procedure geht über eine Zeitspanne list die Einträge über die Personalnummer und Berechnet den Zeitanteil nach Kostenstelle bzw. Maschine

Die Methode geht über einen Zeitraum und lies alle Einträge aller Personalnummern. 
Diese werden dann über interne Speichertabellen die beim lesen gefüllt werden je
Personalnummer ausgewertet und verteilt. Die Verteilung für die Kostenstelle erfolgt
so, dass eine Anmeldung eine Person (eine Personalnummer) an zwei Maschinen gleichzeitig
je Maschine nur zu 50% gewertet wird. Bei drei Maschinen dann jeweils nur zu 1/3 usw.
  
@author -HJG- Hans Joachim Gödeke

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_pd_pres_beginn  in bde_pd_pers_zeit_kst.pd_pers_beginn  Start des Zeitraum für die Berechnung 
@param in_pd_pres_ende    in bde_pd_pers_zeit_kst.pd_pers_ende    Ende des Zeitraum für die Berechnung

-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--04.04.2011   3.5.2.x     (-HJG-)  Created 

*/
  procedure bde_c_pd_pers_zeit_berech (in_sid                      in  bde_pd_pers_zeit_kst.sid%type,
                                       in_firma_nr                in  bde_pd_pers_zeit_kst.firma_nr%type,
                                       in_pd_pres_beginn          in  bde_pd_pers_zeit_kst.pd_pers_beginn%type,
                                       in_pd_pres_ende            in  bde_pd_pers_zeit_kst.pd_pers_ende%type)
                                       is

    type t_pers_zeit_kst is table of bde_pd_pers_zeit_kst%rowtype
        index by binary_integer;

    type t_pers_zeit_event is table of date
        index by binary_integer;


    v_pd_pers_zeit_kst               bde_pd_pers_zeit_kst%rowtype;
    v_pd_pers_zeit_kst_last          bde_pd_pers_zeit_kst%rowtype;

    v_pers_zeit_kst_tab              t_pers_zeit_kst;
    v_pers_zeit_kst_tab_empty        t_pers_zeit_kst;

    v_pers_zeit_kst_event            t_pers_zeit_event;
    v_pers_zeit_kst_event_empty      t_pers_zeit_event;

    max_idx                          number;
    idx                              number;
    idx_akt                          number;
    idx_start                        number;
    anz_event                        number;
    anz_change_event                 number;
    idx_event                        number;
    max_event                        number;
    idx_start_event                  number;


    CURSOR c_pd_pers_zeit_kst is
      select *
        from bde_pd_pers_zeit_kst t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and ((    t.pd_pers_beginn > in_pd_pres_beginn
               and t.pd_pers_beginn < in_pd_pres_ende
               and t.pd_pers_ende > in_pd_pres_beginn
              )
             or
             (    t.pd_pers_beginn < in_pd_pres_beginn
              and t.pd_pers_beginn > in_pd_pres_beginn - (1 / 24)
              and t.pd_pers_ende > in_pd_pres_beginn
             ))
         and t.pd_pers_ende != to_date('31.12.3000', 'dd.mm.yyyy')
       order by t.pers_nr, t.pd_pers_beginn;

    CURSOR c_pd_pers_zeit_event is
      select x.event_date
        from (
               (
                select t.pd_pers_beginn event_date
                   from bde_pd_pers_zeit_kst t
                  where t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and ((    t.pd_pers_beginn > in_pd_pres_beginn
                          and t.pd_pers_beginn < in_pd_pres_ende
                          and t.pd_pers_ende > in_pd_pres_beginn
                         )
                        or
                        (    t.pd_pers_beginn < in_pd_pres_beginn
                         and t.pd_pers_beginn > in_pd_pres_beginn - (1 / 24)
                         and t.pd_pers_ende > in_pd_pres_beginn
                        ))
                    and t.pd_pers_ende != to_date('31.12.3000', 'dd.mm.yyyy')
                    and t.pers_nr = v_pd_pers_zeit_kst_last.pers_nr
                )
                union all
                (
                 select t.pd_pers_ende event_date
                   from bde_pd_pers_zeit_kst t
                  where t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and ((    t.pd_pers_beginn > in_pd_pres_beginn
                          and t.pd_pers_beginn < in_pd_pres_ende
                          and t.pd_pers_ende > in_pd_pres_beginn
                         )
                        or
                        (    t.pd_pers_beginn < in_pd_pres_beginn
                         and t.pd_pers_beginn > in_pd_pres_beginn - (1 / 24)
                         and t.pd_pers_ende > in_pd_pres_beginn
                        ))
                    and t.pd_pers_ende != to_date('31.12.3000', 'dd.mm.yyyy')
                    and t.pers_nr = v_pd_pers_zeit_kst_last.pers_nr
                )
             ) x
             group by x.event_date
             order by x.event_date;

  begin
    idx := 0;
    max_idx := 0;
    v_pd_pers_zeit_kst_last := NULL;
    OPEN c_pd_pers_zeit_kst;
    LOOP
      FETCH c_pd_pers_zeit_kst into v_pd_pers_zeit_kst;

      if v_pd_pers_zeit_kst_last.pers_nr != v_pd_pers_zeit_kst.pers_nr
      or (    c_pd_pers_zeit_kst%NOTFOUND
          and v_pd_pers_zeit_kst_last.pers_nr is not NULL
         )
      then
        idx_event := 0;
        OPEN c_pd_pers_zeit_event;
        LOOP
          max_event := idx_event;
          idx_event := idx_event + 1;
          FETCH c_pd_pers_zeit_event into v_pers_zeit_kst_event(idx_event);
          EXIT when c_pd_pers_zeit_event%NOTFOUND;
        end LOOP;
        CLOSE c_pd_pers_zeit_event;

        idx_start_event := 1;
        anz_change_event := 0;
        idx_event := 1;
        idx := 1;
        idx_akt := idx;
        anz_event := 0;
        idx_start := 1;

        while (idx_event <= max_event)
        LOOP
          if idx_event > 1
          then
            idx := idx_start;
            anz_change_event := 0;
            while (idx <= max_idx)
            LOOP
              if v_pers_zeit_kst_tab(idx_start).pd_pers_ende <= v_pers_zeit_kst_event(idx_event)
              then
                idx_start := idx_start + 1;
              end if;
              if  v_pers_zeit_kst_tab(idx).pd_pers_beginn <= v_pers_zeit_kst_event(idx_event - 1)
              and v_pers_zeit_kst_tab(idx).pd_pers_ende >= v_pers_zeit_kst_event(idx_event)
              and anz_event > 0
              then
                v_pers_zeit_kst_tab(idx).pd_pers_zeit_anteil_min := v_pers_zeit_kst_tab(idx).pd_pers_zeit_anteil_min +
                                                                    ((v_pers_zeit_kst_event(idx_event) - v_pers_zeit_kst_event(idx_event - 1)) * 1440) / anz_event;
                                                                    NULL;
              end if;

              if  v_pers_zeit_kst_tab(idx).pd_pers_beginn = v_pers_zeit_kst_event(idx_event)
              then
                anz_event := anz_event + 1;
              end if;

              if  v_pers_zeit_kst_tab(idx).pd_pers_ende = v_pers_zeit_kst_event(idx_event)
              then
                anz_change_event := anz_change_event - 1;
              end if;

              if v_pers_zeit_kst_tab(idx).pd_pers_beginn > v_pers_zeit_kst_event(idx_event)
              then
                idx := max_idx;
              end if;
              idx := idx + 1;
            end LOOP;
          else
            anz_event := anz_event + 1;
          end if;
          idx_event := idx_event + 1;
          anz_event := anz_event + anz_change_event;
        end LOOP;

        idx := 1;
        while (idx <= max_idx)
        LOOP
          update bde_pd_pers_zeit_kst t
             set t.pd_pers_zeit_anteil_min = v_pers_zeit_kst_tab(idx).pd_pers_zeit_anteil_min
           where t.sid = v_pers_zeit_kst_tab(idx).sid
             and t.firma_nr = v_pers_zeit_kst_tab(idx).firma_nr
             and t.res_id = v_pers_zeit_kst_tab(idx).res_id
             and t.pers_nr = v_pers_zeit_kst_tab(idx).pers_nr
             and t.pd_pers_beginn = v_pers_zeit_kst_tab(idx).pd_pers_beginn;
          idx := idx + 1;
        end LOOP;
        v_pers_zeit_kst_tab := v_pers_zeit_kst_tab_empty;
        max_idx := 0;
        idx := 0;
      end if;

      exit when c_pd_pers_zeit_kst%NOTFOUND;

      max_idx := max_idx + 1;
      v_pd_pers_zeit_kst.pd_pers_zeit_anteil_min := 0;
      v_pers_zeit_kst_tab(max_idx) := v_pd_pers_zeit_kst;
      v_pd_pers_zeit_kst_last := v_pd_pers_zeit_kst;
    end LOOP;
    CLOSE c_pd_pers_zeit_kst;
    commit;
  end;

end BDE_P_PERS_ZEIT_KST;
/



-- sqlcl_snapshot {"hash":"2ee09059f463d2a38bb63a2cca6c5c9bbcc82a0a","type":"PACKAGE_BODY","name":"BDE_P_PERS_ZEIT_KST","schemaName":"DIRKSPZM32","sxml":""}