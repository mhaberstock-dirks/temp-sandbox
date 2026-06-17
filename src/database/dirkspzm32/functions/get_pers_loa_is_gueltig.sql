create or replace function dirkspzm32.get_pers_loa_is_gueltig (
    in_pers_nr     in pzm_personal.pers_nr%type,
    in_lz_id       in pzm_lohnarten.lz_id%type,
    in_sa_kurzname in pzm_schichtarten.sa_kurzname%type
) return number is

    v_gueltig        boolean;
    v_gueltigx       boolean;
    v_gueltig_ret    number;
    v_tarif_name     pzm_tarifmodelle.tarif_name%type;
    v_kst_id         pzm_personal.pers_kst_id%type;
    v_pzm_lz_tarif   pzm_lz_tarifmodelle%rowtype;
    v_isi_pzm_lz_kst pzm_lz_kst%rowtype;
    v_isi_pzm_lz_sa  pzm_lz_sa%rowtype;

  --------------------
    cursor c_lztarif is
    select
        *
    from
        pzm_lz_tarifmodelle t
    where
        t.lz_id = in_lz_id;
  --------------------
    cursor c_lzsa is
    select
        *
    from
        pzm_lz_sa
    where
        lzsa_lz_id = in_lz_id;
  --------------------
    cursor c_lzkst is
    select
        *
    from
        pzm_lz_kst
    where
        lzkst_lz_id = in_lz_id;
  --------------------
    cursor c_pers is
    select
        t.tarif_name
    from
        pzm_personal t
    where
        t.pers_nr = in_pers_nr;

