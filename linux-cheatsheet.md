Linux Cheatsheet
===============

# Table of Contents
- [User Management](#User-Management)
- [SSH Key Generation](#SSH-Key-Generation)
- [Creating a tarball/archive](#creating-a-tarball-archive-file)
- [Add customer service to systemd](#add-customer-service-to-systemd)

# User Management 

## Add & remove a user

Let us add a user.

```bash
useradd -m username
```

This will add a user with a home directory.  Replace `username` with the username of your choice.

For login screens where seeing a users actual name instead of their username is desired add a `-C` as follows:

```bash
useradd -m username -C "Full Name"
```

The option `-C` denotes that we are commenting the user as their proper name.
Replace `Full Name` with the desired or proper name of the user.

## Adding a user to a group

```bash
usermod -aG group username
```

This command modifies a user to be joined to a group (i.e. sudo).
Replace `group` and `username` with the desired group and username.

## User password

```bash
passwd username
```

This command modifies the password for the user.
You will be prompted for the new user password.

To set a temporary password that will force the user to change their password upon logging in for the first time after setting the password:

```bash
chage -d 0 username
```

What this command does is use the `-d` flag/option to set the age limit of the password to `0`.
This effectively causes the password to immediately expire.
When the user logs in with the password, they will be prompted to change their password.

## Change user type

It is entirely possible to change a user from a "regular" user to a system user.
For example, you might have a system administrator user account that you don't want shown on the login page.
As super user:

```bash
cd /var/lib/AccountsService/users/
```

Edit the file that corresponds with the user you are editing.
The boolean value of `SystemAccount` is by default set to false.

## Log out user

You are able to use the CLI to log out a user.
This can be done using the following command:

```bash
killall -u username
```

The `killall` command has the flag `-u` to tell the system to terminate processes owned by a particular user.
Replace `username` with the username.
This will result in that user getting logged out of their session.

# SSH Key Generation

## ED25519

```
ssh-keygen -t ed25519
```

## RSA

```
ssh-keygen -t rsa -b 4096
```

## Explanation

The above examples will create a SSH key of either type (ED25519 or RSA).
The commands will introduce a prompt which will ask you to name the file of the SSH key.
Some users may prefer to have a separate key generated, but it is not required.
However, checking with your system administrator regarding the specific SSH key policy or practice for your organization is a good idea.

Additionally, you may use the `-C` flag to comment each SSH key.
Some network resources or online services may require or recommend a comment.

# Creating a tarball (archive file)

There may come a time when creating an archive (compressed) file is necessary.
Perhaps it is time to save space, but saving the data is important.
Or you may be manually copying a log of files to a new machine.
This is when creating a tarball (tarring a file or directory) is useful.

## Compressing a directory

To compress a directory simply execute:

```
tar -czvf nameoffile.tar.gz /path/to/directory
```

Where `c` creates the new archive, `z` filters the the archive through `gzip`, `v` gives verbose output, and `f` use the specified archive file (i.e. `nameoffile.tar.gz`).

Replace `nameoffile` with an easy to identify filename.
Replace `/path/to/directory` with the full filepath of the directory.

### Excluding a file or directory

Let us assume that you are creating a tarball of `/path/to/directory` which contains `dir01`, `dir02`, and `dir03`.
For archiving purposes you do not need the contents of `dir02`.
You can exclude `dir02` by executing the following:

```
tar -czvf nameoffile.tar.gz --exclude='dir02' /path/to/directory
```

In this example we are excluding `dir02`.
The `--exclude` flag cannot contain a list of files or directories, so the flag will have to be used for each file or directory you want to exclude.
There is an easier way.

#### Use an exclude file

1. Using your text editor create a file (i.e. `exclude.txt`) and fill each line of the file with a different file or directory as below:

```
dir02
dir04
file3
file4
file9
```

2. Save the file.
3. Execute the following:

```
tar -czvf nameoffile.tar.gz -X exclude.txt /path/to/directory
```

What this will do is exclude any files listed in the exclude file while it creates the archive.

## Check the contents of a tarball

You can check the contents of a tarball by executing:

```
tar -ztvf nameoffile.tar.gz
```

Where `t` lists the contents of the archive.  Flags `z`, `v`, and `f` do as described above.

## Unpacking a tarball

You can unpack the contents of an archive by executing the following:

```
tar -xzvf nameoffile.tar.gz
```

Where the `x` flag extracts from the archive.

To extract to a specific path execute:

```
tar -xzvf nameoffile.tar.gz -C /path/to/destination/
```

Where `-C` changes the target directory to the directory path specified.

# Add customer service to systemd

Sometimes you might want to add a custom daemon to systemd that auto runs.
This instruction will use an example for writing a service file to run an application.

1. Create a unit file

The unit file will **always** include `.service`.
Example: `myunit.service`.
In the below example unit file we are setting up a systemd service file to start after *reboot* and after detecting that the network is online.

```
[Unit]
Description=Start my app after reboot
After=network-online.target

[Service]
ExecStart=/path/to/myapp
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

In the above example we have three important aspects of the unit file.

- **[Unit]**: This defines the unit file and when it should activate.
- **[Service]**: This defines the command that should be run, by what user, and if it should always restart.
- **[Install]**: This defines what the unit is being requested by.

While the *Description* is not necessary, it is best practice to describe what the unit file should do.
We definte the *User* as **root** because we want the unit to be run by **root**.
Defining `multi-user.target` is a good practice because it ensures that the service starts in a state where the system is operational, but without a graphical user interface (GUI).

2. Add to systemd

To add to systemd move or copy the unit file you created into the `/etc/systemd/system` directory.
You may also create a symlink using the command `ln -s /path/to/app myunit.service`.

3. Restart systemd daemon

Next restart the systemd daemon by the following command:

```
systemctl daemon-reload
```

This ensures that systemd recognizes `myunit.service` as a service.

4. Test your service

Run the following command:

```
systemctl start myunit.service
```

Then run:

```
systemctl status myunit.service
```

You will see output that shows that your service is running.
You will also see log output as well.
Pay attention to any error messages and troubleshoot as needed.

5. Enable your service

Run the following command:

```
systemctl enable myunit.service
```

This will enable the service.
With the service enabled systemd will automatically start the service at boot.
