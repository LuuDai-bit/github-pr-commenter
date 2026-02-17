class GithubAuthToken < ApplicationRecord
  scope :active_token, ->() do
    where("expire_date > ?", Time.current)
  end
end
