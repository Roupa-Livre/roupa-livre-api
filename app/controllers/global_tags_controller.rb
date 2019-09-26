# == Schema Information
#
# Table name: global_tags
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GlobalTagsController < APIController
  before_action :authenticate_user!
  before_action :set_global_tag, only: [:show]

  # GET /global_tags/1
  # GET /global_tags/1.json
  def show
    render json: @global_tag
  end

  private

    def set_global_tag
      @global_tag = GlobalTag.find(params[:id])
    end
end
