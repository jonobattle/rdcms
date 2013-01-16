class Session

  include Mongoid::Document
  field :account_slug, type: String
  field :device_slug, type: String
  field :ip_address, type: String
  field :auth_token, type: String

  before_create { generate_token(:auth_token)}

  def data(show_auth_token = false)
    data = []
    data << { "name" => "authorization_token", "value" => self.auth_token, "prompt" => "Authorization Token" }
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Session.where(auth_token: self.auth_token).exists?
  end

end
