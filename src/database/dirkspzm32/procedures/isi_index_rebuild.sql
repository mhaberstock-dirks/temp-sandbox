create or replace procedure dirkspzm32.isi_index_rebuild (
    p_mb_max in number,
    p_mb_min in number
) is

    cursor c_index is
    select
        ivw01.segment_name
    --  ,ivw01.segment_type
    --  ,ivw01.partition_name
    --  ,ivw01.TABLESPACE_name
    --  ,ivw01.BLOCKS
    --  ,ivw01.Size_MByte
    --  ,CONCAT(CONCAT('ALTER INDEX ',ivw01.segment_name),' REBUILD;') RebuildString
    from
        (
            select
                us.segment_name,
                us.partition_name,
                us.segment_type,
                ( sum(us.bytes) / 1024 / 1024 ) size_mbyte,
                us.blocks,
                us.tablespace_name
            from
                user_segments us
            where
                1 = 1
            group by
                us.segment_name,
                us.partition_name,
                segment_type,
                us.tablespace_name,
                us.blocks
            order by
                us.segment_name,
                us.partition_name
        ) ivw01
    where
            1 = 1
--AND ivw01.segment_name = UPPER('IX_PZM_KONTO_NR_ZK_START') -- Eine Spezielle Tabelle / Index betrachten
        and ivw01.segment_type = 'INDEX' -- Nur Index anzeigen
        and ( size_mbyte <= p_mb_max
              or p_mb_max = 0 )         -- alle die größer gleich als ...
        and ( size_mbyte >= p_mb_min
              or p_mb_min = 0 )         -- alle die kleiner gleich als ...
    order by
        ivw01.segment_type,
        ivw01.size_mbyte desc;

    v_command varchar2(255);
begin
    if isi_utils.iso_weekday(sysdate) != 7 --'SONNTAG'
     then
        return;
    end if;

   -- MWe 20180313 Log Eintrag
    isi_p_log.isi_system_meldung('01', 1, 'isi_index_rebuild', 'ORA-DB', 'isi_index_rebuild',
                                 null, null, -1, null, null,
                                 'Start der Procedur.', 'I', 3);

    open c_index;
    loop
        fetch c_index into v_command;
        exit when c_index%notfound;
        begin
       -- dbms_output.put_line(v_command);   -Debug
            execute immediate 'ALTER INDEX '
                              || v_command
                              || ' REBUILD';
        exception
            when others then
                null;
        end;

    end loop;

    close c_index;
    isi_p_log.isi_system_meldung('01', 1, 'isi_index_rebuild', 'ORA-DB', 'isi_index_rebuild',
                                 null, null, -1, null, null,
                                 'Ende der Procedur.', 'I', 3);

end isi_index_rebuild;
/


-- sqlcl_snapshot {"hash":"386f7341aa304a77c5050cb96dcf297bd13b0c3b","type":"PROCEDURE","name":"ISI_INDEX_REBUILD","schemaName":"DIRKSPZM32","sxml":""}