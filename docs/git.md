# git

## Helpful Commands

### Searching through logs
```sh
# Log range.
git log --oneline HEAD...release/3.11.0
git log --oneline HEAD...cc3703bb~

# Log range with inclusive.
git log --oneline HEAD...cc3703bb~

# Search if commit message is in branch.
git log master --grep=AG-458 --oneline

# Search if commit message is in current branch.
git log --grep=AG-458 --oneline

# Removes branch name.
git log --grep=AG-458 --oneline | cat
```

### Common ancestors
Finds most recent common ancestor for history rewrite and releases.
```sh
git merge-base master 2a8b1c3abfa
git checkout $(git merge-base master 2a8b1c3abfa)
git checkout -b ancestor
```

### Ammend a commit already in branch.
```sh
git rebase -i release/3.11.0

# Then while your editor is open, specify which commits to edit (e).
git add src/
git commit --amend
git rebase --continue
```
