class DaysController < ApplicationController
  before_action :set_date

  def index
    redirect_to day_path(Date.current)
  end

  def show
    @exercise_entries = current_user.exercise_entries.where(occurred_on: @date).order(:created_at)
    @medication_entries = current_user.medication_entries.where(occurred_on: @date).order(:created_at)
    @water = water_amounts.sum.convert_to(current_user.settings.water_unit)
    @food_entries = current_user.food_entries.where(occurred_on: @date).order(:created_at)
  end

  private

  def set_date
    @date = Date.parse(params[:id].to_s)
  rescue Date::Error
    redirect_to day_path(Date.current)
  end

  def water_amounts
    amounts = current_user.water_entries.where(occurred_on: @date).map(&:amount)
    if amounts.any?
      amounts
    else
      [Measured::Volume.new(0, :oz)]
    end
  end
end
