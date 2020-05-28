class ProfilesController < ApplicationController
  before_action :set_profile

  def edit
  end

  def show
  end

  def update
    if profile_params[:avatar]
      @profile.avatar.attach(profile_params[:avatar])
    end

    @profile.assign_topics(profile_params[:topics])

    if @profile.save
      redirect_to edit_user_profile_path(current_user), notice: t('questions.profile_update_success')
    else
      render :edit
    end
  end

  def profile_params
    params.require(:profile).permit(:avatar, topics: [])
  end

  private def set_profile
    @profile = current_user.profile
  end
end