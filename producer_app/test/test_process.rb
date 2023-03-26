# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/usecase/process_new_user'

class TestListener < Minitest::Test

  #Given that the process method is called When the message is valid Then should execute without errors
  def test_process_success
    sqs = MockSqsClient.new
    result = ProcessNewUser.new(sqs = sqs).process('{"primary_id": "test","secondary_id": "test"}')
    assert result[0] == '{ "message": "User sent to processing app" }'
    assert result[1] == 200
  end

  #Given that the process method is called When the message lacks primary id Then should raise exception
  def test_process_without_primary_id
    sqs = MockSqsClient.new
    result = ProcessNewUser.new(sqs = sqs).process('{"secondary_id": "test"}')
    assert result[0] == '{ "message": "You should inform the primary_id!" }'
    assert result[1] == 500
  end

  #Given that the process method is called When the message lacks secondary id Then should raise exception
  def test_process_without_secondary_id
    sqs = MockSqsClient.new
    result = ProcessNewUser.new(sqs = sqs).process('{"primary_id": "test"}')
    assert result[0] == '{ "message": "You should inform the secondary_id!" }'
    assert result[1] == 500
  end

  #Given that the process method is called When the message is empty Then should raise exception
  def test_process_without_body
    sqs = MockSqsClient.new
    result = ProcessNewUser.new(sqs = sqs).process(nil)
    assert result[0] == '{ "message": "Body should be in JSON format and cannot be empty" }'
    assert result[1] == 500
  end
  class MockSqsClient
    def send_message(*args); end
  end
end
