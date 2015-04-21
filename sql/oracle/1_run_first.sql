SET DEFINE ON;

DEFINE TM_WZ_SCHEMA='TM_WZ';
DEFINE TM_LZ_SCHEMA='TM_LZ';
DEFINE TM_CZ_SCHEMA='TM_CZ';

DROP INDEX "I2B2DEMODATA"."OF_CTX_BLOB";

CREATE INDEX "&TM_WZ_SCHEMA"."IDX_WTN_LOAD_CLINICAL" ON "&TM_WZ_SCHEMA"."WT_TRIAL_NODES"
  (
    "LEAF_NODE",
    "CATEGORY_CD",
    "DATA_LABEL"
  );
  
  
  
  CREATE INDEX "I2B2DEMODATA"."IDX_PD_SOURCESYSTEMCD_PNUM" ON "I2B2DEMODATA"."PATIENT_DIMENSION"
  (
    "SOURCESYSTEM_CD",
    "PATIENT_NUM"
  );
  
  
  CREATE INDEX "&TM_CZ_SCHEMA"."IDX_TMP_SUBJ_USUBJID" ON "&TM_CZ_SCHEMA"."TMP_SUBJECT_INFO"
  (
    "USUBJID"
  );
  
  CREATE INDEX "&TM_LZ_SCHEMA"."IDX_SCD_STUDY" ON "&TM_LZ_SCHEMA"."LT_SRC_CLINICAL_DATA"
  (
    "STUDY_ID"
  );
  
  
CREATE INDEX CZ_JOB_AUDIT_JOBID_DATE ON "&TM_CZ_SCHEMA".CZ_JOB_AUDIT (JOB_ID, JOB_DATE);
CREATE INDEX IX_DE_SUBJECT_SMPL_MPNG_MRNA ON DEAPP.DE_SUBJECT_SAMPLE_MAPPING (TRIAL_NAME, PLATFORM, SOURCE_CD, CONCEPT_CODE);
CREATE INDEX IX_I2B2_SOURCE_SYSTEM_CD ON I2B2METADATA.I2B2 (SOURCESYSTEM_CD);

ALTER TABLE "&TM_WZ_SCHEMA"."WRK_CLINICAL_DATA" CACHE;
ALTER TABLE "&TM_WZ_SCHEMA"."WRK_CLINICAL_DATA" NOLOGGING;

ALTER TABLE "&TM_LZ_SCHEMA"."LT_SRC_CLINICAL_DATA" CACHE;
ALTER TABLE "&TM_LZ_SCHEMA"."LT_SRC_CLINICAL_DATA" NOLOGGING;

-- TODO: already null?
ALTER TABLE i2b2demodata.observation_fact modify (instance_num null);

CREATE INDEX IDX_CCONCEPT_PATH ON i2b2demodata.CONCEPT_COUNTS (CONCEPT_PATH);

-- TODO: already exists?
CREATE INDEX IDX_I2B2_SECURE_FULLNAME ON I2B2METADATA.I2B2_SECURE (C_FULLNAME);

CREATE INDEX "I2B2METADATA"."IDX_I2B2_FULLNAME_BASECODE" ON "I2B2METADATA"."I2B2"
  (
    "C_FULLNAME",
    "C_BASECODE"
  );
  
