CREATE CACHED TABLE chunk(
  checksum varchar(40) NOT NULL,
  size bigint NOT NULL,
  PRIMARY KEY (checksum)
);

CREATE CACHED TABLE databaseversion (
  id int NOT NULL IDENTITY,
  localtime datetime NOT NULL,
  client varchar(45) NOT NULL  
);

CREATE CACHED TABLE filecontent (
  checksum varchar(40) NOT NULL,
  size bigint NOT NULL,
  CONSTRAINT pk_checksum PRIMARY KEY (checksum)
);

CREATE CACHED TABLE filecontent_chunk (
  filecontent_checksum varchar(40) NOT NULL,
  chunk_checksum varchar(40) NOT NULL,
  num int NOT NULL,
  PRIMARY KEY (filecontent_checksum, chunk_checksum, num),
  FOREIGN KEY (filecontent_checksum) REFERENCES filecontent (checksum) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (chunk_checksum) REFERENCES chunk (checksum) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE CACHED TABLE filehistory (
  id varchar(40) NOT NULL,
  databaseversion_id int NOT NULL,
  PRIMARY KEY (id, databaseversion_id),
  FOREIGN KEY (databaseversion_id) REFERENCES databaseversion (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE CACHED TABLE fileversion (
  filehistory_id varchar(40) NOT NULL,
  version int NOT NULL,
  path varchar(1024) NOT NULL,
  type varchar(45) NOT NULL,
  status varchar(45) NOT NULL,
  size bigint NOT NULL,
  lastmodified datetime NOT NULL,
  linktarget varchar(1024),
  filecontent_checksum varchar(40) DEFAULT NULL,
  updated datetime NOT NULL,
  posixperms varchar(45) DEFAULT NULL,
  dosattrs varchar(45) DEFAULT NULL,
  PRIMARY KEY (filehistory_id, version),
  FOREIGN KEY (filecontent_checksum) REFERENCES filecontent (checksum) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE INDEX idx_fileversion_path ON fileversion (path);

// Does not work, because filehistory.id is not UNIQUE
//  FOREIGN KEY (filehistory_id) REFERENCES filehistory (id) ON DELETE NO ACTION ON UPDATE NO ACTION

CREATE CACHED TABLE multichunk (
  id varchar(40) NOT NULL,
  PRIMARY KEY (id)
);

CREATE CACHED TABLE multichunk_chunk (
  multichunk_id varchar(40) NOT NULL,
  chunk_checksum varchar(40) NOT NULL,
  PRIMARY KEY (multichunk_id, chunk_checksum),
  FOREIGN KEY (multichunk_id) REFERENCES multichunk (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (chunk_checksum) REFERENCES chunk (checksum) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE CACHED TABLE vectorclock (
  databaseversion_id int NOT NULL,
  client varchar(45) NOT NULL,
  logicaltime int NOT NULL,
  PRIMARY KEY (databaseversion_id, client),
  FOREIGN KEY (databaseversion_id) REFERENCES databaseversion (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

