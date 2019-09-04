require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.create!(chefname:"adam", email:"adam@example.com")
    @recipe = @chef.recipes.build(name:"veggies", description: "greate veggie recipe")
    @recipe2 = @chef.recipes.build(name:"chicken dish", description: "great chicken dish")
    @recipe2.save
  end
  
  test "should get recipes index" do
    get recipe_path
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipe_path(@recipe)
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end

  test "should get recipes show" do
    get recipe_path(@recipe2)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end
  
  test "recipe without chef should be invalid" do
    @recipe.chef_id = nil
    assert_not @recipe.valid?
  end
  
  test "recipe should be valid" do
    assert @recipe.valid?
  end

  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end
  
   test "description should be present" do
    @recipe.description = " "
    assert_not @recipe.valid?
  end
  
   test "description shouldn't be less than 5 characters" do
     @recipe.description = "a" * 3
     assert_not @recipe.valid?
   end
  
  test "description shouldn't be more than 500 characters" do
    @recipe.description = "a" * 501 
    assert_not @recipe.valid?
  end
  
  test "create new valid recipe" do
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "chicken saute"
    description_of_recipe = "add chicken, add vegetables, cook for 20mins, serve delicious meal"
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: {name: name_of_recipe, description: description_of_recipe}}
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end
  
  test "reject invalid recipe submissions" do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: {recipe: {name: " ", description: " "} }
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end