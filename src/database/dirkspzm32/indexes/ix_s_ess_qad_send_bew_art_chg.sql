create index dirkspzm32.ix_s_ess_qad_send_bew_art_chg on
    dirkspzm32.s_essex_qad_send_bew (
        artikel,
        charge,
        aktion
    );


-- sqlcl_snapshot {"hash":"b5e9d45cc0667a0564200f494f3843c23035362a","type":"INDEX","name":"IX_S_ESS_QAD_SEND_BEW_ART_CHG","schemaName":"DIRKSPZM32","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>DIRKSPZM32</SCHEMA>\n   <NAME>IX_S_ESS_QAD_SEND_BEW_ART_CHG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>DIRKSPZM32</SCHEMA>\n         <NAME>S_ESSEX_QAD_SEND_BEW</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ARTIKEL</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>CHARGE</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AKTION</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}