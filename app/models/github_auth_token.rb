class GithubAuthToken < ApplicationRecord
  validates :token, :expire_date, presence: true

  scope :active_token, ->() do
    where("expire_date > ?", Time.current)
  end
end
