# Renovate configurations

Renovate configuration used across AWT organizations are hosted here.

This organization along with `default.json` are special for Renovate. They are looked for during onboarding. Preset sharing is documented [here](https://docs.renovatebot.com/config-presets/#organization-level-presets).

## Usage

To manually configure Renovate, create a `.github/renovate.json5` file in your repository with the following content:

```json5
{
    $schema: "https://docs.renovatebot.com/renovate-schema.json",
    extends: ["local>kronostechnologies/renovate-config"],
}
```

## Presets

| Preset | Description |
| --- | --- |
| `default.json` | Applied during onboarding. Extends `authenticated.json5`. |
| `authenticated.json5` | `base.json5` plus the `hostRules` needed to reach our private registries. |
| `base.json5` | Organization-wide defaults: scheduling, automerge, labels and grouping. |
| `exclusions.json5` | Organization-wide version caps. |
| `analyze.json5` | `authenticated.json5` plus the NuGet/npm rules specific to the Analyze product. |

## Agent tooling

This repository uses [APM](https://microsoft.github.io/apm/) to deploy shared Copilot instructions,
skills, review agents, and Jira MCP configuration. Install the CLI version pinned in `.apm-version`
(currently `0.35.0`) using the [APM installation instructions](https://microsoft.github.io/apm/).
The common packages in `apm.yml` are pinned to agent-toolkit v1.3.0 by commit SHA.

### Setup and validation

Local installation and auditing require read access to the private
`kronostechnologies/agent-toolkit` and `kronostechnologies/.github-private` repositories.
Authenticate with GitHub CLI and provide its token to APM, or supply an appropriately scoped
`GITHUB_APM_PAT` directly. Do not commit credentials.

```bash
gh auth login
export GITHUB_APM_PAT="$(gh auth token)"
apm install
apm audit --ci --no-cache
make check.workflows
```

The audit must discover the actual organization policy from `.github-private`; a run reporting
no policy found is not sufficient validation. `apm_modules/` is a local cache and is not committed.
The existing Renovate and workflow checks remain unchanged.

### Updating generated files

Edit `apm.yml` to change dependencies, keeping all agent-toolkit packages on the same release
commit, then run `apm install` and `apm audit --ci --no-cache`. Update `.apm-version` when upgrading
the CLI. Commit the manifest, lockfile, and all deployed files together.

`apm.lock.yaml`, `.github/instructions/`, `.github/prompts/`, `.github/agents/`, `.github/mcp.json`,
and `.agents/skills/` are generated and marked accordingly in `.gitattributes`. Do not edit them
directly: change their source package in agent-toolkit and reinstall. Put repository-specific
primitives in a local APM package under `.apm-local/` and reference it in `apm.yml`.

### CI and client authentication

The APM workflow uses `equisoft-actions/setup-apm@v1`, which reads `.apm-version` and exports a
short-lived GitHub App token as `GITHUB_APM_PAT`. This repository must be allowlisted for the
organization `APM_APP_ID` variable and `APM_APP_PRIVATE_KEY` secret. The App must have read access
to `agent-toolkit` and `.github-private`; the default workflow `GITHUB_TOKEN` cannot read these
private cross-repository dependencies.

The generated Jira MCP configuration requires a separate Atlassian OAuth connection in local
Copilot clients. Hosted Copilot code review uses separate GitHub MCP settings and approved
read-only credentials; committing `.github/mcp.json` does not configure hosted review access.
