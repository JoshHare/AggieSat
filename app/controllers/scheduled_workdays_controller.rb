# frozen_string_literal: true

class ScheduledWorkdaysController < ApplicationController
  def create
    @scheduled_workday = ScheduledWorkday.new(scheduled_workday_params)
    if @scheduled_workday.save
      flash[:notice] = 'Scheduled workday successfully created!'
      redirect_to(project_path(@scheduled_workday.project_id, anchor: 'create-tab-pane'))
    else
      flash[:alert] = 'Failed to create scheduled workday'
    end
  end

  def scheduled_workday_params
    params.require(:scheduled_workday).permit(:program_manager_id, :project_id, :day)
  end
end
