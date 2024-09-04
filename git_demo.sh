#!/bin/bash

#
# BEGIN SETUP
#
if [ -e git_demo ]; then
    echo "directory git_demo already exists! Pass --rm to remove."
    exit 1;
fi

# Set some vars to get get consistent commit hashes
export GIT_AUTHOR_NAME="Bob"
export GIT_AUTHOR_EMAIL="bob@smith.fake"
export GIT_AUTHOR_DATE="1986-05-31 12:34:56"
export GIT_COMMITTER_NAME="Alice"
export GIT_COMMITTER_EMAIL="alice@carol.fake"
export GIT_COMMITTER_DATE="2023-06-08 12:34:56"

# Show output directly
export GIT_PAGER=cat

# This makes $section output a nice section separator
section=': -------- : '

# Show the commands as they run and detect errors
PS4="\n\e[37;1;44m > \e[0m "
set -Eeuxo pipefail
#
# END SETUP
#

$section  Create new repo with one file
git init git_demo
cd git_demo

tee hello <<<"hello"
git add hello
git commit -m 'first real commit'

git show HEAD
git cat-file -p e7f38df43504fa66364f82ca7934138ef71c5976
git cat-file -p b4d01e9b0c4a9356736dfddf8830ba9a54f5271c
git cat-file -p ce013625030ba8dba906f756967f9e9ca394464a

$section  Add world
tee world <<<"world"
git add world
git commit -m 'adding world'

git cat-file -p HEAD
git cat-file -p c7863f72467ed8dd44f4b8ffdb8b57ca7d91dc9e
git cat-file -p cc628ccd10742baea8241c5924df992b5c019f71

$section  Make both files have the same content
tee hello <<<"hello world"
tee world <<<"hello world"
git commit -am 'make files have same content'

git cat-file -p HEAD
git cat-file -p 0947dab0677081c292f50a9e6407c5a25a2ebc61
git cat-file -p 3b18e512dba79e4c8300dd08aeb37f8e728b8dad

$section  Move the files to a subdir
mkdir subdir
git mv hello world subdir/
git commit -am 'move files to subdir'

git cat-file -p HEAD
git cat-file -p cdef053d748131c21c9d23564f5724bc48448dc9
git cat-file -p 0947dab0677081c292f50a9e6407c5a25a2ebc61
git cat-file -p 3b18e512dba79e4c8300dd08aeb37f8e728b8dad

$section  Duplicate subdir
cp -a subdir subdir-copy
git add subdir-copy
git commit -am 'move files to subdir'

git cat-file -p HEAD
git cat-file -p 558a7648621635d7b1ebefcfee2b5870f7c513ac

$section  Show files
find -s .git/objects
git gc
find -s .git/objects
