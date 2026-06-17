create or replace 
procedure DIRKSPZM32.isi_index_rebuild(p_Mb_Max in number,p_Mb_Min in number) is


CURSOR c_Index IS
SELECT
       ivw01.segment_name
    --  ,ivw01.segment_type
    --  ,ivw01.partition_name
    --  ,ivw01.TABLESPACE_name
    --  ,ivw01.BLOCKS
    --  ,ivw01.Size_MByte
    --  ,CONCAT(CONCAT('ALTER INDEX ',ivw01.segment_name),' REBUILD;') RebuildString

 FROM
    (
     SELECT
       us.segment_name
     , us.partition_name
     , us.segment_type
     , (SUM(us.BYTES)/ 1024 / 1024) Size_MByte
     , us.blocks
     , us.tablespace_name
     FROM
       user_segments us
     WHERE 1=1
     GROUP BY us.segment_name
            , us.partition_name
            , segment_type
            , us.tablespace_name
            , us.blocks
     ORDER BY us.segment_name
            , us.partition_name
    )ivw01
WHERE 1=1
--AND ivw01.segment_name = UPPER('IX_PZM_KONTO_NR_ZK_START') -- Eine Spezielle Tabelle / Index betrachten
  and ivw01.segment_type = 'INDEX' -- Nur Index anzeigen
  and (Size_MByte <= p_Mb_Max or p_Mb_Max = 0)         -- alle die größer gleich als ...
  and (Size_MByte >= p_Mb_Min or p_Mb_Min = 0)         -- alle die kleiner gleich als ...
order by ivw01.segment_type,ivw01.Size_MByte DESC
;

  v_command   varchar2(255);


begin

 if isi_utils.Iso_WeekDay(sysdate) != 7 --'SONNTAG'
 then
    return;
 end if;

   -- MWe 20180313 Log Eintrag
  isi_p_log.isi_system_meldung('01',
                               1,
                               'isi_index_rebuild',
                               'ORA-DB',
                               'isi_index_rebuild',
                               null,
                               null,
                               -1,
                               null,
                               null,
                               'Start der Procedur.',
                               'I',
                               3);
 OPEN c_Index;
  LOOP
    FETCH c_Index INTO v_command;

    EXIT WHEN c_Index%NOTFOUND;

    begin
       -- dbms_output.put_line(v_command);   -Debug
       execute immediate 'ALTER INDEX '||v_command||' REBUILD';
    exception
      when others then
        NULL;
    end;
  END LOOP;

  CLOSE c_Index;

  isi_p_log.isi_system_meldung('01',
                               1,
                               'isi_index_rebuild',
                               'ORA-DB',
                               'isi_index_rebuild',
                               null,
                               null,
                               -1,
                               null,
                               null,
                               'Ende der Procedur.',
                               'I',
                               3);

end isi_index_rebuild;
/



-- sqlcl_snapshot {"hash":"1ecc38a9e37abc00d995dcb6f8024781d5f28f81","type":"PROCEDURE","name":"ISI_INDEX_REBUILD","schemaName":"DIRKSPZM32","sxml":""}