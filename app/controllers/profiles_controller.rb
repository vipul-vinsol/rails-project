class ProfilesController < ApplicationController

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    
    if profile_params[:avatar]
      @profile.avatar.attach(profile_params[:avatar])
    end

    profile_params[:topics].each do |topic_name|
      if topic_name.blank?
        next
      end
      @profile.topics << Topic.find_or_create_by(name: topic_name)
    end

    if @profile.save
      redirect_to profile_user_path(current_user), notice: t(:profile_update_success)
    else
      render :edit
    end
  end

  def profile_params
    params.require(:profile).permit(:avatar, topics: [])
  end
end
