# Commiting Changes to tsdemo
This document explains how a participant should do things like contribute new features and submit patches.
It assumes a good understanding of [Git][12] and [GitHub][11].

## Terminology
Many of these terms have more than one meaning, but for the purposes of this document,
they mean the following:

* **contributor** - A person who makes a change to tsdemo and submits a change set in the form of a [pull request][04].
* **change set** - A set of discrete fixes or features which combined together form a contribution.
A change set takes the form of Git commits and is submitted to tsdemo in the form of a pull request.
* **committer** - A person responsible for reviewing a pull request
and then making the decision what base [branch][10] to merge the change set into.
* **master branch** - The branch where new functionality that are not bug fixes is merged.

# Contributing to GitHub Project
Collaboration on Github is not complicated but also not intuitively clear
because not all parts of the workflow are incorporated into the Github user interface.
By convention, the main repository is called the `upstream` branch.
The maintainers of this repository are responsible of merging in contributor's commits.

To contribute to a repository, first fork it.
A fork is a copy of a repository and is used to propose changes to someone else' project.
(If your not providing changes, just do a clone of the repository.)
With this, rather than logging an issue for a bug you've found, you can:

1. Fork the repository.
1. Make the fix.
1. Submit a pull request to the project owner (aka committer).

If the project owner likes your work,
they might pull your fix into the original repository!

## Step 1: Set Things Up
Creating a fork is producing a personal copy of someone else’s project
and is sort of bridge between the original repository and your personal copy.
When you are cloning a GitHub repository on your local workstation,
you cannot contribute back to the upstream repository unless you are explicitly declared as "contributor".

### Fork the Repository
Firstly you need a fork of the project,
so go ahead and press the "fork" button in GitHub.
This will create a copy of the repository in your own GitHub account
and you'll see a note that it's been forked underneath the project name.
For example:

1. Login to Github using your account.  Go to the repository on github repository you wish to contribute to.  Say it’s by `kidbug`, and is called `tsdemo`, then you’ll find it at http://github.com/kidbug/tsdemo.
1. Click the “Fork” button at the top right.
1. You’ll now have your own copy of that repository withing your github account.  This will be at http://github.com/jeffskinnerbox/tsdemo.

### Clone to Local System
Now clone the repository you created with your Github account to your local system.
You'll also need to set up a new remote that points to the original/source project
so that you can grab any changes from the original, or `upstream` repository
and bring them into your local copy.

```bash
# clone the repostory
cd ~/src
git clone https://github.com/jeffskinnerbox/tsdemo.git

# add a connection to the original owner’s repository
cd tsdemo
git remote add upstream https://github.com/kidbug/tsdemo
```

You now have two remotes for this project on your filesystem
([What is the difference between origin and upstream on GitHub?][01]):

1. `origin` which points to your GitHub fork of the project. You can read/write to this remote.
1. `upstream` which points to the source project's GitHub repository. You can only read from this remote.

To verify the new `upstream` repository you've specified for your fork,
type `git remote -v`.
You should see the URL for your fork as `origin`,
and the URL for the original repository as `upstream`.

```bash
# verify repositories
$ git remote -v
origin	https://github.com/jeffskinnerbox/tsdemo.git (fetch)
origin	https://github.com/jeffskinnerbox/tsdemo.git (push)
upstream	https://github.com/kidbug/tsdemo (fetch)
upstream	https://github.com/kidbug/tsdemo (push)
```

* You will use `upstream` to [fetch][02] from the original repository (in order to keep your local copy in [sync][05] with the project you want to contribute to).
* You will use `origin` to [pull][02] and [push][03] since you can contribute to your own repository
(See [Git Pull vs Git Fetch (and Stashing)][06]).
* You will contribute back to the `upstream` repository by making a [pull request][04].

## Step 2: Do Some Work
An important rule is to put each piece of work on its own branch.
Most projects have both a `master` and a `development` branch.
The general rule is that if you are bug fixing,
then branch from `master` and if you are adding a new feature then branch from `development`.
If the project only has a `master` branch, then branch from that.

