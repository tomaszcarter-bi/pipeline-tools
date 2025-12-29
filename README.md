# Pipeline Tools

Command-line utilities for monitoring GitLab CI/CD pipelines.

## Requirements

- [glab](https://gitlab.com/gitlab-org/cli) - GitLab CLI tool
- Bash 4.0+

## Installation

### Quick Install

```bash
git clone https://github.com/tomaszcarter-bi/pipeline-tools.git
cd pipeline-tools
./install.sh
```

This installs scripts to `~/.local/bin` by default.

### Custom Installation Directory

```bash
./install.sh /usr/local/bin
```

### Manual Installation

```bash
cp bin/watch-pipeline ~/.local/bin/
chmod +x ~/.local/bin/watch-pipeline
```

Ensure `~/.local/bin` is in your PATH:

```bash
export PATH="$PATH:$HOME/.local/bin"
```

## Tools

### watch-pipeline

Monitor a GitLab pipeline until completion.

**Usage:**
```bash
watch-pipeline <pipeline-id> [check-interval-seconds] [repo]
```

**Examples:**

```bash
# Watch a pipeline (default: 30s interval, boardiq/monorepo)
watch-pipeline 2236689681

# Custom check interval (10 seconds)
watch-pipeline 2236689681 10

# Different repository
watch-pipeline 2236689681 30 boardiq/other-repo
```

**Exit Codes:**
- `0` - Pipeline succeeded
- `1` - Pipeline failed, cancelled, or not found

**Chaining Commands:**

Run commands after pipeline completion:

```bash
# Run only on success
watch-pipeline 2236689681 && echo "Deploying..."

# Run only on failure
watch-pipeline 2236689681 || echo "Pipeline failed!"

# Run regardless of outcome
watch-pipeline 2236689681; echo "Pipeline finished"

# Complex workflows
watch-pipeline 2236689681 && {
    PIPELINE_ID=2236689681
    JOB_ID=$(glab api "/projects/boardiq%2Fmonorepo/pipelines/$PIPELINE_ID/jobs" | jq -r '.[] | select(.name == "permafrost-retag-and-update-overlays") | .id')
    glab ci trace $JOB_ID | grep "IMAGE_TAG=" | tail -1
} || {
    echo "Pipeline failed, skipping deployment"
}
```

## Configuration

The tools use `glab` for GitLab API access. Ensure you have configured `glab` with your GitLab credentials:

```bash
glab auth login
```

## Licence

MIT
