require 'influxdb'
require 'securerandom'

class WordCounter
  INFLUX_DB_NAME = ENV['INFLUX_DB_NAME'] || 'word_count'
  INFLUX_HOST = ENV['INFLUX_HOST'] || 'localhost'
  INFLUX_PORT = ENV['INFLUX_PORT'] || 8086

  def add(word)
    # InfluxDB will overwrite points with same tags/timestamp, so need either to hack the tags or use Telegraf to
    # aggregate the measurements of duplicated words. Hacking the tags for now but it is a bad choice for production.
    #
    # https://docs.influxdata.com/influxdb/v1.6/troubleshooting/frequently-asked-questions/#how-does-influxdb-handle-duplicate-points

    influxdb.write_point 'words',
                           values: { value: 1 },
                           tags: { measurement_id: SecureRandom.hex, word: word.downcase }
  end

  def count(word)
    influxdb.query('select count(*) from words where word=%{word}', params: { word: word }) do |_, _, (point)|
      # Using `(point)` shortcut because we need only one aggregated point
      return point['count_value']
    end

    return 0
  end

  def influxdb
    # Need to check how connection pooling works in InfluxDB client, doing it simple for now
    @influxdb ||= InfluxDB::Client.new INFLUX_DB_NAME, host: INFLUX_HOST, port: INFLUX_PORT
  end
end
