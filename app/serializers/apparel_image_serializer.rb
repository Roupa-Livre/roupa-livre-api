class ApparelImageSerializer < ActiveModel::Serializer
  attributes :id, :file_url

  def file_url
    (object.file_identifier.start_with?("data:") ) ? object.file_identifier : object.file_url
  end
end
