package com.thomsonreuters.lsps.transmart.etl

import groovy.sql.BatchingPreparedStatementWrapper
import groovy.sql.Sql

/**
 * Created by bondarev on 4/7/14.
 */
class SamplesLoader {
    String loadSchema = "tm_lz"
    String trialId
    List<List> samples = []

    SamplesLoader(String trialId) {
        this.trialId = trialId
    }

    void addSample(Map<String, Object> attrs = [:],
                   String categoryCd, String subjectId, String sampleCd, String platform) {
        samples << [trialId, attrs.siteId ?: '', subjectId, sampleCd, platform ?: '',
                    attrs.tissueType ?: 'Unknown', attrs.attr1 ?: '', attrs.attr2 ?: '',
                    categoryCd, attrs.sourceCd ?: 'STD']
    }

    void loadSamples(Sql sql) {
        sql.execute("delete from ${loadSchema}.lt_src_mrna_subj_samp_map")
        sql.withBatch(
                """
                INSERT into ${loadSchema}.lt_src_mrna_subj_samp_map
                (TRIAL_NAME, SITE_ID, SUBJECT_ID, SAMPLE_CD, PLATFORM, TISSUE_TYPE,
                 ATTRIBUTE_1, ATTRIBUTE_2, CATEGORY_CD, SOURCE_CD)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """
        ) { BatchingPreparedStatementWrapper batch ->
            samples.each { batch.addBatch(it) }
        }
    }
}
