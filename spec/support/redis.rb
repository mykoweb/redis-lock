# -*- encoding: utf-8 -*-

require "redis"

module RedisClient

  TEST_REDIS = { url: "redis://127.0.0.1:6379/1" }

  def redis
    @redis ||= ::Redis.connect(TEST_REDIS)
  end

  def redis2
    @redis2 ||= ::Redis.connect(TEST_REDIS)
  end

  def with_watch( redis, *args )
    redis.watch( *args )
    begin
      yield
    ensure
      redis.unwatch
    end
  end

  def with_clean_redis(&block)
    redis.client.disconnect # auto connect after fork
    redis2.client.disconnect # auto connect after fork
    redis.flushall          # clean before run
    yield
  ensure
    redis.flushall          # clean up after run
    redis.quit              # quit (close) connection
    redis2.quit              # quit (close) connection
  end

end # RedisClient
