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
     
      record.errors[attribute] << "URI response not 200 OK" unless response.code == 200  
    
    rescue RestClient::RequestTimeout
      record.errors[attribute] << "URI request timeout error (> 3 sec.)"
    rescue RestClient::Exception
      record.errors[attribute] << "Error happend during requesting URI"
    rescue SocketError
      record.errors[attribute] << "Host unavailable"
    end
  end
end
