namespace :admin do
  desc "Creates admin user"
  task :new => :environment do
    puts "Enter your name: "
    username = STDIN.gets
    puts "Enter your email: "
    email = STDIN.gets
    puts "Enter a password: "
    password = STDIN.gets
    unless username.strip!.blank? || email.strip!.blank? || password.strip!.blank?
      ActiveRecord::Base.transaction do
        admin = User.new(name: username, email: email, password: password, 
                        password_confirmation: password,  role: 'admin')
        admin.skip_confirmation!
        admin.save!
        admin.create_profile!
        admin.credit_transactions.create!(amount: ENV['signup_credits'], reason: CreditTransaction::reasons[:signup])
        puts "The admin was created successfully."
      end
    end
  end
end