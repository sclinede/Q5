require 'uri'

class UriValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ URI.regexp(['http']) 
      record.errors[attribute] << "Wrong URI format"
      return
    end

    begin

      resource = RestClient::Resource.new value, :timeout => 3, :open_timeout => 3
      
      response = resource.head
     
      case response.code  
      when 200
        true
      when 408
        record.errors[attribute] << "URI request timeout error (> 3 sec.) [server respond]"      
      else
        record.errors[attribute] << "URI response not 200 OK"
      end

    rescue RestClient::ResourceNotFound
      record.errors[attribute] << "Resource not found error"
    rescue RestClient::RequestTimeout
      record.errors[attribute] << "URI request timeout error (> 3 sec.) [open connection]"
    rescue RestClient::Exception
      record.errors[attribute] << "Error happend during requesting URI [connection]"
    rescue SocketError
      record.errors[attribute] << "Host unavailable"
    end
  end
end
