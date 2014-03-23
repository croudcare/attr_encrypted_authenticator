# attr_encrypted_authenticator

attr_encrypted allows to easily handle encryption, but models with encrypted attributes lose the capability to automatically set attributes to the correct type, which is something useful when working, for example, with active_record and models initialized by form submition. This gem tries to restore that functionality.

Please note that even though this gem works with attr_encrypted it doesn't depend on it, so you'll need to add it youself.

Also a big thanks to the guys that made attr_encrypted (homepage: https://github.com/attr-encrypted/attr_encrypted).

Check section "Why & How" for more details.

## Installation

Add this line to your application's Gemfile:

    gem 'attr_encrypted_authenticator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attr_encrypted_authenticator

## Usage

Extend your model with attributes you want to encrypt:

    extend AttrEncryptedAuthenticator

Add attr_encrypted method for encrypted attributes, also don't forget to set marshal as true to save and load as the correct type (according to documentation should be true by default when working with active_record but didn't work for me using version 1.2.1):

    attr_encrypted :start_date, :end_date, key: "some key", marshal: true

The following line has to come after the calling attr_encrypted (since it overrides methods set by it):

    attr_encrypted_authenticator :start_date, :end_date, authenticator: DateTimeOrDefaultNilAuthenticator

Now every time "start_date" and "end_date" is set, the value is validated and converted so that it's a datetime (or nil in case it's a value not convertable with to_datetime method from active_support) before setting them.

Also in case you want to aditional work after the value is set, you may pass the callback method name for that:

    attr_encrypted_authenticator :start_date, authenticator: DateTimeOrDefaultNilAuthenticator, callback: :recalculate_duration

    def recalculate_duration
      # ...
    end

We provide two base authenticator classes, DateTimeOrDefaultNilAuthenticator and BoolOrDefaultFalseAuthenticator, and you use them by setting it as the value for the authenticator key:

    attr_encrypted_authenticator :rainy_day, authenticator: BoolOrDefaultFalseAuthenticator

Besides the authenticators provided, you may also want create and use your own authenticator, to do so just define a class that inherits from AuthenticatorBase, as follows:

    class NameAuthenticator < AttrEncryptedAuthenticator::AuthenticatorBase
      def authenticate
        # available instance attributes:
        # value: this is the value that is being set
        # options: in case you want to pass some aditional parameters to your authenticator, you may do so by providing them in the option key
    end

Now just use it:

    attr_encrypted_authenticator :first_name, authenticator: NameAuthenticator, options: { titleize: true }

## Why & How

While working in a ror project I noticed that all the encrypted attributes were (obvioulsy) strings, which means that we lose the convenience of type convertion as when we are working with regular attributes.

As an example, imagine that we have a model "user" that has the attribute "birth_date". Normally we would set this attribute as a datetime, and we would always work with a datetime, even if we set the value from a string. The following lines return a birth_date of type DateTime (nil on unconvertible value):

    User.new(birth_date: "1981-12-12")
    user.birth_date = "1992-1-1"

Now what happens when working with AttrEncrypted? It sets the value as is, so doing user.birth_date = "1990-1-1" will set birth_date as string, which can be inconvenient, and a custom marshaler doesn't help us since it only works with the value that goes to be encrypted, while the original value that goes to birth_date remains untouched (besides it didn't feel right for the marshaler to be converting the value anyway).

So as a solution, what this gem does is to override the attribute setter, thus allowing us to convert the value being set to whatever type we want, so we go from this:

    set value -> encrypt value and set to encrypted_attribute -> set value to attribute

to this:

    set value -> execute authenticator -> encrypt value and set to encrypted_attribute -> set value to attribute -> callback

That's about it.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/attr_encrypted_authenticator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
