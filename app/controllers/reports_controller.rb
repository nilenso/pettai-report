class ReportsController < ActionController::Base
  layout 'application'
  respond_to :json, :html

  def show
    harvest = HarvestClient.get_client
    @invoices = harvest.open_invoices
    @projects = harvest.billable_projects
  end

  def new
    harvest = HarvestClient.get_client
    @invoices = harvest.open_invoices
    @projects = harvest.billable_projects
    @bar_graph_data = @projects.map { |p| {key: p.name, value: p.uninvoiced_time.sum(&:hours)}  }
    render json: @bar_graph_data
  end
end
