require 'bunny'
require 'json'

class MessagePublisher
  def self.publish(message)
    begin
      connection = Bunny.new("amqp://guest:guest@rabbitmq:5672")
      connection.start
      channel = connection.create_channel
      queue = channel.queue("visit_logs", durable: true)
      queue.publish(message.to_json)
      connection.close
    rescue StandardError => e
      puts "MessagePublisher error: #{e.message}"
    end
  end
end