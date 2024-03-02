class ProjectsController < ApplicationController
    before_action :set_project, only: [:edit, :destroy, :delete, :update, :remove_member_confirmation, :remove_member, :add_member, :create_member]
  
    def index
      @projects = Project.all
    end

    def new
        @project = Project.new
    end
    
    def create
        @project = Project.new(project_params)
        if @project.save
            @project.update(project_id: @project.id)
            redirect_to projects_path, notice: 'Project was successfully created.'
        else
            render :new
        end
    end
  
    def edit
    end

    def show
        @project = Project.find(params[:id])
    end
  
    def destroy
        @project = Project.find(params[:id])
        if @project.destroy
          flash[:notice] = "Project successfully deleted."
        else
          flash[:error] = "Failed to delete the project."
        end
        redirect_to projects_path
    end

    def delete
        @project = Project.find(params[:id])
    end
  
    def update
      if @project.update(project_params)
        redirect_to projects_path, notice: 'Project was successfully updated.'
      else
        render :edit
      end
    end
  
    def remove_member_confirmation
      @member = User.find(params[:member_id])
      render :remove_member
    end
    
    def remove_member
      @member = User.find(params[:member_id])
      if @project.members.delete(@member)
        flash[:notice] = "Member removed from the project successfully."
      else
        flash[:error] = "Failed to remove member from the project."
      end
      redirect_to edit_project_path(@project)
    end
  
    def add_member
      @project_member = @project.project_members.build
    end
  
    def create_member
      @project_member = @project.project_members.build(project_member_params)
      if @project_member.save
        redirect_to edit_project_path(@project), notice: 'Member was successfully added to the project.'
      else
        render :add_member
      end
    end
  
    private
  
    def set_project
      @project = Project.find(params[:id])
    end
  
    def project_params
      params.require(:project).permit(:project_name, :leader_id, :other_attributes)
    end
  
    def project_member_params
      params.require(:project_member).permit(:user_id)
    end
  end
  