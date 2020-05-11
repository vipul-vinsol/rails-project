class ProfilesController < ApplicationController

  def edit
    @profile = Profile.find_by(user_id: current_user.id)
  end

  def attach_avatar
    user = User.find(current_user.id)
    user.profile.avatar.attach(params[:profile][:avatar])
    if user.save()
      redirect_to user_profile_path(user_id: user.id), notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end
end