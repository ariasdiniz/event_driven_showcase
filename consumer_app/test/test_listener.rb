# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/listener/listener_sqs'

class TestListener < Minitest::Test
  def test_listen_success
    listener = ListenerSqs.new(MockSQS.new, MockDynamo.new)
    listener.listen_queue
  end

  class MockSQS
    def receive_message(*args)
      MockResponse.new
    end
    def delete_message(*args); end
  end

  class MockResponse
    def messages
      response = [{ body: '{ "primary_id": "test", "secondary_id": "test" }', receipt_handle: 'test' }]
      response[0].define_singleton_method(:body) { self[:body] }
      response[0].define_singleton_method(:receipt_handle) { self[:receipt_handle] }
      response
    end
  end

  class MockDynamo
    def scan(*args); end
    def put_item(*args); end
  end
end
