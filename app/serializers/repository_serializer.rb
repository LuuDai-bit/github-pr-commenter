class RepositorySerializer < ActiveModel::Serializer
  attributes :id, :name, :owner, :full_name

  def full_name
    "#{object.owner}/#{object.name}"
  end
end
