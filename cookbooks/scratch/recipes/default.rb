def try_recipe(name)
  include_recipe "scratch::#{name}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.debug("Not found recipe[scratch::#{name}], not loading")
end

Dir[File.join(File.dirname(__FILE__), "all-*.rb")].sort.each do |f|
  try_recipe(File.basename(f, '.rb'))
end

try_recipe "node-#{node.name}"

