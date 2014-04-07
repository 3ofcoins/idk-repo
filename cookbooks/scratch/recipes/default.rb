def try_recipe(name)
  include_recipe "scratch::#{name}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.debug("Not found recipe[scratch::#{name}], not loading")
end

try_recipe "node-#{node.name}"

