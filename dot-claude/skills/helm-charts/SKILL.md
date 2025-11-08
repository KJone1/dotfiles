---
name: helm-charts
description: Strict guidelines for creating and maintaining production-ready Helm charts. Covers best practices for chart structure, values, security, resources, and dependencies. Applied when creating, modifying, testing, or reviewing Helm charts.
---
# Helm Chart Rules

MANDATORY: `helm template --set` test ALL changes with multiple value combos

## Structure & Naming

- Lowercase + hyphens: `my-app`
- Standard: `Chart.yaml`, `values.yaml`, `templates/`, `charts/`
- Clear nested names: `database.timeout` not `db.ct`

## Values

- No hardcoding: ports, replicas, images, timeouts, any varying string
- Replace ALL instances: Find+replace entire chart
- Defaults in values.yaml ONLY: `{{ .Values.x }}` not `{{ .Values.x | default y }}`
- Environment-agnostic: Design for dev/staging/prod
- values.yaml: no quotes on primitives (port: 8080, enabled: true)

## Templates

- 2-space indent, NO excess quotes
- Quote only when numeric/boolean must be string: port: "{{ .Values.port }}" (number→string) | name: {{ .Values.name }} (string, no quotes)
- Whitespace: Use `{{-` to trim left and `-}}` to trim right
- Conditionals: `{{- if .Values.x }}` or `{{- with .Values.x }}` (use `with` when referencing values inside)
- Loops: `range`
- NOTES.txt: Only for {{ required "msg" .Values.x }} validation, no other content

## Resources

- CPU: requests only (no limits)
- Memory: requests == limits
- Set resources appropriate for workload

## Labels

- Consistent selectors: Svc/Deploy/StatefulSet/NetworkPolicy must match
- Use helpers: `{{- define "chart.selectorLabels" -}}`

## Security

Required:
- securityContext.runAsNonRoot: true (all containers)
- readinessProbe (all deployments/statefulsets)
- Secrets for sensitive data (never ConfigMaps)

Recommended:
- livenessProbe with delays
- Network policies
- securityContext.readOnlyRootFilesystem: true where possible

## Testing (MANDATORY)

E2E validation: Before ANY change, establish baseline with full chart test, then test each modification angle

Test with `helm template --set`:

- Defaults (no overrides)
- Changed values
- Edge cases
- Null/empty: `value=null`, `value=[]`, `value=""`
- Types: strings, numbers, booleans, arrays, objects
- Interactions: modified value + other features
- Conflicts: nodeSelector + tolerations, ingress + service types
- Resources referencing changed value
- Cross-template: ALL templates using changed value
- Valid YAML: pipe to `yamllint` or `yq`
- Example: `helm template --set tolerations[0].key=x --set tolerations[0].value=y --set tolerations=null`
- `helm lint` before packaging

## Dependencies

- Pin subchart versions in `Chart.yaml`, override via chart name key
- On changes: bump Chart.yaml version, update appVersion if app changes, revise description if functionality changes
- Review subchart: `helm show values <chart>` to check defaults, structure, what's templated vs hardcoded; explicitly set critical values to avoid upstream changes

## Anti-patterns

- ❌ Hardcoded values
- ❌ `latest` tags in prod
- ❌ No resource limits
- ❌ Inconsistent naming
- ❌ Secrets in ConfigMaps
- ❌ `kubectl apply` for testing (Always use `helm template`)
