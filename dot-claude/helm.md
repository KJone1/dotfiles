# Helm Charts Best Practices

When working with Helm charts, follow these best practices to ensure maintainable, secure, and production-ready deployments:

## Core Principle
- **Test every change immediately**: Use `helm template --set` with multiple value combinations for EVERY modification

## Chart Structure and Organization

- **Use consistent naming**: Chart names should be lowercase with hyphens (e.g., `my-application`, not `MyApplication` or `my_application`)
- **Organize templates logically**: Group related templates in subdirectories when charts become complex
- **Follow the standard chart structure**:
  ```
  chart-name/
  ├── Chart.yaml
  ├── values.yaml
  ├── templates/
  │   ├── deployment.yaml
  │   ├── service.yaml
  │   ├── configmap.yaml
  │   └── _helpers.tpl
  └── charts/
  ```

## Values and Configuration

- **Use logical and descriptive names**: Choose clear, intuitive names for values that reflect their purpose:
  - Good: `database.connectionTimeout`, `monitoring.enabled`, `ingress.className`
  - Bad: `db.ct`, `mon`, `class`
- **Avoid hardcoded values**: NEVER hardcode values in templates - make everything configurable:
  - Resource limits and requests
  - Replica counts
  - Image tags and repositories
  - Environment-specific settings
  - Port numbers, timeouts, intervals
  - Any string that might vary between deployments
- **Replace ALL instances when creating new values**: When converting a hardcoded value to a configurable one, you MUST scan the ENTIRE chart and replace EVERY instance of that hardcoded value:
  - Search all template files, helpers, and any other chart files
  - Replace every occurrence with the templated value - do not miss any
  - Ensure consistency across the entire chart
  - Example: If replacing hardcoded port `8080`, find and replace ALL instances of `8080` with `{{ .Values.service.port }}` throughout the chart
- **Set defaults in values.yaml, NOT templates**: Always define default values in `values.yaml` rather than using the `default` template function:
  - Good: Define `replicaCount: 3` in values.yaml, use `{{ .Values.replicaCount }}` in templates
  - Bad: Use `{{ .Values.replicaCount | default 3 }}` in templates
- **Use meaningful defaults**: Provide sensible default values that work out-of-the-box for development
- **Use nested structure**: Organize values hierarchically to avoid naming conflicts

## Template Best Practices

- **Use proper indentation**: Maintain consistent YAML indentation (2 spaces)
- **Quote values appropriately**:
  - DON'T quote strings unnecessarily - let YAML handle string values naturally
  - DO quote numbers when the expected configuration requires a number type, not a string
  - Examples:
    - Good: `name: {{ .Values.service.name }}` (string, no quotes needed)
    - Good: `port: "{{ .Values.service.port }}"` (port number that should be treated as number)
    - Bad: `name: "{{ .Values.service.name }}"` (unnecessary string quoting)
    - Bad: `port: {{ .Values.service.port }}` (number without quotes when string expected)
- **Use `when` keyword for conditional rendering**: Prefer using `when` for conditional resource creation when possible:
  - Good: Use `when` to conditionally render entire resources based on values
  - Example: `{{- if .Values.ingress.enabled }} ... {{- end }}` for optional ingress
  - Cleaner than wrapping individual fields in conditional statements
  - Makes templates more readable and maintainable

## Security and Production Readiness

- **Configure resources properly**:
  - **CPU**: Set only CPU requests, do NOT set CPU limits (avoids CPU throttling)
  - **Memory**: Set both memory requests and limits, with requests EQUAL to limits
  - Example:
    ```yaml
    resources:
      requests:
        cpu: 250m
        memory: 512Mi
      limits:
        memory: 512Mi  # Same as request
        # No CPU limit
    ```
- **Use non-root containers**: Run containers as non-root user when possible
- **Enable security contexts**: Configure appropriate security contexts for pods
- **Use secrets properly**: Never put sensitive data in ConfigMaps
- **Enable network policies**: Define network policies for pod-to-pod communication
- **Configure probes**: Always set liveness and readiness probes

## Labels and Annotations

- **Use consistent labeling**: Apply the same label strategy across all resources
- **Label selector consistency**: Ensure selector labels are consistent between resources that need to find each other:
  - Services must use the same selector labels as their target Pods
  - Deployments, StatefulSets, DaemonSets must use consistent pod template labels
  - NetworkPolicies must reference the correct pod labels
  - Example of consistent labeling:
    ```yaml
    # In Deployment
    spec:
      selector:
        matchLabels:
          app.kubernetes.io/name: {{ include "chart.name" . }}
          app.kubernetes.io/instance: {{ .Release.Name }}
      template:
        metadata:
          labels:
            app.kubernetes.io/name: {{ include "chart.name" . }}
            app.kubernetes.io/instance: {{ .Release.Name }}

    # In Service (must match deployment selector)
    spec:
      selector:
        app.kubernetes.io/name: {{ include "chart.name" . }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    ```
- **Use helper templates for labels**: Create reusable label templates in `_helpers.tpl`:
  ```yaml
  {{- define "chart.selectorLabels" -}}
  app.kubernetes.io/name: {{ include "chart.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
  {{- end }}
  ```

## Environment Management

- **Support multiple environments**: Design charts to work across dev/staging/prod
- **Avoid environment-specific logic**: Keep templates environment-agnostic

## Dependencies and Subcharts

- **Manage dependencies properly**: Use `Chart.yaml` dependencies section for subchart management
- **Version dependencies**: Pin subchart versions for reproducible deployments
- **Override subchart values**: Use the chart name as key to override subchart values
- **Document dependencies**: Clearly document what each dependency provides

## Testing and Validation

- **MANDATORY: Test every change with `helm template --set`**: For EVERY modification to a Helm chart, you MUST test using `helm template --set` with multiple value combinations:
  - Test the specific values being changed
  - Test edge cases and boundary conditions
  - Test values that could be affected by the change
  - Test multiple scenarios and variations each time
  - Example: If adding tolerations support, test with:
    ```bash
    helm template --set tolerations[0].key=node-type --set tolerations[0].operator=Equal --set tolerations[0].value=gpu --set tolerations[0].effect=NoSchedule
    helm template --set tolerations=null
    helm template --set tolerations=[]
    helm template --set nodeSelector.disktype=ssd --set tolerations[0].key=disktype
    ```
- **Test multiple angles**: Each change must be tested from different perspectives:
  - Default values behavior
  - Custom values override behavior
  - Interaction with other chart features
  - Empty/null value handling
  - Invalid value handling
- **Validate YAML**: Ensure all templates produce valid YAML
- **Use `helm lint`**: Always run helm lint before packaging
- **Test template rendering**: Verify templates render correctly with various value combinations

## Documentation

- **Maintain Chart.yaml**: Keep Chart.yaml metadata up-to-date

## Common Template Patterns

- **Conditional resources**: Use `if` statements to conditionally create resources
- **Loop over lists**: Use `range` for creating multiple similar resources
- **String manipulation**: Use template functions for string processing
- **Date and version handling**: Use appropriate functions for timestamps and versions

## Common Anti-Patterns to Avoid

- ❌ Hardcoding values directly in templates
- ❌ Using latest tags in production
- ❌ Ignoring resource limits
- ❌ Creating overly complex single charts instead of using subcharts
- ❌ Not testing charts before deployment
- ❌ Using inconsistent naming conventions
- ❌ Exposing sensitive data in ConfigMaps instead of Secrets