class GithubAuthToken < ApplicationRecord
  scope :active_token, -> () {
    where(expire_date < Time.current).first
  }
end
