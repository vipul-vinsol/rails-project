namespace :admin do
  desc "Creates admin user"
  task :new => :environment do
    logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    tag_sting = "[rake: admin:new]"
    puts "Enter your Name: "
    username = STDIN.gets
    puts "Enter your Email: "
    email = STDIN.gets
    puts "Choose a Password: "
    password = STDIN.getpass(''),
    logger.tagged(tag_sting) { logger.info "User input: #{username}, #{email}, #{password}"  }
    unless username.strip!.blank? || email.strip!.blank? || password.strip!.blank?
      ActiveRecord::Base.transaction do
        
        user = User.new(name: username, email: email, password: password, 
                        password_confirmation: password, role: User::roles[:admin])
        user.skip_confirmation!
        user.save!
        
        logger.tagged(tag_sting) { logger.info "Saving User"  }
        
        user.create_profile!
        user.credit_transactions.create!(amount: ENV['signup_credits'], reason: CreditTransaction::reasons[:signup])
        
        logger.tagged(tag_sting) do
         logger.info "Profile and credits created successfully. Admin initialization complete"
        end
        
        puts "The admin was created successfully."
      end
    end
  end
end