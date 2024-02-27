class ProjectsController < ApplicationController
    def index
        @projects = Project.all
    end

    def edit
        @project = Project.find(params[:id])
    end

    def destroy
        @project = Project.find(params[:id])
        # render the delete confirmation page
        render :delete
    end

    def delete
        @project = Project.find(params[:id])
    end

    def update
        @project = Project.find(params[:id])
        if @project.update(project_params)
          redirect_to projects_path, notice: 'Project was successfully updated.'
        else
          render :edit
        end
    end

    def project_params
        params.require(:project).permit(:project_name, :other_attributes)
    end

    def remove_member_confirmation
        @project = Project.find(params[:id])
        @member = User.find(params[:member_id])
        render :remove_member
    end
      
    def remove_member
        @project = Project.find(params[:id])
        @member = User.find(params[:member_id])
      
        if @project.members.delete(@member)
          flash[:notice] = "Member removed from the project successfully."
        else
          flash[:error] = "Failed to remove member from the project."
        end
      
        redirect_to edit_project_path(@project)
    end

end