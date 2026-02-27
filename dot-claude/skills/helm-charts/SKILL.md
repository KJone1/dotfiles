---
name: helm-charts
description: Expert guidance for Helm chart development, testing, and security.
user-invocable: false
---

# Helm Chart Standards

> [!IMPORTANT]
> Charts are deployed via **ArgoCD** by pushing to Git. Manual deployments are strictly prohibited.

## Deployment & Safety

<rules>
<rule>
NEVER run `helm install`, `helm upgrade`, or `kubectl apply`. Manual cluster modifications are forbidden.
<example>
<intent>Prevent manual drift and ensure GitOps integrity.</intent>
<rationale>ArgoCD is the source of truth; manual changes bypass the deployment pipeline and cause configuration drift.</rationale>
<good_example>
user: Deploy this chart to production.
assistant: I will verify the chart with `helm template` and `helm lint`. Once verified, you can commit and push the changes to Git for ArgoCD to sync.
explanation: Respects the GitOps workflow by avoiding direct cluster interaction.
</good_example>
<bad_example>
user: Deploy this chart to production.
assistant: [run_shell_command(command="helm upgrade --install my-app .")]
explanation: Violates the GitOps mandate by performing a manual deployment.
</bad_example>
</example>
</rule>

<rule>
ONLY use `helm template` for verification. Do NOT use `--dry-run` with install/upgrade commands as they may still require cluster connectivity or credentials.
</rule>
</rules>

## Development Workflow

<rules>
<rule>
Follow the standard directory structure: `Chart.yaml`, `values.yaml`, `templates/`, and `charts/`.
</rule>

<rule>
Pin subchart versions in `Chart.yaml`.
<example>
<intent>Maintain predictable dependencies for wrapper charts.</intent>
<rationale>Pinning prevents unexpected upstream changes from breaking the chart. Since these are wrapper charts deployed via ArgoCD, internal versioning is handled by Git.</rationale>
<good_example>
# Chart.yaml
dependencies:
  - name: redis
    version: 17.3.14
    repository: https://charts.bitnami.com/bitnami
explanation: Correctly pins the subchart dependency.
</good_example>
<bad_example>
# Chart.yaml
dependencies:
  - name: redis
    version: ">15.0.0"
explanation: Uses an unstable dependency range which could lead to breaking changes during ArgoCD sync.
</bad_example>
</example>
</rule>

<rule>
`NOTES.txt` MUST only contain `{{ required "msg" .Values.x }}` validation; no other content.
<example>
<intent>Use NOTES.txt strictly for input validation.</intent>
<rationale>Keeps the deployment output clean and ensures mandatory values are provided before installation proceeds.</rationale>
<good_example>
{{- required "A valid domain is required in .Values.domain" .Values.domain -}}
explanation: Uses NOTES.txt solely to enforce a required value.
</good_example>
<bad_example>
Thank you for installing {{ .Chart.Name }}.
To access your application, go to http://{{ .Values.domain }}
explanation: Includes informational text which should be avoided in favor of strict validation.
</bad_example>
</example>
</rule>
</rules>

## Template Standards

<rules>
<rule>
Use 2-space indentation and avoid excess quotes. Quote ONLY when a numeric/boolean value must be rendered as a string.
<example>
<intent>Maintain clean and valid YAML templates.</intent>
<rationale>Excessive quoting makes templates harder to read, while missing quotes on numeric strings can cause YAML parsing errors.</rationale>
<good_example>
name: {{ .Values.name }}
port: "{{ .Values.port }}"
enabled: {{ .Values.enabled }}
explanation: Correctly quotes the port (number to string) while leaving the name (string) and enabled (boolean) unquoted.
</good_example>
<bad_example>
name: "{{ .Values.name }}"
port: {{ .Values.port }}
enabled: "{{ .Values.enabled }}"
explanation: Over-quotes the name and boolean, and fails to quote the port which might be interpreted as an integer instead of a string if required by the schema.
</bad_example>
</example>
</rule>

<rule>
Use `{{-` and `-}}` for precise whitespace control.
<example>
<intent>Prevent unwanted newlines and spaces in rendered YAML.</intent>
<rationale>Excess whitespace can lead to invalid YAML or hard-to-read output.</rationale>
<good_example>
{{- if .Values.enabled }}
enabled: true
{{- end }}
explanation: Trims whitespace around the conditional block to ensure clean output.
</good_example>
<bad_example>
{{ if .Values.enabled }}
enabled: true
{{ end }}
explanation: Leaves trailing newlines that can clutter the rendered manifest.
</bad_example>
</example>
</rule>

