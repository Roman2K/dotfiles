# dotfiles

![Screenshot](http://i.imgur.com/eBPxuHA.png)

## Install

    $ tools/install

## Uninstall

    $ tools/uninstall

## Additional config

To do by hand:

### Bundler

```bash
$ bundle config --global jobs 8
```

See [`--jobs`](http://bundler.io/v1.5/bundle_install.html#jobs)

### Launchd

```bash
$ for f in launchd/*.plist; do (cd ~/Library/LaunchAgents/ && ln -s "../../code/dotfiles/$f") || break; done
```
