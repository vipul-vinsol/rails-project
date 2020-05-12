class ProfilesController < ApplicationController

  def edit
    @profile = Profile.find_by(user_id: current_user.id)
  end

  def attach_avatar
    @profile = current_user.profile
    @profile.avatar.attach(profile_params[:avatar])
    if @profile.save()
      redirect_to profile_user_path(current_user), notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  def profile_params
    params.require(:profile).permit(:avatar)
  end
end