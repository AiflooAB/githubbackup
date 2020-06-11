# Setup

Configure the following variables in `/etc/default/githubbackup`:

```bash
GITHUB_ORG=
BACKUP_DIR=/var/backups/github/
```

## Authentication

### Personal access token

This is the solution if you just want to back up your own repositories.

You can create a new personal access token for github with the help of this
guide:

https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line

```
GITHUB_TOKEN=
GITHUB_USER=
```

### GitHub App

If you want to configure this application for an organization I recommend you
configure it as a GitHub App, that way the backups aren't tied to a particular
user.

1. Create a new github application either under your personal settings or your
   organisations settings. The menu item you want is "GitHub Apps".
2. Create a new GitHub App by pressing the "New GitHub App" button.
3. Once you have done that you need to generate a private key. This is done at
   the bottom of the General settings page under the GitHub App. Let
   `GITHUB_APP_KEY` point to that file.
4. Authorize the GitHub App in the "Install App" settings page under your GitHub App.
5. Extract the GitHub app installation id. This can be found by pressing the
   gear icon next to what you just installed. Set that ID as
   `GITHUB_INSTALLATION_ID`
