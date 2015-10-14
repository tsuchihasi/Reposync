require 'sinatra'
require 'json'
require 'shell'

DOWNSTREAM = "Coiney-SDK"

post '/webhook' do
    read = JSON.parse(request.body.read)
    reponame = "#{read['repository']['name']}"
    ref = "#{read['ref']}"
    sshurl = "#{read['repository']['ssh_url']}"
    event = "#{request.env.select { |k, v| k.start_with?('HTTP_X_GITHUB_EVENT') }}"
    wiki = event.include?("gollum")
    ua = "#{request.user_agent}"
    check = ua.include?("GitHub-Hookshot")
    wikiurl = sshurl[1..15] + "#{read['repository']['full_name']}" + ".wiki.git"
    puts wikiurl

    if check then
      if wiki == false
        `git clone #{sshurl} /tmp/webhook/#{reponame}
        cd /tmp/webhook/#{reponame}
        git remote add downstream https://github.com/#{DOWNSTREAM}/#{reponame}
        git push downstream #{ref}:#{ref}
        rm -rf ../#{reponame}`
      else
        `git clone #{wikiurl} /tmp/webhook/#{reponame}.wiki
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
