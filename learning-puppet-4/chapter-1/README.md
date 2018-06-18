# Chapter 1. Thinking Declarative

Coming from developer background, I am accustomed with imperative programming because that's the kind of programs that I usually write. The good thing about this chapter is that it reminds its readers that it is a common mistake to attempt to use Puppet to make changes in an imperative fashion. 

The book argues that when it comes to maintaining configuration on systems, I will find declarative programming as easier to create, read, and maintain. While the book states several arguments to back up the claim that declarative programming is easier to create, read, and maintain, it really comes down to idempotency.

With imperative programming, to add a new user, we need to execute the following command:

```
sudo useradd -u 1001 -g 1001 -c "Joe User" -m joe
```

If we re-execute the previous command, it will return an error message saying that the user we attempted to create already exists. To fix this, with imperative programming we need to change our code to handle that situation:

```
getent passwd $USERNAME > /dev/null 2> /dev/null
if [ $? -ne 0 ]; then
    useradd -u $UID -g $GID -c "$COMMENT" -s $SHELL -m $USERNAME
else
    usermod -u $UID -g $GID -c "$COMMENT" -s $SHELL -m $USERNAME
fi
```

Compare the code above with the following resource declaration for the same user in Puppet:

```
user { 'joe':
  ensure     => present,
  uid        => '1001',
  gid        => '1000',
  comment    => 'Joe User',
  managehome => true,
}
```

We only need to declare the final state that we desire (that is a user called 'joe' to be present in the system) and Puppet will evaluate the systen and then perform any necessary changes to ensure the desired state is achieved.