### Create Branch
Create a new branch from where you want to base your work on your fork.
This is usually the repository’s master branch.
To quickly create a branch based on master
git checkout -b fix/master/my_contribution master.
**DO NOT** work directly on the master branch,
always create a new branch and allow the project committer do the merger with the `master` branch.

```bash
cd ~/src/tsdemo

# check out the branch from which you will branch
git checkout master

# make sure this branch is the latest from the orginal repository
git pull upstream master

# push any of the updates to your forked repository
git push origin master
```

Now we create the new branch.
You can name your branch whatever you like,
but it helps for it to be meaningful.
Including the issue number is usually helpful.

I'm creating a utility that creates traffic load for a demonstration.
I'm call this functionality "tsloader" and so this what I'll call my branch.

```bash
# create a new branch on master
git checkout -b tsloader master
```

### Make Your Updates
Now make you update within this branch.
When you have your project at a point that you want to share, you have to push it to `origin`.
The command for this is simple: `git push [remote-name] [branch-name]`:

```bash
# add the changes to  your local repository
git add --all

# make the commit and comment
git commit -m 'initial creation working on desktop linux'

git push origin tsloader
```

## Step 3: Submit Pull Request
With your changes load into your GitHub repository,
you can now make the owner of the original repository (aka `upstream` remote)
aware of you updates.
You do this by submitting a [pull request][07].
Once a pull request is opened,
you can discuss and review the potential changes with collaborators
and add follow-up commits before the changes are merged into the repository.

### Creating the Pull Request
1. On GitHub, navigate to the main page of you repository (i.e. the one you created under your account via forking the original repository).
1. In the "Branch" menu, choose the branch that contains your commits.
1. To the right of the Branch menu, click "New pull request".
1. Use the base branch dropdown menu to select the branch you'd like to merge your changes into, then use the compare branch dropdown menu to choose the topic branch you made your changes in.
1. Type a title and description for your pull request.
1. Click "Create pull request".

Once you've created a pull request,
you can push commits from your topic branch to add them to your existing pull request.
These commits will appear in chronological order within your pull request
and the changes will be visible in the "Files changed" tab.

### Merge the Pull Request
The owner of the original repository (aka committer) is responsible for merging the pull requested with the code.
The owner would go to the branch where the merge needs to be made,
perform the merge and then delete the new feature branch.
It would go something like this:

```bash
# go to the branch where the merge will take place
git checkout master

# perfrom the merge
git merge --no-ff tsloader

# delete the no longer needed branch
git branch -d tsloader

# push the merger to github repository
git push origin master
```

The `--no-ff` flag causes the merge to always create a new commit object,
even if the merge could be performed with a [`fast-forward`][09].
This [avoids losing information][08] about the historical existence of a feature branch
and groups together all commits that together added the feature.

# Sources
For additional insights, read the following articles, many of which were used as source materials:

* [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
* [How to Contribute to Someone's GitHub Repository](https://www.youtube.com/watch?v=yr6IzOGoMsQ)
* [Contribute to someone's repository](http://kbroman.org/github_tutorial/pages/fork.html)
* [The beginner's guide to contributing to a GitHub project](https://akrabat.com/the-beginners-guide-to-contributing-to-a-github-project/)
* [Contributing to a GitHub repository](https://docs.mendix.com/howto50/contributing-to-a-github-repository)



[01]:http://stackoverflow.com/questions/9257533/what-is-the-difference-between-origin-and-upstream-on-github/9257901#9257901
[02]:https://help.github.com/articles/fetching-a-remote/
[03]:https://help.github.com/articles/pushing-to-a-remote/
[04]:https://help.github.com/articles/about-pull-requests/
[05]:https://help.github.com/articles/syncing-a-fork/
[06]:http://codeahoy.com/2016/04/18/10-git-pull-vs-git-fetch-(and-stashing)/
[07]:https://help.github.com/articles/creating-a-pull-request/
[08]:http://stackoverflow.com/questions/2850369/why-does-git-fast-forward-merges-by-default
[09]:https://ariya.io/2013/09/fast-forward-git-merge
[10]:https://guides.github.com/introduction/flow/
[11]:https://guides.github.com/activities/hello-world/
[12]:https://git-scm.com/
[13]:
[14]:
[15]:
[16]:
[17]:
[18]:
[19]:
[20]:
