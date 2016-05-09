class Admin::ChildrenController < ApplicationController
  def index
    def index
      @active_children = User.where(:is_active => true, :is_deleted => false).joins(:role).where("roles.name=?", "child")
      @inactive_children = User.where(:is_active => false, :is_deleted => false).joins(:role).where("roles.name=?", "child")
    end
  end
end
