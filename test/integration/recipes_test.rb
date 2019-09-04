require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @chef = Chef.create!(chefname: "adam", email: "adam@example.com")
    @recipe = Recipe.create(name:"veggy", description: "this is good veggy dish", chef: @chef)
    @recipe2 = @chef.recipes.build(name:"chicken", description:"good chicken dish")
    @recipe2.save
  end
  
  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index' 
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end
  
  test "should get recipes show" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
  
  test "create new valid recipe" do
    get new_recipe_path
  end
  
  test "reject invalid recipe submissions" do
    get new_recipe_path  
  end
end
