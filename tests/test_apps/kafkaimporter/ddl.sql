-- This is the import table into which a single value will be pushed by kafkaimporter.

-- file -inlinebatch END_OF_BATCH

------- kafka Importer Table -------
CREATE TABLE importtable
     (
                  KEY   BIGINT NOT NULL ,
                  value BIGINT NOT NULL ,
                  insert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                  CONSTRAINT pk_importtable PRIMARY KEY ( KEY )
     );
-- Partition on id
PARTITION TABLE importtable ON COLUMN KEY;

------- Kafka Importer Tables -------
CREATE TABLE kafkaimporttable1
     (
                  KEY   BIGINT NOT NULL,
                  value BIGINT NOT NULL,
                  insert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                  CONSTRAINT pk_kafka_import_table1 PRIMARY KEY ( KEY )
     );
-- Partition on id
PARTITION TABLE kafkaimporttable1 ON COLUMN KEY;

CREATE TABLE kafkaimporttable2
    (
          txnid                     BIGINT        NOT NULL
        , rowid                     BIGINT        NOT NULL
        , rowid_group               TINYINT       NOT NULL
        , type_null_tinyint         TINYINT
        , type_not_null_tinyint     TINYINT       NOT NULL
        , type_null_smallint        SMALLINT
        , type_not_null_smallint    SMALLINT      NOT NULL
        , type_null_integer         INTEGER
        , type_not_null_integer     INTEGER       NOT NULL
        , type_null_bigint          BIGINT
        , type_not_null_bigint      BIGINT        NOT NULL
        , type_null_timestamp       TIMESTAMP
        , type_not_null_timestamp   TIMESTAMP     NOT NULL
        , type_null_float           FLOAT
        , type_not_null_float       FLOAT         NOT NULL
        , type_null_decimal         DECIMAL
        , type_not_null_decimal     DECIMAL       NOT NULL
        , type_null_varchar25       VARCHAR(32)
        , type_not_null_varchar25   VARCHAR(32)   NOT NULL
        , type_null_varchar128      VARCHAR(128)
        , type_not_null_varchar128  VARCHAR(128)  NOT NULL
        , type_null_varchar1024     VARCHAR(1024)
        , type_not_null_varchar1024 VARCHAR(1024) NOT NULL
    );
PARTITION TABLE kafkaimporttable2 ON COLUMN rowid;

CREATE TABLE kafkamirrortable1
     (
                  KEY   BIGINT NOT NULL ,
                  value BIGINT NOT NULL ,
                  insert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                  CONSTRAINT pk_kafkamirrortable PRIMARY KEY ( KEY )
     );

-- Partition on id
PARTITION TABLE kafkamirrortable1 ON COLUMN KEY;

CREATE TABLE kafkamirrortable2
    (
          txnid                     BIGINT        NOT NULL
        , rowid                     BIGINT        NOT NULL
        , rowid_group               TINYINT       NOT NULL
        , type_null_tinyint         TINYINT
        , type_not_null_tinyint     TINYINT       NOT NULL
        , type_null_smallint        SMALLINT
        , type_not_null_smallint    SMALLINT      NOT NULL
        , type_null_integer         INTEGER
        , type_not_null_integer     INTEGER       NOT NULL
        , type_null_bigint          BIGINT
        , type_not_null_bigint      BIGINT        NOT NULL
        , type_null_timestamp       TIMESTAMP
        , type_not_null_timestamp   TIMESTAMP     NOT NULL
        , type_null_float           FLOAT
        , type_not_null_float       FLOAT         NOT NULL
        , type_null_decimal         DECIMAL
        , type_not_null_decimal     DECIMAL       NOT NULL
        , type_null_varchar25       VARCHAR(32)
        , type_not_null_varchar25   VARCHAR(32)   NOT NULL
        , type_null_varchar128      VARCHAR(128)
        , type_not_null_varchar128  VARCHAR(128)  NOT NULL
        , type_null_varchar1024     VARCHAR(1024)
        , type_not_null_varchar1024 VARCHAR(1024) NOT NULL
    );
PARTITION TABLE kafkamirrortable2 ON COLUMN rowid;

-- Export table
CREATE TABLE kafkaexporttable1
     (
                  KEY   BIGINT NOT NULL ,
                  value BIGINT NOT NULL
     );

PARTITION TABLE kafkaexporttable1 ON COLUMN KEY;
EXPORT TABLE kafkaexporttable1;

CREATE TABLE kafkaexporttable2
    (
          txnid                     BIGINT        NOT NULL
        , rowid                     BIGINT        NOT NULL
        , rowid_group               TINYINT       NOT NULL
        , type_null_tinyint         TINYINT
        , type_not_null_tinyint     TINYINT       NOT NULL
        , type_null_smallint        SMALLINT
        , type_not_null_smallint    SMALLINT      NOT NULL
        , type_null_integer         INTEGER
        , type_not_null_integer     INTEGER       NOT NULL
        , type_null_bigint          BIGINT
        , type_not_null_bigint      BIGINT        NOT NULL
        , type_null_timestamp       TIMESTAMP
        , type_not_null_timestamp   TIMESTAMP     NOT NULL
        , type_null_float           FLOAT
        , type_not_null_float       FLOAT         NOT NULL
        , type_null_decimal         DECIMAL
        , type_not_null_decimal     DECIMAL       NOT NULL
        , type_null_varchar25       VARCHAR(32)
        , type_not_null_varchar25   VARCHAR(32)   NOT NULL
        , type_null_varchar128      VARCHAR(128)
        , type_not_null_varchar128  VARCHAR(128)  NOT NULL
        , type_null_varchar1024     VARCHAR(1024)
        , type_not_null_varchar1024 VARCHAR(1024) NOT NULL
    );
PARTITION TABLE kafkaexporttable2 ON COLUMN rowid;
EXPORT TABLE kafkaexporttable2;

-- Stored procedures
LOAD classes sp.jar;

CREATE PROCEDURE PARTITION ON TABLE KafkaImportTable1 COLUMN key FROM class kafkaimporter.db.procedures.InsertImport;
CREATE PROCEDURE PARTITION ON TABLE Kafkamirrortable1 COLUMN key FROM class kafkaimporter.db.procedures.InsertExport;
CREATE PROCEDURE PARTITION ON TABLE KafkaMirrorTable1 COLUMN key FROM class kafkaimporter.db.procedures.DeleteRows;

CREATE PROCEDURE PARTITION ON TABLE KafkaImportTable2 COLUMN rowid FROM class kafkaimporter.db.procedures.InsertImport2;
CREATE PROCEDURE PARTITION ON TABLE Kafkamirrortable2 COLUMN rowid FROM class kafkaimporter.db.procedures.InsertExport2;
-- CREATE PROCEDURE PARTITION ON TABLE KafkaMirrorTable2 COLUMN rowid FROM class kafkaimporter.db.procedures.DeleteRows2;

CREATE PROCEDURE FROM class kafkaimporter.db.procedures.InsertFinal;
CREATE PROCEDURE FROM class kafkaimporter.db.procedures.MatchRows;

CREATE PROCEDURE CountMirror as select count(*) from kafkamirrortable1;
CREATE PROCEDURE CountImport as select count(*) from kafkaimporttable1;

CREATE PROCEDURE CountMirror2 as select count(*) from kafkamirrortable2;
CREATE PROCEDURE CountImport2 as select count(*) from kafkaimporttable2;

-- END_OF_BATCH
