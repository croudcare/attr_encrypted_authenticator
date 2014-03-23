require "attr_encrypted_authenticator/version"
require "attr_encrypted_authenticator/authenticators"
require "attr_encrypted_authenticator/exceptions"
require "attr_encrypted_authenticator/authenticator_base"
require "active_support/all"

module AttrEncryptedAuthenticator
  def attr_encrypted_authenticator(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}

    klass = build_authenticator_klass(options[:authenticator])
    callback = options[:callback]

    args.each do |attribute_name|
      alias_method_name = "original_#{attribute_name}="
      overriding_method_name = "#{attribute_name}="

      alias_method alias_method_name, overriding_method_name
      define_method(overriding_method_name) do |val|
        send("#{alias_method_name}", klass.new(val, options[:options]).authenticate)
        send(callback) if callback.present?
      end
    end
  end

  def build_authenticator_klass(authenticator)
    [ authenticator.to_s.camelize, "Authenticator" ].join.constantize
  rescue StandardError => error
    raise AttrEncryptedAuthenticator::Exceptions::AuthenticatorClassError, "unable to retrieve authenticator class for '#{authenticator.to_s}' with message '#{error.message}'\n#{error.backtrace.join("\n")}"
  end
end
