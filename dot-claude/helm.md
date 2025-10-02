# Helm Chart Rules

**Test EVERY change**: `helm template --set` with multiple value combos mandatory for ALL mods

## Structure & Naming
- Lowercase + hyphens: `my-app`
- Standard: `Chart.yaml`, `values.yaml`, `templates/`, `charts/`
- Clear, nested names: `database.timeout` not `db.ct`

## Values
- **No hardcoding**: ports, replicas, images, timeouts, ANY varying string
- **Replace ALL instances**: Find+replace ENTIRE chart
- **Defaults in values.yaml ONLY**: `{{ .Values.x }}` not `{{ .Values.x | default y }}`, use sensible defaults
- **Environment-agnostic**: Design for dev/staging/prod, avoid env-specific logic

## Templates
- 2-space indent, no excess quotes (YAML handles strings)
- `name: {{ .Values.name }}` ✓ | `port: "{{ .Values.port }}"` ✓
- **Whitespace**: Use `{{-` and `-}}` to control spacing/newlines
- **Conditionals**: `{{- if .Values.x }}` or `{{- with .Values.x }}` (`with` when referencing values inside)
- **Loops**: `range`
- **Functions**: Template funcs for strings, dates, versions
- **NOTES.txt**: Only `required` checks, no other content

## Resources
- CPU: requests only (250m), NO limits (avoid throttling)
- Memory: requests = limits (512Mi)

## Labels
- **Consistent selectors**: Svc/Deploy/StatefulSet/NetworkPolicy must match
- **Use helpers**: `{{- define "chart.selectorLabels" -}}...{{- end }}`

## Security
- Non-root containers
- Security contexts
- Secrets (not ConfigMaps) for sensitive data
- Network policies
- Liveness/readiness probes

## Testing (MANDATORY)
**E2E validation**: Before ANY change, establish baseline with full chart test, then test each modification angle

Test with `helm template --set`:
- **Defaults**: No overrides
- **Changed values**: Modified values
- **Edge cases**: Boundary conditions
- **Null/empty**: `value=null`, `value=[]`, `value=""`
- **Types**: strings, numbers, booleans, arrays, objects
- **Interactions**: Modified value + other features
- **Conflicts**: nodeSelector + tolerations, ingress + service types
- **Resources**: Resources referencing changed value
- **Cross-template**: ALL templates using changed value
- **Valid YAML**: Validate output (pipe to `yamllint` or `yq`)
- Example: `helm template --set tolerations[0].key=x --set tolerations[0].value=y --set tolerations=null`
- `helm lint` before packaging

## Dependencies
- Pin subchart versions in `Chart.yaml`, override via chart name key
- Keep `Chart.yaml` metadata up-to-date

## Anti-patterns
- ❌ Hardcoded values
- ❌ `latest` tags in prod
- ❌ No resource limits
- ❌ Inconsistent naming
- ❌ Secrets in ConfigMaps
