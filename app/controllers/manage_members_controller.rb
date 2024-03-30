class ManageMembersController < ApplicationController
    def index
        @users = User.all.order(:full_name)
    end

    def new
        @user = User.new
    end
    
    def create
        @user = User.new(member_params)
        @user.avatar_url = 'testing'
        if @user.save
          redirect_to manage_members_path, notice: 'New member added successfully.'
        else
          render :new
        end
    end

    before_action :authenticate_user!, only: [:destroy]
    def destroy
        @member = User.find_by(uid: params[:id])
        if @member.destroy
          redirect_to manage_members_path, notice: 'Member removed successfully.'
        else
          redirect_to manage_members_path, alert: 'Failed to remove member.'
        end
    end
      
    
    def update_role
        updatee = User.where(uid: params[:uid])
        updatee.update(role: params[:role])
        redirect_to manage_members_path
    end

    private

    def member_params
        params.require(:user).permit(:uid, :full_name, :email, :role, :other_attributes)
    end

end