DROP INDEX "&TM_WZ_SCHEMA".IDX_WT_TRIALNODES;
CREATE INDEX "&TM_WZ_SCHEMA"."IDX_WT_TRIALNODES" ON "&TM_WZ_SCHEMA"."WT_TRIAL_NODES"
  (
    "LEAF_NODE",
    "NODE_NAME"
  );
  
 CREATE INDEX "DEAPP"."IDX_DE_SUBJ_SMPL_TRIAL_CCODE" ON "DEAPP"."DE_SUBJECT_SAMPLE_MAPPING"
  (
    "TRIAL_NAME",
    "CONCEPT_CODE"
  );
  
  
  CREATE TABLE "&TM_WZ_SCHEMA"."I2B2_LOAD_PATH"
  (
    "PATH" VARCHAR2(700 BYTE),
    "RECORD_ID" ROWID,
    PRIMARY KEY ("PATH", "RECORD_ID")
  )  
  ORGANIZATION INDEX NOLOGGING;
  
  
  CREATE TABLE "&TM_WZ_SCHEMA"."I2B2_LOAD_TREE_FULL"
  (
    "IDROOT"          ROWID,
    "IDCHILD"         ROWID,
	  PRIMARY KEY("IDROOT", "IDCHILD")
  )  
  ORGANIZATION INDEX NOLOGGING;

  create or replace synonym "&TM_CZ_SCHEMA"."I2B2_LOAD_TREE_FULL" for "&TM_WZ_SCHEMA"."I2B2_LOAD_TREE_FULL";
  create or replace synonym "&TM_CZ_SCHEMA"."I2B2_LOAD_PATH" for "&TM_WZ_SCHEMA"."I2B2_LOAD_PATH";

  grant all privileges on "&TM_WZ_SCHEMA"."I2B2_LOAD_TREE_FULL" to "&TM_CZ_SCHEMA";
  grant all privileges on "&TM_WZ_SCHEMA"."I2B2_LOAD_PATH" to "&TM_CZ_SCHEMA";
  
---------------------------------------------

DROP TABLE "&TM_WZ_SCHEMA".I2B2_LOAD_PATH_WITH_COUNT;
 
CREATE TABLE "&TM_WZ_SCHEMA"."I2B2_LOAD_PATH_WITH_COUNT"
  (
    "C_FULLNAME"          VARCHAR2(700 BYTE),
    "NBR_CHILDREN"         NUMBER,
    PRIMARY KEY(C_FULLNAME)
  )  
  ORGANIZATION INDEX NOLOGGING;
  
grant all privileges on "&TM_WZ_SCHEMA"."I2B2_LOAD_PATH_WITH_COUNT" to "&TM_CZ_SCHEMA";
create or replace synonym "&TM_CZ_SCHEMA"."I2B2_LOAD_PATH_WITH_COUNT" for "&TM_WZ_SCHEMA"."I2B2_LOAD_PATH_WITH_COUNT";

---- DEC 4, 2013 CHANGES --------------------

DROP INDEX "I2B2DEMODATA"."IDX_OB_FACT_PATIENT_NUMBER";
CREATE INDEX "I2B2DEMODATA"."IDX_OB_FACT_PATIENT_NUMBER" ON "I2B2DEMODATA"."OBSERVATION_FACT" ("PATIENT_NUM", "CONCEPT_CD");

CREATE INDEX "&TM_WZ_SCHEMA"."IDX_WRK_CD" ON "&TM_WZ_SCHEMA"."WRK_CLINICAL_DATA" (DATA_TYPE ASC, DATA_VALUE ASC, VISIT_NAME ASC, DATA_LABEL ASC, CATEGORY_CD ASC, USUBJID ASC);

--- JUL 23, 2014 CHANGES --------------------

CREATE TABLE "&TM_LZ_SCHEMA"."LT_SNP_CALLS_BY_GSM"
(
  "GSM_NUM" VARCHAR2(100 BYTE),
	"SNP_NAME" VARCHAR2(100 BYTE),
	"SNP_CALLS" VARCHAR2(4 BYTE)
) NOLOGGING;

CREATE TABLE "&TM_LZ_SCHEMA"."LT_SNP_COPY_NUMBER"
(
	"SNP_NAME" VARCHAR2(50 BYTE),
	"CHROM" VARCHAR2(2 BYTE),
	"CHROM_POS" NUMBER(20,0),
	"COPY_NUMBER" FLOAT(53),
  "GSM_NUM" VARCHAR(100 byte)
) NOLOGGING;

CREATE TABLE "&TM_LZ_SCHEMA"."LT_SNP_GENE_MAP"
(
	"SNP_NAME" VARCHAR2(256 BYTE),
	"ENTREZ_GENE_ID" NUMBER
) NOLOGGING;

