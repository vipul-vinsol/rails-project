namespace :admin do
  desc "Creates admin user"
  task :new => :environment do

    tag_sting = "[rake: admin:new]"
    Rails.logger.tagged(tag_sting) do

      puts "Enter your Name: "
      username = STDIN.gets.chomp.strip
      puts "Enter your Email: "
      email = STDIN.gets.chomp.strip
      puts "Choose a Password: "
      password = STDIN.getpass.chomp.strip

      Rails.logger.debug { "User input: #{username}, #{email}, #{password}"  }
      
      unless username.blank? || email.blank? || password.blank?
        ActiveRecord::Base.transaction do

          begin
            user = User.new(name: username, email: email, password: password,
                            password_confirmation: password, role: User::roles[:admin])
            user.skip_confirmation!
            user.save!

            Rails.logger.debug { "Saving User"  }

            user.create_profile!
            user.credit_transactions.create!(amount: ENV['signup_credits'], reason: CreditTransaction::reasons[:signup])

            Rails.logger.debug { "Profile and credits created successfully. Admin initialization complete" }

            puts "The admin was created successfully."
          rescue => e
            puts e.message
            raise ActiveRecord::Rollback, e.message
          end
        end
      end
    end
  end
end
