class BaseController < WebsocketRails::BaseController
  around_filter :wrap_in_transaction
  def wrap_in_transaction
    begin
      ActiveRecord::Base.transaction do
        yield
      end
    rescue Exception => e
      trigger_failure({message: e.message})
      raise e
    end
  end
end