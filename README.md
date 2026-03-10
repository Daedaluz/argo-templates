# argo-templates

Argo Workflow templates for GitHub releases, git cloning, and aptly package uploads.

## Workflow Templates

### github-latest-release

Resolves the latest release tag for a GitHub repository.

**Parameters:**
| Name | Description | Default |
|------|-------------|---------|
| `repo` | GitHub repository (`owner/repo`) | required |
| `gh-image` | Container image | `ghcr.io/daedaluz/argo-templates/gh:latest` |

**Outputs:**
- `version` — parameter with the release tag name
- `release-info` — artifact with full release JSON

### github-release-assets

Downloads release assets from a GitHub repository with glob pattern matching.

**Parameters:**
| Name | Description | Default |
|------|-------------|---------|
| `repo` | GitHub repository (`owner/repo`) | required |
| `version` | Release version tag | required |
| `pattern` | Glob pattern to filter assets | `*` |
| `gh-image` | Container image | `ghcr.io/daedaluz/argo-templates/gh:latest` |

**Outputs:**
- `release-assets` — artifact containing matched files
- `release-info` — artifact with full release JSON

**Auth:** Expects a secret `github-token` with a `GH_TOKEN` key.

### version-gate

Tracks processed versions in a ConfigMap to avoid reprocessing.

**Templates:**
- `check` — returns `already-processed` (true/false)
- `mark-processed` — records the version as processed

**Parameters:**
| Name | Description | Default |
|------|-------------|---------|
| `name` | Identifier for what is being tracked | required |
| `version` | Version to check/mark | required |
| `configmap` | ConfigMap name | `processed-versions` |
| `namespace` | ConfigMap namespace | `argo` |

### git-clone

Clones a git repository at a given version.

**Parameters:**
| Name | Description | Default |
|------|-------------|---------|
| `repo` | Git repository URL | required |
| `version` | Branch, tag, or commit | `HEAD` |
| `shallow` | Shallow clone (depth=1) | `true` |
| `recursive` | Clone submodules recursively | `false` |

**Outputs:**
- `repo` — artifact containing the cloned repository

### aptly-upload

Uploads `.deb` files to an aptly repository.

**Parameters:**
| Name | Description | Default |
|------|-------------|---------|
| `aptly-url` | Aptly API base URL | required |
| `aptly-repo` | Aptly repository name | required |
| `upload-dir` | Upload directory name in aptly | `argo-upload` |
| `cleanup` | Remove upload directory after adding | `true` |
| `aptly-credentials-secret` | K8s secret with `username`/`password` keys | `""` |
| `gh-image` | Container image | `ghcr.io/daedaluz/argo-templates/gh:latest` |

**Inputs:**
- `debs` — artifact containing `.deb` files

## Docker Image

Minimal Alpine image with `gh`, `jq`, and `git`.

```sh
# Build and push (amd64 + arm64)
./build.sh
./build.sh ghcr.io/daedaluz/argo-templates/gh v1.0
```

## Example

See [examples/fetch-latest-release-assets.yaml](examples/fetch-latest-release-assets.yaml) for a full workflow that resolves the latest release, gates on version, downloads assets, and marks the version as processed.

```sh
argo submit examples/fetch-latest-release-assets.yaml \
  -p repo=cli/cli \
  -p pattern='*.tar.gz'
```
