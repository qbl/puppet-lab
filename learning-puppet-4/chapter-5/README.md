# Chapter 5. Using The Puppet Configuration Language

## Variables

### Variable Basics

1. Puppet variables are just like Ruby variables prefixed with $:

     ```
     $my_var
     ```

2. Variables starting with underscore should only be used within the local scope:

     ```
     $_my_var
     ```

3. Variable assignment works just as Ruby assignmen:

     ```
     $string_var = 'value'
     $num_var = 1234
     $boolean_var = true
     ```

4. Uninitialized variabbles are evaluated as `undef`. We can assign `undef` to a variable:

     ```
     $not_defined_var = undef
     ```

5. We can use `puppetlabs/stdlib` module to see variable's type:

     ```
     include stdlib
     $name_type = type_of($my_name)
     $num_type = type_of($my_num)
     ```

### Defining Numbers

Valid numeric types in Puppet are:

```
$decimal = 1234
$float = 12.34
$octal = 0775
$hexadecimal = 0xFFAA
$string = '001234'
```

I'm still unsure about the `$string` part, is it treated as numeric or as string.

### Arrays and Hashes

1. Arrays in Puppet work just like arrays in Ruby, they can contain objects with different data type:

     ```
     $num_array = [1, 2, 3, 4]
     $text_array = ["A", "B", "C", "D"]
     $mixed_array = [1, "A", 2, "B"]
     $trailing = [1, 2, 3,]
     $nested = [1, 2, [3, 4]]
     ```

2. Puppet allow array-to-array assignment if there are equal number of variables and values:

     ```
     [$first, $middle, $last] = ["Iqbal", undef, "Farabi"] # OK
     [$first, $middle, $last] = ["Iqbal", "Farabi"] # not OK
     ```

3. Splat operator works just as normal Ruby, we can use it to convert array to comma-separated list of values with `*`:

     ```
     my_method(*$array_of_arguments) { # some block here }
     ```

4. The biggest difference with Ruby hashes is that hashes in Puppet only allow string and number as key and do not allow symbol. Therefore, we can only use `=>` in Puppet hashes:

     ```
     $homes = {
       'qbl' => '/home/qbl'
     }
     ```

### Using Variables in String

1. String interpolation works with `${}` inside double quotes:

     ```
     notice("Hello ${username}, how are you today?")
     ```

2. For large block of text, we can use heredoc multiline format:

     ```
     $message = @(END)
     This is a long message,
     spanning into multiple lines.
     END
     ```

3. To do string interpolation with heredoc multiline format, use:

     ```
     $message = @("END")
     Dear ${user},
     To change your password, please visit this page: ${site_url}.
     END
     ```

4. To redact sensitive values, we can use:

     ```
     $my_passphrase = Sensitive("Some sensitive passphrase here")
     ```

5. Curiously, the book says that this will output every value in `my_list` array followed by string `[1]`:

     ```
     notice("The second value in the list is $my_list[1]")
     ```

6. However, I can understand that the following examples work just fine:

     ```
     notice("The second value in the list is ${my_list[1]}")
     notice("The value stored with key alpha is ${my_hash['alpha']}")
     ```

7. To prevent interpolation, we use escape character `\`:

     ```
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

     ```
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
