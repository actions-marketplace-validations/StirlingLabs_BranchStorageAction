# Extract project name from remote url
github_project=$(git remote get-url origin | sed 's/https:\/\/[a-zA-Z\.]*\/\([a-zA-Z0-9\.\/\-]*\)\.git/\1/g')

# Create a new orphan branch unrelated history
git stash
git checkout --orphan $1
git stash pop

# Remove all files on orphan branch (except .git/ folder)
ls -A -I .git | xargs rm -r

# Add a default message to document the purpose of this branch
cat > README.md <<EOF
# Storage branch

> Branch used to store statics files generated by GitHub actions.

Can be used to permanently store coverage reports, badges, etc...
Resulting files can then be referenced in
* markdown documentation
* issues
* pull requests
* or anywhere else.

Here is for example the link to the raw README.md file :

https://raw.githubusercontent.com/${github_project}/random-storage/README.md
EOF

# Create initial commit and push the new branch to remote
git add . && git commit -m "Create storage branch" && git push -u origin $1
