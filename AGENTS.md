# AGENTS.md

Homebrew tap for [p3bot](https://github.com/p3bot) Go CLIs. Users install with `brew tap p3bot/tap` then `brew install p3bot/tap/<name>`. Formulae are read from the `main` branch; no separate deploy step.

## Layout

```
Formula/     # one .rb per tool
LICENSE      # MPL-2.0
README.md    # human install docs
AGENTS.md    # this file
```

## Approach

Build from source (not bottles or prebuilt bins). Each formula downloads a tagged GitHub source archive and runs `go build`. Matches personal-tap practice and keeps maintenance low.

## Publishable tools

| Formula | Upstream tag | Module | Build path | Version ldflag |
| --- | --- | --- | --- | --- |
| kagi | v1.0.1 | github.com/p3bot/kagi | `.` (root main) | `-X main.version=` |
| snag | v1.1.3 | github.com/p3bot/snag | `.` (root main) | `-X main.version=` |
| webctl | v0.2.1 | github.com/p3bot/webctl | `./cmd/webctl` | `-X github.com/p3bot/webctl/internal/cli.Version=` |
| agentdex | v0.0.2 | github.com/p3bot/agentdex | `./cmd/agentdex` | `github.com/p3bot/agentdex/internal/cli.{Version,Commit,Date}` |
| start | v0.0.1 | github.com/p3bot/start | `./cmd/start` | `github.com/p3bot/start/internal/cli.{cliVersion,commit,buildDate}` |
| pj | v0.0.1 | github.com/p3bot/pj | `./cmd/pj` | none (no version command yet); test via `--help` |

Ldflag package paths must match `go.mod` of the tagged source.

## Local package paths

Sibling git repos under the p3bot workspace. Paths are relative to this tap repo (`homebrew-tap/`).

| Formula | Formula file | Upstream clone | GitHub |
| --- | --- | --- | --- |
| kagi | `Formula/kagi.rb` | `../kagi` | https://github.com/p3bot/kagi |
| snag | `Formula/snag.rb` | `../snag` | https://github.com/p3bot/snag |
| webctl | `Formula/webctl.rb` | `../webctl` | https://github.com/p3bot/webctl |
| agentdex | `Formula/agentdex.rb` | `../agentdex` | https://github.com/p3bot/agentdex |
| start | `Formula/start.rb` | `../start` | https://github.com/p3bot/start |
| pj | `Formula/pj.rb` | `../pj` | https://github.com/p3bot/pj |

Note: clones are independent git repositories. Run all git and build commands from the upstream path, then return here for the formula bump.

## Release workflow

Releases are manual. There is no CI publish step. Users install from the tap `main` branch after the formula lands.

Prerequisites: clean `main` on both upstream and this tap; push access to both GitHub remotes; `brew`, `curl`, `gh` (optional, for GitHub Release notes).

### 1. Choose version

In the upstream clone (`../<name>`):

```bash
cd ../<name>
git fetch --tags origin
git tag -l 'v*' | sort -V | tail -5
git log "$(git describe --tags --abbrev=0 2>/dev/null || echo '')"..HEAD --oneline
```

Pick the next semver tag (`vMAJOR.MINOR.PATCH`). Bump MAJOR for breaking CLI changes, MINOR for features, PATCH for fixes.

### 2. Verify upstream is ready

```bash
cd ../<name>
git switch main
git pull --ff-only
git status   # must be clean
# run the project's usual tests (go test ./..., make test, etc.)
```

Confirm HEAD is what you want to ship. Do not tag unpushed or dirty work.

### 3. Tag and push upstream

```bash
cd ../<name>
VERSION=0.0.2   # no leading v in the variable
git tag -a "v${VERSION}" -m "<name>: v${VERSION}"
git push origin "v${VERSION}"
git push origin main   # if main has commits not yet on remote
```

Optional GitHub Release (notes from commits since previous tag):

```bash
cd ../<name>
gh release create "v${VERSION}" --generate-notes --title "v${VERSION}"
```

The source archive URL used by Homebrew is:

`https://github.com/p3bot/<name>/archive/refs/tags/v${VERSION}.tar.gz`

### 4. Bump the formula in this tap

```bash
cd /path/to/homebrew-tap   # this repo
```

1. Set `url` to the new tag archive.
2. Recompute sha256:

```bash
curl -sL "https://github.com/p3bot/<name>/archive/refs/tags/v${VERSION}.tar.gz" | shasum -a 256
```

3. Paste the checksum into `sha256`.
4. If the formula hardcodes a commit in ldflags (agentdex, start):

```bash
git -C ../<name> rev-list -n1 "v${VERSION}"
```

5. Update the Upstream tag cell in the Publishable tools table above.
6. Confirm `test do` still matches version or help output for this release.

### 5. Test and audit

```bash
brew style Formula/<name>.rb
brew audit --strict --online Formula/<name>.rb
brew uninstall <name> 2>/dev/null || true
brew install --build-from-source ./Formula/<name>.rb
brew test Formula/<name>.rb
# smoke: <name> --version  |  agentdex version  |  pj --help
```

Fix any failures before committing.

### 6. Commit and publish the tap

```bash
git add Formula/<name>.rb AGENTS.md
git commit -m "<name>: bump to v${VERSION}"
git push origin main
```

No separate deploy: `brew tap p3bot/tap` and `brew install p3bot/tap/<name>` read `main`. Existing installs upgrade with `brew update && brew upgrade <name>` (or reinstall from source if needed).

## New formula

1. Create `Formula/<name>.rb` with class name PascalCase of the binary name.
2. Set `url` to `https://github.com/p3bot/<repo>/archive/refs/tags/v<version>.tar.gz`.
3. Set `sha256` (see checksum step below).
4. `license "MPL-2.0"`, `depends_on "go" => :build`.
5. In `install`: `ENV["CGO_ENABLED"] = "0"`, `go build` with `std_go_args` and the tool's ldflags, package path as in the table.
6. Add a `test do` that runs the binary's version command and asserts the version string (or a stable help string if the tool has no version flag).
7. Test and audit locally (below). Commit and push to `main`.

Template:

```ruby
class Name < Formula
  desc "Short description (no trailing period)"
  homepage "https://github.com/p3bot/<repo>"
  url "https://github.com/p3bot/<repo>/archive/refs/tags/v<version>.tar.gz"
  sha256 "<checksum>"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/name --version")
  end
end
```

Adjust build path and ldflags per tool. Prefer `#{version}` over hardcoding version strings in ldflags where possible.

## Update formula

When upstream tags a new release:

1. Change the tag in `url`.
2. Recompute `sha256`.
3. Update any hardcoded commit SHA in ldflags (agentdex, start).
4. Confirm `test do` still matches version output format.
5. Test and audit, then commit.

Checksum:

```bash
curl -sL "https://github.com/p3bot/<repo>/archive/refs/tags/v<version>.tar.gz" | shasum -a 256
```

Commit at a tag (for ldflags):

```bash
git -C ~/Projects/p3bot/<repo> rev-list -n1 "v<version>"
```

## Test before push

```bash
brew style Formula/<name>.rb
brew audit --strict --online Formula/<name>.rb
brew install --build-from-source ./Formula/<name>.rb
brew test Formula/<name>.rb
<name> --version   # or: agentdex version; pj has no version flag yet
```

Reinstall path for updates:

```bash
brew uninstall <name>
brew install --build-from-source ./Formula/<name>.rb
brew test Formula/<name>.rb
```

## Style

- 2-space indent, double-quoted strings (Ruby / Homebrew)
- `desc` under ~80 chars, no ending period
- HTTPS URLs only; sha256 mandatory
- CGO off unless the tool needs it
- Use `std_go_args`; pass package path when not root main

## Commits

Scoped Commits: `<scope>: <description>` (https://scopedcommits.com). Scope is usually the formula name or `Formula`. Examples:

```
kagi: add formula for v1.0.0
snag: bump to v1.1.1
Formula: refresh agentdex sha256
docs: update README formula list
```

No `Co-Authored-By` trailers.

## Tap URL

- Repo: https://github.com/p3bot/homebrew-tap
- Tap name: `p3bot/tap`

## Refs

- https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap
- https://docs.brew.sh/Formula-Cookbook
- Personal tap patterns: `~/Projects/homebrew-tap/AGENTS.md`
