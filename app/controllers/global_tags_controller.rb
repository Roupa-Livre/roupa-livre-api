class GlobalTagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_global_tag, only: [:show, :destroy, :update]

  # GET /global_tags
  # GET /global_tags.json
  def index
    # Somente Admin
    # render json: GlobalTag.all
    render json: []
  end

  # GET /global_tags/1
  # GET /global_tags/1.json
  def show
    render json: @global_tag
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    head :no_content

    # Somente ADMIN
    # if @global_tag.update(global_tag_params)
    #   head :no_content
    # else
    #   render json: @global_tag.errors, status: :unprocessable_entity
    # end
  end

  # DELETE /global_tag/1
  # DELETE /global_tag/1.json
  def destroy
    # Somente Admin
    # @chat.destroy

    head :no_content
  end

  private

    def set_global_tag
      @global_tag = GlobalTag.find(params[:id])
    end

    def global_tag_params
      params.require(:global_tag).permit(:description, :body)
    end
end
