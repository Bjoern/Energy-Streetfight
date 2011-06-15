require 'digest/sha2'

class User < ActiveRecord::Base
    validates_presence_of :name
    validates_uniqueness_of :name
    
    
    belongs_to :ship
    has_many :meter_readings
    has_many :votes

    def self.authenticate(name, password) #todo encrypted password
	puts "pwd #{password} name #{name}"

	user = self.find_by_name(name) 
	puts "user #{user.password}"

	if user and user.password != password
	    #expected_password = encrypted_password(password, user.salt) 
	    #if user.password != expected_password
		user = nil
	    #end
	end
	user
    end
    
    # 'password' is a virtual attribute
    #def password 
	#@password
    #end
#
#    def password=(pwd) 
#	return if pwd.blank? 
#	create_new_salt 
#	@password = User.encrypted_password(pwd, @salt)
#    end


    def self.encrypted_password(password, salt) 
	#puts "pwd #{password} salt #{salt}"

	string_to_hash = password + "hrmblscnuup" + salt #hrmblscnuup makes it harder to guess 
	Digest::SHA2.hexdigest(string_to_hash)
    end

    def create_new_salt 
	@salt = self.object_id.to_s + rand.to_s
    end

end
