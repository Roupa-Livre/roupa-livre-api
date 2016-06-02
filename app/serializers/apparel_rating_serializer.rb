class ApparelRatingSerializer < ActiveModel::Serializer
  attributes :id, :apparel_id, :user_id, :liked

  def attributes(*args)
    data = super
    data[:chat] = instance_options[:chat] if instance_options[:chat] && instance_options[:chat] != nil
    data
  end
end
