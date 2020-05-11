class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable


  #FIXME_AB: add validation on name. presence

  #FIXME_AB: dependent?
  has_one :profile


  def after_confirmation
    #FIXME_AB: this will change
    self.profile = Profile.new(credits: 5)
    self.save()
  end
end
