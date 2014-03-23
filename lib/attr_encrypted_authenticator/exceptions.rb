module AttrEncryptedAuthenticator::Exceptions
  class AttrEncryptedAuthenticatorStandardError < StandardError; end

  class AuthenticatorClassError < AttrEncryptedAuthenticatorStandardError; end
  class DefaultAuthenticateCalledError < AttrEncryptedAuthenticatorStandardError; end
end