create index QT_PATIENT_SET_COLLECTION_IDX1 on I2B2DEMODATA.QT_PATIENT_SET_COLLECTION(RESULT_INSTANCE_ID, PATIENT_NUM);

create index bio_marker_correl_mv_abm_idx on BIOMART.bio_marker_correl_mv(asso_bio_marker_id);

create index search_keyword_uid_idx on searchapp.search_keyword(unique_id);

create index DE_SNP_CALLS_BY_GSM_PN_GN_IDX on deapp.de_snp_calls_by_gsm(patient_num, gsm_num);

create index de_snp_calls_by_gsm_sn_nm_idx on deapp.de_snp_calls_by_gsm(snp_name);

CREATE INDEX IDX_DE_CHROMOSAL_REGION ON DEAPP.de_chromosomal_region (GPL_ID, GENE_SYMBOL);

--------------------------------------------------------
--  DDL for Table DE_VARIANT_DATASET
--------------------------------------------------------

  CREATE TABLE "DEAPP"."DE_VARIANT_DATASET"
   (	"DATASET_ID" VARCHAR2(50 BYTE),
	"DATASOURCE_ID" VARCHAR2(200 BYTE),
	"ETL_ID" VARCHAR2(20 BYTE),
	"ETL_DATE" DATE,
	"GENOME" VARCHAR2(50 BYTE),
	"METADATA_COMMENT" CLOB,
	"VARIANT_DATASET_TYPE" VARCHAR2(50 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
 LOB ("METADATA_COMMENT") STORE AS BASICFILE (
  ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)) ;
--------------------------------------------------------
--  DDL for Table DE_VARIANT_SUBJECT_DETAIL
--------------------------------------------------------
CREATE SEQUENCE deapp.DE_VARIANT_SUBJECT_DETAIL_seq
      START WITH 1
      INCREMENT BY 1
      NOMINVALUE
      NOMAXVALUE
      CACHE 2;

  CREATE TABLE "DEAPP"."DE_VARIANT_SUBJECT_DETAIL"
   (	"VARIANT_SUBJECT_DETAIL_ID" NUMBER(9,0),
	"DATASET_ID" VARCHAR2(50 BYTE),
	"CHR" VARCHAR2(50 BYTE),
	"POS" NUMBER(20,0),
	"RS_ID" VARCHAR2(50 BYTE),
	"REF" VARCHAR2(100 BYTE),
	"ALT" VARCHAR2(100 BYTE),
	"QUAL" VARCHAR2(100 BYTE),
	"FILTER" VARCHAR2(50 BYTE),
	"INFO" VARCHAR2(2000 BYTE),
	"FORMAT" VARCHAR2(50 BYTE),
	"VARIANT_VALUE" CLOB
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
 LOB ("VARIANT_VALUE") STORE AS BASICFILE (
  ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT))
  CACHE ;

CREATE OR REPLACE TRIGGER deapp.DE_VAR_SUB_DETAIL_incr
	BEFORE INSERT ON deapp.DE_VARIANT_SUBJECT_DETAIL
	FOR EACH ROW

	BEGIN
	  SELECT deapp.DE_VARIANT_SUBJECT_DETAIL_seq.NEXTVAL
	  INTO   :new.VARIANT_SUBJECT_DETAIL_ID
	  FROM   dual;
	END;
	/
--------------------------------------------------------
--  DDL for Table DE_VARIANT_SUBJECT_IDX
--------------------------------------------------------
CREATE SEQUENCE deapp.DE_VARIANT_SUBJECT_IDX_seq
      START WITH 1
      INCREMENT BY 1
      NOMINVALUE
      NOMAXVALUE
      CACHE 2;

  CREATE TABLE "DEAPP"."DE_VARIANT_SUBJECT_IDX"
   (	"DATASET_ID" VARCHAR2(50 BYTE),
	"SUBJECT_ID" VARCHAR2(50 BYTE),
	"POSITION" NUMBER(10,0),
	"VARIANT_SUBJECT_IDX_ID" NUMBER(18,0)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);

CREATE OR REPLACE TRIGGER deapp.de_var_sub_idx_incr
	BEFORE INSERT ON deapp.DE_VARIANT_SUBJECT_IDX
	FOR EACH ROW

	BEGIN
	  SELECT deapp.de_variant_population_info_seq.NEXTVAL
	  INTO   :new.VARIANT_SUBJECT_IDX_ID
	  FROM   dual;
	END;
	/
--------------------------------------------------------
--  DDL for Table DE_VARIANT_SUBJECT_SUMMARY
--------------------------------------------------------
CREATE SEQUENCE deapp.de_variant_subject_summary_seq
      START WITH 1
      INCREMENT BY 1
      NOMINVALUE
      NOMAXVALUE
      CACHE 2;

  CREATE TABLE "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY"
   (	"VARIANT_SUBJECT_SUMMARY_ID" NUMBER(9,0),
	"CHR" VARCHAR2(50 BYTE),
	"POS" NUMBER(20,0),
	"DATASET_ID" VARCHAR2(50 BYTE),
	"SUBJECT_ID" VARCHAR2(50 BYTE),
	"RS_ID" VARCHAR2(50 BYTE),
	"VARIANT" VARCHAR2(100 BYTE),
	"VARIANT_FORMAT" VARCHAR2(100 BYTE),
	"VARIANT_TYPE" VARCHAR2(100 BYTE),
	"REFERENCE" VARCHAR2(100),
        "ALLELE1" integer,
        "ALLELE2" integer,
        "ASSAY_ID" NUMBER(10,0)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);

CREATE OR REPLACE TRIGGER deapp.de_var_sub_summary_incr
	BEFORE INSERT ON  "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY"
	FOR EACH ROW

	BEGIN
	  SELECT deapp.de_variant_subject_summary_seq.NEXTVAL
	  INTO   :new.VARIANT_SUBJECT_SUMMARY_ID
	  FROM   dual;
	END;
	/
--------------------------------------------------------
--  DDL for Index DE_VARIANT_DATASET_I_DS_ID
--------------------------------------------------------

  CREATE UNIQUE INDEX "DEAPP"."DE_VARIANT_DATASET_I_DS_ID" ON "DEAPP"."DE_VARIANT_DATASET" ("DATASET_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);
--------------------------------------------------------
--  DDL for Index DE_VARIANT_SUB_DT_IDX1
--------------------------------------------------------

  CREATE INDEX "DEAPP"."DE_VARIANT_SUB_DT_IDX1" ON "DEAPP"."DE_VARIANT_SUBJECT_DETAIL" ("DATASET_ID", "RS_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);
--------------------------------------------------------
--  DDL for Index DE_VARIANT_SUB_DETAIL_IDX2
--------------------------------------------------------

  CREATE INDEX "DEAPP"."DE_VARIANT_SUB_DETAIL_IDX2" ON "DEAPP"."DE_VARIANT_SUBJECT_DETAIL" ("DATASET_ID", "CHR")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);

--------------------------------------------------------
--  DDL for Index DE_VSD_I_VSD_ID
--------------------------------------------------------

  CREATE UNIQUE INDEX "DEAPP"."DE_VSD_I_VSD_ID" ON "DEAPP"."DE_VARIANT_SUBJECT_DETAIL" ("VARIANT_SUBJECT_DETAIL_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);

--------------------------------------------------------
--  DDL for Index VARIANT_SUBJECT_DETAIL_UK
--------------------------------------------------------

  CREATE INDEX "DEAPP"."VARIANT_SUBJECT_DETAIL_UK" ON "DEAPP"."DE_VARIANT_SUBJECT_DETAIL" ("DATASET_ID", "CHR", "POS", "RS_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);

--------------------------------------------------------
--  DDL for Index VARIANT_SUBJECT_IDX_UK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DEAPP"."VARIANT_SUBJECT_IDX_UK" ON "DEAPP"."DE_VARIANT_SUBJECT_IDX" ("DATASET_ID", "SUBJECT_ID", "POSITION")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);

--------------------------------------------------------
--  DDL for Index DE_VSS_I_VSS_ID
--------------------------------------------------------

  CREATE UNIQUE INDEX "DEAPP"."DE_VSS_I_VSS_ID" ON "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY" ("VARIANT_SUBJECT_SUMMARY_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);
--------------------------------------------------------
--  DDL for Index VARIANT_SUBJECT_SUMMARY_UK
--------------------------------------------------------

  CREATE INDEX "DEAPP"."VARIANT_SUBJECT_SUMMARY_UK" ON "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY" ("DATASET_ID", "CHR", "POS", "RS_ID", "SUBJECT_ID")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT);

--------------------------------------------------------
--  Constraints for Table DE_VARIANT_DATASET
--------------------------------------------------------

  ALTER TABLE "DEAPP"."DE_VARIANT_DATASET" MODIFY ("GENOME" NOT NULL ENABLE);

  ALTER TABLE "DEAPP"."DE_VARIANT_DATASET" ADD PRIMARY KEY ("DATASET_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  ENABLE;
--------------------------------------------------------
--  Constraints for Table DE_VARIANT_SUBJECT_DETAIL
--------------------------------------------------------

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_DETAIL" ADD PRIMARY KEY ("VARIANT_SUBJECT_DETAIL_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  ENABLE;

--------------------------------------------------------
--  Constraints for Table DE_VARIANT_SUBJECT_IDX
--------------------------------------------------------

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_IDX" ADD CONSTRAINT "VARIANT_SUBJECT_IDX_UK" UNIQUE ("DATASET_ID", "SUBJECT_ID", "POSITION")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  ENABLE;
--------------------------------------------------------
--  Constraints for Table DE_VARIANT_SUBJECT_SUMMARY
--------------------------------------------------------

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY" MODIFY ("DATASET_ID" NOT NULL ENABLE);

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY" MODIFY ("SUBJECT_ID" NOT NULL ENABLE);

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY" ADD PRIMARY KEY ("VARIANT_SUBJECT_SUMMARY_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  ENABLE;

--------------------------------------------------------
--  Ref Constraints for Table DE_VARIANT_SUBJECT_DETAIL
--------------------------------------------------------

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_DETAIL" ADD CONSTRAINT "VARIANT_SUBJECT_DETAIL_FK" FOREIGN KEY ("DATASET_ID")
	  REFERENCES "DEAPP"."DE_VARIANT_DATASET" ("DATASET_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table DE_VARIANT_SUBJECT_IDX
--------------------------------------------------------

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_IDX" ADD CONSTRAINT "VARIANT_SUBJECT_IDX_FK" FOREIGN KEY ("DATASET_ID")
	  REFERENCES "DEAPP"."DE_VARIANT_DATASET" ("DATASET_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table DE_VARIANT_SUBJECT_SUMMARY
--------------------------------------------------------

  ALTER TABLE "DEAPP"."DE_VARIANT_SUBJECT_SUMMARY" ADD CONSTRAINT "VARIANT_SUBJECT_SUMMARY_FK" FOREIGN KEY ("DATASET_ID")
	  REFERENCES "DEAPP"."DE_VARIANT_DATASET" ("DATASET_ID") ENABLE;

CREATE SEQUENCE deapp.de_variant_population_data_seq
      START WITH 1
      INCREMENT BY 1
      NOMINVALUE
      NOMAXVALUE
      CACHE 2;

  --
  -- Name: deapp.de_variant_population_data; Type: TABLE; Schema: deapp; Owner: -
  --
  CREATE TABLE deapp.de_variant_population_data (
      VARIANT_POPULATION_DATA_ID NUMBER(10,0),
      DATASET_ID varchar2(50),
      CHR varchar2(50),
      POS  NUMBER(10,0),
      INFO_NAME varchar2(100),
      INFO_INDEX integer DEFAULT 0,
      INTEGER_VALUE NUMBER(10,0),
      FLOAT_VALUE double precision,
      TEXT_VALUE CLOB
  );


CREATE OR REPLACE TRIGGER deapp.de_var_pop_data_incr
BEFORE INSERT ON deapp.de_variant_population_data
FOR EACH ROW

BEGIN
  SELECT deapp.de_variant_population_data_seq.NEXTVAL
  INTO   :new.variant_population_data_id
  FROM   dual;
END;
/
--
  -- Name: deapp.de_variant_population_data_id_idx; Type: CONSTRAINT; Schema: deapp; Owner: -
  --
  ALTER TABLE deapp.de_variant_population_data
      ADD CONSTRAINT de_var_pop_data_id_idx PRIMARY KEY (variant_population_data_id);

  --
  -- Name: de_variant_population_data_default_idx; Type: INDEX; Schema: deapp; Owner: -
  --
  CREATE INDEX de_var_pop_data_default_idx ON deapp.de_variant_population_data(dataset_id, chr, pos, info_name);

  --
  -- Name: de_variant_population_data_fk; Type: FK CONSTRAINT; Schema: deapp; Owner: -
  --
  ALTER TABLE deapp.de_variant_population_data
      ADD CONSTRAINT de_variant_population_data_fk FOREIGN KEY (dataset_id) REFERENCES deapp.de_variant_dataset(dataset_id);
--
  -- Name: deapp.de_variant_population_info_seq; Type: SEQUENCE; Schema: deapp; Owner: -
  --
  CREATE SEQUENCE deapp.de_variant_population_info_seq
      START WITH 1
      INCREMENT BY 1
      NOMINVALUE
      NOMAXVALUE
      CACHE 2;

  --
  -- Name: deapp.de_variant_population_info; Type: TABLE; Schema: deapp; Owner: -
  --
  CREATE TABLE deapp.de_variant_population_info (
      "VARIANT_POPULATION_INFO_ID" number(10,0),
      "DATASET_ID" varchar2(50),
      "INFO_NAME" varchar2(100),
      "DESCRIPTION" clob,
      "TYPE" varchar2(30),
      "NUMBER" varchar2(10)
  );

	CREATE OR REPLACE TRIGGER deapp.de_var_pop_info_incr
	BEFORE INSERT ON deapp.de_variant_population_info
	FOR EACH ROW

	BEGIN
	  SELECT deapp.de_variant_population_info_seq.NEXTVAL
	  INTO   :new.variant_population_info_id
	  FROM   dual;
	END;
	/

  ALTER TABLE deapp.de_variant_population_info
      ADD CONSTRAINT de_var_pop_info_id_idx PRIMARY KEY (variant_population_info_id);

  --
  -- Name: variant_population_info_dataset_name; Type: INDEX; Schema: deapp; Owner: -
  --
  CREATE INDEX variant_pop_info_dataset_name ON deapp.de_variant_population_info(dataset_id, info_name);

  --
  -- Name: de_variant_population_info_fk; Type: FK CONSTRAINT; Schema: deapp; Owner: -
  --
  ALTER TABLE deapp.de_variant_population_info
      ADD CONSTRAINT de_variant_population_info_fk FOREIGN KEY (dataset_id) REFERENCES deapp.de_variant_dataset(dataset_id);
/
ALTER TABLE tm_lz.lt_src_deapp_annot
   modify gene_symbol character varying(400 byte);

ALTER TABLE tm_cz.annotation_deapp
   modify gene_symbol character varying(400 byte);

ALTER TABLE deapp.de_mrna_annotation
   modify gene_symbol character varying(400 byte);

ALTER TABLE tm_lz.lt_src_deapp_annot
   modify probe_id character varying(200 byte);

ALTER TABLE tm_cz.annotation_deapp
   modify probe_id character varying(200 byte);

ALTER TABLE deapp.de_mrna_annotation
   modify probe_id character varying(200 byte);
/
