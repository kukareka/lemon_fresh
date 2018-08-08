# Assumptions

## Sinatra + InfluxDB

Could use Rails + some SQLite, but:

- _The input may be very large (up to tens of gigabytes)_ => It would be easier to use Sinatra and tweak it to read and 
parse the request input stream without saving the whole request body to memory.
- It would be too boring and cumbersome to use Rails for such a small app.

