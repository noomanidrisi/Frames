printf "\n\nGetting tag information\n"
tagInfo="$(curl https://api.github.com/repos/jahirfiquitiva/Blueprint/releases/latest)"
releaseId="$(echo "$tagInfo" | jq ".id")"

releaseNameOrg="$(echo "$tagInfo" | jq --raw-output ".tag_name")"
releaseName=$(echo $releaseNameOrg | cut -d "\"" -f 2)

ln=$"%0D%0A"
tab=$"%09"

changes="$(echo "$tagInfo" | jq --raw-output ".body")"
changes=$"$changes"
changes=$(echo "${changes//\\r\\n/$ln}")
changes=$(echo "$changes" | cut -d "\"" -f 2)
# changes=$"$changes"
# changes=${changes%$'\r\n'}
# changes=${changes%$'\r'}
# changes=${changes%.*}
printf "\nChanges3: ${changes}\n"

urlText="$(echo "$tagInfo" | jq --raw-output ".assets[].browser_download_url")"
url=$(echo $urlText | cut -d "\"" -f 2)
url=$"$url"
url=${url%$'\r\n'}
url=${url%$'\r'}
printf "Url: ${url}"

message=$"*New ${repoName} update available now!*${ln}*Version:*${ln}${tab}${releaseName}*Changes:*${ln}${changes}"
btns=$"{\"inline_keyboard\":[[{\"text\":\"How To Update\",\"url\":\"https://github.com/${TRAVIS_REPO_SLUG}/wiki/How-to-update\"}],[{\"text\":\"Download sample\",\"url\":\"${url}\"}]]}"

printf "\n\nSending message to Telegram channel\n\n"
echo "Message: ${message}"
printf "\n\n"
echo "Buttons: ${btns}"
printf "\n\n"

telegramUrl="https://api.telegram.org/bot${TEL_BOT_KEY}/sendMessage?chat_id=@JFsDashSupport&text=${message}&parse_mode=Markdown&reply_markup=${btns}"
echo "$telegramUrl"
printf "\n\n"
curl -g "${telegramUrl}"

exit -1