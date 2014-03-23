require "attr_encrypted_authenticator/exceptions"

module AttrEncryptedAuthenticator
  class AuthenticatorBase
    attr_accessor :val, :options

    def initialize(val, options)
      self.val = val
      self.options = options
    end

    def authenticate
      raise AttrEncryptedAuthenticator::Exceptions::DefaultAuthenticateCalledError, "default authenticate method called, either you called it which isn't needed or it wasn't overridden"
    end
  end
end