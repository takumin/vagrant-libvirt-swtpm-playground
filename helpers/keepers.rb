MItamae::RecipeContext.class_eval do
  def include_role(name=nil)
    roles_dir = File.expand_path('../../roles', __FILE__)
    if File.exists?(File.join(roles_dir, name + '.rb')) then
      include_recipe(File.join(roles_dir, name))
    end
  end

  def include_helper(name=nil)
    helpers_dir = File.expand_path('../../helpers', __FILE__)
    include_recipe(File.join(helpers_dir, name))
  end

  def include_cookbook(name=nil)
    cookbooks_dir = File.expand_path("../../cookbooks", __FILE__)
    include_recipe(File.join(cookbooks_dir, name))
  end
end

include_helper('env_proxy_conn')
include_helper('env_current_user')
include_helper('env_apt_repos_url')
