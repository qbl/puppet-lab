# Chapter 5. Using The Puppet Configuration Language

## Variables

### Variable Basics

1. Puppet variables are just like Ruby variables prefixed with $:

     ```puppet
     $my_var
     ```

2. Variables starting with underscore should only be used within the local scope:

     ```puppet
     $_my_var
     ```

3. Variable assignment works just as Ruby assignment:

     ```puppet
     $string_var = 'value'
     $num_var = 1234
     $boolean_var = true
     ```

4. Uninitialized variables are evaluated as `undef`. We can assign `undef` to a variable:

     ```puppet
     $not_defined_var = undef
     ```

5. We can use `puppetlabs/stdlib` module to see variable's type:

     ```puppet
     include stdlib
     $name_type = type_of($my_name)
     $num_type = type_of($my_num)
     ```

### Defining Numbers

Valid numeric types in Puppet are:

```puppet
$decimal = 1234
$float = 12.34
$octal = 0775
$hexadecimal = 0xFFAA
$string = '001234'
```

I'm still unsure about the `$string` part, is it treated as numeric or as string.

### Arrays and Hashes

1. Arrays in Puppet work just like arrays in Ruby, they can contain objects with different data type:

     ```puppet
     $num_array = [1, 2, 3, 4]
     $text_array = ["A", "B", "C", "D"]
     $mixed_array = [1, "A", 2, "B"]
     $trailing = [1, 2, 3,]
     $nested = [1, 2, [3, 4]]
     ```

2. Puppet allow array-to-array assignment if there are equal number of variables and values:

     ```puppet
     [$first, $middle, $last] = ["Iqbal", undef, "Farabi"] # OK
     [$first, $middle, $last] = ["Iqbal", "Farabi"] # not OK
     ```

3. Splat operator works just as normal Ruby, we can use it to convert array to comma-separated list of values with `*`:

     ```puppet
     my_method(*$array_of_arguments) { # some block here }
     ```

4. The biggest difference with Ruby hashes is that hashes in Puppet only allow string and number as key and do not allow symbol. Therefore, we can only use `=>` in Puppet hashes:

     ```puppet
     $homes = {
       'qbl' => '/home/qbl'
     }
     ```

5. In Puppet, we can retrieve specific values from a hash bby assigning to an array of variables for the keys we'd like to retrieve. I find this one to be quite peculiar as well:

     ```puppet
     [$iqbal] = $homes # in Puppet, this is identical to $iqbal = $homes['iqbal']
     [$username, $uid] = $user # $username = $user['username'] and $uid = $user['uid']
     ```

6. We can also define attribute with hash in Puppet by combining it with splat operator:

     ```puppet
     $resource_attributes = {
       ensure => present,
       owner => root,
       group => root,
       'mode' => '0644',
       'replace' => true
     }

     file { '/etc/config/first.cfg':
       source => 'first.cfg',
       * => $resource_attributes
     }
     ```

### Using Variables in String

1. String interpolation works with `${}` inside double quotes:

     ```puppet
     notice("Hello ${username}, how are you today?")
     ```

2. For large block of text, we can use heredoc multiline format:

     ```puppet
     $message = @(END)
     This is a long message,
     spanning into multiple lines.
     END
     ```

3. To do string interpolation with heredoc multiline format, use:

     ```puppet
     $message = @("END")
     Dear ${user},
     To change your password, please visit this page: ${site_url}.
     END
     ```

4. To redact sensitive values, we can use:

     ```puppet
     $my_passphrase = Sensitive("Some sensitive passphrase here")
     ```

5. Curiously, the book says that this will output every value in `my_list` array followed by string `[1]`:

     ```
     notice("The second value in the list is $my_list[1]")
     ```

6. However, I can understand that the following examples work just fine:

     ```puppet
     notice("The second value in the list is ${my_list[1]}")
     notice("The value stored with key alpha is ${my_hash['alpha']}")
     ```

7. To prevent interpolation, we use escape character `\`:

     ```puppet
     $the_greeting = "we need 'single quotes' and \"double quotes\" here."
     $describe = "\$user uses a \$ dollar sign and a \\ backslash"
     ```

     Or, just as with Ruby, we can also use single quote to avoid string interpolation.

8. In Puppet, we can't reassign value to variables.

## Finding Facts

Puppet is bundled with a tool called Facter. We can use Facter to find facts about a node.

1. To print every facts known by Facter, simply run the command in our node:

     ```
     facter
     ```

     Of course we can also combine it with grep:

     ```
     facter | grep version
     ```

     To see all facts used by Puppet, we can use:

     ```
     facter --puppet
     ```

2. Puppet always adds the following facts above and beyond system facts provided by Facter:

     ```puppet
     $facts['clientcert']
     $facts['clientversion']
     $facts['clientnoop']
     $facts['agent_specified_environment']
     ```

     All of these facts can be found in `$facts` hash.

3. We can also use the following command to list out Puppet facts in JSON format:

     ```
     puppet facts find
     ```

4. Both Facter and Puppet's `facts find` can be instructed to output format in yaml and JSON:

     ```
     facter --yaml
     puppet facts find --render-as yaml

     facter --json
     puppet facts find --render-as json
     ```

## Calling Functions in Manifests

According to the book, functions in Puppet may return a value. I find this interesting because in Ruby, every method always returns a value and I think functions in Puppet is the equivalent of methods in Ruby.

Below we can find two examples how to call `md5` function in a manifest:

```puppet
# Example 1: calling function
notify { 'md5_hash':
  message => md5($facts['fqdn'])
}

