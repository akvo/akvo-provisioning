
module Puppet::Parser::Functions

    # Creates a new puppet function called 'firstof' which will return the first
    # argument it is given which has a non-empty value
    #
    # Example usage:
    #
    #    $real_value = ($possibly_nil, $some_default)
    #
    # This allows values to be set based on the presence or not of an argument to
    # a parameterised class, for example.
    #
    # See http://serverfault.com/questions/392783/how-to-make-a-variable-in-a-parameterized-puppet-class-default-to-the-value-of-a

    newfunction(:firstof, :type => :rvalue) do |args|
        value = nil
        args.each { |x|
            if ! x.nil? and x.length > 0
                value = x
                break
            end
        }
        return value
    end

end