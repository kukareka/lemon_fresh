# Assumptions

## Sinatra + InfluxDB

I decided to use Sinatra and InfluxDB instead of Rails/SQL due to the following considerations:

- _The input may be very large (up to tens of gigabytes)_ => It would be easier to use Sinatra and tweak it to read and 
parse the request input stream without saving the whole request body to memory.
- Could use the power of InfluxDB continuous queries and retention policies to aggregate the counters.
- It would be too boring and cumbersome to use Rails for such a small app.

## Reading local files

For demo purposes, it is possible to count words in local files from `public` directory on the server. 
Access to other files on the server is forbidden. Please use `URL` endpoint for S3 and other remote storages.

# Setup

```
$ docker-compose up
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

## File

```
$ curl -X PUT http://localhost:8788/file\?file\=agile_manifesto.txt -d ''
$ curl http://localhost:8788/\?word\=kent 
1                  
```

