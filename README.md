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
