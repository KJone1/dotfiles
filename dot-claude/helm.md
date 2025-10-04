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

## Templates

- 2-space indent, no excess quotes
- `name: {{ .Values.name }}` ✓ | `port: "{{ .Values.port }}"` ✓
- Whitespace: Use `{{-` to trim left and `-}}` to trim right
- Conditionals: `{{- if .Values.x }}` or `{{- with .Values.x }}` (use `with` when referencing values inside)
- Loops: `range`
- NOTES.txt: Only for `required` value checks, no other content

## Resources

- CPU: requests only (250m), NO limits
- Memory: requests == limits (512Mi)

## Labels

- Consistent selectors: Svc/Deploy/StatefulSet/NetworkPolicy must match
- Use helpers: `{{- define "chart.selectorLabels" -}}`

## Security

Non-root, security contexts, secrets (not ConfigMaps), network policies, liveness/readiness probes

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
- Keep `Chart.yaml` metadata current
- Review subchart: `helm show values <chart>` to check defaults, structure, what's templated vs hardcoded; explicitly set critical values to avoid upstream changes

## Anti-patterns

- ❌ Hardcoded values
- ❌ `latest` tags in prod
- ❌ No resource limits
- ❌ Inconsistent naming
- ❌ Secrets in ConfigMaps
