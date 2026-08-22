# honeynet-filebeat

Custom Filebeat image for shipping [T-Pot](https://github.com/telekom-security/tpotce)
honeypot logs, published as `quay.io/honeynet/filebeat`.

It is the image used by
[honeynet/ansible-role-tpotce](https://github.com/honeynet/ansible-role-tpotce),
configured by
[honeynet/ansible-role-tpotce-filebeat](https://github.com/honeynet/ansible-role-tpotce-filebeat).

## Versioning

**One image is built, at the version upstream T-Pot pins Elasticsearch to.**

CI reads `ES_VER` from upstream's
[`docker/elk/elasticsearch/Dockerfile`](https://github.com/telekom-security/tpotce/blob/master/docker/elk/elasticsearch/Dockerfile)
at build time and builds Filebeat at exactly that version, tagging the image
with it. Elastic supports a Beat only against its own version or a newer stack,
so a Filebeat that does not match the Elasticsearch it feeds is an unsupported
combination — there is no reason to publish a matrix of other versions.

The build fails loudly if `ES_VER` cannot be found or is not a three-part
version, rather than publishing an empty or `latest` tag that would silently
diverge.

The `filebeat_version` build arg in the Dockerfile is a fallback for local
builds only. It is not what CI publishes.

### Keeping up with upstream

The publish workflow runs on pushes to `master`, on a weekly schedule, and on
demand via **Actions → Docker build and push → Run workflow**. The scheduled
run is what picks up an upstream Elasticsearch bump without a commit here.

## What the image adds

The stock Elastic image runs Filebeat as uid/gid 1000. T-Pot's containers use
2000, so this image:

- moves the `filebeat` user and group to uid/gid 2000 and reowns
  `/usr/share/filebeat`,
- creates `/usr/share/filebeat/conf.d` for the per-honeypot inputs and
  `/usr/share/filebeat/pki` for TLS material, both writable by that uid,
- applies outstanding OS package updates.

CI smoke tests each build before publishing: it checks the image reports the
expected version, runs as uid 2000, and can write to both directories.

## Building locally

```bash
docker build -t honeynet/filebeat:local .

# or pin explicitly
docker build --build-arg filebeat_version=9.3.5 -t honeynet/filebeat:9.3.5 .
```

## License

See [LICENSE](LICENSE).
