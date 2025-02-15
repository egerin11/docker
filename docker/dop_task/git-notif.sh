#!/bin/sh
COMMIT_AUTHOR=$(git log -1 --pretty=format:'%an')
COMMIT_EMAIL=$(git log -1 --pretty=format:'%ae')
COMMIT_MESSAGE=$(git log -1 --pretty=format:'%s')
COMMIT_HASH=$(git log -1 --pretty=format:'%H')
COMMIT_DIFF=$(git show $COMMIT_HASH)
SUBJECT="Новый коммит в репозитории: $COMMIT_HASH"
BODY="Автор: $COMMIT_AUTHOR ($COMMIT_EMAIL)\nСообщение: $COMMIT_MESSAGE\nХэш: ($COMMIT_HASH )\nОтличия: $COMMIT_DIFF"

python3 /home/egerin/trainee/docker/dop_task/pytonsender.py --subject "$SUBJECT" --body "$BODY"
