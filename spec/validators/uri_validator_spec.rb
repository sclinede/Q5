require 'spec_helper'
require 'validators/uri_validator' 

describe UriValidator do
  
  before(:all) { class TestModel; include ActiveModel::Validations; end }

  let(:validator) { UriValidator.new({:attributes => {}}) }

  let(:record) { TestModel.new }

  let(:attribute) { "uri" }

  let(:correct_uri) { "http://ya.ru" }
  let(:wrong_scheme_uri) { "https://ya.ru" }
  let(:wrong_uri) { "www.ya.ru" }
  let(:timeout_error_uri) { "http://ya.ru:889" }
  let(:socket_error_uri) { "http://yaefb.ru" }
  let(:not_200_code_uri) { "http://www.gismeteo.ru/city/daily/4517/abc.jpg" }

  it 'should be valid if correct URI passed' do

    validator.validate_each(record, attribute, correct_uri)
    record.errors.empty?.should be_true
  end

  it 'should not be valid if wrong URI was passed' do
    validator.validate_each(record, attribute, wrong_uri)
    record.errors[attribute].should == ["Wrong URI format"]
  end

  it 'should not be valid if wrong scheme in URI was passed' do
    validator.validate_each(record, attribute, wrong_scheme_uri)
    record.errors[attribute].should == ["Wrong URI format"]
  end

  it 'should not be valid if requesting URI timeout error' do
    validator.validate_each(record, attribute, timeout_error_uri)
    record.errors[attribute].should == ["URI request timeout error (> 3 sec.)"]
  end

  it 'should not be valid if host invalid' do
    validator.validate_each(record, attribute, socket_error_uri)
    record.errors[attribute].should == ["Host unavailable"]
  end

  it 'should not be valid if response code not 200 OK' do
    validator.validate_each(record, attribute, not_200_code_uri)
    record.errors[attribute].should == ["Error happend during requesting URI"]
  end

end
