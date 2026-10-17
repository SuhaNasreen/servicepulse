# ServicePulse

ServicePulse is a static operations dashboard that demonstrates the difference between packaging an application with Docker and maintaining its desired state with Kubernetes.

## What this project proves

- I can create a focused Dockerfile and build versioned images.
- I can declare a Kubernetes Deployment and Service in YAML.
- I can expose a cluster-internal Service with port forwarding.
- I can scale a workload, test self-healing, and perform a rolling update.
- I can document failures and explain the reason behind each tool and setting.

## Architecture

```text
Browser
  |
  | kubectl port-forward
  v
ClusterIP Service
  |
  v
Deployment -> ReplicaSet -> nginx Pods
```
## Repository structure

```text
servicepulse/
|-- Dockerfile
|-- .dockerignore
|-- README.md
|-- site/
|   |-- index.html
|   `-- styles.css
`-- k8s/
    |-- deployment.yaml
    `-- service.yaml
```
## Run the demo

Build the current image:

```bash
docker build -t servicepulse:v2 .
```

Apply the Kubernetes resources from Ubuntu while using Docker Desktop's `kubectl.exe` through the `kubectl` alias:

```bash
cat k8s/deployment.yaml | kubectl apply -f -
cat k8s/service.yaml | kubectl apply -f -
kubectl rollout status deployment/servicepulse
```

Open the dashboard:

```bash
kubectl port-forward service/servicepulse 8080:80
```

Visit `http://localhost:8080`.

## Why versioned tags and IfNotPresent

The project uses `servicepulse:v1` and `servicepulse:v2` instead of `latest`, so the release shown in the manifest is explicit and easy to discuss or roll back. `imagePullPolicy: IfNotPresent` tells Kubernetes to use the local image when it exists and pull only when it is absent, which fits this local Docker Desktop learning cluster.

## Demonstrate scaling and self-healing

```bash
kubectl scale --replicas=3 deployment/servicepulse
kubectl get pods -l app=servicepulse
kubectl delete pod <POD-NAME>
kubectl get pods -l app=servicepulse -w
```

The Deployment notices that the actual Pod count is below the declared count and creates a replacement.
## What I learned / what broke

### What I learned

- Docker packages the files and runtime into an image. A container is a running instance of that image.
- A Kubernetes Deployment declares the desired Pod state and manages ReplicaSets.
- A Service gives changing Pods one stable network target.
- Scaling changes the desired replica count. Self-healing restores it after a failure.
- Changing the Deployment Pod template from v1 to v2 triggers a rolling update.

### What broke

- Stopping the standalone Docker container made the dashboard unavailable.
- Record any setup or rollout error encountered here.

### Root cause and fix

- The standalone container had no controller maintaining desired state.
- Kubernetes fixed that gap by managing replicas through a Deployment.
- Record the root cause and fix for any additional error here.

### Next improvement

Add HTTP health probes and container CPU and memory requests and limits.

## What I learned / what broke

### What I learned

- Docker packages the files and runtime into an image. A container is a running instance of that image.
- A Kubernetes Deployment declares the desired Pod state and manages ReplicaSets.
- A Service gives changing Pods one stable network target.
- Scaling changes the desired replica count. Self-healing restores it after a failure.
- Changing the Deployment Pod template from v1 to v2 triggers a rolling update.

### What broke

- Stopping the standalone Docker container made the dashboard unavailable.
- Record any setup or rollout error encountered here.

### Root cause and fix

- The standalone container had no controller maintaining desired state.
- Kubernetes fixed that gap by managing replicas through a Deployment.
- Record the root cause and fix for any additional error here.

### Next improvement

Add HTTP health probes and container CPU and memory requests and limits.