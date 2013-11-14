class ReportsController < ActionController::Base
  def show
    harvest = HarvestClient.get_client
    @invoices = harvest.open_invoices
    @projects = harvest.billable_projects
  end
end
