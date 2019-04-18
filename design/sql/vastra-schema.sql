-- TABLE route
-- Description: a route is a course that a user might exercise multiple times
CREATE TABLE route (
  uuid VARCHAR(50),      -- UUIDv4
  name VARCHAR(500),     -- name of the route
  latitude DOUBLE,       -- latitude of first data point
  longitude DOUBLE,      -- longitude of first data point
  ctime BIGINT,          -- creation time, use UNIX epoch time (seconds since 1970)
  PRIMARY KEY uuid
);

-- TABLE workout
-- Description: a workout is a single workout session. 
CREATE TABLE workout (
  uuid VARCHAR(50),      -- UUIDv4
  route VARCHAR(50),     -- UUIDv4 foreign key references route.uuid
  start_time BIGINT,     -- workout start time (time of first data point) in UNIX epoch time
  end_time BIGINT,       -- workout end time (time of last data point) in UNIX epoch time
  ctime BIGINT,          -- creation time (time this record was saved) in UNIX epcoh time
  PRIMARY KEY uuid,
  FORIEGN KEY route REFERENCES route(uuid)
);

-- TABLE: workout_data
-- Description: a single data point that comprises a workout
CREATE TABLE workout_data (
  uuid VARCHAR(50),     -- UUIDv4
  workout VARCHAR(50),  -- UUIDv4 foreign key references workout.uuid
  latitude DOUBLE,      -- latitude of data point
  longitude DOUBLE,     -- longitude of data point
  altitude DOUBLE,      -- altitude of data point
  speed DOUBLE,         -- instantaneous speed observed when this data point was recorded
  ns_direction DOUBLE,  -- North/South unit vector for velocity. 1 is due North, -1 is due South
  ew_direction DOUBLE,  -- East/West unit vector for velocity. 1 is due East, -1 is due West
  ctime BIGINT,         -- creation time of this data point
  PRIMARY KEY uuid,
  FOREIGN KEY workout REFERENCES workout(uuid)
);
