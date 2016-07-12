module Overrides
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController

    def validate_token
      super

      # @resource will have been set by set_user_by_token concern
      if @resource
        data = { type: 'refresh_token', token: @token, user: @resource.id }.to_json
        # REDIS.publish 'refresh_token', data
      end
    end
  end
end