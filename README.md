# homebus-component-n-most-recent

This is a simple HomeBus component that remembers the `n` most recent items it subscribes to and publishes them as an array of at most `n` length.

## Usage

On its first run, `homebus-component-n-most-recent` needs to know how to find the HomeBus provisioning server.

```
bundle exec homebus-component-n-most-recent -n number-of-most-recent-items -b homebus-server-IP-or-domain-name -P homebus-server-port
```

The port will usually be 80 (its default value).

Once it's provisioned it stores its provisioning information in `.env.provisioning`.

`homebus-component-n-most-recent` also needs to be configured via its `.env` file:

- `N` - the number of items to be kept
- `SOURCE_UUID` - the UUID that publishes the items
