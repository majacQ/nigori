CREATE TABLE stores (
  sid  serial  PRIMARY KEY,
  pk   bytea   NOT NULL  UNIQUE,
  reg  TIMESTAMP WITH TIME ZONE  NOT NULL
) WITH (OIDS=FALSE);

CREATE INDEX stores_pk ON stores (pk);

CREATE TABLE lookups (
  lid  serial  PRIMARY KEY,
  sid  integer REFERENCES stores (sid)  ON DELETE CASCADE,
  lookup bytea NOT NULL,
  UNIQUE (sid, lookup)
) WITH (OIDS=FALSE);

CREATE INDEX lookups_sid ON lookups (sid);

CREATE TABLE revisions (
  rid  serial  PRIMARY KEY,
  lid  integer REFERENCES lookups (lid) ON DELETE CASCADE,
  rev  bytea   NOT NULL,
  UNIQUE(lid,rev)
) WITH (OIDS=FALSE);

CREATE INDEX revisions_lid ON revisions (lid);

CREATE TABLE rid_values (
  rid serial PRIMARY KEY REFERENCES revisions (rid) ON DELETE CASCADE,
  val bytea  NOT NULL
) WITH (OIDS=FALSE);

CREATE INDEX rid_values_rid ON rid_values (rid);

CREATE VIEW rev_values AS
  SELECT lid, rev, val FROM revisions, rid_values
  WHERE revisions.rid = rid_values.rid;

CREATE TABLE nonces (
  sid    integer  REFERENCES stores (sid)  ON DELETE CASCADE,
  nonce  bytea    NOT NULL,
  use    TIMESTAMP WITH TIME ZONE  NOT NULL,
  PRIMARY KEY (sid, nonce)
) WITH (OIDS=FALSE);

CREATE INDEX nonces_sid_nonce ON nonces (sid, nonce);

/* TODO some automated delete of old nonces */