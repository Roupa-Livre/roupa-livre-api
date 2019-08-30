# require 'model_file'

module ModelWithFiles
  include ModelFile
  extend ActiveSupport::Concern

  included do
    before_validation :check_uploaded_files

    after_save :clear_temp_files
    after_save :clear_temp_attributes

  end

  module ClassMethods
    def file_attributes_info
      class_variable_get(:@@file_attributes_info)
    end

    def add_attributes(file_attrs)
      class_variable_set(:@@file_attributes_info, file_attrs)

      file_attrs.each do |attr_info|
        attr_data_name = attr_info[:data]
        attr_destroy_file_name = attr_info[:destroy_file]

        define_method "#{attr_data_name}" do
          self.instance_variable_get("@#{attr_data_name}")
        end

        define_method "#{attr_data_name}=" do |value|
          current_value = public_send(attr_data_name)
          send(:attribute_will_change!, attr_data_name) if current_value != value
          self.instance_variable_set("@#{attr_data_name}", value)
        end

        define_method "#{attr_data_name}_changed?" do
          self.instance_variable_get("@#{attr_data_name}") ? true : false
        end

         attr_accessor(attr_destroy_file_name)
      end

      define_method "changed?" do
        self.class.file_attributes_info.each do |attr_info|
          attr_data_name = attr_info[:data]
          return true if self.instance_variable_get("@#{attr_data_name}")

          attr_destroy_file_name = attr_info[:destroy_file]
          return true if public_send(attr_destroy_file_name)
        end

        return super()
      end
    end
  end

  protected

    def check_uploaded_files
      @tempfiles = { } if !@tempfiles

      self.class.file_attributes_info.each do |attr_info|
        attr_name = attr_info[:name].to_s
        attr_data = self.send(attr_info[:data])
        attr_destroy_file = self.send(attr_info[:destroy_file])

        logger.debug "#{attr_name} -> #{attr_info[:data].to_s}"
        tempfile = @tempfiles[attr_name]

        do_check_uploaded_file(attr_data, attr_destroy_file, tempfile,
          Proc.new do |new_tempfile| @tempfiles[attr_name] = new_tempfile end,
          Proc.new do |file, should_destroy| 
            if should_destroy
              self.send('remove_' + attr_name + '!') 
              self.send(attr_name + '=', nil)
            else
              self.send(attr_name + '=', file)
            end
          end
        )
      end
    end

    def clear_temp_files
      if @tempfiles
        @tempfiles.each do |key, tempfile|
          do_clear_temp_file(tempfile)
          @tempfiles.delete(key)
        end
        @tempfiles = {} # force clean
      end
    end

    def clear_temp_attributes
      self.class.file_attributes_info.each do |attr_info|
        attr_data = self.send(attr_info[:data].to_s + '=', nil)
        attr_destroy_file = self.send(attr_info[:destroy_file].to_s + '=', nil)
      end
    end
end
