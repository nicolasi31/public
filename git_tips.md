**Git Tips**

[[_TOC_]]

# Links
- https://docs.gitlab.com/ce/gitlab-basics/start-using-git.html
- https://docs.gitlab.com/ce/user/markdown.html
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet


# Common variables

```shell
export GITLABUSERNAME="my_name"
export GITLABACCOUNT="my_account"
export GITLABEMAIL="my_email_address@myprovid.er"
```

# Git global setup

```shell
git config --global user.name "${GITLABUSERNAME}"
git config --global user.email "${GITLABEMAIL}"
```

# Create a new repository

```shell
git clone git@gitlab.com:${GITLABACCOUNT}/public.git
cd public
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
```

# Push an existing folder

```shell
cd existing_folder
git init
git remote add origin git@gitlab.com:${GITLABACCOUNT}/public.git
git add .
git commit -m "Initial commit"
git push -u origin master
```

# Push an existing Git repository

```shell
cd existing_repo
git remote rename origin old-origin
git remote add origin git@gitlab.com:${GITLABACCOUNT}/public.git
git push -u origin --all
git push -u origin --tags
```

# My commands

```shell
export GITLABACCOUNT="my_account"
export GITLABEMAIL="my_email_address@myprovid.er"

mkdir ~/gitlab/
cd ~/gitlab/

git config --global user.name "${GITLABACCOUNT}"
git config --global user.email "${GITLABEMAIL}"
git config pull.rebase false
git config --global --list

git init

git clone git@gitlab.com:${GITLABACCOUNT}/public.git
# git clone https://gitlab.com/${GITLABACCOUNT}/gitlab.git

# git push git@gitlab.com:${GITLABACCOUNT}/public.git

cd public

git checkout master

git pull git@gitlab.com:${GITLABACCOUNT}/public.git
# git pull https://gitlab.com/${GITLABACCOUNT}/public.git

git pull ; git add . ; git commit -m "my comment" ; git push
```

# BitBucket
```shell
## Switch to ssh:
git remote set-url origin ssh://git@bitbucket.org/nicolasi31/public.git
```

