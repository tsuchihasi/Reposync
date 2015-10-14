require 'sinatra'
require 'json'
require 'shell'

DOWNSTREAM = "Coiney-SDK"

post '/webhook' do
    read = JSON.parse(request.body.read)
    reponame = "#{read['repository']['name']}"
    ref = "#{read['ref']}"
    svnurl = "#{read['repository']['svn_url']}"
    event = "#{request.env.select { |k, v| k.start_with?('HTTP_X_GITHUB_EVENT') }}"
    wiki = event.include?("gollum")
    ua = "#{request.user_agent}"
    check = ua.include?("GitHub-Hookshot")

    if check then
      case wiki
      when false then
        `git clone #{svnurl}.git /tmp/webhook/#{reponame}
        cd /tmp/webhook/#{reponame}
        git remote add downstream https://github.com/#{DOWNSTREAM}/#{reponame}
        git push downstream #{ref}:#{ref}
        rm -rf ../#{reponame}`
      when true then
        `git clone #{svnurl}.wiki.git /tmp/webhook/#{reponame}.wiki
        cd /tmp/webhook/#{reponame}.wiki
        git remote add downstream https://github.com/#{DOWNSTREAM}/#{reponame}.wiki
        git push downstream #{ref}:#{ref}
        rm -rf ../#{reponame}.wiki`
      end
    else
          status 401
          "Authorization Required."
    end
end
