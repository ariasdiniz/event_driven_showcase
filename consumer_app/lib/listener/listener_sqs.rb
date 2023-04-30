# frozen_string_literal: true

require 'json'
require 'logger'

class ListenerSqs
  def initialize(sqs, dynamo, logger = Logger.new($stdout))
    @sqs = sqs
    @dynamo = dynamo
    @logger = logger
  end

  def listen_queue
    listen_queue_once if ENV['TESTING']
    loop_listen_queue unless ENV['TESTING']
  rescue StandardError => e
    @logger.error("Error: #{e.message}")
  end

  private

  def loop_listen_queue
    loop do
      response = @sqs.receive_message(
        queue_url: 'http://172.18.0.3:4566/000000000000/test-queue',
        max_number_of_messages: 1
      )
      if response.messages.count.zero?
        sleep(1)
        next
      end
      process_messages(response.messages)
    end
  end

  def listen_queue_once
    response = @sqs.receive_message(
      queue_url: 'http://172.18.0.3:4566/000000000000/test-queue',
      max_number_of_messages: 1
    )
    process_messages(response.messages) unless response.messages.count.zero?
  end

  def process_messages(messages)
    messages.each do |message|
      @logger.info("Processing message #{message}")
      save_message(message)
    rescue StandardError => e
      @logger.error("Error: #{e.message}")
    end
  end

  def save_message(message)
    message_hash = JSON.parse(message.body)
    @dynamo.put_item(
      {
        table_name: 'test',
        item: {
          primary_id: message_hash['primary_id'],
          secondary_id: message_hash['secondary_id']
        }
      }
    )
    @logger.info('Successfully saved in the database')
    delete_message(message)
  end

  def delete_message(message)
    @logger.info('Deleting message from queue')
    @sqs.delete_message(
      queue_url: 'http://172.18.0.3:4566/000000000000/test-queue',
      receipt_handle: message.receipt_handle
    )
    @logger.info('Message deleted')
  end
end
