require 'spec_helper'
require 'validators/uri_validator' 

describe UriValidator do

  before(:each) do
    @validator = UriValidator.new({:attributes => {}})
    @mock = mock('model')
    @mock.stub("errors").and_return([])
    @mock.errors.stub('[]').and_return({})  
    @mock.errors[].stub('<<')
  end
  
  let(:attribute) { "uri" }
  let(:correct_uri) { "http://ya.ru" }
  let(:wrong_scheme_uri) { "https://ya.ru" }
  let(:wrong_uri) { "www.ya.ru" }
  let(:timeout_error_uri) { "http://ya.ru:889" }
  let(:socket_error_uri) { "http://yaefb.ru" }
  let(:not_200_code_uri) { "http://www.gismeteo.ru/city/daily/4517/abc.jpg" }

  it 'should be valid if correct URI passed' do
    @mock.should_not_receive('errors')
    @validator.validate_each(@mock, attribute, correct_uri)
  end

  it 'should not be valid if wrong URI was passed' do
    @mock.errors[].should_receive("<<").with("Wrong URI format")
    @validator.validate_each(@mock, attribute, wrong_uri)
  end

  it 'should not be valid if wrong scheme in URI was passed' do
    @mock.errors[].should_receive("<<").with("Wrong URI format")
    @validator.validate_each(@mock, attribute, wrong_scheme_uri)
  end

  it 'should not be valid if requesting URI timeout error' do
    @mock.errors[].should_receive("<<").with("URI request timeout error (> 3 sec.)")
    @validator.validate_each(@mock, attribute, timeout_error_uri)
  end

  it 'should not be valid if host invalid' do
    @mock.errors[].should_receive("<<").with("Host unavailable")
    @validator.validate_each(@mock, attribute, socket_error_uri)
  end

  it 'should not be valid if response code not 200 OK' do
    @mock.errors[].should_receive("<<").with("Error happend during requesting URI")
    @validator.validate_each(@mock, attribute, not_200_code_uri)
  end

end