<rule>
Prefer `{{- with .Values.x -}}` for conditionals when referencing multiple values inside a block.
<example>
<intent>Simplify template logic by scoping to a specific value object.</intent>
<rationale>Reduces repetition and makes the template more readable by setting the context (the dot) to the specified object.</rationale>
<good_example>
{{- with .Values.ingress }}
enabled: {{ .enabled }}
host: {{ .host }}
{{- end }}
explanation: Uses 'with' to scope the block to .Values.ingress, making internal references shorter.
</good_example>
<bad_example>
{{- if .Values.ingress.enabled }}
enabled: {{ .Values.ingress.enabled }}
host: {{ .Values.ingress.host }}
{{- end }}
explanation: Repetitively references the full path, making the template more verbose.
</bad_example>
</example>
</rule>

<rule>
Use `range` for loops to iterate over collections in `values.yaml`.
<example>
<intent>Dynamically generate resources from a list.</intent>
<rationale>Loops allow for flexible configuration of multiple similar resources (e.g., environment variables, volumes).</rationale>
<good_example>
env:
{{- range .Values.extraEnv }}
  - name: {{ .name }}
    value: {{ .value | quote }}
{{- end }}
explanation: Correctly iterates over a list of environment variables.
</good_example>
<bad_example>
env:
  - name: DB_HOST
    value: "localhost"
explanation: Hardcodes environment variables instead of using a loop for flexibility.
</bad_example>
</example>
</rule>

<rule>
NEVER hardcode values (ports, replicas, images, timeouts) in templates; use `values.yaml`. Replace ALL instances of a value across the entire chart when externalizing.
<example>
<intent>Ensure all configuration is externalized and overridable.</intent>
<rationale>Hardcoding prevents users from customizing the chart for different environments or use cases.</rationale>
<good_example>
containerPort: {{ .Values.service.port }}
explanation: References a value from values.yaml.
</good_example>
<bad_example>
containerPort: 8080
explanation: Hardcodes the port, making it impossible to change without modifying the template.
</bad_example>
</example>
</rule>

<rule>
Defaults MUST reside in `values.yaml` only. Avoid `{{ .Values.x | default y }}` in templates to keep logic centralized.
<example>
<intent>Centralize configuration defaults.</intent>
<rationale>Placing defaults in values.yaml makes them discoverable and easier to manage than scattering them across templates.</rationale>
<good_example>
# values.yaml
replicaCount: 1

# template.yaml
replicas: {{ .Values.replicaCount }}
explanation: Uses the default value defined in values.yaml.
</good_example>
<bad_example>
# template.yaml
replicas: {{ .Values.replicaCount | default 1 }}
explanation: Defines the default in the template, hiding it from users who only look at values.yaml.
</bad_example>
</example>
</rule>
</rules>

## Values & Naming

<rules>
<rule>
Pin specific image tags (e.g., `v1.2.3`) for production-ready charts; NEVER use `latest`.
<example>
<intent>Ensure reproducible and stable deployments.</intent>
<rationale>Using 'latest' can lead to unpredictable behavior as the image changes without notice, making rollbacks difficult.</rationale>
<good_example>
image:
  repository: my-app
  tag: v1.2.3
explanation: Uses a specific, immutable tag for the image.
</good_example>
<bad_example>
image:
  repository: my-app
  tag: latest
explanation: Uses the 'latest' tag, which is non-deterministic and risky for production.
</bad_example>
</example>
</rule>

<rule>
Use lowercase and hyphens for all names (e.g., `my-app`).
<example>
<intent>Follow Kubernetes naming conventions.</intent>
<rationale>Kubernetes resources must follow DNS-compliant naming rules, which typically require lowercase and hyphens.</rationale>
<good_example>
name: my-web-service
explanation: Uses lowercase and hyphens for the resource name.
</good_example>
<bad_example>
name: MyWebService
explanation: Uses camelCase, which is not recommended for Kubernetes resource names.
</bad_example>
</example>
</rule>

