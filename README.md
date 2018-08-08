# Assumptions

## Sinatra + InfluxDB

I decided to use Sinatra and InfluxDB instead of Rails/SQL due to the following considerations:

- _The input may be very large (up to tens of gigabytes)_ => It would be easier to use Sinatra and tweak it to read and 
parse the request input stream without saving the whole request body to memory.
- Could use the power of InfluxDB continuous queries and retention policies to aggregate the counters.
- It would be too boring and cumbersome to use Rails for such a small app.

# Setup

```
$ docker_compose up
```

# Usage

## Simple string

```
$ curl -X PUT http://localhost:8788/ -d 'Hello world'
$ curl http://localhost:8788/\?word\=hello
1
```

## URL

```
$ curl -X PUT http://localhost:8788/url\?url\=https://example.com/ -d ''
$ curl http://localhost:8788/\?word\=domain
4
```
