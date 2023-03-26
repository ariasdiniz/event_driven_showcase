# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/usecase/recover_user_list'

class TestRecoverList < Minitest::Test

  def test_list
    usecase = RecoverUserList.new(MockDynamo.new)
    assert usecase.recover_list_of_users[0][:primary_id] == 'test'
    assert usecase.recover_list_of_users[0][:secondary_id] == 'test'
  end
  class MockDynamo
    def scan(*args)
      { items: [{ primary_id: 'test', secondary_id: 'test' }] }
    end
  end
end
