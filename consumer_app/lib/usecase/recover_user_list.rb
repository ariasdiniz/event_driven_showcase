# frozen_string_literal: true

class RecoverUserList

  def initialize(dynamo, logger = Logger.new($stdout))
    @dynamo = dynamo
    @logger = logger
  end

  def recover_list_of_users
    @logger.info('Recovering list of users')
    @dynamo.scan({ table_name: 'test' })[:items]
  end
end
