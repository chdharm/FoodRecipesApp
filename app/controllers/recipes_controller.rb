class RecipesController < ApplicationController
	before_action :set_recipe, only: [:show, :edit, :update, :destroy,:check_user]
    before_action :authenticate_user!, only: [:new,:show, :update, :destroy]

  def index
  	@recipes = Recipe.all
  end

  def new
  	@recipe = Recipe.new
  end

  def create
   	@recipe = Recipe.new(recipe_params)
   	@recipe.user_id = current_user.id
	if @recipe.save
		flash[:success] = "Recipe Created!"
		redirect_to @recipe
	else
		render 'new'
	end
  end

  def show
  end
  def edit
  end

def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

   def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def check_user
      if @recipe.user.id == current_user.id
        puts "Vaild user"
      else
        redirect_to root_path, notice: 'You dont have rights for this'
      end
    end

  def recipe_params
    params.require(:recipe).permit(:name, :description)
  end

end
