set positional-arguments := true
set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

bootstrap_dir := justfile_dir() + '/bootstrap'
kubernetes_dir := justfile_dir() + '/kubernetes'

[private]
default: wait namespaces resources crds apps

[doc('Wait for nodes to be not-ready')]
wait:
    just log debug "Running stage $0 ..."
    if ! kubectl wait nodes --for=condition=Ready=True --all --timeout=10s &>/dev/null; then \
        until kubectl wait nodes --for=condition=Ready=False --all --timeout=10s &>/dev/null; do \
            just log info "Nodes not available, waiting for nodes to be available. Retrying in 5 seconds..." "stage" "$0"; \
            sleep 5; \
        done \
    fi

[doc('Apply Kubernetes namespaces')]
namespaces:
    just log debug "Running stage $0 ..."
    for d in "{{ kubernetes_dir }}/apps"/*; do \
        [ -d "$d" ] || continue; \
        ns="${d##*/}"; \
        if kubectl get namespace "$ns" >/dev/null 2>&1; then \
            continue; \
        fi; \
        if ! kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply --server-side -f - >/dev/null 2>&1; then \
            just log error "Failed to apply namespace" "stage" "$0" "namespace" "$ns"; \
        else \
            just log info "Namespace applied successfully" "stage" "$0" "namespace" "$ns"; \
        fi; \
    done

[doc('Apply Kubernetes resources')]
resources:
    just log debug "Running stage $0 ..."
    if ! rs=$(just template "{{ bootstrap_dir }}/resources.yaml.j2") || [[ -z "$rs" ]]; then \
        just log fatal "Failed to render resources"; \
    fi; \
    if ! echo "$rs" | kubectl diff -f - &>/dev/null; then \
        if ! echo "$rs" | kubectl apply --server-side -f - &>/dev/null; then \
            just log fatal "Failed to apply resources" "stage" "$0"; \
        fi \
    fi

[doc('Apply Helmfile CRDs')]
crds:
    just log debug "Running stage $0 ..."
    if ! rs=$(helmfile -f "{{ bootstrap_dir }}/helmfile.d/00-crds.yaml" template -q) || [[ -z "$rs" ]]; then \
        just log fatal "Failed to render CRDs from Helmfile" "stage" "$0"; \
    fi; \
    if ! echo "$rs" | kubectl diff -f - &>/dev/null; then \
        if ! echo "$rs" | kubectl apply --server-side -f - &>/dev/null; then \
            just log fatal "Failed to apply helmfile" "stage" "$0"; \
        fi; \
    fi

[doc('Apply Helmfile Apps')]
apps:
    just log debug "Running stage $0 ..."
    if ! helmfile -f "{{ bootstrap_dir }}/helmfile.d/01-apps.yaml" sync --hide-notes; then \
        just log fatal "Failed to apply helmfile" "stage" "$0"; \
    fi
