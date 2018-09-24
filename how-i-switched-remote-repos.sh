#https://gist.github.com/niksumeiko/8972566
#cloned from github using https:
git clone https://github.com/terrydhariwal/quorum360.git
cd quorum360

#created new repo in google called quorum360

# set remote using this command
$ git remote add google \
  https://source.developers.google.com/p/quorum-360-187413/r/quorum360

$ git push --all google

$ git push --tags google

$ git remote -v
google  https://source.developers.google.com/p/quorum-360-187413/r/quorum360 (fetch)
google  https://source.developers.google.com/p/quorum-360-187413/r/quorum360 (push)
origin  https://github.com/terrydhariwal/quorum360.git (fetch)
origin  https://github.com/terrydhariwal/quorum360.git (push)

git remote rm origin
git remote -v

git remote rename google origin

git remote -v
origin  https://source.developers.google.com/p/quorum-360-187413/r/quorum360 (fetch)
origin  https://source.developers.google.com/p/quorum-360-187413/r/quorum360 (push)