# Example 2: calling function in string interpolation
$result = "The MD5 hash for the node name is ${md5($facts['fqdn'])}"
notify { 'result':
  message => $result
}
```

## Multiple Resources

1. We can use array to define multiple resource titles:

     ```puppet
     file { ['/tmp/file_one.txt', '/tmp/file_two.txt']:
       ensure => present,
       owner => vagrant
     }
     ```

     Resource definition above will create two files.

2. We can declare multiple resource bodies such as:

     ```puppet
     file {
       'file_one':
         ensure => present,
         owner => 'vagrant',
         path => 'file_one.txt'
       ;

       'file_two':
         ensure => present,
         owner => 'vagrant',
         path => 'file_two.txt'
     }
     ```

     Resource defnition above will create two files.

3. Multiple resource definiton can come very handy when we are doing things such as the following:

     ```puppet
     file {
       default:
         ensure => present,
         owner => 'vagrant'
       ;

       'file_one': path => 'file_one.txt';
       'file_two': path => 'file_two.txt';
     }
     ```

## Operators

1. Standard arithmetic operators:

     ```puppet
     $added       = 10 + 5       # 15
     $subtracted  = 10 - 5       # 5
     $multiplied  = 10 * 5       # 50
     $divided     = 10 / 5       # 2
     $remainder   = 10 % 5       # 0
     $two_bits_l  = 2 << 2       # 8
     $two_bits_r  = 64 >> 2      # 16
     ```

     Although both `<<` and `>>` for bit operator are something that I'm not really familiar with.

2. This is a new feature in Puppet 4, adding items to array and hash:

     ```puppet
     $my_list = [1, 2, 3]
     $more_list = $my_list + [4, 5]

     $my_hash = {name => 'Iqbal', uid => 1001}
     $user = $my_hash + {gid => 500}
     ```

     For array, we can use the good old Ruby syntax as well:

     ```puppet
     $more_list = $my_list << [4, 5]
     ```

3. Interestingly, we can use `-` to remove items from array and hash in Puppet:
 
     ```puppet
     # Remove a single value from array
     $nations = ['Italy', 'Germany', 'Spain']
     $world_cup = $nations - 'Italy'

     # Remove a multiple values from array
     $nations = ['Italy', 'Germany', 'Spain', 'Netherlands']
     $world_cup = $nations - ['Italy', 'Netherlands']

     # Remove a single value from hash
     $name = {first => 'Iqbal', last => 'Farabi'}
     $surname = $name - 'first'

     # Remove a multiple values from hash
     $name = {first => 'Iqbal', middle => undef, last => 'Farabi'}
     $surname = $name - ['first', 'middle']

     # Remove all matching keys
     $user = {name => 'Iqbal', uid => 1001, guid => 500}
     $compare = {name => 'Iqbal', uid => 1001, home => '/home/jo'}
     $difference = $user - $compare
     ```

4. Comparison operators mostly work like Ruby, except for a little quirk with string and additional compariosn operators (`=~` and `!~`):

     ```puppet
     # Numeric comparison is all fine
     4 != 4.1 # true
     3 < 4 # true
     5 > 4 # true

     # String is a little bit weird
     coffee == 'coffee' # true, weird right?
     'Coffee' == 'coffee' # true, case insensitive, also weird
     !('tea' in 'coffee') # true
     !('Fee' in 'coffee') # true, case insensitive, weird as well

     # Array and Hash
     [1, 2, 5] != [1, 2] # true, only == if identical arrays
     5 in [1, 2, 5] # true, nothing surprising here

     {name => 'Joe'} != {name => 'Jo'} # true, only == if identical hash
     'Jo' !in {name => 'Jo'} # true, Jo is a value so it does not match

     # Compare values to data type
     $not_true =~ Boolean        # true if true or false
     $num_tokens =~ Integer      # true if an integer
     $my_name !~ String          # true if not a string
     ```

## Conditional Expressions

1. Basic conditional with curly braces:

     ```puppet
     if ($config == 'ok') {
       notify { 'notification':
         message => 'ok'
       }
     }
     elsif ($config == 'not ok') {
       notify { 'notification':
         message => 'not ok'
       }
     }
     else {
       notify { 'notification':
         message => 'no config'
       }
     }
     ```

2. New in Puppet 4, we can use unless-else:

     ```puppet
     unless $facts['kernel'] == Linux {
       notify { 'You are on an older machine.': }
     }
     else {
       notify { 'We got you covered.': }
     }
     ```

     But as usual, unless-else conditional is a little bit confusing to read.

3. Case conditions look a little bit different from Ruby and requires us to define default even if it does nothing:

     ```puppet
     case $what_she_drank {
       'wine':            { include state::california }
       $stumptown:        { include state::portland   }
       /(scotch|whisky)/: { include state::scotland   }
       is_tea( $drink ):  { include state::england    }
       default:           {} 
     }
     ```

4. Puppet has a concept called `selectors`. It looks like a normal assignment, but with `?` as if it is a ternary operation and with a comparison syntax like this:

     ```puppet
      $native_of = $what_he_drinks ? {
        'wine'            => 'california',
        $stumptown        => 'portland',
        /(scotch|whisky)/ => 'scotland',
        is_tea( $drink )  => 'england',
        default           => 'unknown',
      }
     ```
