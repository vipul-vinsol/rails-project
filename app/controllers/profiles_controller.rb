class ProfilesController < ApplicationController

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    if profile_params[:avatar]
      @profile.avatar.attach(profile_params[:avatar])
    end

    @profile.assign_topics(profile_params[:topics])

    if @profile.save
      redirect_to edit_user_profile_path(current_user), notice: t(:profile_update_success)
    else
      render :edit
    end
  end

  def profile_params
    params.require(:profile).permit(:avatar, topics: [])
  end
end