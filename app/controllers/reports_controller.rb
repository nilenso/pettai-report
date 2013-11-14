class ReportsController < ActionController::Base
  def show
    harvest = HarvestClient.get_client
    @invoices = harvest.get_open_invoices
  end
end
