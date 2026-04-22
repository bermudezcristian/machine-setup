# abbr.fish — Fish abbreviations (expand on Enter, unlike aliases)

# Docker
abbr -a dk docker
abbr -a dkc 'docker compose'
abbr -a dkps 'docker ps'

# Kubernetes (if used)
if command -q kubectl
    abbr -a k kubectl
    abbr -a kgp 'kubectl get pods'
    abbr -a kgs 'kubectl get svc'
    abbr -a kga 'kubectl get all'
    abbr -a kl 'kubectl logs'
    abbr -a kx 'kubectl exec -it'
end

# Terraform (if used)
if command -q terraform
    abbr -a tf terraform
    abbr -a tfi 'terraform init'
    abbr -a tfp 'terraform plan'
    abbr -a tfa 'terraform apply'
end

# mise
if command -q mise
    abbr -a mi 'mise install'
    abbr -a mu 'mise use'
    abbr -a ml 'mise ls'
end
