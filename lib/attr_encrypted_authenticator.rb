require "attr_encrypted_authenticator/version"
require "attr_encrypted_authenticator/authenticators"
require "attr_encrypted_authenticator/exceptions"
require "active_support/all"

module AttrEncryptedAuthenticator
  def attr_encrypted_authenticator(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}

    klass = options[:authenticator]
    callback = options[:callback]
    aditional_options = options[:options]

    if !(klass.is_a? Class and klass < AttrEncryptedAuthenticator::AuthenticatorBase)
      raise AttrEncryptedAuthenticatorExceptions::AuthenticatorClassError, "'#{klass.to_s}' is not a class of type AttrEncryptedAuthenticator::AuthenticatorBase"
    end

    args.each do |attribute_name|
      alias_method_name = "original_#{attribute_name}="
      overriding_method_name = "#{attribute_name}="

      alias_method alias_method_name, overriding_method_name
      define_method(overriding_method_name) do |val|
        send("#{alias_method_name}", klass.new(val, aditional_options).authenticate)
        send(callback) if callback.present?
      end
    end
  end
end
