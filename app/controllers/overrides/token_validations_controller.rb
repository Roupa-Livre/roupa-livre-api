module Overrides
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController

    def validate_token
      super

      # @resource will have been set by set_user_by_token concern
      if @resource
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        data = { type: 'refresh_token', token: @token, user: @resource.id }.to_json
        puts data
        REDIS.publish 'refresh_token', data
      end
    end
  end
end