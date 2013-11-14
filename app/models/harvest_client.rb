class HarvestClient < Struct.new(:client)
  def self.get_client
    new(Harvest.client(Settings.harvest_subdomain, Settings.harvest_username, Settings.harvest_password))
  end

  def get_open_invoices
    client.invoices.all(status: "open").map { |i| HarvestInvoice.new(client, i) }
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
end
