# frozen_string_literal: true

class ManageMembersController < ApplicationController
  def index
    @users = User.all.order(:full_name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.uid = generate_uid
    @user.full_name = params[:user][:full_name]
    @user.email = params[:user][:email]
    @user.role = params[:user][:role]
    @user.avatar_url = 'testing'
    if @user.save
      redirect_to(manage_members_path, notice: 'New member added successfully.')
    else
      render(:new)
    end
  end

  before_action :authenticate_user!, only: [:destroy]
  def destroy
    @member = User.find_by(uid: params[:id])
    if @member.destroy
      redirect_to(manage_members_path, notice: 'Member removed successfully.')
    else
      redirect_to(manage_members_path, alert: 'Failed to remove member.')
    end
  end

  def update_role
    updatee = User.where(uid: params[:uid])
    updatee.update!(role: params[:role])
    redirect_to(manage_members_path)
  end

  private

  def generate_uid
    # Logic to generate the UID, such as finding the highest current uid and incrementing it
    highest_uid = Integer((User.maximum(:uid) || '0'), 10)
    (highest_uid + 1).to_s
  end
end
