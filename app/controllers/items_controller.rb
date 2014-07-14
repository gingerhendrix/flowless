class ItemsController < ApplicationController
  before_action :set_flow, only: [:index, :new, :show, :edit, :update, :create, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # to allow the new action to not render the layout when call as an ajax call
  # before_action ->(controller){ controller.action_has_layout = false if controller.request.xhr? }, only: [:new]

  # GET /items
  def index
    redirect_to flow_path(@flow)
    #@items = Item.all
  end

  # GET /items/1
  def show
  end

  # GET /items/new
  def new
    intialize_new_item

    if request.xhr?
      render partial: 'new_modal', layout: false && return
    end
  end

  # GET /items/1/edit
  def edit
    @item.build_missing_field_containers
    @item.build_field_value_layer
  end

  # POST /items
  def create
    @item = @flow.items.new(item_params)

    @creation_mode = params[:creation_mode] || 'single'

    respond_to do |format|
      if @item.save
        format.html { redirect_to [@flow, @item], flash: { success: 'Item was successfully created.' } }
        format.js   { intialize_new_item; flash.now[:success] = 'Item was successfully created.'; render :show }
      else
        format.html { render :new }
        format.js   { render :new }
      end
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      redirect_to [@flow, @item], flash: { success: 'Item was successfully updated.' }
    else
      render :edit
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    redirect_to flow_path(@flow), notice: 'Item was successfully destroyed.'
  end

  private
    def intialize_new_item
      @item = @flow.items.new
      @item.build_missing_field_containers
      @item.build_field_value_layer
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_flow
      @flow = Flow.find(params[:flow_id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(
        field_containers_attributes: [
          :id, :field_type_id, field_values_attributes: [
            :_type, :id, :value, :current_value
          ]
        ]
      ).merge(user_id: current_user.id)
    end
end
