# AttrEncryptedAuthenticator

Problem: AttrEncrypted allows to easily handle encryption, yet when working with ActiveRecord we lose the convenience of type casting and have to validate by hand. This gem tries to keep that responsability in the model.

Please note that even though this gem works with AttrEncrypted it doesn't depend on it, so you'll still need to install AttrEncrypted.

Check section "Why & How" for more details.

## Installation

Add this line to your application's Gemfile:

    gem 'attr_encrypted_authenticator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attr_encrypted_authenticator

## Usage

Extend your model:

    extend AttrEncryptedAuthenticator

After that, add authenticator method after setting encrypted attributes, like this:

    attr_encrypted :start_date, :end_date, key: "some key"
    attr_encrypted_authenticator :start_date, :end_date, authenticator: :date_time_or_default_nil

What this means is that when setting the value of attribute start_date, it will set the value after it was authenticated by a class called DateTimeOrDefaultNilAuthenticator (one of the default authenticator classes).

Also you may want to do your own logic after the value is set, so you may pass a callback that will be invoked for this effect:

    attr_encrypted_authenticator :start_date, authenticator: :date_time_or_default_nil, callback: :recalculate_duration

    def recalculate_duration
      # ...
    end

We provide two base authenticator classes, DateTimeOrDefaultNilAuthenticator and BoolOrDefaultFalseAuthenticator, and you use them by setting the value of authenticator key to the underscore version of the name minus the authenticator portion:

    attr_encrypted_authenticator :rainy_day, authenticator: :bool_or_default_false

Besides the authenticators provided, you may also want to use your own authenticator, to do so just define a class that inherits from AuthenticatorBase, as follows:

    class NameAuthenticator < AttrEncryptedAuthenticator::AuthenticatorBase
      def authenticate
        # you have access to self.val, which is the value being set to attribute and an self.options which can be passed to attr_encrypted_authenticator method
      end
    end

Now just use it:

    attr_encrypted_authenticator :first_name, authenticator: :custom, options: { titleize: true }

## Why & How

While working in a ror project I noticed that all the encrypted attributes were (obvioulsy) strings, which means that we lose the convenience of type convertion as when we are working with regular attributes.

As and example, imagine that we have a model user that has a birth_date. Normally we would set this attribute as a datetime, and we would always work with a datetime, even if we set the value from a string. The following lines return a birth_date of type DateTime (nil on unconvertible value):

    User.new(birth_date: "1981-12-12")
    user.birth_date = "1992-1-1"

Now what happens when working with AttrEncrypted? It sets the value as is, so doing user.birth_date = "1990-1-1" will set birth_date as string, which can be inconvenient, and a custom marshaler doesn't help us since it only works with the value that goes to be encrypted, while the original value that goes to birth_date remains untouched (besides it didn't feel right for the marshaler to be converting the value anyway).

So as a solution, what this gem does is to override the attribute setter, thus allowing us to convert the value being set to whatever type we want, so we go from this:

    set value -> encrypt value and set to encrypted_attribute -> set value to attribute

to this:

    set value -> do our job -> encrypt value and set to encrypted_attribute -> set value to attribute -> callback

That's about it.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/attr_encrypted_authenticator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
