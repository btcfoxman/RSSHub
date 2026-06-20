# RSSHub service

This directory contains the local deployment wrapper for RSSHub in the AI
marketing MVP. RSSHub is only the source-discovery layer; business state is
stored by ai-orchestration in Postgres tables with the `ai_` prefix.

## 3.6 deployment

Deploy under:

```text
/home/btcfoxman/docker/rsshub
```

Start:

```bash
bash test/deploy.sh
```

Health:

```bash
curl -f http://127.0.0.1:1200/
```

## Source policy

No RSSHub source changes are required for the MVP. Use the official image by
default:

```text
diygod/rsshub:latest
```

`https://github.com/btcfoxman/RSSHub` is only needed if we later add custom
routes or plugins. Until then, deployment should be a compose-only pull on the
3.6 runner, not a source checkout on the server.
