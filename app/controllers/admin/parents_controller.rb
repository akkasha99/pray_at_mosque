class Admin::ParentsController < Admin::AdminsController
  def index
    @active_parents = User.where(:is_active => true, :is_deleted => false).joins(:role).where("roles.name=?", "parent")
    @inactive_parents = User.where(:is_active => false, :is_deleted => false).joins(:role).where("roles.name=?", "parent")
  end
end
