.PHONY: build
build:
	mkdir -p ./bin
	go build -o ./bin

.PHONY: build-image-kind
build-image-kind: build
	docker build --no-cache -t localhost:5000/mutating-webhook:latest .

.PHONY: push-kind
push-kind: build-image-kind
	kind load docker-image localhost:5000/mutating-webhook:latest

.PHONY: deploy
deploy:
	kubectl apply -f ./kubernetes/webhook-deployment.yaml
	kubectl apply -f ./kubernetes/webhook-service.yaml
	kubectl apply -f ./kubernetes/mutating-webhook-config.yaml

.PHONY: cleanup
cleanup:
	kubectl delete -f ./kubernetes/webhook-deployment.yaml
	kubectl delete -f ./kubernetes/webhook-service.yaml
	kubectl delete -f ./kubernetes/mutating-webhook-config.yaml
	kubectl delete -f ./kubernetes/test-pod.yaml

cert-manager:
	helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.10.1 \
   --set installCRDs=true
