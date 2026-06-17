create or replace 
procedure DIRKSPZM32.pzm_konto_art_neu_alle_pers(in_name_kurz in varchar2) is
begin
  insert into pzm_konten
  select '01' sid,
         1 firma_nr,
         p.pers_nr,
         null konto_nr, --seq_pzm_konto_nr.nextval konto_nr,
         kc.name,
         kc.name_kurz,
         kc.typ,
         kc.buch_einheit,
         0 saldo,
         null letzte_buchung,
         null letzter_abschluss_am,
         null abschluss_saldo,
         null info,
         kc.def_max_saldo max_saldo,
         kc.def_min_saldo min_saldo,
         'T' aktiv,
         0
    from pzm_personal p,
         pzm_konten_cfg kc
   where kc.name_kurz = in_name_kurz
     and p.pers_nr not in (select t.pers_nr from pzm_konten t where t.name_kurz = in_name_kurz);

   commit;
end pzm_konto_art_neu_alle_pers;
/



-- sqlcl_snapshot {"hash":"eb612f014e3d8c535e5bd2c0188a373c5ec3a44f","type":"PROCEDURE","name":"PZM_KONTO_ART_NEU_ALLE_PERS","schemaName":"DIRKSPZM32","sxml":""}