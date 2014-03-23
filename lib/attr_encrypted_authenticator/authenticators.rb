require "attr_encrypted_authenticator/exceptions"
require "active_support/all"

class AttrEncryptedAuthenticator::AuthenticatorBase
  attr_accessor :val, :options

  def initialize(val, options)
    self.val = val
    self.options = options
  end

  def authenticate
    raise AttrEncryptedAuthenticatorExceptions::DefaultAuthenticateCalledError, "default authenticate method called, either you called it which isn't needed or it wasn't overridden"
  end
end

class DateTimeOrDefaultNilAuthenticator < AttrEncryptedAuthenticator::AuthenticatorBase
  def authenticate
    val.to_datetime
  rescue
    nil
  end
end

class BoolOrDefaultFalseAuthenticator < AttrEncryptedAuthenticator::AuthenticatorBase
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