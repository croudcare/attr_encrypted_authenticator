require "attr_encrypted_authenticator/authenticator_base"
require "active_support/all"

module AttrEncryptedAuthenticator::Authenticators
  class ::DateTimeOrDefaultNilAuthenticator < AttrEncryptedAuthenticator::AuthenticatorBase
    def authenticate
      val.to_datetime
    rescue
      nil
    end
  end

  class ::BoolOrDefaultFalseAuthenticator < AttrEncryptedAuthenticator::AuthenticatorBase
    TRUE_VALUES = [ '1', 't', 'true', 'on' ]

    def authenticate
      val_as_bool
    rescue
      false
    end

  private

    def val_as_bool
      TRUE_VALUES.include? val.to_s.downcase
    end
  end
end