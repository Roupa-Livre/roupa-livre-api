module ModelWithFile
  include ModelFile
  extend ActiveSupport::Concern

  included do
    before_validation :check_uploaded_file

    after_save :clear_temp_file
    after_save :clear_temp_attributes

    attr_accessor :data
    attr_accessor :destroy_file
  end

  protected

    def check_uploaded_file
      do_check_uploaded_file(self.data, self.destroy_file, @tempfile,
        Proc.new do |tempfile| @tempfile = tempfile end,
        Proc.new do |file, should_destroy| 
          if should_destroy
            self.remove_file!
            self.set_file(nil)
          else
            self.set_file(file)
          end
        end
      )
    end

    def clear_temp_file
      @tempfile = do_clear_temp_file(@tempfile)
    end

    def clear_temp_attributes
      self.data = nil
      self.destroy_file = nil
    end

    def set_file(new_file)
      self.file = new_file
    end
end