<rule>
Use clear, descriptive nested names in `values.yaml` (e.g., `database.timeout` instead of `db.ct`).
<example>
<intent>Improve readability and discoverability of configuration options.</intent>
<rationale>Clear names make it easier for users to understand what each value controls without referring to the templates.</rationale>
<good_example>
database:
  connectionTimeout: 30s
explanation: Uses a descriptive name that clearly indicates its purpose.
</good_example>
<bad_example>
db:
  ct: 30s
explanation: Uses cryptic abbreviations that are hard to understand.
</bad_example>
</example>
</rule>

<rule>
Design charts to be environment-agnostic (dev/staging/prod).
<example>
<intent>Enable the same chart to be used across different environments.</intent>
<rationale>Environment-specific logic should be handled via values files, not by creating separate charts for each environment.</rationale>
<good_example>
# values-prod.yaml
replicaCount: 5
ingress:
  host: app.example.com
explanation: Uses environment-specific values files to customize the deployment.
</good_example>
<bad_example>
# template.yaml
{{- if eq .Values.env "prod" }}
replicas: 5
{{- else }}
replicas: 1
{{- end }}
explanation: Hardcodes environment-specific logic into the template, making it less flexible.
</bad_example>
</example>
</rule>

<rule>
Do NOT use quotes for primitives (numbers, booleans) in `values.yaml`.
<example>
<intent>Maintain correct data types in values.yaml.</intent>
<rationale>Quoting primitives turns them into strings, which can cause issues if the template or application expects a specific type.</rationale>
<good_example>
port: 8080
enabled: true
explanation: Correctly uses unquoted primitives for numbers and booleans.
</good_example>
<bad_example>
port: "8080"
enabled: "true"
explanation: Quotes the primitives, turning them into strings.
</bad_example>
</example>
</rule>
</rules>

## Security & Resources

<rules>
<rule>
REQUIRED: `securityContext.runAsNonRoot: true` and `readinessProbe` for all containers.
<example>
<intent>Enforce security and availability best practices.</intent>
<rationale>Running as non-root mitigates privilege escalation risks, and readiness probes ensure traffic is only sent to healthy pods.</rationale>
<good_example>
spec:
  securityContext:
    runAsNonRoot: true
  containers:
    - name: app
      readinessProbe:
        httpGet:
          path: /healthz
          port: 8080
explanation: Adheres to mandatory security and availability requirements.
</good_example>
<bad_example>
spec:
  containers:
    - name: app
      image: my-app:v1.0.0
explanation: Missing mandatory security context and readiness probe.
</bad_example>
</example>
</rule>

<rule>
Use Secrets for sensitive data; NEVER use ConfigMaps for credentials or tokens.
<example>
<intent>Protect sensitive information.</intent>
<rationale>Secrets are designed for sensitive data and can be encrypted at rest, whereas ConfigMaps are for non-sensitive configuration.</rationale>
<good_example>
kind: Secret
metadata:
  name: db-credentials
data:
  password: {{ .Values.db.password | b64enc }}
explanation: Uses a Secret to store the database password.
</good_example>
<bad_example>
kind: ConfigMap
metadata:
  name: db-config
data:
  password: {{ .Values.db.password }}
explanation: Stores a password in a ConfigMap, which is insecure.
</bad_example>
</example>
</rule>

<rule>
Resource allocation: Set CPU `requests` only (no limits); set Memory `requests` equal to `limits`.
<example>
<intent>Optimize resource usage and prevent OOM kills.</intent>
<rationale>CPU limits can cause unnecessary throttling, while matching memory requests and limits ensures predictable performance and prevents eviction.</rationale>
<good_example>
resources:
  requests:
    cpu: 100m
    memory: 256Mi
  limits:
    memory: 256Mi
explanation: Follows the recommended resource allocation strategy.
</good_example>
<bad_example>
resources:
  limits:
    cpu: 500m
    memory: 512Mi
explanation: Sets a CPU limit and doesn't match memory requests and limits.
</bad_example>
</example>
</rule>

<rule>
Recommended: `livenessProbe` with delays, Network Policies, and `securityContext.readOnlyRootFilesystem: true`.
<example>
<intent>Enhance application resilience and security.</intent>
<rationale>Liveness probes restart unhealthy pods, Network Policies restrict traffic, and read-only filesystems prevent unauthorized modifications.</rationale>
<good_example>
securityContext:
  readOnlyRootFilesystem: true
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 30
explanation: Implements recommended security and resilience features.
</good_example>
<bad_example>
# No liveness probe or read-only filesystem
explanation: Misses opportunities to improve security and resilience.
</bad_example>
</example>
</rule>
</rules>

