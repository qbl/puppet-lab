# Chapter 4. Writing Manifests

In Puppet, a manifest is a file containing configuration language that describes the desired state of resources. A manifest is the base component for Puppet configuration policy and a building block for complex Puppet modules.

## Implementing Resources

As mentioned above, a manfiest describes the desired state of resources. Resources are the smallest building block of the Puppet configuration language. Puppet comes with many built-in resource types, including but not limited to: users, groups, files, host file entries, packages, and services.

This is a simple example of a `notify` resource:

```
notify { 'greeting':
  message => 'Hello, world!'
}
```

We can put it in a Puppet manifest file, for instance named `hello-world.pp`, and apply the configuration policy with command:

```
puppet apply hello-world.pp
```

## Applying a Manifest

When we executed `puppet apply hello-world.pp` command above, what Puppet does is:
- Compiles a Puppet catalog from the manifest.
- Uses dependency and ordering information to determine evaluation order.
- Evaluates the target resource to determine if changes should be applied.
- Creates, modifies, or removes the resource. In our previous case, a notification message is created.
- Provides verbose feedback about the catalog application.

## Declaring Resources

As we learned from our exercise above, the format to declare a resource is as follow:

```
resource_type { 'resource_title':
  ensure => present, # or absent
  attribute1 => 'value' # value can be different data types such as string, number, boolean, or array, to name a few
}
```

The most important thing to remember is within a set of manifests that are applied together, there can be no duplicate of resource title.

## Viewing Resources

Puppet can also show us existing resources, formatted in the Puppet configuration language. Below is an example of how to view a resource with Puppet:

```
puppet resource mailalias postmaster
```

There is one thing that bothers me a little though. If we try to run this command:

```
puppet resource user vagrant
```

Puppet will return an error message:

```
Error: Could not run: undefined method 'exists?' for nil:NilClass
```

That error message is a little bit misleading because what we actually need to make the command work is by adding `sudo` in front of it. That's because to view the resource, we need administrator privilege provided by `sudo`. This command will work:

```
sudo puppet resource user vagrant
```

## Executing Programs

In Puppet we can execute a program with `exec` like this:

```
exec { 'echo-hello-exec':
  path => ['/bin'],
  cwd => '/tmp',
  command => 'echo "hello exec" > testfile.txt',
  creates => '/tmp/testfile.txt',
  returns => [0],
  logoutput => on_failure
}
```

But the usage of `exec` manifest is discouraged by the author because of two reasons. The first is because it will be hard to keep idempotency with `exec`. The second is because it will make us revert to imperative programming instead of declarative programming. Only use `exec` when there is no other way to achieve the desired configuration state.

## File Resources

To replace the `exec` manifest above, we can use file resource:

```
file { '/tmp/testfile.txt':
  ensure => present,
  mode => '0644',
  replace => true,
  content => 'hello file resource'
}
```

When we apply the manifest above, we can make Puppet to evaluate configurion changes on a lot of things, including permission and content of the file.

Every file changed by Puppet `file` resource is backed up on the node in a directory specified by `$clientbucketdir` configuration setting. We can also tell Puppet to backup a file manually with this command:

```
sudo puppet filebucket --local backup /tmp/testfile.txt
```

We can see the list of backup files created by Puppet (both manually and automatically) with the following command:

```
sudo puppet filebucket --local list
```

To view the content of specific backup file, we can use the hash associated with the backup file using this command:

```
sudo puppet filebucket --local get [hash-code-here]
```

We can also compare files and backups using this command:

```
sudo puppet filebucket --local diff \
  [hash-code-here] /tmp/testfile.txt
```

Lastly, we can also restore a backup file to any location:

```
sudo puppet filebucket --local restore \
  /tmp/testfile.old [hash-code-here]
```
