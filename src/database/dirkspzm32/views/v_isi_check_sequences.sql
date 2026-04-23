create or replace force editionable view dirkspzm32.v_isi_check_sequences (
    table_name_,
    seq_name_,
    field_name_,
    "Kommentar_",
    seq_tab_werte
) as
    select
        check_table_name(upper(s."table_name_")) table_name_,
        upper(s."sequence_name_")                seq_name_,
        check_field_name(
            upper(s."table_name_"),
            upper(s."field_name_")
        )                                        field_name_,
        s."Kommentar_",
        isi_check_sequence(
            upper(s."sequence_name_"),
            get_max_index(
                upper(s."table_name_"),
                upper(s."field_name_")
            )
        )                                        seq_tab_werte
    from
        v_isi_tab_field_seq s
    order by
        s."table_name_" asc;


-- sqlcl_snapshot {"hash":"244c58ecedea48fc5f4f08c3f4a037ec5cb6f4a0","type":"VIEW","name":"V_ISI_CHECK_SEQUENCES","schemaName":"DIRKSPZM32","sxml":""}