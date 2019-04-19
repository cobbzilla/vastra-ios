# workout JSON object storage
## Description: a workout is a single workout session
Save under `workouts/YYYY/ET_YYYYMMDD_HHmmSS_UUID.json`
where:
 * ET is the epoch time in milliseconds, which always monotonically increases
 * YYYY is 4-digit year
 * MM is 2-digit month
 * DD is 2-digit day of month
 * HH is 2-digit hour using 24-hour clock
 * mm is 2-digit minutes
 * ss is 2-digit seconds
 * UUID is the vlaue of "uuid" field in JSON, always present

Generate UUID upon object creation using standard UUIDv4 algorithm.
Generate ctime upon object creation, all of the time-related fields above are based on this ctime.

```javascript
    {
      "uuid": "standard-UUIDv4-string",  // UUIDv4
      "name": "some name",    // optional name if provided when saved
      "start_time": BIGINT,   // workout start time (time of first data point) in UNIX epoch time, in milliseconds
      "end_time": BIGINT,     // workout end time (time of last data point) in UNIX epoch time, in milliseconds
      "ctime": BIGINT         // creation time (time this record was saved) in UNIX epcoh time, in milliseconds
    }
```

# workout_data JSON object storage
## Description: a single data point that comprises a workout
Save under `workouts/YYYY/ET_YYYYMMDD_HHmmss_UUID/ET_HHmmss_UUID.json`
where:
 * ET is the epoch time in milliseconds, which always monotonically increases
 * YYYY is 4-digit year
 * MM is 2-digit month
 * DD is 2-digit day of month
 * HH is 2-digit hour using 24-hour clock
 * mm is 2-digit minutes
 * ss is 2-digit seconds
 * UUID is the vlaue of "uuid" field in JSON, always present

Generate UUID upon object creation using standard UUIDv4 algorithm.
Generate ctime upon object creation, all of the time-related fields above are based on this ctime.


```javascript
    {
      "uuid": "standard-UUIDv4-string",  // UUIDv4
      "latitude": DOUBLE,      // latitude of data point
      "longitude": DOUBLE,     // longitude of data point
      "altitude": DOUBLE,      // altitude of data point
      "speed": DOUBLE,         // instantaneous speed observed when this data point was recorded
      "ns_direction": DOUBLE,  // North/South unit vector for velocity. 1 is due North, -1 is due South
      "ew_direction": DOUBLE,  // East/West unit vector for velocity. 1 is due East, -1 is due West
      "ctime": BIGINT          // creation time of this data point, in UNIX epoch milliseconds
    }
```
