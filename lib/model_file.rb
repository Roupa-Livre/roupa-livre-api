require 'file_size_validator'
require 'securerandom'

module ModelFile
  protected
    def do_check_uploaded_file(data_obj, destroy_obj, tempfile, set_tempfile_proc, set_final_proc)
      # logger.debug "do_check_uploaded_file:" + self.class.name
      # logger.debug "do_check_uploaded_file a:" + (data_obj ? data_obj.to_s : "null")
      # logger.debug "do_check_uploaded_file b:" + (destroy_obj ? destroy_obj.to_s : "null")
      # logger.debug Thread.current.thread_variable_get(:classes)
      if data_obj.present?
        # logger.debug "do_check_uploaded_file OK"
        # https://gist.github.com/ifightcrime/9291167a0a4367bb55a2
        base64_image = data_obj

        @tempfilename = "file-" + (SecureRandom.hex(10)).to_s if !@tempfilename
        filename = @tempfilename
        in_content_type, encoding, image_data = base64_image.split(/[:;,]/)[1..3]

        #create a new tempfile named fileupload
        set_tempfile_proc.call(do_clear_temp_file(tempfile))

        tempfile = Tempfile.new(filename)
        tempfile.binmode
        tempfile.write(Base64.decode64(image_data))
        tempfile.rewind
        set_tempfile_proc.call(tempfile)

        # for security we want the actual content type, not just what was passed in
        content_type = `file --mime -b #{tempfile.path}`.split(";")[0]

        extension = content_type.match(/gif|jpeg|jpg|png|pdf/).to_s
        filename += ".#{extension}" if extension

        uploaded_file = ActionDispatch::Http::UploadedFile.new({
          tempfile: tempfile,
          content_type: content_type,
          filename: filename
        })

        # logger.debug "do_check_uploaded_file SETTING"
        set_final_proc.call(uploaded_file, false)
        # logger.debug "do_check_uploaded_file SET!"
      elsif destroy_obj
        # logger.debug "do_check_uploaded_file DELETE"
        set_final_proc.call(nil, true)
      end
    end

    def do_clear_temp_file(tempfile)
      if tempfile
        tempfile.close
        tempfile.unlink
      end
      return nil
    end
end
