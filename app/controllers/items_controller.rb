class ItemsController < ApplicationController
  before_action :set_flow, only: [:index, :new, :show, :edit, :update, :create, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]

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
    @item = @flow.items.new
    @item.build_field_containers
    @item.build_field_values
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  def create
    @item = @flow.items.new(item_params)

    if @item.save
      redirect_to [@flow, @item], flash: { success: 'Item was successfully created.' }
    else
      render :new
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
          :field_type_id, field_values_attributes: [
            :_type, :id, :value #, :current
          ]
        ]
      ).merge(user_id: current_user.id)
    end
end
