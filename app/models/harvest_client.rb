class HarvestClient < Struct.new(:client)
  def self.get_client
    new(Harvest.client(Settings.harvest_subdomain, Settings.harvest_username, Settings.harvest_password))
  end

  def open_invoices
    client.invoices.all(status: "open").map { |i| HarvestInvoice.new(client, i) }
  end

  def billable_projects
    client.projects.all.select { |i| i.active? && i.billable? }.map { |i| HarvestProject.new(client, i) }
  end

  class HarvestInvoice < Struct.new(:harvest, :invoice)
    delegate :issued_at, :subject, :due_at, :period_start, :period_end, :amount, :currency_symbol, to: :invoice

    def client
      HarvestClient.new harvest, harvest.clients.find(invoice.client_id)
    end
  end

  class HarvestClient < Struct.new(:harvest, :client)
    delegate :name, to: :client
  end

  class HarvestProject < Struct.new(:harvest, :project)
    delegate :name, to: :project

    def uninvoiced_time
      @uninvoice_time ||= harvest.reports
        .time_by_project(project.id, 2.months.ago, Date.today, billable: true)
        .reject { |i| i.is_billed? }
        .map { |i| HarvestEntry.new(:harvest, i) }
    end
  end

  class HarvestEntry < Struct.new(:harvest, :entry)
    delegate :hours, to: :entry
  end
end
