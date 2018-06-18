# Chapter 2. Creating a Learning Environment

Not much to do for me on this chapter because most of the tools needed for practices in this book are already installed at my laptop. The few things I need to do is:

1. Download CentOS 7 Box

     ```
     vagrant box add --provider virtualbox centos/7
     ```

2. Clone the learning repository

     ```
     git clone https://github.com/jorhett/learning-puppet4
     ```

     In this repository, I put Jo Rhett's learning repository in `learning-puppet-4/official-src` directory.

3. Install vbguest plugin for Vagrant

     ```
     vagrant plugin install vagrant-vbguest
     ```

4. Initialize Vagrant setup

     From `official-src` directory, run the Vagrant setup that is already written in `Vagrantfile` there:

     ```
     vagrant up client
     ```
