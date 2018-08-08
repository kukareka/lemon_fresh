require 'influxdb'
require 'securerandom'

class WordCounter
  INFLUX_DB_NAME = ENV['INFLUX_DB_NAME'] || 'word_count'
  INFLUX_PORT = ENV['INFLUX_PORT'] || 18086

  def add(word)
    # InfluxDB will overwrite points with same tags/timestamp, so need either to hack the tags or use Telegraf to
    # aggregate the measurements for duplicate words. Hacking the tags for now but it is a bad choice for production.
    #
    # https://docs.influxdata.com/influxdb/v1.6/troubleshooting/frequently-asked-questions/#how-does-influxdb-handle-duplicate-points

    influxdb.write_point 'words',
                           values: { value: 1 },
                           tags: { measurement_id: SecureRandom.hex, word: word.downcase }
  end

  def count(word)
    influxdb.query('select count(*) from words where word=%{word}', params: { word: word }) do |_, _, (point)|
      return point['count_value']
    end

    return 0
  end

  def influxdb
    @influxdb ||= InfluxDB::Client.new INFLUX_DB_NAME, port: INFLUX_PORT
  end
end