## Labels & Dependencies

<rules>
<rule>
Use helper templates (e.g., `{{- include "chart.selectorLabels" . -}}`) for consistent selectors across Service, Deployment, and StatefulSet.
<example>
<intent>Ensure consistent resource linking.</intent>
<rationale>Using helpers prevents typos and ensures that services correctly target the pods they are intended to manage.</rationale>
<good_example>
# deployment.yaml
selector:
  matchLabels:
    {{- include "my-app.selectorLabels" . | nindent 4 }}

# service.yaml
selector:
  {{- include "my-app.selectorLabels" . | nindent 4 }}
explanation: Uses a shared helper to ensure selectors match exactly.
</good_example>
<bad_example>
# deployment.yaml
selector:
  matchLabels:
    app: my-app

# service.yaml
selector:
  app: myapp
explanation: Manual label entry leads to a mismatch (my-app vs myapp), breaking the service.
</bad_example>
</example>
</rule>

<rule>
Review subchart values using `helm show values <chart>` before overriding.
<example>
<intent>Understand subchart configuration before making changes.</intent>
<rationale>Reviewing the subchart's values ensures you are overriding the correct keys and using the expected data types.</rationale>
<good_example>
user: I need to override the redis password in the subchart.
assistant: [run_shell_command(command="helm show values bitnami/redis")]
explanation: Checks the subchart's values to identify the correct key for the password.
</good_example>
<bad_example>
user: I need to override the redis password in the subchart.
assistant: I'll add 'redisPassword: secret' to your values.yaml.
explanation: Guesses the key name without verifying it against the subchart's documentation.
</bad_example>
</example>
</rule>
</rules>

## Testing Standards

<rules>
<rule>
MANDATORY: Test ALL changes with `helm template --set` using multiple value combinations (defaults, overrides, edge cases, nulls). Validate that changes are correctly reflected across ALL templates that reference the modified value.
<example>
<intent>Verify template rendering with various overrides.</intent>
<rationale>Ensures templates handle edge cases, null values, and type conversions correctly without requiring a live cluster.</rationale>
<good_example>
user: I've updated the ingress template.
assistant: [run_shell_command(command="helm template . --set ingress.enabled=true --set ingress.hosts[0].host=example.com && helm template . --set ingress.enabled=false")]
explanation: Tests both the enabled and disabled states to ensure the conditional logic works as expected.
</good_example>
<bad_example>
user: I've updated the ingress template.
assistant: I have updated the ingress.yaml file. You can now deploy it to your cluster.
explanation: Fails to verify the template rendering, which could lead to deployment failures due to syntax errors or logic bugs.
</bad_example>
</example>
</rule>

<rule>
Pipe `helm template` output to `yq` or `yamllint` to ensure the rendered manifest is valid YAML and meets structural requirements.
<example>
<intent>Verify the structural integrity of rendered manifests.</intent>
<rationale>Helm template can produce invalid YAML if indentation or quoting is incorrect. yq provides a robust way to validate the output before pushing.</rationale>
<good_example>
user: Validate the rendered output.
assistant: [run_shell_command(command="helm template . | yq eval '.. | select(has(\"kind\"))'")]
explanation: Uses yq to parse the rendered output and ensure it contains valid Kubernetes resources.
</good_example>
<bad_example>
user: Validate the rendered output.
assistant: I've checked the output and it looks fine.
explanation: Relies on manual inspection instead of automated validation tools.
</bad_example>
</example>
</rule>

<rule>
Run `helm lint` before pushing to Git or reporting completion.
<example>
<intent>Ensure chart follows best practices and has no syntax errors.</intent>
<rationale>Linting catches common mistakes and ensures the chart is well-formed before it's synced by ArgoCD.</rationale>
<good_example>
user: I've finished the chart.
assistant: [run_shell_command(command="helm lint .")]
explanation: Verifies the chart's integrity before it is committed to the repository.
</good_example>
<bad_example>
user: I've finished the chart.
assistant: Great! I'll commit and push it for you now.
explanation: Skips the linting step, potentially pushing a chart with errors that will cause ArgoCD sync failures.
</bad_example>
</example>
</rule>
</rules>
