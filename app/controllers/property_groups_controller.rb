# == Schema Information
#
# Table name: property_groups
#
#  id                 :integer          not null, primary key
#  code               :string
#  name               :string
#  prop_name          :string
#  property_segment   :string
#  sort_order         :integer
#  parent_id          :integer
#  property_filter    :boolean          default(FALSE)
#  filter_property_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PropertyGroupsController < APIController
  # GET /property_groups
  # GET /property_groups.json
  def index
    if params[:root]
      @property_groups = PropertyGroup.where(parent_id: nil)
      render json: @property_groups.order(:sort_order)
    elsif params[:parent_id]
      @property_groups = PropertyGroup.where(parent_id: params[:parent_id])
        .where('property_filter = ? or filter_property_id = ?', false, params[:property_id])
      render json: @property_groups.order(:sort_order)
    else
      render json: { "filter":  "group_code or parent_id must be passed"}, status: :unprocessable_entity
    end
  end
end
