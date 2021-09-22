# git

## Helpful Commands

### Searching through logs
```sh
# Use range operator (...) to log changes. Specify ~ to be inclusive.
git log --oneline HEAD...release/3.11.0
git log --oneline HEAD...cc3703bb~

# Search if commit message is in master or any other branch.
git log --grep=AG-458 --oneline
git log master --grep=AG-458 --oneline
git log dev --grep=AG-458 --oneline

# Pipe to cat to remove branch name and other git metadata.
git log --grep=AG-458 --oneline | cat
```

### Common ancestors
Finds most recent common ancestor for history rewrite and releases.
```sh
git merge-base master 2a8b1c3abfa
git checkout $(git merge-base master 2a8b1c3abfa)
git checkout -b ancestor
```

### Run with config to ignore git hooks
```sh
git -c core.hooksPath=/dev/null cherry-pick --continue
git -c core.hooksPath=/dev/null cherry-pick
```

### Search master but only look for commits that match these patterns
```sh
git log master --oneline | grep -e AG-462 -e AG-495 -e AG-411 -e AG-01 -e AG-469
git log master --oneline | grep -E 'AG-(462|495|411|469)'
```

### Ammend a commit already in branch.
After rebasing, while your editor is open, specify which commits to edit (e) after step 1.

```sh
git rebase -i release/3.11.0
git add files
git commit --amend
git rebase --continue
```

### Ignoring changes
```sh
git update-index --skip-worktree files
git update-index --no-skip-worktree files
```

```sh
git update-index --assume-unchanged files
git update-index --no-assume-unchanged files
```