begin
    open c_pers;
    fetch c_pers into v_tarif_name;
    close c_pers;
    v_kst_id := get_pers_kst_id(in_pers_nr);
    v_gueltig := true;
    if v_gueltig = true then
        open c_lztarif;
        loop
            fetch c_lztarif into v_pzm_lz_tarif;
      -- Wenn kein Eintrag vorhanden, dann gilt diese Lohnart fuer all Schichten
            exit when c_lztarif%notfound;

      -- Eintrag vorhanden, dann erst mal ungültig
            if c_lztarif%rowcount = 1 then
                v_gueltig := false;
            end if;

      -- Ein Eintrag mit gültig gefunden, dann nur noch Gültig wenn Eintrag genau für diese Schicht
            if v_pzm_lz_tarif.lz_gueltig = 1 then
                v_gueltigx := false;
                v_gueltig := false;
            end if;

      -- Wenn der Passende Tarif gefunden wurde und fuer diesen Tarif des Status
      -- GUELTIG gesetzt ist, dann ist diese Lohnart immer noch gültig.
            if
                v_tarif_name = v_pzm_lz_tarif.tarif_name
                and v_pzm_lz_tarif.lz_gueltig = 1
            then
                v_gueltig := true;
                exit;
            end if;

      -- Wenn der Passende Tarif gefunden wurde und fuer diesen Tarif des Status
      -- UNGUELTIG gesetzt ist, dann ist diese Lohnart ungültig.
            if
                v_tarif_name = v_pzm_lz_tarif.tarif_name
                and v_pzm_lz_tarif.lz_gueltig = 0
            then
                v_gueltig := false;
                exit;
            end if;

      -- Ein Entrag mit UNGUELTIG fuer einen anderen Tarif gefunden,
      -- dann erst mal wieder auf gueltig stellen
            if
                v_tarif_name = v_pzm_lz_tarif.tarif_name
                and v_pzm_lz_tarif.lz_gueltig = 0
            then
                v_gueltig := v_gueltigx;
            end if;

        end loop;

        close c_lztarif;
    end if;
        
  -- Jede gefundene Lohnart ist gueltig, wenn LoaZeit in der Schichtzeit !!!!
    v_gueltigx := true;
    if
        v_gueltig = true
        and in_sa_kurzname is not null
    then
        open c_lzsa;
        loop
            fetch c_lzsa into v_isi_pzm_lz_sa;
      -- Wenn kein Eintrag vorhanden, dann gilt diese Lohnart fuer all Schichten
            exit when c_lzsa%notfound;

      -- Eintrag vorhanden, dann erst mal ungültig
            if c_lzsa%rowcount = 1 then
                v_gueltig := false;
            end if;

      -- Ein Eintrag mit gültig gefunden, dann nur noch Gültig wenn Eintrag genau für diese Schicht
            if v_isi_pzm_lz_sa.lzsa_gueltig = 1 then
                v_gueltigx := false;
                v_gueltig := false;
            end if;

      -- Wenn die Passende Schicht gefunden wurde und fuer diesen Eintrag des Status
      -- GUELTIG gesetzt ist, dann ist diese Lohnart immer noch gültig.
            if
                v_isi_pzm_lz_sa.lzsa_sa_kurzname = in_sa_kurzname
                and v_isi_pzm_lz_sa.lzsa_gueltig = 1
            then
                v_gueltig := true;
                exit;
            end if;

      -- Wenn die Passende Schicht gefunden wurde und fuer diesen Eintrag des Status
      -- UNGUELTIG gesetzt ist, dann ist diese Lohnart ungültig.
            if
                v_isi_pzm_lz_sa.lzsa_sa_kurzname = in_sa_kurzname
                and v_isi_pzm_lz_sa.lzsa_gueltig = 0
            then
                v_gueltig := false;
                exit;
            end if;

      -- Ein Entrag mit UNGUELTIG fuer eine andere Schicht gefunden,
      -- dann erst mal wieder auf gueltig stellen
            if
                v_isi_pzm_lz_sa.lzsa_sa_kurzname != in_sa_kurzname
                and v_isi_pzm_lz_sa.lzsa_gueltig = 0
            then
                v_gueltig := v_gueltigx;
            end if;

        end loop;

        close c_lzsa;

    -- Lohnart ist gueltig fuer diese KST!!
        v_gueltigx := true;
        if v_gueltig = true then
            open c_lzkst;
            loop
                fetch c_lzkst into v_isi_pzm_lz_kst;

        -- Wenn kein Eintrag vorhanden, dann gilt diese Lohnart fuer all Abteilungen
                exit when c_lzkst%notfound;

        -- Eintrag vorhanden, dann erst mal ungültig
                if c_lzkst%rowcount = 1 then
                    v_gueltig := false;
                end if;

        -- Ein Eintrag mit gültig gefunden, dann nur noch Gültig wenn Eintrag genau für diese Abteilung
                if v_isi_pzm_lz_kst.lzkst_gueltig = 1 then
                    v_gueltigx := false;
                    v_gueltig := false;
                end if;

        -- Wenn die Passende Abteilung gefunden wurde und fuer diesen Eintrag des Status
        -- GUELTIG gesetzt ist, dann ist diese Lohnart immer noch gültig.
                if
                    v_isi_pzm_lz_kst.lzkst_abt_kst = v_kst_id
                    and v_isi_pzm_lz_kst.lzkst_gueltig = 1
                then
                    v_gueltig := true;
                    exit;
                end if;

        -- Wenn die Passende Abteilung gefunden wurde und fuer diesen Eintrag des Status
        -- UNGUELTIG gesetzt ist, dann ist diese Lohnart ungültig.
                if
                    v_isi_pzm_lz_kst.lzkst_abt_kst = v_kst_id
                    and v_isi_pzm_lz_kst.lzkst_gueltig = 0
                then
                    v_gueltig := false;
                    exit;
                end if;

        -- Ein Entrag mit UNGUELTIG fuer eine andere Abteilung gefunden,
        -- dann erst mal wieder auf gueltig? stellen
                if
                    v_isi_pzm_lz_kst.lzkst_abt_kst != v_kst_id
                    and v_isi_pzm_lz_kst.lzkst_gueltig = 0
                then
                    v_gueltig := v_gueltigx;
                end if;

            end loop;

            close c_lzkst;
        end if;

    end if;

    if v_gueltig then
        v_gueltig_ret := 1;
    else
        v_gueltig_ret := 0;
    end if;
    return v_gueltig_ret;
end get_pers_loa_is_gueltig;
/


-- sqlcl_snapshot {"hash":"66f7bc6ac50c3685de6793b1ceac04c45d7d8ee1","type":"FUNCTION","name":"GET_PERS_LOA_IS_GUELTIG","schemaName":"DIRKSPZM32","sxml":""}