module ProxmoxRb
  class Auth
    Ticket = Struct.new(:host, :ticket, :csrf)
    def self.get_ticket(host, username, password, options = {verify_ssl: OpenSSL::SSL::VERIFY_PEER})
      retry_count = 0
      auth = nil
      begin
        resource = RestClient::Resource.new("https://#{host}:8006/api2/json/access/ticket", options)
        json = resource.post username: username, password: password
        auth = JSON.parse json
      rescue => e
        retry_count += 1
        retry if retry_count < 5
        raise e
      end
      ticket = auth['data']['ticket']
      csrf = auth['data']['CSRFPreventionToken']
      tick = Ticket.new(host, ticket, csrf)
    end
  end
end
