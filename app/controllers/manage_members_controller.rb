# frozen_string_literal: true

require 'csv'

class ManageMembersController < ApplicationController
  def index
    @users = User.all.order(:full_name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.uid = generate_uid
    @user.avatar_url = 'testing'
    if @user.save
      params[:user][:project_ids].each do |project_id|
        project = Project.find_by(id: project_id)
        if project
          ProjectMember.create(project_id: project.project_id, user_id: @user.uid)
        end
      end
      redirect_to(manage_members_path, notice: 'New member added successfully.')
    else
      render(:new)
    end
  end

  before_action :authenticate_user!, only: [:destroy]
  def destroy
    @member = User.find_by(uid: params[:id])
    if @member.destroy
      ProjectMember.where(user_id: @member.uid).destroy_all
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

  def process_batch
    csv_file = params[:csv_file]
    emails_added = []

    if csv_file.present? && csv_file.content_type == 'text/csv'
      csv_data = csv_file.read
      csv = CSV.parse(csv_data, headers: true)

      csv.each do |row|
        email = row['email']
        name = row['name']
        next unless valid_tamu_email?(email)
        next if User.find_by(email: email)

        user = User.new(email: email, full_name: name, uid: generate_uid, role: 'Member')
        if user.save
          emails_added << email
          Rails.logger.debug { "User #{email} added to the database." }
        else
          Rails.logger.debug { "Error creating user #{email}: #{user.errors.full_messages.join(', ')}" }
        end
      end

      flash[:success] = "#{emails_added.count} valid emails added to the database."
    else
      flash.now[:error] = 'Please upload a valid CSV file.'
    end

    render(:batch)
  end

  private

  def user_params
    params.require(:user).permit(:email, :role, :full_name)
  end

  def generate_uid
    # Logic to generate the UID, such as finding the highest current uid and incrementing it
    highest_uid = Integer((User.maximum(:uid) || '0'), 10)
    (highest_uid + 1).to_s
  end

  def valid_tamu_email?(email)
    email.present? && email =~ URI::MailTo::EMAIL_REGEXP && email.ends_with?('@tamu.edu')
  end
end
