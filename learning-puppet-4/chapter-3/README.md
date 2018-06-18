# Chapter 3. Installing Puppet

In this chapter, we are going to install Puppet in the new vagrant box that we have prepared from the previous chapter. The steps are as follows:

1. Add the package repository.

     ```
     sudo yum install -y  http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
     ```

     Afterward, we can verify that the new repository is in our repolist by running:

     ```
     sudo yum repolist
     ```

2. Install Puppet agent.

     ```
     sudo yum install -y puppet-agent
     ```

     We can view all dependencies that are installed together with Puppet by running:

     ```
     ls -al /opt/puppetlabs/bin/
     ```

3. Setup environment.

     Puppet agent is not installed in the default binary directories such as `/usr/bin/` or `/usr/local/bin/`. Therefore we need to set it up by executing `puppet-agent.sh`:

     ```
     source /etc/profile.d/puppet-agent.sh
     ```

     For learning purpose, we may want to do commands in this book without having to write `sudo` over and over again. For this purpose, we change `etc/puppetlabs` owner to our vagrant user:

     ```
     sudo chown -R vagrant /etc/puppetlabs
     ```

     In addition to be able to run `puppet` command without writing `sudo`, in many cases we do need to run `sudo puppet` (for instance, to view resources that requires sudo privilege). Therefore, we need to add `/opt/puppetlabs/bin` directory to sudo's secure path:

     ```
     sudo grep secure_path /etc/sudoers \
       | sed -e 's#$#:/opt/puppetlabs/bin#' \
       | sudo tee /etc/sudoers.d/puppet-securepath
     ```

That's all and we're set to go.
