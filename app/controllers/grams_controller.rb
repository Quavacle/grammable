class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy]
  def index
    @grams = Gram.all
  end

  def new
    @gram = Gram.new 
  end


  def update
     @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_forbid if @gram.user != current_user
    @gram.update_attributes(gram_params)
    if @gram.valid?
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def edit
       @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_forbid if @gram.user != current_user
  end

  def show
    @gram = Gram.find_by_id(params[:id])
    return render_forbid if @gram.blank?
  end

  def destroy
    @gram = Gram.find_by_id(params[:id])
    return render_not_found if @gram.blank?
    return render_forbid if @gram.user != current_user
    @gram.delete
    if @gram.valid?
      redirect_to root_path
    end
  end

  def create
    @gram = current_user.grams.create(gram_params)
  if @gram.valid?
    redirect_to root_path
  else
    render :new, status: :unprocessable_entity
  end



end

  private
  def gram_params
    params.require(:gram).permit(:message, :picture)
  end

  def render_not_found
      render plain: 'Not found', status: :not_found
  end

  def render_forbid
    render plain: 'Forbidden: Not your gram', status: :not_found
  end
end
