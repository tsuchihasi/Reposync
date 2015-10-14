# Reposync

Running this program, you can automatically sync contents, wiki, tags etc... between upstream and downstream(forked) repositories when upstream was updated.
You have to setup **webhook** to run **Reposync**.

### Usage

1. Clone Reposync to local.
```
git clone git@github.com:tsuchihasi/Reposync.git
```

2. Configure webhook on upstream repository. Remember to add '/webhook' to your payload URL.

3. Run **server.rb**.

4. That's it. Your updates will be automatically reflected to the downstream repository.
