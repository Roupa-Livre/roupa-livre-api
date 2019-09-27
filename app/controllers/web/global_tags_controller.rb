class Web::GlobalTagsController < Web::ApplicationController
  before_action :set_global_tag, only: [:show, :edit, :update, :destroy]

  # GET /global_tags
  # GET /global_tags.json
  def index
    if params[:all]
      @showing_all = true
      @global_tags = GlobalTag.all
    else
      @showing_all = false
      @global_tags = GlobalTag.where("(description is not null and description <> '') or (body is not null and body <> '')")
    end

    @global_tags = @global_tags
      .joins('left join apparel_tags on apparel_tags.global_tag_id = global_tags.id')
      .group(GlobalTag.column_names.map{|col| "global_tags.#{col}"})
      .order('COUNT(apparel_tags.id) DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @global_tags }
    end
  end

  # GET /global_tags/new
  # GET /global_tags/new.json
  def new
    @global_tag = GlobalTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @global_tag }
    end
  end

  # GET /global_tags/1/edit
  def edit
  end

  # POST /global_tags
  # POST /global_tags.json
  def create
    @global_tag = GlobalTag.new(create_global_tag_params)

    respond_to do |format|
      if @global_tag.save
        format.html { redirect_to web_global_tags_path, notice: 'Tag criada.' }
        format.json { render json: @global_tag, status: :created, location: web_global_tags_path }
      else
        format.html { render action: "new" }
        format.json { render json: @global_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /global_tags/1
  # PATCH/PUT /global_tags/1.json
  def update
    respond_to do |format|
      if @global_tag.update(update_global_tag_params)
        format.html { redirect_to web_global_tags_path, notice: 'Tag atualizada.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @global_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /global_tags/1
  # DELETE /global_tags/1.json
  def destroy
    @global_tag.destroy

    respond_to do |format|
      format.html { redirect_to web_global_tag_url }
      format.json { head :no_content }
    end
  end

  private

    def set_global_tag
      @global_tag = GlobalTag.find(params[:id])
    end

    def create_global_tag_params
      params.require(:global_tag).permit(:name, :description, :body)
    end

    def update_global_tag_params
      params.require(:global_tag).permit(:description, :body)
    end
end
