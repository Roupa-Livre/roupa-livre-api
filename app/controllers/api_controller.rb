class APIController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def to_boolean(str)
      str == 'true' || str == "1"
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:name, :email, :type, :uid, :provider, :password, :password_confirmation, :phone, :address, :image, :data, :image_cache)
      devise_parameter_sanitizer.for(:account_update).push(:name, :lat, :lng, :phone, :email, :address, :image, :data, :image_cache)
    end

    def load_new_apparel_images(current_params)
      added_images = []
      begin
        final_params = current_params
        if final_params[:apparel_images_attributes]
          final_params[:apparel_images_attributes] = do_load_new_images(final_params[:apparel_images_attributes], added_images)
        end
        yield final_params
      ensure
        clear_temp_images(added_images)
      end
    end
    
    def do_load_new_image(image_attribute, added_images, file_param = :file)
      if image_attribute[:data].present? && image_attribute[:data] != nil && !image_attribute[:data].empty?
        # https://gist.github.com/ifightcrime/9291167a0a4367bb55a2
        base64_image = image_attribute[:data]
        # logger.error image_attribute.to_json

        filename = "file-" + (added_images.length + 1).to_s
        in_content_type, encoding, image_data = base64_image.split(/[:;,]/)[1..3]

        #create a new tempfile named fileupload
        tempfile = Tempfile.new(filename)
        tempfile.binmode
        tempfile.write(Base64.decode64(image_data))
        tempfile.rewind

        added_images.push tempfile

        # for security we want the actual content type, not just what was passed in
        content_type = `file --mime -b #{tempfile.path}`.split(";")[0]

        extension = content_type.match(/gif|jpeg|jpg|png|pdf/).to_s
        filename += ".#{extension}" if extension

        uploaded_file = ActionDispatch::Http::UploadedFile.new({
          tempfile: tempfile,
          content_type: content_type,
          filename: filename
        })

        image_attribute.delete("data")
        image_attribute[file_param] = uploaded_file
      else
        image_attribute.delete("data")
      end
    end

    def do_load_new_images(images_attributes, added_images, file_param = :file)
      images_attributes.each do |image_attribute|
        do_load_new_image(image_attribute, added_images, file_param)
      end
      images_attributes
    end

    def clear_temp_images(temp_images)
      temp_images.each do |temp_image|
        temp_image.close
        temp_image.unlink
      end
    end
end
