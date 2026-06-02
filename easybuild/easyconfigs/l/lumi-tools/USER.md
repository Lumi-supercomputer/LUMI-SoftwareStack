# lumi-tools user information

The `lumi-tools` module (which is preloaded when you log in) provides a number 
of tools, including commands for monitoring of your account and projects on LUMI
or to send notifications (as an alternative for the missing email notifications
in Slurm):

-   `lumi-workspaces` is the all-in command and the only one that a user really
    needs.

    There is a modern version and a classic version which is just a shell script
    calling `lumi-quota` and `lumi-allocations`.

    From 26.05 on, the modern version is used while earlier versions used the
    classic version.

-   `lumi-quota` and `lumi-allocations` restrict the output to just the file system
    quota and billing unit information respectively.

-   `lumi-check-quota` implements the same tests that are performed when you log in
    to print warnings about depletion of quota or billing units.

-   The `lumi-ldap-userinfo` and `lumi-ldap-projectinfo` commands are mostly meant 
    for support people and advanced users with a technical understanding of Linux
    user account and group management.

-   `pushover`: Send messages to the [pushover service](https://pushover.net/), which is
    relatively easy to set up and cheap for individuals. This is a tool that is really
    meant to send notifications from scripts etc., and is used by, e.g., sysadmins.

-   `pushslack`: Send messages to [Slack](https://slack.com/). This variant is a bit more
    tricky to set up though, and not all ways of communicating with Slack are supported.
    Slack is not so much meant for automated notifications from scripts but rather for 
    Team communications, so the setup is more cumbersome.


## lumi-workspaces (modern version, 26.05 and later)

The `lumi-workspaces` command combines the functionality of `lumi-quota` and `lumi-allocations`
commands shown below, but is currently only capable to show the output for
all your workspaces/projects (user workspace on `/user`and the various project-related
workspaces on `/project`, `/scratch` and `/flash`).

Note that currently no output is displayed about storage use on the object file 
system as that information is not yet available in a format that a tool can 
always access without temporary access keys.

The check of the allocations in `lumi-workspaces` and `lumi-allocations` 
is currently done based on pre-stored data. That
data is refreshed periodically, but the data can be out-of-date, especially
if the scripts that build up the cache fail. Currently the tool is not
able to show when the data was collected, so the results may be wrong without
warning.

The modern version of the tool also shows what percentage of your total 
project time has been consumed to make it easier to track your relative consumption
of billing units, and how much time is left until your project data gets 
removed from LUMI.


## lumi-workspaces (classic version)

The `lumi-workspaces` command combines the `lumi-quota` and `lumi-allocations`
commands shown below, but is currently only capable to show the output for
all your workspaces/projects (user workspace on `/user`and the various project-related
workspaces on `/project`, `/scratch` and `/flash`).

Note that currently no output is displayed about storage use on the object file 
system as that information is not yet available in a format that a tool can 
always access without temporary access keys.

The check of the allocations in `lumi-workspaces` and `lumi-allocations` 
is currently done based on pre-stored data. That
data is refreshed periodically, but the data can be out-of-date, especially
if the scripts that build up the cache fail. Currently the tool is not
able to show when the data was collected, so the results may be wrong without
warning.


## lumi-quota

The `lumi-quota` command can be used to check your file quota on the 
system.

The command comes in three different forms:
  * `lumi-quota`         : Shows quota for all your workspaces (user and project)
  * `lumi-quota -v`      : Detailed quota information
  * `lumi-quota -p prj`  : Show quota of project prj

This tool only produces output about the Lustre file systems, so directories in
`/user`, `/project` (or the old name `/projappl`), `/scratch` and `/flash`.


## lumi-allocations

The `lumi-allocations` command can be used to check the status of your
allocations on LUMI.

-   To check all your remaining allocations, simply run
    `lumi-allocations`. 
-   Use `lumi-allocations --help`
    for more informations. This command will be extended with more features in the
    future that will be shown through this flag.


## lumi-check-quota (version 23.02 and higher)

The `lumi-check-quota` command is equivalent to the script run at login that prints
a warning when you are running out of quota or out of billing units.

Note that this is fully based on cached data gathered from time to time in the background.
The command will in no way show 100% correct instantaneous numbers, so it is not useable
during a quick clean-up to check if you are already again below your quota.


## lumi-ldap-projectinfo (version 23.04 and higher)

`lumi-ldap-projectinfo` shows information about projects as it is kept in the 
LDAP system. The amount of information that is shown depends on your privileges
on the system as not all information is available to regular users and as 
regular users can only see data from their own projects. The information includes
information about the allocation and quota. That is not live information but
computed periodically. The tool also shows the members of the project.

This tool shows more information than `lumi-allocations`, `lumi-quota` or
`lumi-workspaces`. However, `lumi-quota` and `lumi-workspaces` show quota
information almost in real time. It is complementary to the
`lumi-ldap-userinfo` tool that shows user information from the LDAP.


## lumi-ldap-userinfo (version 23.04 and higher)

`lumi-allocations` shows information about projects as it is kept in the 
LDAP system. The amount of information that is shown depends on your privileges
on the system as regular users can only see data from themselves. 
The information includes information about the quota. That is not live information but
computed periodically. The tool also shows a list of projects 
found on the system (in the group database) for the given user(s).

This tool shows more information than `lumi-quota` or
`lumi-workspaces`. However, `lumi-quota` and `lumi-workspaces` show quota
information almost in real time. It is complementary to the
`lumi-ldap-projectinfo` tool that shows project information from the LDAP.


## pushover

### Getting credentials and using the configuration file

The credentials consist of both a user key and an API token. 
They can be passed via command line arguments or stored in a configuration file
(default: `~/.LUMI-notifications.ini`). Using a configuration file is recommended,
and it is also recommended to make this file only readable to the user and not
the group or others.

To obtain those credentials:

-   Create  an  account on [pushover.net](https://pushover.net/), or log in to your account if you already have one.
    Your user key will appear on the page that you get
    just after logging on (you may need to log out and log in again if you just signed up).

-   Towards the bottom of the profile page that you get after logging in to [pushover.net](https://pushover.net/), 
    you can see a list of your applications and it offers you the option to create a new one. 
    Create an application if you don't have one yet that you want to use for this configuration.
    If you then click on the application in the list of your applications, the page that you see then 
    will clearly show you you API Token/Key which is what you need for the API token.

The configuration file has the following format:

```
; This is a comment line
[pushover]

api-token = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
user-key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
title = New alert
sound = cashregister
message = My default message
```

All key-value pairs are optional, but we highly recommend to store the user key and API token in a configuration file and not specify them on
the command line as then they can be intercepted by other users and used to spam you with notifications.


### Command line options

-   `-a`, `--api-token`:
    Specify the API token on the command line, overwriting what may be set in the configuration file. It is not recommended to use this
    option as the API token can appear in the process list if suitable options are used to see running processes.

-   `-c`, `--configuration-file`:
    Specify the configuration file to use instead of the default one.

-   `-d`, `--debug`:
    Print additional debug information.

-   `-h`, `--help`:
    Print help information about pushover.

-   `-m`, `--message`:
    Specifies  the message to be sent. This argument is optional. If a text string is specified without flag,
    it will be taken as the message.

-   `-n`, `--no-configuration-file`:
    Do not read the configuration file, but use only command line arguments.  This is useful for a quick try if you have not yet created a
    configuration file.

-   `-s`, `--sound`:
    Specify  the  sound to use in pushover from the list of pushover-supported sounds that you can see with `pushover --help`. This argument
    is entirely optional, and if not specified on the command line or in the configuration file, a default will be used.

-   `-t`, `--title`:
    Specify the title for the message. This argument is entirely optional, and `pushover` will use the name of the `pushover` application if
    not specified in either the configuration file or the argument list.

-   `-u`, `--user`:
    Specify the user key for pushover, overwriting what is in the configuration file.

-   `-v`, `--version`:
    Show the version of pushover and quit.


## pushslack

### Getting credentials and using the configuration file

This tool supports two communication modes with Slack, though both require setting up a Slack app. The primary mode is communication via
`chat.postMessage`,  while  the  fallback method is via a webhook. In both cases a Slack app has to be created. In the case of communication
via `chat.postMessage`, the messages will appear in the "Apps" section in the workspace under the name of the app while in the webhook case,
messages appear under your own name in "Direct messages". Even though the webhook communication is easier to implement, this may not be 
desirable as you may want to use messages to yourself as some kind of note taking also.

The credential that are needed can be passed via command line arguments or stored in a configuration file
(default: `~/.LUMI-notifications.ini`). Using a configuration file is recommended,
and it is also recommended to make this file only readable to the user and not
the group or others.

To set up for `chat.postMessage` communication method:

-   If you don't have a suitable Slack workspace yet, create one via the [Slack web app at app.slack.com](https://app.slack.com).

-   Create a Slack app from scratch via the [Slack API dashboard at api.slack.com/apps](https://api.slack.com/apps).  
    Create that app in the workspace where you want to receive your messages.

-   In the app, under "OAuth and Permissions", scroll down the page to "Scopes" and add the "Bot Token Scope" "chat:write".

-   Now  you have to install or re-install the app in the workspace you created which can also be done from the "OAuth and Permissions" screen,
    a little higher up, and in "Channel for webhook", select your app under "Direct Messages".

    Now you can find the "Bot User OAuth Token" (starts with `xoxb-`) which you will need to send messages. 
    This is the argument for `bot-token` in
    the configuration file or the `--bot-token` command line option (see below).

-   You also need to find your slack member ID in the workplace: Click on your profile picture in Slack.  Select "Profile" in the menu. Then in
    the right screen with your profile, click "More" (the three vertical dots) and finally "Copy member ID". It will likely start with U.  This
    is the argument for `member-id` in the configuration file or the `--member-id` command line option (see below).

To set up for the webhook communication method:

-   If you don't have a suitable Slack workspace yet, create one via the [Slack web app at app.slack.com](https://app.slack.com).

-   Create a Slack app from scratch via the [Slack API dashboard at api.slack.com/apps](https://api.slack.com/apps).
    Create that app in the workspace where you want to receive your messages.

-   Enable Webhooks: In the app settings, click "Incoming Webhooks" and toggle it to "On."

-   Add Webhook to Workspace: Click "Add New Webhook" at the bottom of the screen from the previous bullet.  
    When prompted to choose a channel, select your own name (the "Direct Messages" section).

-   Copy the URL: It will look like `https://hooks.slack.com/services/T.../B.../XXXX/fR`.
    This is the argument for `webhook-url` in the configuration file or the `--webhook-url` command line option (see below).

The configuration file has the following format:

```
; This is a comment line
[slack]

webhook-url = https://hooks.slack.com/services/T.../B.../XXXX
bot-token = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
member-id = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
message = My default message
```

All key-value pairs are optional, but we highly recommend to store `webhook-url`, `bot-token` and `member-id` in a 
configuration file and not specify them on the command line as then they can be intercepted by other users and 
used to spam you with notifications.  You need either `bot-token` and `member-id` or `webhook-url`.
If both are specified, `pushslack` will use the `chat.postMessage` method.


### Command line options

-   `-b`, `--bot-token`:
    Specify the bot token for the `chat.postMessage` communication method on the command line,
    overwriting what may be set in the configuration  file. It is not recommended to use this 
    option as the bot token can appear in the process list if suitable options are used to
    see running processes.

-   `-c`, `--configuration-file`:
    Specify the configuration file to use instead of the default one.

-   `-d`, `--debug`:
    Print additional debug information.

-   `-h`, `--help`:
    Print help information about pushslack.

-   `-m`, `--message`:
    Specifies the message to be sent. This argument is optional. If a text string is specified without flag, 
    it will be taken as the  message.

-   `-n`, `--no-configuration-file`:
    Do not read the configuration file, but use only command line arguments.  
    This is useful for a quick try if you have not yet created a configuration file.

-   `-u`, `--member-id`:
    Specify the memberID for the `chat.postMessage` communication method, overwriting what is in the configuration file.

-   `-v`, `--version`:
    Show the version of `pushover` and quit.

-   `-w`, `--webhook-url`:
    Specify the webhook URL to use for the webhook communication method, overwriting what may be set in the configuration file.
    It is not recommended to use this option as the bot token can appear in the process list if suitable options are
    used to see running processes.

