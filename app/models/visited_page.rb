class VisitedPage
  include ActiveModel::Validations

  attr_accessor :uri, :title, :referer

  validates :uri, :referer, :uri => true
end
