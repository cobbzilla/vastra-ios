# workout JSON object storage
## Description: a workout is a single workout session
## Save under 'workouts/YYYY/MM/DD/YYYY-MM-DD-HH-mm-ss[_name]_UUID.json'

    {
      "uuid": "VARCHAR(50)",  // UUIDv4
      "name": "VARCHAR(500)", // optional name if provided when saved
      "start_time": BIGINT,   // workout start time (time of first data point) in UNIX epoch time
      "end_time": BIGINT,     // workout end time (time of last data point) in UNIX epoch time
      "ctime": BIGINT         // creation time (time this record was saved) in UNIX epcoh time
    }

# workout_data JSON object storage
## Description: a single data point that comprises a workout
## Save under 'workouts/YYYY/MM/DD/YYYY-MM-DD-HH-mm-ss[_name]/data/YYYYMMDDHHmmss_UUID.json'

    {
      "uuid": "VARCHAR(50)",   // UUIDv4
      "latitude": DOUBLE,      // latitude of data point
      "longitude": DOUBLE,     // longitude of data point
      "altitude": DOUBLE,      // altitude of data point
      "speed": DOUBLE,         // instantaneous speed observed when this data point was recorded
      "ns_direction": DOUBLE,  // North/South unit vector for velocity. 1 is due North, -1 is due South
      "ew_direction": DOUBLE,  // East/West unit vector for velocity. 1 is due East, -1 is due West
      "ctime": BIGINT          // creation time of this data point
    }
