require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable
      def authenticate!
        if params[:user]
          ldap = Net::LDAP.new
          ldap.host = ENV[LDAP_HOST]
          ldap.auth "cn=#{login},ou=Employees,dc=isma,dc=ivanovo,dc=ru", password
        
          if ldap.bind
            user = User.find_or_create_by(login: login)
            success!(user)
          else
            return fail(:invalid_login)
          end
        end
      end
      
      def login
        params[:user][:login]
      end

      def password
        params[:user][:password]
      end

    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)